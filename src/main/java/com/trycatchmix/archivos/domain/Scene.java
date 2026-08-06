package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "scenes")
@Getter @Setter
public class Scene {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "quest_id", nullable = false)
    private Quest quest;

    @Column(nullable = false)
    private int ordinal;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, length = 2000)
    private String body;

    @Column(name = "final_scene", nullable = false)
    private boolean finalScene = false;

    @OneToMany(mappedBy = "scene", fetch = FetchType.LAZY)
    @OrderBy("ordinal ASC")
    private List<SceneOption> options = new ArrayList<>();
}
