package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Un sumando fijo del desglose de la tirada: "Cable resbaladizo" -2. */
@Entity
@Table(name = "option_modifiers")
@Getter @Setter
public class OptionModifier {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "option_id", nullable = false)
    private SceneOption option;

    @Column(nullable = false)
    private String label;

    @Column(nullable = false)
    private int value;
}
