package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.GameService;
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

    @GetMapping
    public List<CharacterView> personajes(@AuthenticationPrincipal AuthPrincipal p) {
        return game.listCharacters(user(p), isAdmin(p));
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
        return game.ficha(user(p), charId, isAdmin(p));
    }

    /** Editar la ficha (todos los campos y la lista de habilidades). */
    @PutMapping("/{charId}")
    public FichaView editarFicha(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId,
                                 @RequestBody FichaEditRequest req) {
        return game.editarFicha(user(p), charId, isAdmin(p), req);
    }

    /** Borrar el personaje con todo lo suyo. Devuelve la lista ya sin él. */
    @DeleteMapping("/{charId}")
    public List<CharacterView> borrar(@AuthenticationPrincipal AuthPrincipal p,
                                      @PathVariable UUID charId) {
        return game.borrarPersonaje(user(p), charId, isAdmin(p));
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

    /** El máster (DM) es el administrador de la mesa. */
    private boolean isAdmin(AuthPrincipal p) {
        return p != null && "DM".equals(p.role());
    }
}
