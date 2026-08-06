package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Una propiedad que posee un personaje (taberna, mina, puerto…). El tipo se
 * guarda como código (ver {@code PropertyKind}); la economía vive en el código,
 * no en la BD. La renta se acumula sola con el tiempo y se recauda a mano.
 */
@Entity
@Table(name = "properties")
@Getter @Setter
public class Property {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "character_id", nullable = false)
    private UUID characterId;

    /** Código del tipo: taberna, posada, herreria, … */
    @Column(nullable = false)
    private String kind;

    /** El nombre que le pone el dueño ("El Toro Ciego"). */
    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private int level = 1;

    @Column(nullable = false)
    private String city = "";

    @Column(name = "purchased_at", nullable = false)
    private Instant purchasedAt = Instant.now();

    /** Desde cuándo se cuenta la renta pendiente. Se pone a "ahora" al recaudar. */
    @Column(name = "last_collected_at", nullable = false)
    private Instant lastCollectedAt = Instant.now();
}
