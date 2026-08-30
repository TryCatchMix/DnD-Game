package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs del bestiario. */
public final class MonsterDtos {
    private MonsterDtos() {}

    /**
     * Lo justo para pintar una criatura en la lista. La ficha completa se pide
     * aparte al abrirla, para no mandar 588 bloques de estadísticas enteros.
     */
    public record MonsterRow(
            String id,
            String name,
            String nameEn,
            String sizeType,
            String creatureType,
            /** El VD ya formateado para leer: "½", "7", "—". */
            String cr,
            String environment,
            /** 'criatura' o 'plantilla'. */
            String kind) {}

    /**
     * Lo que hace falta para el selector de nivel de una criatura con clase.
     *
     * `notes` recoge lo que el escalado NO puede decidir: qué dote se coge,
     * dónde va el +1 de característica, en qué se gastan los puntos de
     * habilidad. Son elecciones del máster, no cuentas.
     */
    public record ScalingView(
            /** La clase en inglés, que es la clave real (Warrior ≠ Fighter). */
            String classNameEn,
            String className,
            /** El nivel que trae el manual. */
            int baseLevel,
            /** El nivel que se está viendo. */
            int level,
            int minLevel,
            int maxLevel,
            /** true si se está viendo el nivel original, sin tocar nada. */
            boolean original,
            /** Cuántas dotes gana entre el nivel base y el pedido. */
            int featsGained,
            /** Cuántas subidas de +1 a una característica. */
            int abilityIncreases,
            /** Puntos de habilidad que reparte por el camino. */
            int skillPoints,
            /** VD estimado. Es una estimación, y la interfaz lo dice. */
            String estimatedCr,
            List<String> notes) {}

    /** La ficha completa, con el bloque tal cual se lee en la mesa. */
    public record MonsterView(
            String id,
            String name,
            String nameEn,
            String family,
            String creatureType,
            String sizeType,
            String cr,
            String challengeRating,
            String hitDice,
            String initiative,
            String speed,
            String armorClass,
            String baseAttack,
            String attack,
            String fullAttack,
            String spaceReach,
            String specialAttacks,
            String specialQualities,
            String saves,
            String abilities,
            String skills,
            String feats,
            String environment,
            String organization,
            String treasure,
            String alignment,
            String advancement,
            String levelAdjustment,
            String description,
            String kind,
            String source,
            /** Solo si la criatura tiene niveles de clase. Null si no. */
            ScalingView scaling) {}

    /** Una página de resultados: el total del filtro y el trozo pedido. */
    public record MonsterPage(int total, List<MonsterRow> items) {}

    /** Los valores por los que se puede filtrar, sacados de los propios datos
     *  para que el frontend no los lleve escritos a mano. */
    public record BestiaryFilters(
            List<String> types,
            List<String> environments,
            /** El VD más bajo y el más alto que hay en el bestiario. */
            double minCr,
            double maxCr) {}
}
