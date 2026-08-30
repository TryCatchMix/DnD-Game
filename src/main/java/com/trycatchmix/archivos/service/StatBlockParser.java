package com.trycatchmix.archivos.service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Saca números de un bloque de estadísticas del SRD, que está escrito para
 * leerlo, no para calcular con él.
 *
 * Es lo que convierte "16 (-2 tamaño, +1 Des, +7 natural), contacto 9,
 * desprevenido 15" en tres enteros, y es justo lo que hace que meter un
 * monstruo en un combate sea un clic en vez de teclear su ficha entera.
 *
 * Si algo no se deja leer, devuelve el valor por defecto y ya está: el máster
 * lo corrige a mano, que es como estaba antes.
 */
public final class StatBlockParser {
    private StatBlockParser() {}

    /** "8d8+40 (76 pg)" -> 76. */
    private static final Pattern PG_ENTRE_PARENTESIS =
            Pattern.compile("\\((\\d+)\\s*(?:pg|hp)\\)", Pattern.CASE_INSENSITIVE);
    /** "8d8+40" -> el aguante medio, por si no viene ya calculado. */
    private static final Pattern DADOS = Pattern.compile("(\\d+)d(\\d+)\\s*([+\\-−]\\s*\\d+)?");

    private static final Pattern CA_PRIMER_NUMERO = Pattern.compile("^\\s*(\\d+)");
    private static final Pattern CA_CONTACTO =
            Pattern.compile("contacto\\s+(\\d+)", Pattern.CASE_INSENSITIVE);
    private static final Pattern CA_DESPREVENIDO =
            Pattern.compile("desprevenido\\s+(\\d+)", Pattern.CASE_INSENSITIVE);

    private static final Pattern SIGNO = Pattern.compile("([+\\-−]\\s*\\d+)");

    /**
     * Los puntos de golpe de una línea de dados de golpe.
     *
     * El SRD ya trae la media entre paréntesis casi siempre; cuando no, se
     * calcula de los dados (media del dado × cantidad + el fijo), que es lo que
     * haría cualquiera en la mesa para no tirar 19d12.
     */
    public static int puntosDeGolpe(String hitDice) {
        String t = txt(hitDice);
        if (t.isEmpty()) return 0;

        Matcher m = PG_ENTRE_PARENTESIS.matcher(t);
        if (m.find()) return entero(m.group(1), 0);

        m = DADOS.matcher(t);
        if (m.find()) {
            int cantidad = entero(m.group(1), 0);
            int caras = entero(m.group(2), 0);
            int fijo = m.group(3) == null ? 0 : entero(m.group(3), 0);
            double media = (caras + 1) / 2.0;
            return Math.max(1, (int) Math.round(cantidad * media) + fijo);
        }
        return 0;
    }

    /** El primer número de la CA: "16 (-2 tamaño…), contacto 9…" -> 16. */
    public static int claseDeArmadura(String armorClass, int porDefecto) {
        Matcher m = CA_PRIMER_NUMERO.matcher(txt(armorClass));
        return m.find() ? entero(m.group(1), porDefecto) : porDefecto;
    }

    public static int caContacto(String armorClass, int porDefecto) {
        Matcher m = CA_CONTACTO.matcher(txt(armorClass));
        return m.find() ? entero(m.group(1), porDefecto) : porDefecto;
    }

    public static int caDesprevenido(String armorClass, int porDefecto) {
        Matcher m = CA_DESPREVENIDO.matcher(txt(armorClass));
        return m.find() ? entero(m.group(1), porDefecto) : porDefecto;
    }

    /** "+1" o "−2" -> 1 o -2. */
    public static int modificador(String v) {
        Matcher m = SIGNO.matcher(txt(v));
        if (m.find()) return entero(m.group(1), 0);
        return entero(txt(v), 0);
    }

    private static int entero(String v, int porDefecto) {
        String t = txt(v).replace("−", "-").replace("+", "").replace(" ", "");
        if (t.isEmpty()) return porDefecto;
        try {
            return Integer.parseInt(t);
        } catch (NumberFormatException e) {
            return porDefecto;
        }
    }

    private static String txt(String s) {
        return s == null ? "" : s.trim();
    }
}
