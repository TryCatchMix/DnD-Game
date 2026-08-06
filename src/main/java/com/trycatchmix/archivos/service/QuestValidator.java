package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.web.dto.QuestDraft;
import com.trycatchmix.archivos.web.dto.QuestDraft.*;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * Comprueba un borrador de encargo antes de guardarlo: te dice qué está mal
 * (errores, que impiden guardar) y qué es sospechoso (avisos, que no).
 */
@Component
public class QuestValidator {

    public record Problem(String field, String message) {}

    public record Report(List<Problem> errors, List<Problem> warnings) {
        public boolean isValid() { return errors.isEmpty(); }
    }

    private static final Set<String> RIESGOS = Set.of("LOW", "MEDIUM", "HIGH");

    public Report validate(QuestDraft d) {
        List<Problem> err = new ArrayList<>();
        List<Problem> warn = new ArrayList<>();

        req(err, "code", d.code());
        req(err, "title", d.title());
        req(err, "hook", d.hook());
        req(err, "location", d.location());

        if (d.code() != null && !d.code().matches("[a-z0-9_]+"))
            warn.add(new Problem("code", "El código debería ser minúsculas, dígitos y guiones bajos."));

        if (d.scenes() == null || d.scenes().isEmpty()) {
            err.add(new Problem("scenes", "El encargo necesita al menos una escena."));
            return new Report(err, warn);
        }

        // claves de escena
        Set<String> claves = new HashSet<>();
        for (int i = 0; i < d.scenes().size(); i++) {
            SceneDraft sc = d.scenes().get(i);
            String donde = "escena " + (i + 1);
            if (sc.key() == null || sc.key().isBlank())
                err.add(new Problem(donde, "Cada escena necesita una clave (key)."));
            else if (!claves.add(sc.key()))
                err.add(new Problem(donde, "Clave de escena repetida: " + sc.key()));
        }

        boolean algunEnd = false;
        boolean algunFinal = false;

        for (SceneDraft sc : d.scenes()) {
            String donde = "escena '" + sc.key() + "'";
            req(err, donde + " · title", sc.title());
            req(err, donde + " · body", sc.body());
            if (Boolean.TRUE.equals(sc.isFinal())) algunFinal = true;

            if (sc.options() == null || sc.options().isEmpty()) {
                err.add(new Problem(donde, "La escena no tiene opciones."));
                continue;
            }

            for (OptionDraft op : sc.options()) {
                String oq = donde + " · opción '" + safe(op.label()) + "'";
                if (op.label() == null || op.label().isBlank())
                    err.add(new Problem(donde, "Una opción no tiene etiqueta (label)."));
                if (op.risk() != null && !RIESGOS.contains(op.risk()))
                    err.add(new Problem(oq, "Riesgo inválido: " + op.risk() + " (LOW, MEDIUM o HIGH)."));

                Map<String, OutcomeDraft> outs = op.outcomes() == null ? Map.of() : op.outcomes();
                boolean tira = op.skill() != null && !op.skill().isBlank();

                if (tira) {
                    if (op.dc() == null)
                        err.add(new Problem(oq, "Una opción con tirada necesita CD (dc)."));
                    for (int g = 1; g <= 5; g++)
                        if (!outs.containsKey(String.valueOf(g)))
                            err.add(new Problem(oq, "Falta el desenlace del grado " + g + " (una opción con tirada necesita los cinco)."));
                } else {
                    if (outs.isEmpty())
                        err.add(new Problem(oq, "Una opción sin tirada necesita al menos un desenlace."));
                    else if (!outs.containsKey("4"))
                        warn.add(new Problem(oq, "Sin tirada se resuelve con el grado 4; conviene definir ese desenlace."));
                }

                for (var e : outs.entrySet()) {
                    OutcomeDraft od = e.getValue();
                    String og = oq + " · grado " + e.getKey();
                    if (od.text() == null || od.text().isBlank())
                        err.add(new Problem(og, "El desenlace no tiene texto."));
                    if (Boolean.TRUE.equals(od.end())) algunEnd = true;
                    if (od.next() != null && !od.next().isBlank()) {
                        if (!claves.contains(od.next()))
                            err.add(new Problem(og, "Apunta a una escena que no existe: " + od.next()));
                        if (Boolean.TRUE.equals(od.end()))
                            warn.add(new Problem(og, "Tiene 'end' y 'next'; gana 'end' (cierra el encargo)."));
                    }
                }
            }
        }

        if (d.requiredFlag() != null && !d.requiredFlag().isBlank()
                && (d.requirementLabel() == null || d.requirementLabel().isBlank()))
            warn.add(new Problem("requiredFlag", "Sin requirementLabel, el bloqueo no explicará por qué en el tablón."));

        if (!algunEnd && !algunFinal)
            warn.add(new Problem("scenes", "Ningún desenlace cierra el encargo ni hay escena final: podría no terminar nunca."));

        return new Report(err, warn);
    }

    private void req(List<Problem> err, String field, String value) {
        if (value == null || value.isBlank())
            err.add(new Problem(field, "Es obligatorio."));
    }

    private String safe(String s) { return s == null ? "?" : s; }
}
