package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Con quién se lleva bien un PNJ y con quién no.
 *
 * El otro extremo es una de tres cosas, y solo una: otro PNJ del elenco, un
 * personaje jugador de la mesa, o un nombre suelto (una facción, un muerto,
 * alguien sin ficha). Se guardan las tres columnas y manda la que venga
 * rellena; resolver el nombre que se enseña es cosa de ElencoService, que es
 * quien sabe si el jugador ya conoce a ese otro.
 *
 * {@link #revealed} va por relación: saber que odia al Gremio no cuenta que sea
 * hermano de la capitana.
 */
@Entity
@Table(name = "npc_relations")
@Getter @Setter
public class NpcRelation {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "npc_id", nullable = false)
    private UUID npcId;

    /** amistoso | neutral | enemigo | familiar. */
    @Column(nullable = false)
    private String kind = "neutral";

    @Column(name = "other_npc_id")
    private UUID otherNpcId;

    @Column(name = "character_id")
    private UUID characterId;

    /** El nombre a pelo, cuando el otro extremo no tiene ficha. */
    @Column(name = "other_name", nullable = false)
    private String otherName = "";

    /** "le debe 200 po", "hermanos de madre". */
    @Column(nullable = false, length = 2000)
    private String note = "";

    @Column(nullable = false)
    private boolean revealed = false;

    @Column(nullable = false)
    private int ordinal = 0;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}
