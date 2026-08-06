package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

/** Un objeto del catálogo. Se referencia por código ("cuerda_canamo"). */
@Entity
@Table(name = "items")
@Getter @Setter
public class Item {

    @Id
    private String code;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, length = 500)
    private String description = "";

    /** Precio base en piezas de cobre. */
    @Column(name = "price_cp", nullable = false)
    private long priceCp;

    /** Peso en libras (para la carga). */
    @Column(name = "weight_lb", nullable = false)
    private double weightLb = 0;

    /** "útil", "arma", "consumible"… solo informativo. */
    @Column(nullable = false)
    private String category = "útil";
}
