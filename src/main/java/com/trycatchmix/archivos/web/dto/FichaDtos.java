package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs de la hoja de personaje D&D 3.5 (ver y editar). */
public final class FichaDtos {
    private FichaDtos() {}

    /** Una característica: puntuación (editable) y su modificador (calculado). */
    public record AbilityView(String key, String name, int score, int modifier) {}

    /** Una dote del personaje, ya resuelta contra el compendio: además de lo
     *  que eligió el jugador, viaja el beneficio para poder leerlo en la ficha
     *  sin ir a buscarlo. `benefit` va vacío si es una dote de la casa. */
    public record FeatOnSheetView(
            String name,
            /** Con qué: "espada larga", "Evocación"… */
            String detail,
            String kind,
            String prerequisite,
            String benefit) {}

    /** Una línea de ataque salida de un arma equipada. */
    public record AtaqueView(
            String weapon,
            /** "cuerpo a cuerpo" o "a distancia". */
            String mode,
            /** El bonificador ya con signo: "+5". */
            String attack,
            /** El daño con el modificador de Fuerza dentro: "1d8+3". */
            String damage,
            String critical,
            String damageType,
            /** Incremento de distancia; vacío en las armas cuerpo a cuerpo. */
            String rangeIncrement) {}

    /**
     * Lo que aporta lo que el personaje lleva PUESTO.
     *
     * Se manda al lado de la ficha, no dentro: los valores de la hoja los
     * escribe el jugador (ahí van la armadura natural, la desviación y las
     * reglas de la casa) y esto es lo que dice el equipo, para comparar.
     */
    public record EquipoView(
            String armor,
            String shield,
            int acFromArmor,
            int acFromShield,
            /** Tope de Destreza de la armadura; null si no lleva ninguna. */
            Integer maxDex,
            int dexMod,
            /** El modificador de Destreza que de verdad cuenta, ya topado. */
            int dexApplied,
            /** Penalizador de armadura (negativo o 0). */
            int armorCheck,
            /** Fallo de conjuros arcanos, en tanto por ciento. */
            int spellFailure,
            /** Velocidad con la armadura puesta. */
            int speed,
            // la CA que sale de lo puesto, para comparar con la de la ficha
            int suggestedAc,
            int suggestedTouch,
            int suggestedFlatFooted,
            List<AtaqueView> attacks) {}

    /** Una habilidad con su desglose 3.5. */
    public record SkillDetailView(
            String name, String code, String keyAbility,
            int ranks, int miscMod, int total) {}

    /** La ficha completa que se muestra. Lo `calculado` (mods, iniciativa,
     *  presa, totales de habilidad) lo hace el backend; el resto es editable. */
    public record FichaView(
            String id,
            // identidad
            String name, String player, String clazz, int level, String race,
            String alignment, String deity, String size, String age, String sex,
            String height, String weight, String campaign, String location,
            // dominios del clérigo (códigos; ver DomainCatalog). Vacío si no aplica.
            String domain1, String domain2,
            // características (con modificadores ya calculados)
            List<AbilityView> abilities,
            // combate
            int hpCurrent, int hpMax,
            int acTotal, int acTouch, int acFlatFooted,
            int initiative, int initiativeMisc,
            int speed,
            int bab, int grapple, int grappleMisc,
            int spellResistance,
            int saveFort, int saveRef, int saveWill,
            String damageReduction,
            // recursos del juego + bolsa (purseCp es el monedero en crudo, para editarlo)
            int vigor, int maxVigor, long purseCp, String bolsa, String carga,
            // habilidades
            List<SkillDetailView> skills,
            // dotes elegidas
            List<FeatOnSheetView> feats,
            /** Lo que aporta el equipo puesto. Nunca pisa los valores de arriba. */
            EquipoView equipo) {}

    /** Lo que llega al editar. Todo lo editable; el monedero se toca en la
     *  tienda, no aquí. Las características son puntuaciones; los modificadores
     *  se recalculan solos. */
    public record FichaEditRequest(
            String name, String player, String clazz, Integer level, String race,
            String alignment, String deity, String size, String age, String sex,
            String height, String weight, String campaign, String location,
            String domain1, String domain2,
            Integer strScore, Integer dexScore, Integer conScore,
            Integer intScore, Integer wisScore, Integer chaScore,
            Integer hpCurrent, Integer hpMax,
            Integer acTotal, Integer acTouch, Integer acFlatFooted,
            Integer initiativeMisc, Integer speed,
            Integer bab, Integer grappleMisc, Integer spellResistance,
            Integer saveFort, Integer saveRef, Integer saveWill,
            String damageReduction,
            Integer vigor, Integer maxVigor, Long purseCp, String carga,
            List<SkillEdit> skills,
            List<FeatEdit> feats) {

        public record SkillEdit(String name, String keyAbility, Integer ranks, Integer miscMod) {}

        /** Una dote elegida: el nombre y, si aplica, con qué. */
        public record FeatEdit(String name, String detail) {}
    }
}
