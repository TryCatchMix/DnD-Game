package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.service.QuestAuthoringService;
import com.trycatchmix.archivos.service.QuestAuthoringService.ImportResult;
import com.trycatchmix.archivos.service.QuestAuthoringService.QuestSummary;
import com.trycatchmix.archivos.service.QuestValidator.Report;
import com.trycatchmix.archivos.web.dto.QuestDraft;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * El editor de encargos del DM. Vive bajo /api/admin/**, reservado al rol DM.
 *
 *   GET  /api/admin/encargos            -> lista de encargos
 *   POST /api/admin/encargos/check      -> valida sin guardar
 *   POST /api/admin/encargos            -> guarda (sin publicar)
 *   GET  /api/admin/encargos/{code}     -> lo devuelve en formato borrador
 *   POST /api/admin/encargos/{code}/publicar | /despublicar
 */
@RestController
@RequestMapping("/api/admin/encargos")
@PreAuthorize("hasRole('DM')")
@RequiredArgsConstructor
public class AdminQuestController {

    private final QuestAuthoringService authoring;

    @GetMapping
    public List<QuestSummary> listar() {
        return authoring.list();
    }

    @PostMapping("/check")
    public Report check(@RequestBody QuestDraft draft) {
        return authoring.check(draft);
    }

    @PostMapping
    public ImportResult importar(@RequestBody QuestDraft draft) {
        return authoring.importDraft(draft);
    }

    @GetMapping("/{code}")
    public QuestDraft exportar(@PathVariable String code) {
        return authoring.export(code);
    }

    @PostMapping("/{code}/publicar")
    public Map<String, Object> publicar(@PathVariable String code) {
        var q = authoring.publish(code);
        return Map.of("code", q.getCode(), "title", q.getTitle(), "published", true);
    }

    @PostMapping("/{code}/despublicar")
    public Map<String, Object> despublicar(@PathVariable String code) {
        var q = authoring.unpublish(code);
        return Map.of("code", q.getCode(), "title", q.getTitle(), "published", false);
    }
}
