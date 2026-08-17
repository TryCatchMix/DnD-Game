package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.BackstoryService;
import com.trycatchmix.archivos.web.dto.BackstoryDtos.BackstoryView;
import com.trycatchmix.archivos.web.dto.BackstoryDtos.SaveRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * El trasfondo del personaje: leer y guardar su historia con formato.
 * Ambas rutas devuelven la vista completa (HTML + fecha) para repintar de una.
 */
@RestController
@RequestMapping("/api/personajes/{charId}/trasfondo")
@RequiredArgsConstructor
public class BackstoryController {

    private final BackstoryService backstory;

    @GetMapping
    public BackstoryView ver(@AuthenticationPrincipal AuthPrincipal p,
                             @PathVariable UUID charId) {
        return backstory.ver(user(p), charId, isAdmin(p));
    }

    @PutMapping
    public BackstoryView guardar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId,
                                 @RequestBody SaveRequest req) {
        return backstory.guardar(user(p), charId, isAdmin(p), req);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    private boolean isAdmin(AuthPrincipal p) {
        return p != null && "DM".equals(p.role());
    }
}
