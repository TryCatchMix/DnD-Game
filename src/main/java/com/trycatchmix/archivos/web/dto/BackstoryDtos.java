package com.trycatchmix.archivos.web.dto;

/** DTOs del trasfondo (la historia del personaje). El contrato con el frontend
 *  es api.types.ts (Backstory). */
public final class BackstoryDtos {
    private BackstoryDtos() {}

    /** Lo que se pinta: el HTML con formato y cuándo se guardó por última vez. */
    public record BackstoryView(
            String html,
            /** ISO-8601, o "" si nunca se ha guardado; el frontend la formatea. */
            String updatedAt) {}

    /** Guardar: solo el HTML del documento. */
    public record SaveRequest(String html) {}
}
