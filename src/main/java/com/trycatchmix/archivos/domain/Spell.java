package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/** Un hechizo del manual. Cada clase que lo aprende lo hace a su propio nivel
 *  (ver SpellClass). */
@Entity
@Table(name = "spells")
@Getter @Setter
public class Spell {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    /** Nombre original del SRD, para buscarlo en el manual en inglés. */
    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** Escuela: Evocación, Conjuración, Abjuración… */
    @Column(nullable = false)
    private String school = "";

    /** Subescuela (Curación, Convocación…) y descriptores (Fuego, Miedo…). */
    @Column(nullable = false)
    private String subschool = "";

    @Column(nullable = false)
    private String descriptors = "";

    @Column(nullable = false, length = 4000)
    private String description = "";

    // ---- El bloque de estadísticas, tal cual se lee en la mesa ----

    /** V, G, M, F, FD, PX. */
    @Column(nullable = false)
    private String components = "";

    @Column(name = "casting_time", nullable = false)
    private String castingTime = "";

    /** `range` es palabra reservada en SQL, por eso la columna es spell_range. */
    @Column(name = "spell_range", nullable = false)
    private String spellRange = "";

    @Column(nullable = false)
    private String target = "";

    /** Si el `target` es un Objetivo, un Área o un Efecto. */
    @Column(name = "target_kind", nullable = false)
    private String targetKind = "";

    @Column(nullable = false)
    private String duration = "";

    @Column(name = "saving_throw", nullable = false)
    private String savingThrow = "";

    @Column(name = "spell_resistance", nullable = false)
    private String spellResistance = "";

    // ---- Daño y escalado ----

    /** Dados base: "1d6", "1d4+1", "3d8"… vacío si el conjuro no tira daño. */
    @Column(nullable = false)
    private String dice = "";

    /** Cómo crece: "por nivel de lanzador", "por cada 2 niveles"… */
    @Column(nullable = false)
    private String scaling = "";

    /** Tope del escalado: "10d6", "+5"… */
    @Column(nullable = false)
    private String cap = "";

    @Column(name = "description_en", nullable = false, length = 4000)
    private String descriptionEn = "";

    @Column(nullable = false)
    private String source = "";

    @OneToMany(mappedBy = "spell", fetch = FetchType.EAGER)
    @OrderBy("level ASC")
    private List<SpellClass> classes = new ArrayList<>();
}
