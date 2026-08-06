package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una aptitud de clase de las clases marciales (Bárbaro, Guerrero, Monje), que
 * NO lanzan conjuros. No es un hechizo: no gasta espacios ni tiene CD de
 * conjuro. Va en la pestaña de "Habilidades" junto a conjuros e invocaciones,
 * pero como su propia categoría.
 */
@Entity
@Table(name = "class_features")
@Getter @Setter
public class ClassFeature {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** La clase que la gana: Bárbaro, Guerrero, Monje. */
    @Column(nullable = false)
    private String clazz;

    @Column(nullable = false)
    private String name;

    /** Nivel de clase al que se obtiene. */
    @Column(nullable = false)
    private int level;

    /** Tipo: Extraordinaria (Ex), Sobrenatural (Sob), Competencia, Dote… */
    @Column(nullable = false)
    private String kind = "";

    @Column(nullable = false, length = 2000)
    private String description = "";

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
