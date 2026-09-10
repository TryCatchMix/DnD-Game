package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * El estado del mundo de UNA campaña: "puente_norte_en_pie" = true/false.
 *
 * La bandera decide si un encargo sale bloqueado en el tablón, así que no puede
 * ser común a toda la instalación: lo que hagan los jugadores de una mesa no
 * tiene por qué cambiar el tablón de la de al lado.
 *
 * La clave textual dejó de ser la primaria en V28 justamente por eso: ahora hay
 * una fila por campaña y bandera, más una plantilla con {@code campaignId} a
 * null de la que copia cada campaña nueva.
 */
@Entity
@Table(name = "world_flags")
@Getter @Setter
public class WorldFlag {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** De qué campaña es. Null solo en la plantilla base. */
    @Column(name = "campaign_id")
    private UUID campaignId;

    @Column(name = "flag_key", nullable = false)
    private String flagKey;

    @Column(nullable = false)
    private boolean state;
}
