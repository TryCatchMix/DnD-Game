package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.*;
import com.trycatchmix.archivos.repo.*;
import com.trycatchmix.archivos.service.QuestValidator.Report;
import com.trycatchmix.archivos.web.dto.QuestDraft;
import com.trycatchmix.archivos.web.dto.QuestDraft.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * Escribir encargos sin tocar SQL, y que salgan jugables.
 *
 * Reglas de la casa (heredadas del diseño original):
 *  · Importar es SUSTITUIR: si el código ya existe, se reemplazan sus escenas.
 *  · Un encargo con partidas EN CURSO no se puede reescribir.
 *  · Importar nunca publica; publicar es un paso aparte y explícito.
 */
@Service
@RequiredArgsConstructor
public class QuestAuthoringService {

    private final QuestRepository quests;
    private final SceneRepository scenes;
    private final SceneOptionRepository options;
    private final OutcomeRepository outcomes;
    private final OptionModifierRepository modifiers;
    private final QuestRunRepository runs;
    private final QuestValidator validator;

    public record ImportResult(String code, String title, boolean created, Report report) {}
    public record QuestSummary(String code, String title, String location, boolean published, int sceneCount) {}

    public static class InvalidDraftException extends RuntimeException {
        private final transient Report report;
        public InvalidDraftException(Report r) {
            super("El encargo tiene %d error(es).".formatted(r.errors().size()));
            this.report = r;
        }
        public Report getReport() { return report; }
    }

    public static class QuestInUseException extends RuntimeException {
        public QuestInUseException(String code, long partidas) {
            super(("El encargo '%s' tiene %d partida(s) en curso. Espera a que terminen "
                 + "o duplícalo con otro código.").formatted(code, partidas));
        }
    }

    public static class QuestNotFoundException extends RuntimeException {
        public QuestNotFoundException(String code) {
            super("No existe el encargo '%s'.".formatted(code));
        }
    }

    // ------------------------------------------------------------- listar ----

    @Transactional(readOnly = true)
    public List<QuestSummary> list() {
        return quests.findAll().stream()
                .sorted(Comparator.comparing(Quest::getTitle))
                .map(q -> new QuestSummary(q.getCode(), q.getTitle(), q.getLocation(),
                        q.isPublished(), q.getSceneCount()))
                .toList();
    }

    // ------------------------------------------------------------ validar ----

    @Transactional(readOnly = true)
    public Report check(QuestDraft draft) {
        return validator.validate(draft);
    }

    // ---------------------------------------------------------- importar -----

    @Transactional
    public ImportResult importDraft(QuestDraft draft) {
        Report report = validator.validate(draft);
        if (!report.isValid()) throw new InvalidDraftException(report);

        Optional<Quest> existente = quests.findByCode(draft.code());

        if (existente.isPresent()) {
            long enCurso = runs.countByQuestIdAndStatus(existente.get().getId(), RunStatus.IN_PROGRESS);
            if (enCurso > 0) throw new QuestInUseException(draft.code(), enCurso);
            borrarEscenas(existente.get().getId());
        }

        Quest quest = existente.orElseGet(Quest::new);
        boolean creado = existente.isEmpty();

        cabecera(quest, draft);
        quest.setPublished(false);          // importar nunca publica
        quests.save(quest);

        construirEscenas(quest, draft);

        return new ImportResult(quest.getCode(), quest.getTitle(), creado, report);
    }

    // --------------------------------------------------------- publicar -----

    @Transactional
    public Quest publish(String code) {
        Quest quest = quests.findByCode(code).orElseThrow(() -> new QuestNotFoundException(code));

        // Segunda red: comprobar el estado REAL de las opciones con tirada.
        List<QuestValidator.Problem> problemas = new ArrayList<>();
        for (Scene sc : scenes.findByQuestIdOrderByOrdinalAsc(quest.getId()))
            for (SceneOption op : options.findBySceneId(sc.getId()))
                if (op.getSkill() != null && op.getDc() != null && op.getOutcomes().size() < 5)
                    problemas.add(new QuestValidator.Problem(sc.getTitle(),
                            "La opción '%s' no tiene los 5 grados.".formatted(op.getLabel())));

        if (!problemas.isEmpty())
            throw new InvalidDraftException(new Report(problemas, List.of()));

        quest.setPublished(true);
        return quest;
    }

    @Transactional
    public Quest unpublish(String code) {
        Quest quest = quests.findByCode(code).orElseThrow(() -> new QuestNotFoundException(code));
        quest.setPublished(false);
        return quest;
    }

    // ---------------------------------------------------------- exportar ----

    @Transactional(readOnly = true)
    public QuestDraft export(String code) {
        Quest q = quests.findByCode(code).orElseThrow(() -> new QuestNotFoundException(code));

        List<Scene> ordenadas = scenes.findByQuestIdOrderByOrdinalAsc(q.getId());
        Map<UUID, String> clavePorId = new HashMap<>();
        for (int i = 0; i < ordenadas.size(); i++)
            clavePorId.put(ordenadas.get(i).getId(), "escena" + (i + 1));

        List<SceneDraft> escenas = ordenadas.stream().map(sc -> new SceneDraft(
                clavePorId.get(sc.getId()), sc.getTitle(), sc.getBody(),
                sc.isFinalScene() ? Boolean.TRUE : null,
                options.findBySceneId(sc.getId()).stream()
                        .sorted(Comparator.comparingInt(SceneOption::getOrdinal))
                        .map(op -> exportarOpcion(op, clavePorId))
                        .toList())).toList();

        return new QuestDraft(
                q.getCode(), q.getTitle(), q.getHook(), q.getLocation(), q.getFaction(),
                q.getVigorCost(), q.getDuration(), q.getRewardNote(), q.getMinLevel(),
                q.getRequiredFlag(), q.getRequiredFlagState(), q.getRequirementLabel(),
                Arrays.stream((q.getSkillTags() == null ? "" : q.getSkillTags()).split(","))
                        .map(String::trim).filter(s -> !s.isEmpty()).toList(),
                escenas);
    }

