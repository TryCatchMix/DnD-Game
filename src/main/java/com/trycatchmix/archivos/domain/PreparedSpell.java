package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/** Un conjuro que un personaje lleva preparado (D&D 3.5: se preparan antes de
 *  jugar). Enlaza un personaje con un conjuro del grimorio y guarda cuántas
 *  veces lo lleva preparado. */
@Entity
@Table(name = "prepared_spells",
        uniqueConstraints = @UniqueConstraint(columnNames = {"character_id", "spell_id"}))
@Getter @Setter
public class PreparedSpell {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "character_id", nullable = false)
    private GameCharacter character;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "spell_id", nullable = false)
    private Spell spell;

    /** Cuántas veces lo lleva preparado (mínimo 1). */
    @Column(nullable = false)
    private int prepared = 1;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}
