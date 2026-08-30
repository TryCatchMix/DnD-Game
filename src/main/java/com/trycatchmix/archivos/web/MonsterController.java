package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.MonsterService;
import com.trycatchmix.archivos.web.dto.MonsterDtos.BestiaryFilters;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterPage;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * El bestiario. Lo consulta cualquier jugador con sesión: es material de
 * consulta del manual, como las Habilidades, no material reservado del máster
 * (para eso está La Mesa, que sí es solo DM).
 */
@RestController
@RequestMapping("/api/bestiario")
@RequiredArgsConstructor
public class MonsterController {

    private final MonsterService bestiario;

    /** Lista filtrada y paginada. Por defecto 25 y ordenada por nombre. */
    @GetMapping
    public MonsterPage lista(@AuthenticationPrincipal AuthPrincipal p,
                             @RequestParam(required = false) String q,
                             @RequestParam(required = false) String tipo,
                             @RequestParam(required = false) String entorno,
                             @RequestParam(required = false) Double vdMin,
                             @RequestParam(required = false) Double vdMax,
                             @RequestParam(required = false) String orden,
                             @RequestParam(defaultValue = "25") int limite,
                             @RequestParam(defaultValue = "0") int offset) {
        exigeSesion(p);
        return bestiario.lista(q, tipo, entorno, vdMin, vdMax, orden, limite, offset);
    }

    /** Los valores que existen de verdad para los desplegables de filtro. */
    @GetMapping("/filtros")
    public BestiaryFilters filtros(@AuthenticationPrincipal AuthPrincipal p) {
        exigeSesion(p);
        return bestiario.filtros();
    }

    /** La ficha completa de una criatura. */
    @GetMapping("/{id}")
    public MonsterView ficha(@AuthenticationPrincipal AuthPrincipal p,
                             @PathVariable UUID id) {
        exigeSesion(p);
        return bestiario.ficha(id);
    }

    private void exigeSesion(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
    }
}
