package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Una enfermedad del SRD. Los monstruos la mencionan sin dar la CD; aquí está. */
@Entity
@Table(name = "diseases")
@Getter @Setter
public class Disease {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** Ingerida, Inhalada, Herida o Contacto. */
    @Column(nullable = false)
    private String infection = "";

    /** CD de la salvación de Fortaleza. */
    @Column(nullable = false)
    private int dc = 0;

    @Column(nullable = false)
    private String incubation = "";

    @Column(nullable = false)
    private String damage = "";

    /** Las aclaraciones que el SRD pone al pie de la tabla. */
    @Column(nullable = false, columnDefinition = "text")
    private String notes = "";

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
