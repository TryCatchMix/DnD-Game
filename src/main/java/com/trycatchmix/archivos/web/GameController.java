package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignService;
import com.trycatchmix.archivos.service.GameService;
import com.trycatchmix.archivos.web.dto.CampaignDtos.CampaignContext;
import com.trycatchmix.archivos.web.dto.FichaDtos.FichaEditRequest;
import com.trycatchmix.archivos.web.dto.FichaDtos.FichaView;
import com.trycatchmix.archivos.web.dto.GameDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * El bucle de juego, con las rutas en español que espera probar.sh y el
 * frontend (juego.service.ts).
 */
@RestController
@RequestMapping("/api/personajes")
@RequiredArgsConstructor
public class GameController {

    private final GameService game;
    private final CampaignService campanas;

    @GetMapping
    public List<CharacterView> personajes(@AuthenticationPrincipal AuthPrincipal p) {
        return game.listCharacters(user(p));
    }

    /** Crear un personaje nuevo. Devuelve su ficha ya montada. */
    @PostMapping
    public FichaView crear(@AuthenticationPrincipal AuthPrincipal p,
                           @RequestBody CharacterCreateRequest req) {
        return game.crearPersonaje(user(p), req);
    }

    /** La hoja de personaje D&D 3.5 completa. */
    @GetMapping("/{charId}")
    public FichaView ficha(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID charId) {
        return game.ficha(user(p), charId);
    }

    /** Editar la ficha (todos los campos y la lista de habilidades). */
    @PutMapping("/{charId}")
    public FichaView editarFicha(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId,
                                 @RequestBody FichaEditRequest req) {
        return game.editarFicha(user(p), charId, req);
    }

    /** Borrar el personaje con todo lo suyo. Devuelve la lista ya sin él. */
    @DeleteMapping("/{charId}")
    public List<CharacterView> borrar(@AuthenticationPrincipal AuthPrincipal p,
                                      @PathVariable UUID charId) {
        return game.borrarPersonaje(user(p), charId);
    }

    /**
     * En qué campaña juega este personaje y qué soy yo en ella.
     *
     * Lo pregunta cada pantalla que cuelga de un personaje antes de pedir nada
     * más: la ruta del navegador lleva el personaje, pero el bloc, la tienda y
     * La Mesa son de la campaña. Devuelve todo a null si aún no se ha unido.
     */
    @GetMapping("/{charId}/campana")
    public CampaignContext campana(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID charId) {
        return campanas.contexto(user(p), charId);
    }

    @GetMapping("/{charId}/tablon")
    public List<QuestCardView> tablon(@AuthenticationPrincipal AuthPrincipal p,
                                      @PathVariable UUID charId) {
        return game.tablon(user(p), charId);
    }

    /** Firmar un encargo y recibir su primera escena. */
    @PostMapping("/{charId}/encargos/{questId}")
    public SceneView firmar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID charId, @PathVariable UUID questId) {
        return game.firmar(user(p), charId, questId);
    }

    /** La escena en la que va el personaje ahora mismo. */
    @GetMapping("/{charId}/escena")
    public SceneView escena(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID charId) {
        return game.escenaActual(user(p), charId);
    }

    /** Elegir una opción: el servidor tira el d20 y devuelve el expediente. */
    @PostMapping("/{charId}/escena/opciones/{optionId}")
    public ResolutionView elegir(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId, @PathVariable UUID optionId) {
        return game.elegir(user(p), charId, optionId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
