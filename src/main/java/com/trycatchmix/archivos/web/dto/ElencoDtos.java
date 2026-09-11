package com.trycatchmix.archivos.web.dto;

import java.util.List;

/**
 * DTOs del elenco.
 *
 * La regla de oro: un campo que el jugador todavía no ha descubierto llega
 * como {@code null}. No se manda con una marca de "oculto" para que el
 * frontend lo tape —lo que viaja al navegador se puede leer—, así que lo que no
 * se sabe sencillamente no sale de aquí.
 */
public final class ElencoDtos {
    private ElencoDtos() {}

    // ----------------------------------------------------------- relaciones

    /**
     * Una relación ya resuelta para enseñar.
     *
     * @param who    el nombre del otro extremo, con la misma discreción: si es
     *               un PNJ cuyo nombre sigue sellado, aquí llega su alias.
     * @param revealed solo para el máster; null para el jugador (todo lo que
     *               le llega está descubierto por definición).
     */
    public record RelationView(
            String id,
            String kind,
            String who,
            String note,
            Boolean revealed) {}

    /** Alta y edición de una relación. Solo uno de los tres destinos manda. */
    public record RelationRequest(
            String kind,
            String otherNpcId,
            String characterId,
            String otherName,
            String note,
            Boolean revealed) {}

    // ------------------------------------------------------------- la ficha

    /** Qué está descubierto. Solo viaja al máster: es su panel de mando. */
    public record Reveal(
            boolean listed,
            boolean name,
            boolean portrait,
            boolean title,
            boolean location,
            boolean race,
            boolean description,
            boolean trivia,
            boolean alignment) {}

    /**
     * La ficha tal como la ve QUIEN pregunta.
     *
     * @param name        el de verdad, o el alias si el nombre sigue sellado
     * @param alias       solo para el máster (al jugador ya le llega en `name`)
     * @param portrait    hay retrato Y se puede ver; los bytes van aparte
     * @param porDescubrir cuántos campos rellenos quedan sellados. Es lo que
     *                    convierte una ficha a medias en un gancho en vez de en
     *                    un formulario incompleto.
     * @param reveal      null para el jugador
     */
    public record NpcView(
            String id,
            String name,
            String alias,
            String title,
            String location,
            String race,
            String description,
            List<String> trivia,
            String alignment,
            boolean portrait,
            List<RelationView> relations,
            int porDescubrir,
            Reveal reveal) {}

    /** Alta y edición: lo que llegue a null se deja como estaba. */
    public record NpcRequest(
            String name,
            String alias,
            String title,
            String location,
            String race,
            String description,
            String trivia,
            String alignment,
            Reveal reveal) {}

    /**
     * El elenco entero.
     *
     * @param dm          si quien mira dirige esta mesa (manda en la interfaz)
     * @param alignments  la lista sugerida del desplegable; el backend acepta
     *                    cualquier texto, como en el bloc de notas
     * @param kinds       amistoso | neutral | enemigo | familiar
     * @param personajes  los personajes jugadores de la mesa, para poder decir
     *                    "es enemigo de Brann" sin escribir el nombre a mano
     */
    public record ElencoView(
            List<NpcView> npcs,
            boolean dm,
            List<String> alignments,
            List<String> kinds,
            List<Quien> personajes) {}

    /** Alguien a quien apuntar en una relación: un PJ o un PNJ del elenco. */
    public record Quien(String id, String name) {}
}
