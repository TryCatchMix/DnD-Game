package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignService;
import com.trycatchmix.archivos.web.dto.CampaignDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

/**
 * Las campañas: crearlas, repartir el código y entrar con un personaje.
 *
 *   GET    /api/campanas                          -> las mías + personajes sueltos
 *   POST   /api/campanas                          -> crear (me quedo de DM)
 *   POST   /api/campanas/unirse                   -> entrar con un código
 *   GET    /api/campanas/{id}                     -> la mesa entera
 *   PUT    /api/campanas/{id}                     -> editar (DM)
 *   DELETE /api/campanas/{id}                     -> borrarla (solo quien la creó)
 *   POST   /api/campanas/{id}/codigo              -> código nuevo (DM)
 *   POST   /api/campanas/{id}/salir               -> me voy
 *   POST   /api/campanas/{id}/personajes/{charId} -> traer un personaje mío
 *   DELETE /api/campanas/{id}/personajes/{charId} -> sacarlo
 *   DELETE /api/campanas/{id}/miembros/{userId}   -> echar a alguien (DM)
 *   PUT    /api/campanas/{id}/miembros/{userId}   -> DM o jugador (DM)
 *
 * No hay @PreAuthorize aquí: el permiso no es de la cuenta, es de la campaña, y
 * lo comprueba el servicio contra la membresía (ver CampaignAccess).
 */
@RestController
@RequestMapping("/api/campanas")
@RequiredArgsConstructor
public class CampaignController {

    private final CampaignService campanas;

    @GetMapping
    public CampaignsView mias(@AuthenticationPrincipal AuthPrincipal p) {
        return campanas.mias(user(p));
    }

    @PostMapping
    public CampaignDetail crear(@AuthenticationPrincipal AuthPrincipal p,
                                @RequestBody CampaignRequest req) {
        return campanas.crear(user(p), req);
    }

    @PostMapping("/unirse")
    public CampaignDetail unirse(@AuthenticationPrincipal AuthPrincipal p,
                                 @RequestBody JoinRequest req) {
        return campanas.unirse(user(p), req);
    }

    @GetMapping("/{campanaId}")
    public CampaignDetail abrir(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID campanaId) {
        return campanas.abrir(user(p), campanaId);
    }

    @PutMapping("/{campanaId}")
    public CampaignDetail editar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID campanaId,
                                 @RequestBody CampaignRequest req) {
        return campanas.editar(user(p), campanaId, req);
    }

    @DeleteMapping("/{campanaId}")
    public CampaignsView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId) {
        return campanas.eliminar(user(p), campanaId);
    }

    @PostMapping("/{campanaId}/codigo")
    public CampaignDetail renovarCodigo(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID campanaId) {
        return campanas.renovarCodigo(user(p), campanaId);
    }

    @PostMapping("/{campanaId}/salir")
    public CampaignsView salir(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID campanaId) {
        return campanas.salir(user(p), campanaId);
    }

    @PostMapping("/{campanaId}/personajes/{charId}")
    public CampaignDetail apuntar(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId, @PathVariable UUID charId) {
        return campanas.apuntar(user(p), campanaId, charId);
    }

    @DeleteMapping("/{campanaId}/personajes/{charId}")
    public CampaignDetail sacar(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID campanaId, @PathVariable UUID charId) {
        return campanas.sacar(user(p), campanaId, charId);
    }

    @DeleteMapping("/{campanaId}/miembros/{otroId}")
    public CampaignDetail expulsar(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID campanaId, @PathVariable UUID otroId) {
        return campanas.expulsar(user(p), campanaId, otroId);
    }

    @PutMapping("/{campanaId}/miembros/{otroId}")
    public CampaignDetail cambiarPapel(@AuthenticationPrincipal AuthPrincipal p,
                                       @PathVariable UUID campanaId, @PathVariable UUID otroId,
                                       @RequestBody Map<String, String> body) {
        return campanas.cambiarPapel(user(p), campanaId, otroId,
                body == null ? null : body.get("role"));
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
