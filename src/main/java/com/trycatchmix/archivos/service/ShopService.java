package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.InventoryEntry;
import com.trycatchmix.archivos.domain.Item;
import com.trycatchmix.archivos.domain.ShopOffer;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.*;
import com.trycatchmix.archivos.web.dto.ShopDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/** La tienda: ver lo que se vende en tu ciudad, comprar y vender. */
@Service
@RequiredArgsConstructor
public class ShopService {

    private final GameCharacterRepository characters;
    private final ItemRepository items;
    private final ShopOfferRepository offers;
    private final InventoryRepository inventory;

    @Transactional(readOnly = true)
    public ShopView tienda(UUID userId, UUID charId) {
        return build(ownedCharacter(userId, charId));
    }

    @Transactional
    public ShopView comprar(UUID userId, UUID charId, String itemCode) {
        GameCharacter c = ownedCharacter(userId, charId);
        ShopOffer offer = offers.findByLocationAndItemCode(c.getCity(), itemCode)
                .orElseThrow(() -> ApiException.notFound("Ese objeto no está a la venta aquí."));

        if (offer.getStock() == 0)
            throw ApiException.conflict("Está agotado.");
        if (c.getPurseCp() < offer.getPriceCp())
            throw ApiException.conflict("No te llega el dinero para eso.");

        c.setPurseCp(c.getPurseCp() - offer.getPriceCp());

        Item item = items.findById(itemCode)
                .orElseThrow(() -> ApiException.notFound("Ese objeto ya no existe en el catálogo."));

        InventoryEntry entry = inventory.findByCharacterIdAndItemCode(charId, itemCode).orElse(null);
        if (entry == null) {
            entry = new InventoryEntry();
            entry.setCharacterId(charId);
            entry.setItemCode(itemCode);
            entry.setName(item.getName());
            entry.setWeightLb(item.getWeightLb());
            entry.setQuantity(0);
        }
        entry.setQuantity(entry.getQuantity() + 1);
        inventory.save(entry);

        if (offer.getStock() > 0) offer.setStock(offer.getStock() - 1);

        return build(c);
    }

    @Transactional
    public ShopView vender(UUID userId, UUID charId, String itemCode) {
        GameCharacter c = ownedCharacter(userId, charId);
        InventoryEntry entry = inventory.findByCharacterIdAndItemCode(charId, itemCode)
                .filter(e -> e.getQuantity() > 0)
                .orElseThrow(() -> ApiException.conflict("No llevas ese objeto."));

        Item item = items.findById(itemCode)
                .orElseThrow(() -> ApiException.notFound("Ese objeto ya no existe en el catálogo."));

        long sellPrice = item.getPriceCp() / 2;   // la tienda paga la mitad
        c.setPurseCp(c.getPurseCp() + sellPrice);

        entry.setQuantity(entry.getQuantity() - 1);
        if (entry.getQuantity() == 0) inventory.delete(entry);
        else inventory.save(entry);

        return build(c);
    }

    // -------------------------------------------- alta de ofertas (solo DM) ---

    /** El DM pone algo a la venta en la ciudad del personaje. Si el objeto no
     *  existe en el catálogo, se crea; si ya había una oferta para ese objeto
     *  en la ciudad, se actualiza (precio y stock). Devuelve la tienda repintada. */
    @Transactional
    public ShopView crearOferta(UUID charId, ShopOfferCreateRequest req) {
        GameCharacter c = characterById(charId);
        if (req == null || req.name() == null || req.name().isBlank())
            throw ApiException.conflict("Ponle un nombre al objeto.");

        String name = req.name().trim();
        long priceCp = req.priceCp() == null ? 0 : Math.max(0, req.priceCp());
        int stock = req.stock() == null ? -1 : req.stock();
        String location = c.getCity();
        String code = itemCode(name);

        // El catálogo es compartido: si el objeto ya existe no le tocamos el
        // precio base (del que sale la reventa a mitad); solo lo creamos si es nuevo.
        Item item = items.findById(code).orElse(null);
        if (item == null) {
            item = new Item();
            item.setCode(code);
            item.setName(name);
            item.setDescription(req.description() == null ? "" : req.description().trim());
            item.setPriceCp(priceCp);
            item.setCategory(req.category() == null || req.category().isBlank()
                    ? "útil" : req.category().trim());
            items.save(item);
        }

        ShopOffer offer = offers.findByLocationAndItemCode(location, code).orElseGet(ShopOffer::new);
        offer.setLocation(location);
        offer.setItemCode(code);
        offer.setPriceCp(priceCp);
        offer.setStock(stock);
        offers.save(offer);

        return build(c);
    }

    /** El DM retira una oferta de la ciudad del personaje. El objeto sigue en
     *  el catálogo (por si alguien ya lo compró): solo desaparece del mostrador. */
    @Transactional
    public ShopView quitarOferta(UUID charId, String itemCode) {
        GameCharacter c = characterById(charId);
        offers.findByLocationAndItemCode(c.getCity(), itemCode).ifPresent(offers::delete);
        return build(c);
    }

    /** Código en minúsculas y sin espacios ni acentos para la clave del catálogo. */
    private String itemCode(String name) {
        return name.trim().toLowerCase()
                .replace('á', 'a').replace('é', 'e').replace('í', 'i')
                .replace('ó', 'o').replace('ú', 'u').replace('ñ', 'n')
                .replaceAll("[^a-z0-9]+", "_")
                .replaceAll("^_+|_+$", "");
    }

    // ------------------------------------------------------------------------

    private ShopView build(GameCharacter c) {
        List<ShopOfferView> offerViews = new ArrayList<>();
        for (ShopOffer o : offers.findByLocationOrderByPriceCpAsc(c.getCity())) {
            items.findById(o.getItemCode()).ifPresent(item -> offerViews.add(new ShopOfferView(
                    item.getCode(), item.getName(), item.getDescription(), item.getCategory(),
                    o.getPriceCp(), Money.format(o.getPriceCp()),
                    c.getPurseCp() >= o.getPriceCp(), o.getStock())));
        }

        // La tienda solo compra lo que salió de su catálogo (item_code no nulo).
        // Los objetos añadidos a mano se gestionan en la bolsa de la ficha.
        List<InventoryItemView> invViews = new ArrayList<>();
        for (InventoryEntry e : inventory.findByCharacterIdOrderByItemCodeAsc(c.getId())) {
            if (e.getItemCode() == null) continue;
            items.findById(e.getItemCode()).ifPresent(item -> {
                long sell = item.getPriceCp() / 2;
                invViews.add(new InventoryItemView(
                        item.getCode(), item.getName(), e.getQuantity(), sell, Money.format(sell)));
            });
        }

        return new ShopView(c.getPurseCp(), Money.format(c.getPurseCp()),
                c.getCity(), offerViews, invViews);
    }

    /** Solo por id (sin comprobar dueño): las rutas que lo usan son del DM. */
    private GameCharacter characterById(UUID charId) {
        return characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
    }

    private GameCharacter ownedCharacter(UUID userId, UUID charId) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }
}
