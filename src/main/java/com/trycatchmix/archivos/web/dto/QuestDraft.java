package com.trycatchmix.archivos.web.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;
import java.util.Map;

/**
 * Un encargo entero en un solo JSON, escribible a mano.
 *
 * Las escenas se referencian por una clave que eliges tú ("pozo", "fondo"), no
 * por UUID: escribir contenido con UUIDs a mano es imposible. Este formato es
 * el que se importa y se exporta en el editor del DM, y produce encargos que el
 * juego puede correr tal cual.
 *
 * Ejemplo mínimo:
 * <pre>
 * {
 *   "code": "silencio_minas",
 *   "title": "El silencio de las minas",
 *   "hook": "Hace once días que no sube nadie del pozo tercero.",
 *   "location": "Dorakan",
 *   "vigorCost": 2, "duration": "6 h", "rewardNote": "120 po",
 *   "skills": ["Trepar"],
 *   "scenes": [{
 *     "key": "pozo", "title": "...", "body": "...",
 *     "options": [{
 *       "label": "Bajar a pulso", "skill": "trepar", "dc": 18, "vigorCost": 1,
 *       "modifiers": [{"label": "Cable resbaladizo", "value": -2}],
 *       "outcomes": {
 *         "1": {"text": "Caes.", "end": true},
 *         "2": {"text": "No pasas.", "end": true},
 *         "3": {"text": "Bajas magullado.", "next": "fondo"},
 *         "4": {"text": "Bajas limpio.", "next": "fondo"},
 *         "5": {"text": "Como una escalera.", "next": "fondo"}
 *       }
 *     }]
 *   }, { "key": "fondo", "title": "...", "body": "...", "final": true, "options": [...] }]
 * }
 * </pre>
 */
public record QuestDraft(
        String code,
        String title,
        String hook,
        String location,
        String faction,
        Integer vigorCost,
        String duration,
        String rewardNote,
        Integer minLevel,
        String requiredFlag,
        Boolean requiredFlagState,
        String requirementLabel,
        List<String> skills,
        List<SceneDraft> scenes) {

    public record SceneDraft(
            String key,
            String title,
            String body,
            @JsonProperty("final") Boolean isFinal,
            List<OptionDraft> options) {}

    public record OptionDraft(
            String label,
            String skill,             // null = opción sin tirada
            Integer dc,
            Integer vigorCost,
            String risk,              // LOW | MEDIUM | HIGH
            String note,
            List<ModifierDraft> modifiers,
            /** Clave "1".."5" -> desenlace. Con tirada hacen falta los cinco. */
            Map<String, OutcomeDraft> outcomes) {}

    public record ModifierDraft(String label, Integer value) {}

    public record OutcomeDraft(
            String text,
            String next,              // clave de la escena siguiente
            Boolean end) {}
}
