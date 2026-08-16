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
import java.util.Optional;
import java.util.UUID;

/**
 * La tienda: ver lo que hay a la venta, comprar y vender.
 *
 * DOS DECISIONES QUE CONVIENE TENER PRESENTES:
 *
 * 1. El mostrador es ÚNICO. Antes las ofertas se filtraban por la ciudad del
 *    personaje (`shop_offers.location`), y bastaba con que la ubicación de su
 *    ficha dijera "Llanuras de Dorakan" en vez de "Dorakan" para quedarse sin
 *    tienda sin saber por qué. Hoy se ven todas las ofertas vengan de donde
 *    vengan; la columna `location` sigue ahí por si algún día vuelven las
 *    tiendas por ciudad.
 *
 * 2. El DM entra en la tienda de CUALQUIER personaje, como ya entraba en su
 *    ficha. No es un privilegio nuevo: el máster ya puede editar a mano el
 *    monedero y la bolsa desde la ficha, así que impedirle comprar solo añadía
 *    fricción, y era lo que hacía que al máster le saltara «no se ha podido
 *    abrir la tienda» en los personajes de sus jugadores.
 */
@Service
@RequiredArgsConstructor
public class ShopService {

    private final GameCharacterRepository characters;
    private final ItemRepository items;
    private final ShopOfferRepository offers;
    private final InventoryRepository inventory;

    @Transactional(readOnly = true)
    public ShopView tienda(UUID userId, UUID charId, boolean admin) {
        return build(accessibleCharacter(userId, charId, admin));
    }

    @Transactional
    public ShopView comprar(UUID userId, UUID charId, boolean admin, String itemCode) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        ShopOffer offer = ofertaDe(itemCode)
                .orElseThrow(() -> ApiException.notFound("Ese objeto no está a la venta."));

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
    public ShopView vender(UUID userId, UUID charId, boolean admin, String itemCode) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
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

        // Una oferta por objeto, no una por ciudad: si ya estaba puesta se
        // actualiza (precio y stock) en vez de aparecer dos veces en la vitrina.
        ShopOffer offer = ofertaDe(code).orElseGet(ShopOffer::new);
        if (offer.getLocation() == null) offer.setLocation(c.getCity());
        offer.setItemCode(code);
        offer.setPriceCp(priceCp);
        offer.setStock(stock);
        offers.save(offer);

        return build(c);
    }

    /** El DM retira una oferta del mostrador. El objeto sigue en el catálogo
     *  (por si alguien ya lo compró): solo desaparece de la vitrina. */
    @Transactional
    public ShopView quitarOferta(UUID charId, String itemCode) {
        GameCharacter c = characterById(charId);
        offers.deleteAll(offers.findByItemCode(itemCode));
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
        for (ShopOffer o : offers.findAllByOrderByPriceCpAsc()) {
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

    /** La oferta de un objeto. Si quedaran restos de la época de tiendas por
     *  ciudad (el mismo objeto puesto en dos sitios), vale la primera. */
    private Optional<ShopOffer> ofertaDe(String itemCode) {
        return offers.findByItemCode(itemCode).stream().findFirst();
    }

    /** Solo por id (sin comprobar dueño): las rutas que lo usan son del DM. */
    private GameCharacter characterById(UUID charId) {
        return characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
    }

    /** El dueño, o el DM sobre cualquiera (mismo criterio que la ficha). */
    private GameCharacter accessibleCharacter(UUID userId, UUID charId, boolean admin) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!admin && !c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }
}
