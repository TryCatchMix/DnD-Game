package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Una cara del elenco: alguien que ha salido (o va a salir) en la campaña.
 *
 * Lo que distingue esta ficha de una nota del bloc es que se DESCUBRE a
 * trozos. Cada campo lleva su propio {@code reveal}: el máster lo ve todo, y
 * al jugador solo le viaja lo que ya se ha destapado. Mientras el nombre siga
 * sellado, la ficha se enseña con su {@link #alias} ("El encapuchado"), así que
 * ocultarlo no deja la tarjeta muda.
 */
@Entity
@Table(name = "npcs")
@Getter @Setter
public class Npc {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** La mesa a la que pertenece. Un elenco no se ve desde otra campaña. */
    @Column(name = "campaign_id", nullable = false)
    private UUID campaignId;

    /** Quién lo escribió. El permiso lo da dirigir la campaña, no esta columna. */
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(nullable = false)
    private String name;

    /** Cómo se le llama mientras el nombre esté sellado. */
    @Column(nullable = false)
    private String alias = "Desconocido";

    @Column(nullable = false)
    private String title = "";

    @Column(nullable = false)
    private String location = "";

    @Column(nullable = false)
    private String race = "";

    @Column(nullable = false, length = 6000)
    private String description = "";

    /** Curiosidades, una por línea. */
    @Column(nullable = false, length = 4000)
    private String trivia = "";

    @Column(nullable = false)
    private String alignment = "";

    /** El retrato, guardado en la biblioteca de La Mesa. null = sin foto. */
    @Column(name = "portrait_id")
    private UUID portraitId;

    // ------------------------------------------------- qué se ha descubierto

    /** En false ni sale en el elenco del jugador: es el borrador del máster. */
    @Column(nullable = false)
    private boolean listed = false;

    @Column(name = "reveal_name", nullable = false)        private boolean revealName = false;
    @Column(name = "reveal_portrait", nullable = false)    private boolean revealPortrait = false;
    @Column(name = "reveal_title", nullable = false)       private boolean revealTitle = false;
    @Column(name = "reveal_location", nullable = false)    private boolean revealLocation = false;
    @Column(name = "reveal_race", nullable = false)        private boolean revealRace = false;
    @Column(name = "reveal_description", nullable = false) private boolean revealDescription = false;
    @Column(name = "reveal_trivia", nullable = false)      private boolean revealTrivia = false;
    @Column(name = "reveal_alignment", nullable = false)   private boolean revealAlignment = false;

    @Column(nullable = false)
    private int ordinal = 0;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}
