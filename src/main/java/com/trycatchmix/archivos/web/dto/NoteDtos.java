package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs del bloc de notas. */
public final class NoteDtos {
    private NoteDtos() {}

    public record NoteView(
            String id,
            String category,
            String title,
            String body,
            boolean pinned,
            /** ISO-8601; el frontend la formatea. */
            String updatedAt) {}

    /** Las categorías van con la lista para que el desplegable salga del backend
     *  y no haya dos verdades. */
    public record NotesView(List<NoteView> notes, List<String> categories) {}

    /** Alta y edición comparten forma: lo que llegue a null no se toca. */
    public record NoteRequest(String category, String title, String body, Boolean pinned) {}
}
