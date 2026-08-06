package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una habilidad del personaje al estilo D&D 3.5: rangos invertidos + varios,
 * sobre el modificador de su característica clave. El total lo calcula
 * GameCharacter.skillTotal().
 */
@Entity
@Table(name = "character_skills")
@Getter @Setter
public class CharacterSkill {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "character_id", nullable = false)
    private GameCharacter character;

    /** El nombre visible ("Trepar"). */
    @Column(nullable = false)
    private String name;

    /** Código en minúsculas que casa con SceneOption.skill ("trepar"). */
    @Column(nullable = false)
    private String code;

    /** Característica clave: FUE, DES, CON, INT, SAB, CAR. Vacío = sin ninguna
     *  (el total es solo rangos + varios; así se conservan las habilidades
     *  antiguas que se sembraron con un modificador plano). */
    @Column(name = "key_ability", nullable = false)
    private String keyAbility = "";

    @Column(nullable = false)
    private int ranks = 0;

    @Column(name = "misc_mod", nullable = false)
    private int miscMod = 0;
}
