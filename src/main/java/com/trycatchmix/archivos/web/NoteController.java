package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignAccess;
import com.trycatchmix.archivos.service.NoteService;
import com.trycatchmix.archivos.web.dto.NoteDtos.NoteRequest;
import com.trycatchmix.archivos.web.dto.NoteDtos.NotesView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * El bloc de notas del jugador, dentro de una campaña.
 *
 * Sigue siendo suyo —el máster no lo lee—, pero ahora cuelga de la mesa: los
 * nombres, los lugares y las facciones de una partida no tienen por qué salir
 * en la otra. Por eso la ruta lleva la campaña y no el personaje: lo que
 * apuntas vale para todos tus personajes de esa mesa.
 *
 * Todas las operaciones devuelven el bloc entero ya actualizado, así el
 * frontend solo tiene que repintar.
 */
@RestController
@RequestMapping("/api/campanas/{campanaId}/notas")
@RequiredArgsConstructor
public class NoteController {

    private final NoteService notes;
    private final CampaignAccess access;

    @GetMapping
    public NotesView listar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId) {
        return notes.listar(miembro(p, campanaId), user(p));
    }

    @PostMapping
    public NotesView crear(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID campanaId,
                           @RequestBody NoteRequest req) {
        return notes.crear(miembro(p, campanaId), user(p), req);
    }

    @PutMapping("/{noteId}")
    public NotesView editar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId,
                            @PathVariable UUID noteId, @RequestBody NoteRequest req) {
        return notes.editar(miembro(p, campanaId), user(p), noteId, req);
    }

    /** Fijar o soltar la nota, sin mandar el resto. */
    @PostMapping("/{noteId}/fijar")
    public NotesView fijar(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID campanaId,
                           @PathVariable UUID noteId) {
        return notes.fijar(miembro(p, campanaId), user(p), noteId);
    }

    @DeleteMapping("/{noteId}")
    public NotesView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                              @PathVariable UUID campanaId,
                              @PathVariable UUID noteId) {
        return notes.eliminar(miembro(p, campanaId), user(p), noteId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    /** Basta con estar en la campaña: el bloc lo tiene todo el mundo. */
    private UUID miembro(AuthPrincipal p, UUID campanaId) {
        return access.exigeMiembro(user(p), campanaId).getId();
    }
}
