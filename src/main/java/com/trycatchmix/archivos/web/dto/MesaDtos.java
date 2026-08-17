package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs de La Mesa (el escritorio de preparación del DM). */
public final class MesaDtos {
    private MesaDtos() {}

    /** La ficha de un archivo. Los bytes se piden aparte, a /contenido. */
    public record AssetView(
            String id,
            String misionId,
            /** imagen | pdf | otro */
            String kind,
            String title,
            String filename,
            String mime,
            long sizeBytes,
            String createdAt) {}

    public record NoteView(
            String id,
            /** lectura | escena | pnj | botin | nota */
            String kind,
            String title,
            String body,
            int ordinal) {}

    /** La tarjeta de la rejilla: lo justo para pintarla sin bajar el detalle. */
    public record MissionCard(
            String id,
            String title,
            String summary,
            String status,
            List<String> tags,
            String sessionDate,
            String coverId,
            int imageCount,
            int pdfCount,
            int noteCount,
            String updatedAt) {}

    /** Lo que se abre al pulsar una tarjeta. */
    public record MissionDetail(
            String id,
            String title,
            String summary,
            String status,
            List<String> tags,
            String sessionDate,
            String coverId,
            String updatedAt,
            List<NoteView> notes,
            List<AssetView> assets) {}

    /** La rejilla + los estados que ofrece el filtro (una sola verdad). */
    public record MesaView(List<MissionCard> misiones, List<String> estados) {}

    /** Alta y edición comparten forma: lo que llegue a null no se toca. */
    public record MissionRequest(
            String title, String summary, String status,
            String tags, String sessionDate, String coverId) {}

    public record NoteRequest(String kind, String title, String body) {}

    /** Renombrar un archivo o moverlo de misión. */
    public record AssetRequest(String title, String misionId) {}

    /**
     * Un PDF donde aparece lo buscado: la ficha del archivo + cuántas veces sale
     * y un fragmento con contexto para enseñar dónde.
     */
    public record AssetHit(
            String id,
            String misionId,
            String title,
            String filename,
            int matchCount,
            String snippet) {}
}
