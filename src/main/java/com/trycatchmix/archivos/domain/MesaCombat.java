package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/** Un encuentro concreto: quién pega a quién y por qué orden. */
@Entity
@Table(name = "mesa_combates")
@Getter @Setter
public class MesaCombat {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** Quién lo montó. El permiso lo da la campaña, no esta columna. */
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "campaign_id", nullable = false)
    private UUID campaignId;

    @Column(name = "mision_id")
    private UUID misionId;

    @Column(nullable = false)
    private String title = "Combate";

    /** 0 = aún no ha empezado; de 1 en adelante, el asalto en curso. */
    @Column(name = "round", nullable = false)
    private int round = 0;

    /** A quién le toca, por su sitio en el orden de iniciativa. */
    @Column(name = "turn_ordinal", nullable = false)
    private int turnOrdinal = 0;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}
