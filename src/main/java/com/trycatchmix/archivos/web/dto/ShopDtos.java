package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs de la tienda (pantalla 06). El precio va en cobre (priceCp) y ya
 *  formateado (price) para que el frontend solo tenga que pintarlo. */
public final class ShopDtos {
    private ShopDtos() {}

    public record ShopView(
            long purseCp,
            String purse,
            List<ShopOfferView> offers,
            List<InventoryItemView> inventory) {}

    public record ShopOfferView(
            String itemCode,
            String name,
            String description,
            String category,
            long priceCp,
            String price,
            boolean affordable,
            int stock) {}     // -1 = sin límite

    public record InventoryItemView(
            String itemCode,
            String name,
            int quantity,
            long sellPriceCp,
            String sellPrice) {}

    /** Lo que manda el DM para poner algo a la venta: nombre, precio (en piezas
     *  de cobre) y cantidad (stock; usa null o -1 para "sin límite"). La
     *  descripción y la categoría son opcionales. */
    public record ShopOfferCreateRequest(
            String name,
            Long priceCp,
            Integer stock,
            String description,
            String category) {}
}
