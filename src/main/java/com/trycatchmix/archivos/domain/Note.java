package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Una nota del bloc: un nombre que conviene no olvidar (un PNJ, una ciudad,
 * una facción…) con lo que se sepa de él.
 *
 * Es del JUGADOR, no de un personaje: lo que apuntas sobre el mundo sigue
 * valiendo aunque cambies de personaje.
 */
@Entity
@Table(name = "notes")
@Getter @Setter
public class Note {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    /** Persona | Lugar | Facción | Objeto | Suceso | Otro. */
    @Column(nullable = false)
    private String category = "Otro";

    /** El nombre en sí: "Gorash", "Dorakan", "El Farol"… */
    @Column(nullable = false)
    private String title;

    @Column(nullable = false, length = 4000)
    private String body = "";

    /** Las fijadas salen arriba del todo. */
    @Column(nullable = false)
    private boolean pinned = false;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}
