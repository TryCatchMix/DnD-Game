package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "quests")
@Getter @Setter
public class Quest {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * De qué campaña es el encargo. Null = COMÚN: los que venían sembrados y
     * los que ya existían antes de que hubiera campañas. Se ven desde cualquier
     * tablón —así una mesa nueva no nace vacía— y nadie los reescribe; lo que
     * escribe un DM a partir de ahora nace dentro de su campaña.
     */
    @Column(name = "campaign_id")
    private UUID campaignId;

    /** Único dentro de la campaña, no en toda la base (ver V28). */
    @Column(nullable = false)
    private String code;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, length = 1000)
    private String hook;

    /** Dónde está clavado el encargo; casa con GameCharacter.city. */
    @Column(nullable = false)
    private String location;

    private String faction;

    @Column(name = "vigor_cost", nullable = false)
    private int vigorCost = 1;

    /** Ya formateado: "6 h", "1 día". */
    @Column(nullable = false)
    private String duration = "";

    @Column(name = "scene_count", nullable = false)
    private int sceneCount;

    @Column(name = "reward_note")
    private String rewardNote;

    @Column(name = "min_level", nullable = false)
    private int minLevel = 1;

    @Column(nullable = false)
    private boolean published = false;

    // --- Bloqueo por el estado del mundo (mínimo: una sola flag) ---
    @Column(name = "required_flag")
    private String requiredFlag;

    @Column(name = "required_flag_state")
    private Boolean requiredFlagState;

    /** "Requiere: Puente Norte en pie". Se muestra cuando está bloqueado. */
    @Column(name = "requirement_label")
    private String requirementLabel;

    /** Etiquetas de habilidad de la tarjeta, separadas por coma: "Trepar,Atletismo". */
    @Column(name = "skill_tags")
    private String skillTags = "";

    @OneToMany(mappedBy = "quest", fetch = FetchType.LAZY)
    @OrderBy("ordinal ASC")
    private List<Scene> scenes = new ArrayList<>();
}
