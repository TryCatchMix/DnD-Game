package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una dote que tiene un personaje concreto.
 *
 * Guarda el NOMBRE, no una referencia obligatoria al compendio, por dos
 * razones: muchas dotes se eligen "para algo" (Arma focalizada con la espada
 * larga, Conjuro focalizado en Evocación) y eso va en {@link #detail}; y una
 * dote de la casa que el máster invente tiene que caber igual.
 *
 * `featId` es un enlace opcional al compendio: si está, la ficha puede enseñar
 * el beneficio de la dote sin que el jugador tenga que ir a buscarlo.
 */
@Entity
@Table(name = "character_feats")
@Getter @Setter
public class CharacterFeat {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "character_id", nullable = false)
    private UUID characterId;

    /** El nombre visible ("Arma focalizada"). */
    @Column(nullable = false)
    private String name;

    /** Con qué: "espada larga", "Evocación"… Vacío si la dote no se especifica. */
    @Column(nullable = false)
    private String detail = "";

    /** La dote del compendio, si es una de las del manual. */
    @Column(name = "feat_id")
    private UUID featId;

    /** Para conservar el orden en que las escribió el jugador. */
    @Column(name = "sort_ordinal", nullable = false)
    private int sortOrdinal = 0;
}
