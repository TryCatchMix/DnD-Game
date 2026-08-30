package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Item;

import java.util.ArrayList;
import java.util.List;

/**
 * Lo que se sabe de un objeto del catálogo mirando sus columnas del SRD:
 * de qué tipo es y cómo se lee su bloque.
 *
 * Vive aparte porque lo necesitan tres sitios distintos —la tienda para pintar
 * la vitrina, la bolsa para saber qué se puede uno poner y {@link GearService}
 * para calcular la ficha— y tenerlo tres veces era pedir que se separaran.
 */
public final class Gear {
    private Gear() {}

    public static final String ARMA = "arma";
    public static final String ARMADURA = "armadura";
    public static final String ESCUDO = "escudo";

    /**
     * Qué es el objeto de cara a ponérselo: arma, armadura, escudo o nada.
     *
     * Los complementos (púas de armadura, guantelete cerrado) devuelven vacío
     * a propósito: no se llevan solos, van montados sobre otra cosa.
     */
    public static String kind(Item item) {
        if (item == null) return "";
        String cat = txt(item.getCategory());
        String grupo = txt(item.getEquipmentGroup());
        if (cat.equals("arma")) return ARMA;
        if (cat.equals("armadura")) {
            if (grupo.equalsIgnoreCase("Escudo")) return ESCUDO;
            if (grupo.equalsIgnoreCase("Complemento")) return "";
            return ARMADURA;
        }
        return "";
    }

    /** Si tiene sentido ofrecer el interruptor de «equipar». */
    public static boolean equipable(Item item) {
        return !kind(item).isEmpty();
    }

    /**
     * El bloque del SRD en una línea, para leerlo de un vistazo:
     * "1d8 · 19-20/×2 · Cortante" en un arma,
     * "CA +8 · Des máx +1 · −6 · 35% de fallo · vel. 20 pies" en una armadura.
     */
    public static String stats(Item item) {
        if (item == null) return "";
        List<String> partes = new ArrayList<>();
        add(partes, item.getDamageMedium());
        add(partes, item.getCritical());
        add(partes, item.getDamageType());
        add(partes, item.getRangeIncrement());

        if (!txt(item.getAcBonus()).isEmpty()) partes.add("CA +" + txt(item.getAcBonus()));
        if (!txt(item.getMaxDex()).isEmpty()) partes.add("Des máx +" + txt(item.getMaxDex()));
        // el penalizador del SRD ya viene con signo ("-4"); el 0 no dice nada
        String pen = txt(item.getArmorCheck());
        if (!pen.isEmpty() && !pen.equals("0")) partes.add(pen.replace("-", "−"));
        String fallo = txt(item.getSpellFailure());
        if (!fallo.isEmpty() && !fallo.equals("0%")) partes.add(fallo + " de fallo");
        if (!txt(item.getSpeed30()).isEmpty()) partes.add("vel. " + txt(item.getSpeed30()));

        return String.join(" · ", partes);
    }

    /** Un entero del SRD ("+2", "-4", "8"). Devuelve `porDefecto` si no lo es. */
    public static int entero(String v, int porDefecto) {
        String t = txt(v).replace("−", "-").replace("+", "");
        if (t.isEmpty() || t.equals("—")) return porDefecto;
        try {
            return Integer.parseInt(t);
        } catch (NumberFormatException e) {
            return porDefecto;
        }
    }

    /** Un porcentaje del SRD ("35%"). */
    public static int porcentaje(String v) {
        return entero(txt(v).replace("%", ""), 0);
    }

    /** Los pies de una velocidad del SRD ("20 pies"). */
    public static int pies(String v) {
        String t = txt(v).replaceAll("[^0-9-]", "");
        return t.isEmpty() ? 0 : entero(t, 0);
    }

    private static void add(List<String> partes, String v) {
        if (!txt(v).isEmpty()) partes.add(txt(v));
    }

    private static String txt(String s) {
        return s == null ? "" : s.trim();
    }
}
