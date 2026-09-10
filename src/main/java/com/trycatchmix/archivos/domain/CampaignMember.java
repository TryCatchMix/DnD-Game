package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Quién está en una campaña y con qué papel.
 *
 * Aquí vive el permiso de verdad: ser DM es serlo DE ESTA campaña. Un mismo
 * usuario tiene una fila por cada mesa en la que participa, y puede ser máster
 * en una y jugador en otra. {@link Role} (users.role) ya no decide esto; se
 * queda como administrador de la instalación.
 */
@Entity
@Table(name = "campaign_members")
@Getter @Setter
public class CampaignMember {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "campaign_id", nullable = false)
    private UUID campaignId;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    /** DM | PLAYER, dentro de esta campaña. */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.PLAYER;

    @Column(name = "joined_at", nullable = false)
    private Instant joinedAt = Instant.now();

    public boolean esDm() {
        return role == Role.DM;
    }
}
