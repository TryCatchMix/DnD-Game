package com.trycatchmix.archivos.web.dto;

import java.time.Instant;
import java.util.List;

/** DTOs del grimorio (conjuros e invocaciones). */
public final class SpellDtos {
    private SpellDtos() {}

    /** Una clase que aprende el conjuro: a qué nivel y con qué atributo lanza.
     *  `saveDcFormula` deja escrita la CD para no tener que recordarla. */
    public record SpellClassView(String clazz, int level, String keyAbility, String saveDcFormula) {}

    public record SpellView(
            String id,
            String name,
            String nameEn,
            String school,
            String subschool,
            String descriptors,
            String description,
            /** El nivel más bajo entre las clases (para ordenar y filtrar). */
            int minLevel,
            // --- bloque de estadísticas ---
            String components,
            String castingTime,
            String range,
            String target,
            String targetKind,
            String duration,
            String savingThrow,
            String spellResistance,
            // --- daño y escalado ---
            String dice,
            String scaling,
            String cap,
            /** "1d6 por nivel de lanzador (máx. 10d6)", ya montado para leer. */
            String damageSummary,
            String source,
            /** true = "de la casa" (lo añadió la mesa; se puede borrar). */
            boolean custom,
            List<SpellClassView> classes) {}

    /** Una página de conjuros: los que caben en el límite pedido más el total
     *  que hay tras el filtro, para que el frontend sepa cuántos quedan. */
    public record SpellPage(int total, List<SpellView> items) {}

    /** Una aptitud de clase (Bárbaro, Guerrero, Monje). No es un conjuro. */
    public record FeatureView(
            String clazz,
            String name,
            int level,
            String kind,
            String description,
            String source) {}

    /** Una invocación de warlock. No tiene nivel de conjuro 0-9: tiene grado y
     *  se usa a voluntad. */
    public record InvocationView(
            String name,
            String nameEn,
            String grade,
            int gradeOrder,
            int spellLevel,
            int minClassLevel,
            String kind,
            String savingThrow,
            String spellResistance,
            String dice,
            String scaling,
            String description,
            String keyAbility,
            String saveDcFormula,
            boolean atWill,
            String source) {}

    /** Una clase que aprende un conjuro nuevo, tal como llega del formulario.
     *  El atributo de lanzamiento (keyAbility) lo deduce el servidor de la clase,
     *  para no pedírselo al usuario. */
    public record SpellClassInput(String clazz, int level) {}

    /** Un conjuro "de la casa" recién creado desde la pestaña Habilidades. Solo
     *  el nombre y al menos una clase son obligatorios; el resto del bloque de
     *  estadísticas es opcional y se rellena si se sabe. */
    public record SpellCreate(
            String name,
            String nameEn,
            String school,
            String subschool,
            String descriptors,
            String description,
            String components,
            String castingTime,
            String range,
            String target,
            String targetKind,
            String duration,
            String savingThrow,
            String spellResistance,
            String dice,
            String scaling,
            String cap,
            List<SpellClassInput> classes) {}
}
