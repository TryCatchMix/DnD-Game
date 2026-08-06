package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Note;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.NoteRepository;
import com.trycatchmix.archivos.web.dto.NoteDtos.NoteRequest;
import com.trycatchmix.archivos.web.dto.NoteDtos.NoteView;
import com.trycatchmix.archivos.web.dto.NoteDtos.NotesView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

/** El bloc de notas del jugador: apuntar nombres, lugares y lo que haga falta. */
@Service
@RequiredArgsConstructor
public class NoteService {

    private final NoteRepository notes;

    /** Las categorías que ofrece el desplegable. Se puede escribir otra: el
     *  backend acepta cualquier texto, esto es solo la lista sugerida. */
    public static final List<String> CATEGORIAS =
            List.of("Persona", "Lugar", "Facción", "Objeto", "Suceso", "Otro");

    @Transactional(readOnly = true)
    public NotesView listar(UUID userId) {
        return build(userId);
    }

    @Transactional
    public NotesView crear(UUID userId, NoteRequest r) {
        String titulo = r == null || r.title() == null ? "" : r.title().trim();
        if (titulo.isEmpty()) throw ApiException.conflict("La nota necesita un nombre.");

        Note n = new Note();
        n.setUserId(userId);
        n.setTitle(titulo);
        n.setCategory(categoriaDe(r.category()));
        n.setBody(r.body() == null ? "" : r.body().trim());
        n.setPinned(Boolean.TRUE.equals(r.pinned()));
        n.setCreatedAt(Instant.now());
        n.setUpdatedAt(Instant.now());
        notes.save(n);
        return build(userId);
    }

    /** Editar. Lo que llegue a null se deja como estaba. */
    @Transactional
    public NotesView editar(UUID userId, UUID noteId, NoteRequest r) {
        Note n = propia(userId, noteId);
        if (r != null) {
            if (r.title() != null && !r.title().isBlank()) n.setTitle(r.title().trim());
            if (r.category() != null) n.setCategory(categoriaDe(r.category()));
            if (r.body() != null) n.setBody(r.body().trim());
            if (r.pinned() != null) n.setPinned(r.pinned());
            n.setUpdatedAt(Instant.now());
        }
        return build(userId);
    }

    /** Fijar o soltar, sin tener que mandar el resto de la nota. */
    @Transactional
    public NotesView fijar(UUID userId, UUID noteId) {
        Note n = propia(userId, noteId);
        n.setPinned(!n.isPinned());
        n.setUpdatedAt(Instant.now());
        return build(userId);
    }

    @Transactional
    public NotesView eliminar(UUID userId, UUID noteId) {
        notes.delete(propia(userId, noteId));
        return build(userId);
    }

    // ------------------------------------------------------------------------

    private NotesView build(UUID userId) {
        List<NoteView> vistas = notes.findByUserIdOrderByPinnedDescTitleAsc(userId).stream()
                .map(n -> new NoteView(
                        n.getId().toString(), n.getCategory(), n.getTitle(),
                        n.getBody(), n.isPinned(),
                        n.getUpdatedAt() == null ? "" : n.getUpdatedAt().toString()))
                .toList();
        return new NotesView(vistas, CATEGORIAS);
    }

    private String categoriaDe(String c) {
        return c == null || c.isBlank() ? "Otro" : c.trim();
    }

    private Note propia(UUID userId, UUID noteId) {
        Note n = notes.findById(noteId)
                .orElseThrow(() -> ApiException.notFound("No existe esa nota."));
        if (!n.getUserId().equals(userId))
            throw ApiException.forbidden("Esa nota no es tuya.");
        return n;
    }
}
