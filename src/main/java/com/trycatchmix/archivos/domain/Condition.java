package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Una condición del SRD: cegado, aturdido, en el suelo… Lo que se consulta a
 *  media pelea cuando alguien pregunta "¿y eso qué me quita?". */
@Entity
@Table(name = "conditions")
@Getter @Setter
public class Condition {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    @Column(nullable = false, columnDefinition = "text")
    private String description = "";

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
