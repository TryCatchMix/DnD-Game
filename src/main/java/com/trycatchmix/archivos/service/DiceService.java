package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.OptionModifier;
import com.trycatchmix.archivos.web.dto.GameDtos.RollModifierView;
import com.trycatchmix.archivos.web.dto.GameDtos.RollView;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * El d20 y su desglose. Un solo dado contra una CD, con cinco grados de
 * resultado según el margen: el mismo sistema que muestran los mockups.
 */
@Service
public class DiceService {

    /** Tira el dado y arma el expediente completo de la tirada. */
    public RollView roll(String skillLabel, int skillMod, List<OptionModifier> mods, int dc) {
        int d20 = ThreadLocalRandom.current().nextInt(1, 21);

        List<RollModifierView> breakdown = new ArrayList<>();
        if (skillLabel != null) breakdown.add(new RollModifierView(skillLabel, skillMod));
        for (OptionModifier m : mods) breakdown.add(new RollModifierView(m.getLabel(), m.getValue()));

        int total = d20 + fixedBonus(skillMod, mods);
        int grade = gradeFor(total - dc);
        return new RollView(grade, gradeLabel(grade), d20, breakdown, dc, total);
    }

    /** Probabilidad de éxito (grado ≥ 3) antes de tirar, en %. */
    public int successChance(int skillMod, List<OptionModifier> mods, int dc) {
        int bonus = fixedBonus(skillMod, mods);
        int exitos = 0;
        for (int cara = 1; cara <= 20; cara++)
            if (cara + bonus - dc >= 0) exitos++;   // margen >= 0 => grado 3+
        return Math.round(exitos * 100f / 20f);
    }

    private int fixedBonus(int skillMod, List<OptionModifier> mods) {
        return skillMod + mods.stream().mapToInt(OptionModifier::getValue).sum();
    }

    /** El margen (total - CD) decide el grado, 1..5. */
    public int gradeFor(int margin) {
        if (margin <= -5) return 1;
        if (margin < 0)   return 2;
        if (margin < 5)   return 3;
        if (margin < 10)  return 4;
        return 5;
    }

    public String gradeLabel(int grade) {
        return switch (grade) {
            case 1 -> "Desastre";
            case 2 -> "Fallo";
            case 3 -> "Éxito con coste";
            case 4 -> "Éxito";
            default -> "Éxito rotundo";
        };
    }
}
