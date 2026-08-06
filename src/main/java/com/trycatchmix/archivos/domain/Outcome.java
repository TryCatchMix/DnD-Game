package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** El desenlace de una opción para un grado (1..5) de resultado. */
@Entity
@Table(name = "outcomes")
@Getter @Setter
public class Outcome {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "option_id", nullable = false)
    private SceneOption option;

    /** 1..5. */
    @Column(nullable = false)
    private int grade;

    @Column(nullable = false, length = 1000)
    private String narrative;

    /** La escena a la que se salta, o null si cierra el encargo. */
    @Column(name = "next_scene_id")
    private UUID nextSceneId;

    @Column(name = "ends_quest", nullable = false)
    private boolean endsQuest = false;
}
