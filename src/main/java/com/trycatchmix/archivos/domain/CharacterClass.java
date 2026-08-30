package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una clase del SRD, con lo que hace falta para escalar a alguien que la tenga.
 *
 * OJO: "Guerrero (PNJ)" (Warrior) y "Guerrero" (Fighter) son clases DISTINTAS
 * aunque en español se llamen casi igual. Por eso la clave con la que se
 * emparejan las criaturas es {@link #nameEn}.
 */
@Entity
@Table(name = "character_classes")
@Getter @Setter
public class CharacterClass {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "name_en", nullable = false, unique = true)
    private String nameEn;

    @Column(name = "hit_die", nullable = false)
    private int hitDie = 8;

    /** Puntos de habilidad por nivel, antes de sumar el modificador de Int. */
    @Column(name = "skill_points", nullable = false)
    private int skillPoints = 2;

    /** true = clase de PNJ (guerrero, experto, adepto, aristócrata, plebeyo). */
    @Column(nullable = false)
    private boolean npc = false;

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
