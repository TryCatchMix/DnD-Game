package com.trycatchmix.archivos.service;

/**
 * Dinero en piezas de cobre (la unidad base) y su formato en po/pp/pc.
 *   1 po (oro)   = 100 pc
 *   1 pp (plata) =  10 pc
 *   1 pc (cobre) =   1 pc
 */
public final class Money {
    private Money() {}

    public static String format(long cp) {
        if (cp <= 0) return "0 pc";
        long po = cp / 100;
        long pp = (cp % 100) / 10;
        long pc = cp % 10;

        StringBuilder sb = new StringBuilder();
        if (po > 0) sb.append(po).append(" po");
        if (pp > 0) sb.append(sb.isEmpty() ? "" : " · ").append(pp).append(" pp");
        if (pc > 0) sb.append(sb.isEmpty() ? "" : " · ").append(pc).append(" pc");
        return sb.toString();
    }
}
