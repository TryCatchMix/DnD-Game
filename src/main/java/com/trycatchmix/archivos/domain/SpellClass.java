package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Qué clase puede lanzar un hechizo y a qué nivel de conjuro. */
@Entity
@Table(name = "spell_classes")
@Getter @Setter
public class SpellClass {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "spell_id", nullable = false)
    private Spell spell;

    /** Nombre de la clase: Clérigo, Mago, Druida, Bardo, Hechicero… */
    @Column(nullable = false)
    private String clazz;

    /** Nivel del conjuro para esa clase (0..9). */
    @Column(nullable = false)
    private int level;

    /** El atributo con el que esa clase lanza: Sabiduría el clérigo,
     *  Inteligencia el mago. La CD sale de él:
     *      CD = 10 + nivel del conjuro + modificador del atributo. */
    @Column(name = "key_ability", nullable = false)
    private String keyAbility = "";
}
