package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignAccess;
import com.trycatchmix.archivos.service.CombatService;
import com.trycatchmix.archivos.web.dto.CombatDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Los enemigos del máster y sus combates, dentro de una campaña.
 *
 *   GET    …/mesa/enemigos                        -> los que tiene guardados
 *   POST   …/mesa/enemigos/del-bestiario          -> copiar una criatura
 *   POST   …/mesa/enemigos                        -> inventar uno
 *   PUT    …/mesa/enemigos/{id}                   -> retocarlo
 *   DELETE …/mesa/enemigos/{id}
 *
 *   GET    …/mesa/combates                        -> los combates guardados
 *   POST   …/mesa/combates                        -> abrir uno
 *   GET    …/mesa/combates/{id}
 *   DELETE …/mesa/combates/{id}
 *   POST   …/mesa/combates/{id}/enemigos          -> meter enemigos (varios)
 *   POST   …/mesa/combates/{id}/personajes        -> meter un personaje
 *   POST   …/mesa/combates/{id}/sueltos           -> meter algo a mano
 *   POST   …/mesa/combates/{id}/iniciativa        -> tirar por todos
 *   POST   …/mesa/combates/{id}/siguiente         -> pasar turno
 *   POST   …/mesa/combates/{id}/combatientes/{cid}/pg   -> daño o curación
 *   PUT    …/mesa/combates/{id}/combatientes/{cid}
 *   DELETE …/mesa/combates/{id}/combatientes/{cid}
 *
 * Todo lo del combate devuelve el combate entero ya actualizado, como el resto
 * de La Mesa: el frontend solo repinta.
 *
 * El permiso es dirigir ESTA campaña, no tener el rol DM en la cuenta: lo mira
 * {@link #dm} en cada método.
 */
@RestController
@RequestMapping("/api/campanas/{campanaId}/mesa")
@RequiredArgsConstructor
public class CombatController {

    private final CombatService combate;
    private final CampaignAccess access;

    // -------------------------------------------------------------- enemigos

    @GetMapping("/enemigos")
    public List<EnemyView> enemigos(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID campanaId) {
        return combate.enemigos(dm(p, campanaId));
    }

    /** Copiar una criatura del bestiario. Es una copia: el manual no se toca. */
    @PostMapping("/enemigos/del-bestiario")
    public EnemyView copiar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId,
                            @RequestBody EnemyFromMonsterRequest req) {
        return combate.copiarDelBestiario(user(p), dm(p, campanaId), req);
    }

    @PostMapping("/enemigos")
    public EnemyView crear(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID campanaId,
                           @RequestBody EnemyUpsertRequest req) {
        return combate.crear(user(p), dm(p, campanaId), req);
    }

    @PutMapping("/enemigos/{enemigoId}")
    public EnemyView editar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId,
                            @PathVariable UUID enemigoId,
                            @RequestBody EnemyUpsertRequest req) {
        return combate.editar(dm(p, campanaId), enemigoId, req);
    }

    @DeleteMapping("/enemigos/{enemigoId}")
    public ResponseEntity<Void> borrar(@AuthenticationPrincipal AuthPrincipal p,
                                       @PathVariable UUID campanaId,
                                       @PathVariable UUID enemigoId) {
        combate.borrar(dm(p, campanaId), enemigoId);
        return ResponseEntity.noContent().build();
    }

    // -------------------------------------------------------------- combates

    @GetMapping("/combates")
    public List<CombatSummary> combates(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID campanaId) {
        return combate.combates(dm(p, campanaId));
    }

    @PostMapping("/combates")
    public CombatView abrir(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId,
                            @RequestBody(required = false) CombatCreateRequest req) {
        return combate.crearCombate(user(p), dm(p, campanaId), req);
    }

    @GetMapping("/combates/{combateId}")
    public CombatView ver(@AuthenticationPrincipal AuthPrincipal p,
                          @PathVariable UUID campanaId,
                          @PathVariable UUID combateId) {
        return combate.combate(dm(p, campanaId), combateId);
    }

    @DeleteMapping("/combates/{combateId}")
    public ResponseEntity<Void> cerrar(@AuthenticationPrincipal AuthPrincipal p,
                                       @PathVariable UUID campanaId,
                                       @PathVariable UUID combateId) {
        combate.borrarCombate(dm(p, campanaId), combateId);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/combates/{combateId}/enemigos")
    public CombatView meterEnemigos(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID campanaId,
                                    @PathVariable UUID combateId,
                                    @RequestBody AddEnemiesRequest req) {
        return combate.anadirEnemigos(dm(p, campanaId), combateId, req);
    }

    @PostMapping("/combates/{combateId}/personajes")
    public CombatView meterPersonaje(@AuthenticationPrincipal AuthPrincipal p,
                                     @PathVariable UUID campanaId,
                                     @PathVariable UUID combateId,
                                     @RequestBody AddCharacterRequest req) {
        return combate.anadirPersonaje(dm(p, campanaId), combateId, req);
    }

    @PostMapping("/combates/{combateId}/sueltos")
    public CombatView meterSuelto(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId,
                                  @PathVariable UUID combateId,
                                  @RequestBody AddLooseRequest req) {
        return combate.anadirSuelto(dm(p, campanaId), combateId, req);
    }

    /** Tira 1d20 + modificador por quien no tenga iniciativa puesta. Con
     *  `personajes=false` no toca a los jugadores, que suelen tirar sus dados. */
    @PostMapping("/combates/{combateId}/iniciativa")
    public CombatView iniciativa(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID campanaId,
                                 @PathVariable UUID combateId,
                                 @RequestParam(defaultValue = "true") boolean personajes) {
        return combate.tirarIniciativa(dm(p, campanaId), combateId, personajes);
    }

    @PostMapping("/combates/{combateId}/siguiente")
    public CombatView siguiente(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID campanaId,
                                @PathVariable UUID combateId) {
        return combate.siguienteTurno(dm(p, campanaId), combateId);
    }

    @PostMapping("/combates/{combateId}/combatientes/{combatantId}/pg")
    public CombatView pg(@AuthenticationPrincipal AuthPrincipal p,
                         @PathVariable UUID campanaId,
                         @PathVariable UUID combateId, @PathVariable UUID combatantId,
                         @RequestBody HpChangeRequest req) {
        return combate.cambiarPg(dm(p, campanaId), combateId, combatantId, req.delta());
    }

    @PutMapping("/combates/{combateId}/combatientes/{combatantId}")
    public CombatView editarCombatiente(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID campanaId,
                                        @PathVariable UUID combateId,
                                        @PathVariable UUID combatantId,
                                        @RequestBody CombatantEditRequest req) {
        return combate.editarCombatiente(dm(p, campanaId), combateId, combatantId, req);
    }

    @DeleteMapping("/combates/{combateId}/combatientes/{combatantId}")
    public CombatView quitarCombatiente(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID campanaId,
                                        @PathVariable UUID combateId,
                                        @PathVariable UUID combatantId) {
        return combate.quitarCombatiente(dm(p, campanaId), combateId, combatantId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    /** La campaña, tras comprobar que quien pregunta la dirige. */
    private UUID dm(AuthPrincipal p, UUID campanaId) {
        return access.exigeDm(user(p), campanaId).getId();
    }
}
