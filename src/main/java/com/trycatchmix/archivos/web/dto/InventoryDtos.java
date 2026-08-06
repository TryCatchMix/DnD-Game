package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs de la bolsa (inventario) del personaje. */
public final class InventoryDtos {
    private InventoryDtos() {}

    public record InventoryLine(
            String id,
            String name,
            int quantity,
            double weightLb,
            double lineWeight,     // weightLb * quantity
            boolean sellable) {}   // viene del catálogo (se puede vender en la tienda)

    public record InventoryView(List<InventoryLine> items, double totalWeight) {}

    public record AddItemRequest(String name, Integer quantity, Double weightLb) {}

    public record SetQuantityRequest(Integer quantity) {}
}
