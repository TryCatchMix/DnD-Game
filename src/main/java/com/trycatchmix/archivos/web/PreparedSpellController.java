package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.PreparedSpellService;
import com.trycatchmix.archivos.web.dto.PreparedDtos.CountRequest;
import com.trycatchmix.archivos.web.dto.PreparedDtos.PreparedList;
import com.trycatchmix.archivos.web.dto.PreparedDtos.PrepareRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * Los conjuros preparados de un personaje: prepararse la lista antes de jugar.
 * Mismo control de propiedad que la ficha (dueño o DM). Todas las operaciones
 * devuelven la lista entera ya actualizada, para repintar de una.
 */
@RestController
@RequestMapping("/api/personajes/{charId}/conjuros")
@RequiredArgsConstructor
public class PreparedSpellController {

    private final PreparedSpellService prepared;

    @GetMapping
    public PreparedList listar(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID charId) {
        return prepared.listar(user(p), charId, isAdmin(p));
    }

    @PostMapping
    public PreparedList preparar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId,
                                 @RequestBody PrepareRequest req) {
        return prepared.preparar(user(p), charId, isAdmin(p), req.name(), req.prepared());
    }

    @PatchMapping("/{prepId}")
    public PreparedList fijarCantidad(@AuthenticationPrincipal AuthPrincipal p,
                                      @PathVariable UUID charId,
                                      @PathVariable UUID prepId,
                                      @RequestBody CountRequest req) {
        return prepared.fijarCantidad(user(p), charId, isAdmin(p), prepId, req.prepared());
    }

    @DeleteMapping("/{prepId}")
    public PreparedList quitar(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID charId,
                               @PathVariable UUID prepId) {
        return prepared.quitar(user(p), charId, isAdmin(p), prepId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    private boolean isAdmin(AuthPrincipal p) {
        return p != null && "DM".equals(p.role());
    }
}
