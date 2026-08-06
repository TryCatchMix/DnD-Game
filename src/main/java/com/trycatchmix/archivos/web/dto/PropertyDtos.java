package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs del juego de propiedades. Los nombres de campo son el contrato con
 *  el frontend (api.types.ts). */
public final class PropertyDtos {
    private PropertyDtos() {}

    /** Una entrada del catálogo de tipos que se pueden comprar. */
    public record CatalogItem(
            String kind,
            String emoji,
            String nombre,
            String blurb,
            long buyPriceCp,
            String buyPrice,          // formateado en po/pp/pc
            long incomePerDayCp,      // renta a nivel 1
            String incomePerDay) {}

    /** Una propiedad ya comprada, con su renta pendiente y sus costes. */
    public record PropertyView(
            String id,
            String kind,
            String emoji,
            String tipo,              // nombre del tipo ("Taberna")
            String name,              // nombre propio ("El Toro Ciego")
            int level,
            int maxLevel,
            String city,
            long incomePerDayCp,
            String incomePerDay,
            long pendingCp,           // renta acumulada sin recaudar
            String pending,
            Long upgradeCostCp,       // null si ya está al máximo
            String upgradeCost,
            boolean canUpgrade,       // hay siguiente nivel Y llega el dinero
            long saleValueCp,
            String saleValue) {}

    /** Todo lo que pinta la pantalla de propiedades. */
    public record HoldingsView(
            long purseCp,
            String purse,
            List<PropertyView> properties,
            List<CatalogItem> catalog) {}

    /** Compra: tipo + nombre que le pone el dueño. */
    public record BuyRequest(String kind, String name) {}
}
