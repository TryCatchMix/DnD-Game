package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Una partida: la mesa a la que se une la gente con sus personajes.
 *
 * Es la unidad que faltaba. Antes todo colgaba del usuario —las misiones eran
 * del DM, la tienda era única, las notas eran del jugador a secas—, y eso solo
 * funciona mientras se juega una sola partida. La campaña es lo que separa una
 * mesa de otra: su tienda, su bloc, su material y sus enemigos.
 *
 * Quien la crea es su DM. El papel de máster es DE AQUÍ, no de la cuenta: el
 * mismo usuario dirige esta y juega en la de al lado (ver {@link CampaignMember}).
 */
@Entity
@Table(name = "campaigns")
@Getter @Setter
public class Campaign {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** Quien la creó: su DM y el único que puede borrarla. */
    @Column(name = "owner_id", nullable = false)
    private UUID ownerId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, length = 4000)
    private String description = "";

    /** El código que se reparte para entrar. Ver {@code CampaignService}. */
    @Column(name = "join_code", nullable = false, unique = true)
    private String joinCode;

    /** Con la puerta cerrada el código deja de valer, pero no se pierde. */
    @Column(name = "open", nullable = false)
    private boolean open = true;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}
