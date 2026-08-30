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

    /** "arma", "armadura", "equipo", "ropa"… es el filtro de un toque de la
     *  tienda, así que conviene que sean pocas y cortas. */
    @Column(nullable = false)
    private String category = "útil";

    /** Nombre original del SRD, para buscarlo en el manual en inglés. */
    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** La familia exacta del SRD: "Arma marcial (una mano)", "Armadura pesada",
     *  "Herramientas y estuches". Más fina que `category`, para la ficha. */
    @Column(name = "equipment_group", nullable = false)
    private String equipmentGroup = "";

    // ---- si es un arma ----

    /** Daño con el arma en tamaño Pequeño y Mediano ("1d6" / "1d8"). */
    @Column(name = "damage_small", nullable = false)
    private String damageSmall = "";

    @Column(name = "damage_medium", nullable = false)
    private String damageMedium = "";

    /** "×2", "19-20/×2", "×3"… */
    @Column(nullable = false)
    private String critical = "";

    /** Incremento de distancia de las armas arrojadizas y de proyectiles. */
    @Column(name = "range_increment", nullable = false)
    private String rangeIncrement = "";

    /** Contundente, Perforante, Cortante (o combinaciones). */
    @Column(name = "damage_type", nullable = false)
    private String damageType = "";

    /** Sencilla, Marcial o Exótica: de ella depende si sabes usarla. */
    @Column(nullable = false)
    private String proficiency = "";

    /** Ligera, Una mano, Dos manos, A distancia, Sin armas. */
    @Column(nullable = false)
    private String handling = "";

    // ---- si es una armadura o un escudo ----

    @Column(name = "ac_bonus", nullable = false)
    private String acBonus = "";

    @Column(name = "max_dex", nullable = false)
    private String maxDex = "";

    /** Penalizador de armadura a las habilidades físicas. */
    @Column(name = "armor_check", nullable = false)
    private String armorCheck = "";

    /** Probabilidad de fallo de conjuros arcanos. */
    @Column(name = "spell_failure", nullable = false)
    private String spellFailure = "";

    /** Velocidad con ella puesta, para quien camina a 30 y a 20 pies. */
    @Column(name = "speed_30", nullable = false)
    private String speed30 = "";

    @Column(name = "speed_20", nullable = false)
    private String speed20 = "";

    /** "SRD 3.5" en lo importado; vacío en lo que puso el máster a mano. */
    @Column(nullable = false)
    private String source = "";
}
