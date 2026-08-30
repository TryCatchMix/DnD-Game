package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CombatService;
import com.trycatchmix.archivos.web.dto.CombatDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Los enemigos del máster y sus combates.
 *
 *   GET    /api/mesa/enemigos                        -> los que tiene guardados
 *   POST   /api/mesa/enemigos/del-bestiario          -> copiar una criatura
 *   POST   /api/mesa/enemigos                        -> inventar uno
 *   PUT    /api/mesa/enemigos/{id}                   -> retocarlo
 *   DELETE /api/mesa/enemigos/{id}
 *
 *   GET    /api/mesa/combates                        -> los combates guardados
 *   POST   /api/mesa/combates                        -> abrir uno
 *   GET    /api/mesa/combates/{id}
 *   DELETE /api/mesa/combates/{id}
 *   POST   /api/mesa/combates/{id}/enemigos          -> meter enemigos (varios)
 *   POST   /api/mesa/combates/{id}/personajes        -> meter un personaje
 *   POST   /api/mesa/combates/{id}/sueltos           -> meter algo a mano
 *   POST   /api/mesa/combates/{id}/iniciativa        -> tirar por todos
 *   POST   /api/mesa/combates/{id}/siguiente         -> pasar turno
 *   POST   /api/mesa/combates/{id}/combatientes/{cid}/pg   -> daño o curación
 *   PUT    /api/mesa/combates/{id}/combatientes/{cid}
 *   DELETE /api/mesa/combates/{id}/combatientes/{cid}
 *
 * Todo lo del combate devuelve el combate entero ya actualizado, como el resto
 * de La Mesa: el frontend solo repinta.
 *
 * Va bajo /api/mesa porque es material del máster: SecurityConfig ya exige DM
 * para toda esa rama.
 */
@RestController
@RequestMapping("/api/mesa")
@PreAuthorize("hasRole('DM')")
@RequiredArgsConstructor
public class CombatController {

    private final CombatService combate;

    // -------------------------------------------------------------- enemigos

    @GetMapping("/enemigos")
    public List<EnemyView> enemigos(@AuthenticationPrincipal AuthPrincipal p) {
        return combate.enemigos(user(p));
    }

    /** Copiar una criatura del bestiario. Es una copia: el manual no se toca. */
    @PostMapping("/enemigos/del-bestiario")
    public EnemyView copiar(@AuthenticationPrincipal AuthPrincipal p,
                            @RequestBody EnemyFromMonsterRequest req) {
        return combate.copiarDelBestiario(user(p), req);
    }

    @PostMapping("/enemigos")
    public EnemyView crear(@AuthenticationPrincipal AuthPrincipal p,
                           @RequestBody EnemyUpsertRequest req) {
        return combate.crear(user(p), req);
    }

    @PutMapping("/enemigos/{enemigoId}")
    public EnemyView editar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID enemigoId,
                            @RequestBody EnemyUpsertRequest req) {
        return combate.editar(user(p), enemigoId, req);
    }

    @DeleteMapping("/enemigos/{enemigoId}")
    public ResponseEntity<Void> borrar(@AuthenticationPrincipal AuthPrincipal p,
                                       @PathVariable UUID enemigoId) {
        combate.borrar(user(p), enemigoId);
        return ResponseEntity.noContent().build();
    }

    // -------------------------------------------------------------- combates

    @GetMapping("/combates")
    public List<CombatSummary> combates(@AuthenticationPrincipal AuthPrincipal p) {
        return combate.combates(user(p));
    }

    @PostMapping("/combates")
    public CombatView abrir(@AuthenticationPrincipal AuthPrincipal p,
                            @RequestBody(required = false) CombatCreateRequest req) {
        return combate.crearCombate(user(p), req);
    }

    @GetMapping("/combates/{combateId}")
    public CombatView ver(@AuthenticationPrincipal AuthPrincipal p,
                          @PathVariable UUID combateId) {
        return combate.combate(user(p), combateId);
    }

    @DeleteMapping("/combates/{combateId}")
    public ResponseEntity<Void> cerrar(@AuthenticationPrincipal AuthPrincipal p,
                                       @PathVariable UUID combateId) {
        combate.borrarCombate(user(p), combateId);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/combates/{combateId}/enemigos")
    public CombatView meterEnemigos(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID combateId,
                                    @RequestBody AddEnemiesRequest req) {
        return combate.anadirEnemigos(user(p), combateId, req);
    }

    @PostMapping("/combates/{combateId}/personajes")
    public CombatView meterPersonaje(@AuthenticationPrincipal AuthPrincipal p,
                                     @PathVariable UUID combateId,
                                     @RequestBody AddCharacterRequest req) {
        return combate.anadirPersonaje(user(p), combateId, req);
    }

    @PostMapping("/combates/{combateId}/sueltos")
    public CombatView meterSuelto(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID combateId,
                                  @RequestBody AddLooseRequest req) {
        return combate.anadirSuelto(user(p), combateId, req);
    }

    /** Tira 1d20 + modificador por quien no tenga iniciativa puesta. Con
     *  `personajes=false` no toca a los jugadores, que suelen tirar sus dados. */
    @PostMapping("/combates/{combateId}/iniciativa")
    public CombatView iniciativa(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID combateId,
                                 @RequestParam(defaultValue = "true") boolean personajes) {
        return combate.tirarIniciativa(user(p), combateId, personajes);
    }

    @PostMapping("/combates/{combateId}/siguiente")
    public CombatView siguiente(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID combateId) {
        return combate.siguienteTurno(user(p), combateId);
    }

    @PostMapping("/combates/{combateId}/combatientes/{combatantId}/pg")
    public CombatView pg(@AuthenticationPrincipal AuthPrincipal p,
                         @PathVariable UUID combateId, @PathVariable UUID combatantId,
                         @RequestBody HpChangeRequest req) {
        return combate.cambiarPg(user(p), combateId, combatantId, req.delta());
    }

    @PutMapping("/combates/{combateId}/combatientes/{combatantId}")
    public CombatView editarCombatiente(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID combateId,
                                        @PathVariable UUID combatantId,
                                        @RequestBody CombatantEditRequest req) {
        return combate.editarCombatiente(user(p), combateId, combatantId, req);
    }

    @DeleteMapping("/combates/{combateId}/combatientes/{combatantId}")
    public CombatView quitarCombatiente(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID combateId,
                                        @PathVariable UUID combatantId) {
        return combate.quitarCombatiente(user(p), combateId, combatantId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
