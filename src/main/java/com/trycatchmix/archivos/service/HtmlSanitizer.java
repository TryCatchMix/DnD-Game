package com.trycatchmix.archivos.service;

import java.util.regex.Pattern;

/**
 * Limpieza ligera del HTML que escribe el usuario en el editor de texto rico
 * (el Trasfondo del personaje y el guion de La Mesa).
 *
 * No es un saneador completo (ese contenido solo lo ven su dueño y el máster),
 * pero quita lo que ejecuta código para no dispararnos en el pie: etiquetas
 * &lt;script&gt;/&lt;iframe&gt;/&lt;object&gt;/&lt;embed&gt;/&lt;style&gt;/&lt;link&gt;/&lt;meta&gt;,
 * atributos on… y urls javascript:. El formato (negritas, colores, listas…) se
 * respeta tal cual.
 */
public final class HtmlSanitizer {
    private HtmlSanitizer() {}

    private static final String NOMBRES = "script|style|iframe|object|embed|link|meta";
    /** Un bloque entero: apertura + contenido + cierre (p.ej. &lt;script&gt;…&lt;/script&gt;). */
    private static final Pattern BLOQUE_PELIGROSO =
            Pattern.compile("(?is)<\\s*(" + NOMBRES + ")\\b[^>]*>.*?<\\s*/\\s*\\1\\s*>");
    /** Cualquier etiqueta suelta de esos nombres (huérfana, vacía o de cierre). */
    private static final Pattern ETIQUETA_SUELTA =
            Pattern.compile("(?is)<\\s*/?\\s*(" + NOMBRES + ")\\b[^>]*>");
    private static final Pattern MANEJADORES_ON =
            Pattern.compile("(?i)\\son\\w+\\s*=\\s*(\"[^\"]*\"|'[^']*'|[^\\s>]+)");
    private static final Pattern JS_URL =
            Pattern.compile("(?i)(href|src)\\s*=\\s*(\"|')\\s*javascript:[^\"']*(\"|')");

    /** Devuelve el HTML sin lo que ejecuta código. Nunca devuelve null. */
    public static String limpiar(String html) {
        if (html == null) return "";
        String limpio = BLOQUE_PELIGROSO.matcher(html).replaceAll("");
        limpio = ETIQUETA_SUELTA.matcher(limpio).replaceAll("");
        limpio = MANEJADORES_ON.matcher(limpio).replaceAll("");
        limpio = JS_URL.matcher(limpio).replaceAll("$1=$2$3");
        return limpio.trim();
    }
}
