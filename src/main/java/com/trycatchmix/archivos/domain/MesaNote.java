package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Un trozo del guion de una misión: una escena, un PNJ, el botín o un texto
 * para leer en voz alta. El orden importa (es un guion), por eso el ordinal.
 */
@Entity
@Table(name = "mesa_notas")
@Getter @Setter
public class MesaNote {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "mision_id", nullable = false)
    private UUID missionId;

    /** lectura | escena | pnj | botin | nota. */
    @Column(nullable = false)
    private String kind = "nota";

    @Column(nullable = false)
    private String title = "";

    // HTML del editor rico (columna `text`): el guion admite formato, así que
    // sin tope de longitud fijo (el de 8000 se quedaba corto con marcado).
    @Column(nullable = false, columnDefinition = "text")
    private String body = "";

    @Column(nullable = false)
    private int ordinal = 0;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}
