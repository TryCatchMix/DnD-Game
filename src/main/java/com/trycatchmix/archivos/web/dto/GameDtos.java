package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs del bucle de juego. Los nombres de campo son el contrato con el
 *  frontend (api.types.ts): cámbialos en los dos sitios o en ninguno. */
public final class GameDtos {
    private GameDtos() {}

    /**
     * Un personaje en la lista de «mis personajes».
     *
     * Lleva la campaña encima porque la lista mezcla dos cosas: los personajes
     * de quien mira y, si dirige alguna mesa, los de su grupo. Sin decir de qué
     * campaña es cada uno y si es tuyo, la pantalla no sabría cómo pintarlos.
     * `campaignId` a null = todavía no se ha unido a ninguna.
     */
    public record CharacterView(
            String id,
            String name,
            String ancestry,
            String role,
            int level,
            int vigor,
            int maxVigor,
            String location,
            String campaignId,
            String campaignName,
            boolean mine) {}

    /** Lo que manda el creador de personaje. Solo el nombre es obligatorio; lo
     *  demás tiene valores por defecto sensatos y se afina luego en la ficha. */
    public record CharacterCreateRequest(
            String name, String clazz, String race, String alignment, String player,
            String city, Integer level,
            Integer strScore, Integer dexScore, Integer conScore,
            Integer intScore, Integer wisScore, Integer chaScore,
            Integer hpMax, Integer acTotal, Integer maxVigor) {}

    public record QuestCardView(
            String id,
            String title,
            String faction,
            String hook,
            List<String> skills,
            int vigorCost,
            String duration,
            int sceneCount,
            String rewardNote,
            String signatures,
            String closesIn,
            String availability,
            String reason) {}

    public record SceneOptionView(
            String id,
            String label,
            String skill,
            Integer dc,
            Integer successChance,
            int vigorCost,
            boolean affordable,
            String risk,
            String note) {}

    public record SceneView(
            String questTitle,
            int sceneOrdinal,
            int sceneCount,
            String title,
            String body,
            String waitingFor,
            List<SceneOptionView> options) {}

    public record RollModifierView(String label, int value) {}

    public record RollView(
            int grade,
            String gradeLabel,
            int d20,
            List<RollModifierView> breakdown,
            int dc,
            int total) {}

    public record ResolutionView(
            RollView roll,
            String narrative,
            List<String> changes,
            boolean finished,
            String waitingFor) {}
}
