package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** La partida de un personaje en un encargo: por qué escena va y si sigue vivo. */
@Entity
@Table(name = "quest_runs")
@Getter @Setter
public class QuestRun {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "character_id", nullable = false)
    private UUID characterId;

    @Column(name = "quest_id", nullable = false)
    private UUID questId;

    @Column(name = "current_scene_id")
    private UUID currentSceneId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RunStatus status = RunStatus.IN_PROGRESS;
}
