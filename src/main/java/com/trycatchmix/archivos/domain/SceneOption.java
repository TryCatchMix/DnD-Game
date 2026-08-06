package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "scene_options")
@Getter @Setter
public class SceneOption {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "scene_id", nullable = false)
    private Scene scene;

    @Column(nullable = false)
    private int ordinal;

    @Column(nullable = false)
    private String label;

    /** Código de la habilidad para la tirada, o null si la opción no tira. */
    private String skill;

    /** Clase de dificultad. Null cuando no hay tirada. */
    private Integer dc;

    @Column(name = "vigor_cost", nullable = false)
    private int vigorCost = 0;

    /** LOW | MEDIUM | HIGH, o null. */
    private String risk;

    private String note;

    @OneToMany(mappedBy = "option", fetch = FetchType.LAZY)
    private List<OptionModifier> modifiers = new ArrayList<>();

    @OneToMany(mappedBy = "option", fetch = FetchType.LAZY)
    @OrderBy("grade ASC")
    private List<Outcome> outcomes = new ArrayList<>();
}
