package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.GameService;
import com.trycatchmix.archivos.web.dto.DevDtos.DevFicha;
import com.trycatchmix.archivos.web.dto.DevDtos.DevPersonaje;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Endpoints de conveniencia para probar.sh. Solo existen en el perfil dev:
 * exponen la ficha completa (bolsa, carga, habilidades) sin pantalla propia.
 */
@RestController
@RequestMapping("/api/dev")
@Profile("dev")
@RequiredArgsConstructor
public class DevController {

    private final GameService game;

    @GetMapping("/personajes")
    public List<DevPersonaje> personajes(@AuthenticationPrincipal AuthPrincipal p) {
        return game.devPersonajes(user(p));
    }

    @GetMapping("/personajes/{id}")
    public DevFicha ficha(@AuthenticationPrincipal AuthPrincipal p, @PathVariable UUID id) {
        return game.devFicha(user(p), id);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
