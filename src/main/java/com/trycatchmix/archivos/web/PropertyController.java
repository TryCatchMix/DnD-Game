package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.PropertyService;
import com.trycatchmix.archivos.web.dto.PropertyDtos.BuyRequest;
import com.trycatchmix.archivos.web.dto.PropertyDtos.HoldingsView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * El juego de propiedades de un personaje: comprar, recaudar la renta, mejorar
 * y vender. Todas las rutas devuelven el estado completo (HoldingsView) para
 * que el frontend repinte de una.
 */
@RestController
@RequestMapping("/api/personajes/{charId}/propiedades")
@RequiredArgsConstructor
public class PropertyController {

    private final PropertyService properties;

    @GetMapping
    public HoldingsView listar(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID charId) {
        return properties.holdings(user(p), charId, isAdmin(p));
    }

    @PostMapping
    public HoldingsView comprar(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID charId,
                                @RequestBody BuyRequest req) {
        return properties.comprar(user(p), charId, isAdmin(p), req);
    }

    @PostMapping("/{propId}/mejorar")
    public HoldingsView mejorar(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID charId, @PathVariable UUID propId) {
        return properties.mejorar(user(p), charId, isAdmin(p), propId);
    }

    @PostMapping("/{propId}/recaudar")
    public HoldingsView recaudar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId, @PathVariable UUID propId) {
        return properties.recaudar(user(p), charId, isAdmin(p), propId);
    }

    @DeleteMapping("/{propId}")
    public HoldingsView vender(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID charId, @PathVariable UUID propId) {
        return properties.vender(user(p), charId, isAdmin(p), propId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    private boolean isAdmin(AuthPrincipal p) {
        return p != null && "DM".equals(p.role());
    }
}
