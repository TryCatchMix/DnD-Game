package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Una fila de la tabla de una clase: qué tiene a ese nivel. */
@Entity
@Table(name = "class_progression")
@Getter @Setter
public class ClassProgression {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "class_en", nullable = false)
    private String classEn;

    @Column(nullable = false)
    private int level;

    /** Ataque base. Los ataques múltiples se deducen de él, no se guardan. */
    @Column(nullable = false)
    private int bab = 0;

    @Column(nullable = false)
    private int fort = 0;

    @Column(nullable = false)
    private int ref = 0;

    @Column(nullable = false)
    private int will = 0;

    /** Lo que gana a ese nivel, tal cual lo escribe el SRD. */
    @Column(nullable = false, columnDefinition = "text")
    private String special = "";
}
