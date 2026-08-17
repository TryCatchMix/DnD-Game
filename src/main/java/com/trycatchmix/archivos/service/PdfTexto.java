package com.trycatchmix.archivos.service;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Component;

import java.text.Normalizer;

/**
 * Saca el texto de un PDF y busca dentro de él.
 *
 * La extracción es best-effort a propósito: un PDF cifrado, corrupto o
 * escaneado (sin capa de texto) devuelve cadena vacía en vez de reventar la
 * subida. Lo peor que pasa es que ese PDF solo se encuentre por su título.
 */
@Component
public class PdfTexto {

    /** El texto plano del PDF, o "" si no se ha podido leer. */
    public String extraer(byte[] pdf) {
        if (pdf == null || pdf.length == 0) return "";
        try (PDDocument doc = Loader.loadPDF(pdf)) {
            String texto = new PDFTextStripper().getText(doc);
            return texto == null ? "" : texto.trim();
        } catch (Exception e) {
            // PDF cifrado, roto o solo-imagen: se queda sin índice, sin drama.
            return "";
        }
    }

    /** Minúsculas y sin tildes, para comparar la consulta con el texto. */
    public static String normalizar(String s) {
        if (s == null) return "";
        return Normalizer.normalize(s.toLowerCase(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
    }

    /** Cuántas veces sale la aguja y un fragmento con contexto, o null si no sale. */
    public record Coincidencia(int veces, String fragmento) {}

    /**
     * Busca {@code agujaNorm} (ya normalizada) dentro de {@code original}.
     *
     * Normaliza el original carácter a carácter guardando, para cada letra del
     * texto normalizado, de qué posición del original vino. Así el fragmento se
     * recorta del texto ORIGINAL (con sus tildes y mayúsculas), aunque quitar
     * tildes cambie la longitud.
     */
    public static Coincidencia buscar(String original, String agujaNorm) {
        if (original == null || original.isBlank() || agujaNorm == null || agujaNorm.isBlank())
            return null;

        StringBuilder norm = new StringBuilder(original.length());
        int[] mapa = new int[original.length() + 1];  // pos en norm -> pos en original
        for (int i = 0; i < original.length(); i++) {
            String limpio = normalizar(String.valueOf(original.charAt(i)));
            for (int k = 0; k < limpio.length(); k++) {
                mapa[norm.length()] = i;
                norm.append(limpio.charAt(k));
            }
        }
        String heno = norm.toString();

        int primera = heno.indexOf(agujaNorm);
        if (primera < 0) return null;

        // Contar todas las apariciones (sin solaparse).
        int veces = 0, desde = 0, p;
        while ((p = heno.indexOf(agujaNorm, desde)) >= 0) {
            veces++;
            desde = p + agujaNorm.length();
        }

        int centro = mapa[primera];
        int ini = Math.max(0, centro - 60);
        int fin = Math.min(original.length(), centro + agujaNorm.length() + 90);
        String frag = original.substring(ini, fin).replaceAll("\\s+", " ").trim();
        if (ini > 0) frag = "…" + frag;
        if (fin < original.length()) frag = frag + "…";
        return new Coincidencia(veces, frag);
    }
}
