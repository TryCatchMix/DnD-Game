package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Invocation;
import com.trycatchmix.archivos.domain.Spell;
import com.trycatchmix.archivos.domain.SpellClass;
import com.trycatchmix.archivos.repo.InvocationRepository;
import com.trycatchmix.archivos.repo.SpellRepository;
import com.trycatchmix.archivos.web.dto.SpellDtos.InvocationView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellClassView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;

/** El grimorio: todos los conjuros con las clases que los aprenden, y las
 *  invocaciones de warlock. El filtro por clase y la búsqueda por nombre los
 *  hace el frontend, para que sea instantáneo mientras escribes. */
@Service
@RequiredArgsConstructor
public class SpellService {

    private final SpellRepository spells;
    private final InvocationRepository invocations;

    @Transactional(readOnly = true)
    public List<SpellView> hechizos() {
        return spells.findAllByOrderByNameAsc().stream().map(s -> {
            List<SpellClassView> clases = s.getClasses().stream()
                    .sorted(Comparator.comparingInt(SpellClass::getLevel)
                            .thenComparing(SpellClass::getClazz))
                    .map(sc -> new SpellClassView(sc.getClazz(), sc.getLevel(),
                            sc.getKeyAbility(), dcFormula(sc.getLevel(), sc.getKeyAbility())))
                    .toList();
            int minLevel = clases.stream().mapToInt(SpellClassView::level).min().orElse(0);
            return new SpellView(
                    s.getName(), s.getNameEn(), s.getSchool(), s.getSubschool(),
                    s.getDescriptors(), s.getDescription(), minLevel,
                    s.getComponents(), s.getCastingTime(), s.getSpellRange(),
                    s.getTarget(), s.getTargetKind(), s.getDuration(),
                    s.getSavingThrow(), s.getSpellResistance(),
                    s.getDice(), s.getScaling(), s.getCap(),
                    damageSummary(s.getDice(), s.getScaling(), s.getCap()),
                    s.getSource(), clases);
        }).toList();
    }

    @Transactional(readOnly = true)
    public List<InvocationView> invocaciones() {
        return invocations.findAllByOrderByGradeOrderAscNameAsc().stream()
                .map(i -> new InvocationView(
                        i.getName(), i.getNameEn(), i.getGrade(), i.getGradeOrder(),
                        i.getSpellLevel(), i.getMinClassLevel(), i.getKind(),
                        i.getSavingThrow(), i.getSpellResistance(),
                        i.getDice(), i.getScaling(), i.getDescription(),
                        i.getKeyAbility(), dcFormula(i.getSpellLevel(), i.getKeyAbility()),
                        i.isAtWill(), i.getSource()))
                .toList();
    }

    /** "CD 13 + mod. de Sabiduría" — la fórmula ya resuelta salvo el modificador,
     *  que depende de quién lance. */
    private String dcFormula(int spellLevel, String keyAbility) {
        if (keyAbility == null || keyAbility.isBlank()) return "";
        return "CD " + (10 + spellLevel) + " + mod. de " + keyAbility;
    }

    /** "1d6 por nivel de lanzador (máx. 10d6)". */
    private String damageSummary(String dice, String scaling, String cap) {
        if ((dice == null || dice.isBlank()) && (scaling == null || scaling.isBlank()))
            return "";
        StringBuilder sb = new StringBuilder();
        if (dice != null && !dice.isBlank()) sb.append(dice);
        if (scaling != null && !scaling.isBlank())
            sb.append(sb.isEmpty() ? "" : " ").append(scaling);
        if (cap != null && !cap.isBlank()) sb.append(" (máx. ").append(cap).append(")");
        return sb.toString().trim();
    }
}
