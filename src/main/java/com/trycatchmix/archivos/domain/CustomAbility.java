package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Una habilidad "de la casa": la añade cualquier jugador (no hace falta ser DM)
 * desde la pestaña Habilidades, para tener a mano cosas tipo "Crear agua" o
 * "Descarga sobrenatural" sin depender del grimorio del SRD.
 *
 * Es a propósito ligera: nombre, un tipo libre y una descripción. Nada de
 * escuelas, componentes ni CD; para eso ya están los conjuros fichados. Se
 * guarda quién la creó solo para mostrarlo, no para restringir.
 */
@Entity
@Table(name = "custom_abilities")
@Getter @Setter
public class CustomAbility {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String name;

    /** Tipo libre: "Conjuro", "Sobrenatural", "Aptitud"… Puede ir vacío. */
    @Column(nullable = false)
    private String kind = "";

    @Column(nullable = false, length = 4000)
    private String description = "";

    /** Quién la añadió (para mostrar el autor). */
    @Column(name = "created_by", nullable = false)
    private UUID createdBy;

    @Column(name = "created_by_name", nullable = false)
    private String createdByName = "";

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}