    private OptionDraft exportarOpcion(SceneOption op, Map<UUID, String> claves) {
        Map<String, OutcomeDraft> outs = new LinkedHashMap<>();
        op.getOutcomes().stream().sorted(Comparator.comparingInt(Outcome::getGrade)).forEach(o ->
                outs.put(String.valueOf(o.getGrade()), new OutcomeDraft(
                        o.getNarrative(),
                        o.getNextSceneId() != null ? claves.get(o.getNextSceneId()) : null,
                        o.isEndsQuest() ? Boolean.TRUE : null)));

        return new OptionDraft(
                op.getLabel(), op.getSkill(), op.getDc(), op.getVigorCost(), op.getRisk(), op.getNote(),
                op.getModifiers().stream()
                        .map(m -> new ModifierDraft(m.getLabel(), m.getValue()))
                        .toList(),
                outs);
    }

    // ------------------------------------------------------- construcción ---

    private void cabecera(Quest q, QuestDraft d) {
        q.setCode(d.code());
        q.setTitle(d.title());
        q.setHook(d.hook());
        q.setLocation(d.location());
        q.setFaction(blankToNull(d.faction()));
        q.setVigorCost(orElse(d.vigorCost(), 1));
        q.setDuration(d.duration() == null ? "" : d.duration());
        q.setRewardNote(blankToNull(d.rewardNote()));
        q.setMinLevel(orElse(d.minLevel(), 1));
        q.setRequiredFlag(blankToNull(d.requiredFlag()));
        q.setRequiredFlagState(d.requiredFlagState());
        q.setRequirementLabel(blankToNull(d.requirementLabel()));
        q.setSceneCount(d.scenes().size());
        q.setSkillTags(d.skills() == null ? "" : String.join(",", d.skills()));
    }

    private void borrarEscenas(UUID questId) {
        for (Scene sc : scenes.findByQuestIdOrderByOrdinalAsc(questId)) {
            for (SceneOption op : options.findBySceneId(sc.getId())) {
                outcomes.deleteByOptionId(op.getId());
                modifiers.deleteByOptionId(op.getId());
            }
            options.deleteBySceneId(sc.getId());
        }
        scenes.deleteByQuestId(questId);
        scenes.flush();
    }

    private void construirEscenas(Quest q, QuestDraft d) {
        // Pasada 1: crear las escenas para tener sus ids.
        Map<String, Scene> porClave = new LinkedHashMap<>();
        int ordinal = 1;
        for (SceneDraft sd : d.scenes()) {
            Scene sc = new Scene();
            sc.setQuest(q);
            sc.setOrdinal(ordinal++);
            sc.setTitle(sd.title());
            sc.setBody(sd.body());
            sc.setFinalScene(Boolean.TRUE.equals(sd.isFinal()));
            scenes.save(sc);
            porClave.put(sd.key(), sc);
        }

        // Pasada 2: opciones, modificadores y desenlaces (ya con los ids).
        for (SceneDraft sd : d.scenes()) {
            Scene sc = porClave.get(sd.key());
            boolean algunNext = false;
            int op = 1;

            for (OptionDraft od : sd.options()) {
                SceneOption o = new SceneOption();
                o.setScene(sc);
                o.setOrdinal(op++);
                o.setLabel(od.label());
                o.setSkill(blankToNull(od.skill()));
                o.setDc(od.dc());
                o.setVigorCost(orElse(od.vigorCost(), 0));
                o.setRisk(blankToNull(od.risk()));
                o.setNote(blankToNull(od.note()));
                options.save(o);

                if (od.modifiers() != null)
                    for (ModifierDraft md : od.modifiers()) {
                        OptionModifier m = new OptionModifier();
                        m.setOption(o);
                        m.setLabel(md.label());
                        m.setValue(orElse(md.value(), 0));
                        modifiers.save(m);
                    }

                if (od.outcomes() != null)
                    for (var e : od.outcomes().entrySet()) {
                        OutcomeDraft odc = e.getValue();
                        Outcome out = new Outcome();
                        out.setOption(o);
                        out.setGrade(Integer.parseInt(e.getKey()));
                        out.setNarrative(odc.text());
                        boolean end = Boolean.TRUE.equals(odc.end());
                        out.setEndsQuest(end);
                        Scene siguiente = (!end && odc.next() != null) ? porClave.get(odc.next()) : null;
                        out.setNextSceneId(siguiente != null ? siguiente.getId() : null);
                        if (siguiente != null) algunNext = true;
                        outcomes.save(out);
                    }
            }

            // Si nada sale de la escena, es final aunque no se marcara.
            if (!algunNext && !sc.isFinalScene()) {
                sc.setFinalScene(true);
                scenes.save(sc);
            }
        }
    }

    private static String blankToNull(String s) { return (s == null || s.isBlank()) ? null : s; }
    private static int orElse(Integer v, int def) { return v != null ? v : def; }
}
