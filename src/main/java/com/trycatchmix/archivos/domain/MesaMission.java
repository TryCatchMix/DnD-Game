package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

/**
 * Una misión en preparación: la carpeta donde el DM va dejando el guion y el
 * material de una sesión antes de jugarla.
 *
 * Es del DM (user_id), no de un personaje. No tiene nada que ver con {@link Quest}:
 * aquello es un encargo jugable en el tablón; esto son los apuntes del máster.
 */
@Entity
@Table(name = "mesa_misiones")
@Getter @Setter
public class MesaMission {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, length = 4000)
    private String summary = "";

    /** idea | preparando | lista | jugada. */
    @Column(nullable = false)
    private String status = "idea";

    /** Etiquetas libres separadas por coma. */
    @Column(nullable = false)
    private String tags = "";

    /** Cuándo se piensa jugar. Opcional. */
    @Column(name = "session_date")
    private LocalDate sessionDate;

    /** Archivo que hace de portada en la tarjeta. */
    @Column(name = "cover_id")
    private UUID coverId;

    @Column(nullable = false)
    private int ordinal = 0;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}
