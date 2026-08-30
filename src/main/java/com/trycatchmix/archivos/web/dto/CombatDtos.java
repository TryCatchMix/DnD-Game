package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs de los enemigos del máster y de sus combates. */
public final class CombatDtos {
    private CombatDtos() {}

    /** Un enemigo de la lista del DM. */
    public record EnemyView(
            String id,
            String name,
            String sizeType,
            String cr,
            int hpMax,
            int ac,
            int acTouch,
            int acFlatFooted,
            int initMod,
            String speed,
            String saves,
            String abilities,
            String attack,
            String fullAttack,
            String specialAttacks,
            String specialQualities,
            String skills,
            String feats,
            String notes,
            /** De qué monstruo salió, si salió de alguno. */
            String monsterId,
            String monsterName,
            String misionId) {}

    /** Copiar un monstruo del bestiario a la lista del DM. El nombre es
     *  opcional: si no viene, se usa el de la criatura. */
    public record EnemyFromMonsterRequest(String monsterId, String name, String misionId) {}

    /** Crear o editar un enemigo a mano. Todo opcional salvo el nombre. */
    public record EnemyUpsertRequest(
            String name, String sizeType, String cr,
            Integer hpMax, Integer ac, Integer acTouch, Integer acFlatFooted, Integer initMod,
            String speed, String saves, String abilities,
            String attack, String fullAttack, String specialAttacks, String specialQualities,
            String skills, String feats, String notes, String misionId) {}

    /** Alguien metido en el combate. */
    public record CombatantView(
            String id,
            /** enemigo | personaje | suelto. */
            String kind,
            String name,
            int initiative,
            int hpMax,
            int hpCurrent,
            int ac,
            String conditions,
            String notes,
            boolean defeated,
            int sortOrdinal,
            /** true si le toca ahora mismo. */
            boolean active,
            String enemigoId,
            String characterId) {}

    public record CombatView(
            String id,
            String title,
            /** 0 = aún no ha empezado. */
            int round,
            int turnOrdinal,
            String misionId,
            List<CombatantView> combatants) {}

    /** Lo mínimo para listar los combates guardados. */
    public record CombatSummary(String id, String title, int round, int combatants) {}

    public record CombatCreateRequest(String title, String misionId) {}

    /** Meter enemigos en el combate. `count` mayor que 1 los numera:
     *  "Trasgo 1", "Trasgo 2"… */
    public record AddEnemiesRequest(String enemigoId, Integer count) {}

    public record AddCharacterRequest(String characterId) {}

    /** Alguien escrito a mano, sin plantilla. */
    public record AddLooseRequest(String name, Integer hpMax, Integer ac, Integer initMod) {}

    /** Daño (negativo) o curación (positivo). */
    public record HpChangeRequest(Integer delta) {}

    public record CombatantEditRequest(
            String name, Integer initiative, Integer hpMax, Integer hpCurrent,
            Integer ac, String conditions, String notes, Boolean defeated) {}
}
