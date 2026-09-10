package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignAccess;
import com.trycatchmix.archivos.service.QuestAuthoringService;
import com.trycatchmix.archivos.service.QuestAuthoringService.ImportResult;
import com.trycatchmix.archivos.service.QuestAuthoringService.QuestSummary;
import com.trycatchmix.archivos.service.QuestValidator.Report;
import com.trycatchmix.archivos.web.dto.QuestDraft;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * El editor de encargos, dentro de una campaña.
 *
 *   GET  …/encargos                -> los de la campaña + los comunes
 *   POST …/encargos/check          -> valida sin guardar
 *   POST …/encargos                -> guarda en esta campaña (sin publicar)
 *   GET  …/encargos/{code}         -> lo devuelve en formato borrador
 *   POST …/encargos/{code}/publicar | /despublicar
 *
 * Lo que se escribe aquí sale en el tablón de ESTA mesa y en ninguna otra. Los
 * encargos comunes —los que venían de fábrica— se listan y se exportan, pero no
 * se editan: cambiarlos afectaría a todas las campañas a la vez.
 *
 * El permiso es dirigir la campaña, no el rol de la cuenta.
 */
@RestController
@RequestMapping("/api/campanas/{campanaId}/encargos")
@RequiredArgsConstructor
public class AdminQuestController {

    private final QuestAuthoringService authoring;
    private final CampaignAccess access;

    @GetMapping
    public List<QuestSummary> listar(@AuthenticationPrincipal AuthPrincipal p,
                                     @PathVariable UUID campanaId) {
        return authoring.list(dm(p, campanaId));
    }

    @PostMapping("/check")
    public Report check(@AuthenticationPrincipal AuthPrincipal p,
                        @PathVariable UUID campanaId,
                        @RequestBody QuestDraft draft) {
        dm(p, campanaId);
        return authoring.check(draft);
    }

    @PostMapping
    public ImportResult importar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID campanaId,
                                 @RequestBody QuestDraft draft) {
        return authoring.importDraft(dm(p, campanaId), draft);
    }

    @GetMapping("/{code}")
    public QuestDraft exportar(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID campanaId,
                               @PathVariable String code) {
        return authoring.export(dm(p, campanaId), code);
    }

    @PostMapping("/{code}/publicar")
    public Map<String, Object> publicar(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID campanaId,
                                        @PathVariable String code) {
        var q = authoring.publish(dm(p, campanaId), code);
        return Map.of("code", q.getCode(), "title", q.getTitle(), "published", true);
    }

    @PostMapping("/{code}/despublicar")
    public Map<String, Object> despublicar(@AuthenticationPrincipal AuthPrincipal p,
                                           @PathVariable UUID campanaId,
                                           @PathVariable String code) {
        var q = authoring.unpublish(dm(p, campanaId), code);
        return Map.of("code", q.getCode(), "title", q.getTitle(), "published", false);
    }

    /** La campaña, tras comprobar que quien pregunta la dirige. */
    private UUID dm(AuthPrincipal p, UUID campanaId) {
        if (p == null) throw ApiException.sessionExpired();
        return access.exigeDm(p.userId(), campanaId).getId();
    }
}
