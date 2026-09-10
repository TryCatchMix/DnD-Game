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
 * TRES DECISIONES QUE CONVIENE TENER PRESENTES:
 *
 * 1. CADA CAMPAÃ‘A TIENE SU MOSTRADOR. Las ofertas cuelgan de la campaÃ±a del
 *    personaje, asÃ­ que lo que un mÃ¡ster pone a la venta se ve en su mesa y en
 *    ninguna otra. Una campaÃ±a reciÃ©n creada nace con el surtido base copiado
 *    (ver CampaignService), para que haya algo que comprar el primer dÃ­a.
 *
 * 2. DENTRO DE UNA CAMPAÃ‘A EL MOSTRADOR ES ÃšNICO. Antes las ofertas se
 *    filtraban ademÃ¡s por la ciudad del personaje (`shop_offers.location`), y
 *    bastaba con que la ficha dijera "Llanuras de Dorakan" en vez de "Dorakan"
 *    para quedarse sin tienda sin saber por quÃ©. La columna `location` sigue
 *    ahÃ­ por si algÃºn dÃ­a vuelven las tiendas por ciudad, pero no se filtra.
 *
 * 3. UN PERSONAJE SIN CAMPAÃ‘A NO TIENE TIENDA. No hay mostrador que enseÃ±arle
 *    porque no hay mesa: el error lo da CampaignAccess y dice que se una a una.
 *
 * El catÃ¡logo de objetos (`items`) sÃ­ es comÃºn a todo el mundo: es la lista de
 * quÃ© existe, no de quÃ© se vende. Y el mÃ¡ster entra en la tienda de cualquier
 * personaje de SU campaÃ±a, como ya entraba en su ficha.
 */
@Service
@RequiredArgsConstructor
public class ShopService {

    private final ItemRepository items;
    private final ShopOfferRepository offers;
    private final InventoryRepository inventory;
    private final CampaignAccess access;

    @Transactional(readOnly = true)
    public ShopView tienda(UUID userId, UUID charId) {
        return build(access.exigePersonaje(userId, charId));
    }

    @Transactional
    public ShopView comprar(UUID userId, UUID charId, String itemCode) {
        GameCharacter c = access.exigePersonaje(userId, charId);
        ShopOffer offer = ofertaDe(access.exigeCampanaDe(c), itemCode)
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
    public ShopView vender(UUID userId, UUID charId, String itemCode) {
        GameCharacter c = access.exigePersonaje(userId, charId);
        access.exigeCampanaDe(c);
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
    public ShopView crearOferta(UUID userId, UUID charId, ShopOfferCreateRequest req) {
        GameCharacter c = maestroDe(userId, charId);
        UUID campaignId = c.getCampaignId();
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
        ShopOffer offer = ofertaDe(campaignId, code).orElseGet(ShopOffer::new);
        offer.setCampaignId(campaignId);
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
    public ShopView quitarOferta(UUID userId, UUID charId, String itemCode) {
        GameCharacter c = maestroDe(userId, charId);
        offers.deleteAll(offers.findByCampaignIdAndItemCode(c.getCampaignId(), itemCode));
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
        for (ShopOffer o : offers.findByCampaignIdOrderByPriceCpAsc(access.exigeCampanaDe(c))) {
            items.findById(o.getItemCode()).ifPresent(item -> offerViews.add(new ShopOfferView(
                    item.getCode(), item.getName(), item.getDescription(), item.getCategory(),
                    o.getPriceCp(), Money.format(o.getPriceCp()),
                    c.getPurseCp() >= o.getPriceCp(), o.getStock(),
                    item.getEquipmentGroup(), item.getWeightLb(), Gear.stats(item))));
        }

        // La tienda solo compra lo que salió de su catálogo (item_code no nulo).
        // Los objetos añadidos a mano se gestionan en la bolsa de la ficha.
        List<InventoryItemView> invViews = new ArrayList<>();
        for (InventoryEntry e : inventory.findByCharacterIdOrderByItemCodeAsc(c.getId())) {
            if (e.getItemCode() == null) continue;
            items.findById(e.getItemCode()).ifPresent(item -> {
                long sell = item.getPriceCp() / 2;
                invViews.add(new InventoryItemView(
                        item.getCode(), item.getName(), e.getQuantity(), sell, Money.format(sell),
                        item.getWeightLb(), Gear.stats(item)));
            });
        }

        return new ShopView(c.getPurseCp(), Money.format(c.getPurseCp()),
                c.getCity(), offerViews, invViews);
    }

    /** La oferta de un objeto. Si quedaran restos de la época de tiendas por
     *  ciudad (el mismo objeto puesto en dos sitios), vale la primera. */
    private Optional<ShopOffer> ofertaDe(UUID campaignId, String itemCode) {
        return offers.findByCampaignIdAndItemCode(campaignId, itemCode).stream().findFirst();
    }

    /**
     * El personaje visto por el mÃ¡ster de SU campaÃ±a. Poner precios y retirar
     * gÃ©nero es cosa del DM de esa mesa; el rol de la cuenta ya no basta.
     */
    private GameCharacter maestroDe(UUID userId, UUID charId) {
        GameCharacter c = access.personaje(charId);
        access.exigeDm(userId, access.exigeCampanaDe(c));
        return c;
    }
}
