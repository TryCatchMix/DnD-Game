package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.NoteService;
import com.trycatchmix.archivos.web.dto.NoteDtos.NoteRequest;
import com.trycatchmix.archivos.web.dto.NoteDtos.NotesView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * El bloc de notas del jugador. Cuelga de /api/notas (no del personaje) porque
 * las notas son del jugador: siguen valiendo aunque cambie de personaje.
 *
 * Todas las operaciones devuelven el bloc entero ya actualizado, así el
 * frontend solo tiene que repintar.
 */
@RestController
@RequestMapping("/api/notas")
@RequiredArgsConstructor
public class NoteController {

    private final NoteService notes;

    @GetMapping
    public NotesView listar(@AuthenticationPrincipal AuthPrincipal p) {
        return notes.listar(user(p));
    }

    @PostMapping
    public NotesView crear(@AuthenticationPrincipal AuthPrincipal p,
                           @RequestBody NoteRequest req) {
        return notes.crear(user(p), req);
    }

    @PutMapping("/{noteId}")
    public NotesView editar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID noteId, @RequestBody NoteRequest req) {
        return notes.editar(user(p), noteId, req);
    }

    /** Fijar o soltar la nota, sin mandar el resto. */
    @PostMapping("/{noteId}/fijar")
    public NotesView fijar(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID noteId) {
        return notes.fijar(user(p), noteId);
    }

    @DeleteMapping("/{noteId}")
    public NotesView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                              @PathVariable UUID noteId) {
        return notes.eliminar(user(p), noteId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
