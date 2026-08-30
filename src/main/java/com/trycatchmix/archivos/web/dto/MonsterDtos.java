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
            String source) {}

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
