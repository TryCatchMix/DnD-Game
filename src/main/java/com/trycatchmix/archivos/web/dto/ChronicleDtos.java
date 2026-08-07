package com.trycatchmix.archivos.web.dto;

/** DTOs de la crónica del clan (pantalla 07). */
public final class ChronicleDtos {
    private ChronicleDtos() {}

    public record ChronicleView(
            String id,
            int year,
            String era,
            String title,
            /** El cuerpo verdadero, o el texto censurado si está sellada sin revelar. */
            String body,
            String category,
            String faction,
            boolean sealed,
            boolean revealed,
            /** Si quien mira puede destaparla (es DM y sigue sellada). */
            boolean canReveal) {}

    /** Añadir una entrada nueva (solo el DM / Los Archivos). */
    public record ChronicleCreateRequest(
            Integer year,
            String era,
            String title,
            String body,
            String category,
            String faction,
            Boolean sealed) {}

    /** Editar una entrada (solo el DM). Como crear, pero permite además tocar
     *  el estado de revelada, para el panel de administración. */
    public record ChronicleUpdateRequest(
            Integer year,
            String era,
            String title,
            String body,
            String category,
            String faction,
            Boolean sealed,
            Boolean revealed) {}
}
