package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Una criatura del bestiario, con su bloque de estadísticas tal cual se lee en
 * la mesa. Los campos son texto y no números porque el SRD los escribe así
 * ("16 (-2 tamaño, +1 Des, +7 natural), contacto 9, desprevenido 15"): partirlos
 * perdería información y no aportaría nada, ya que aquí solo se consultan.
 *
 * La excepción es {@link #cr}: el valor de desafío se guarda además como número
 * para poder ordenar y filtrar por él ("enséñame bichos de VD 3 a 6").
 *
 * `kind` vale 'criatura' o 'plantilla'. Las plantillas (fantasma, liche,
 * semidragón…) no tienen bloque: son reglas para modificar a otra criatura, así
 * que solo llevan nombre y descripción.
 */
@Entity
@Table(name = "monsters")
@Getter @Setter
public class Monster {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    /** Nombre original del SRD, para buscarlo en el manual en inglés. */
    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** La página del SRD de la que sale: "Dragon, True", "Elemental"… Sirve
     *  para agrupar variantes de la misma criatura. */
    @Column(nullable = false)
    private String family = "";

    /** Tipo de criatura suelto (Dragón, Exterior, No muerto…), para filtrar. */
    @Column(name = "creature_type", nullable = false)
    private String creatureType = "";

    /** "Dragón grande (frío)" — tamaño, tipo y subtipos juntos, como el SRD. */
    @Column(name = "size_type", nullable = false)
    private String sizeType = "";

    /** El VD como número (½ = 0.5) para ordenar y filtrar. Null en plantillas. */
    @Column
    private BigDecimal cr;

    /** El VD tal cual lo escribe el SRD, que a veces es una frase entera. */
    @Column(name = "challenge_rating", nullable = false)
    private String challengeRating = "";

    // ---- El bloque de estadísticas, en el orden en que se lee ----

    @Column(name = "hit_dice", nullable = false)
    private String hitDice = "";

    @Column(nullable = false)
    private String initiative = "";

    @Column(nullable = false)
    private String speed = "";

    @Column(name = "armor_class", nullable = false)
    private String armorClass = "";

    @Column(name = "base_attack", nullable = false)
    private String baseAttack = "";

    @Column(nullable = false, columnDefinition = "text")
    private String attack = "";

    @Column(name = "full_attack", nullable = false, columnDefinition = "text")
    private String fullAttack = "";

    @Column(name = "space_reach", nullable = false)
    private String spaceReach = "";

    @Column(name = "special_attacks", nullable = false, columnDefinition = "text")
    private String specialAttacks = "";

    @Column(name = "special_qualities", nullable = false, columnDefinition = "text")
    private String specialQualities = "";

    @Column(nullable = false)
    private String saves = "";

    @Column(nullable = false)
    private String abilities = "";

    @Column(nullable = false, columnDefinition = "text")
    private String skills = "";

    @Column(nullable = false, columnDefinition = "text")
    private String feats = "";

    @Column(nullable = false)
    private String environment = "";

    @Column(nullable = false, columnDefinition = "text")
    private String organization = "";

    @Column(nullable = false)
    private String treasure = "";

    @Column(nullable = false)
    private String alignment = "";

    @Column(nullable = false, columnDefinition = "text")
    private String advancement = "";

    @Column(name = "level_adjustment", nullable = false)
    private String levelAdjustment = "";

    /** La prosa del SRD (aspecto, combate, aptitudes). Sigue en inglés, igual
     *  que la de los conjuros. */
    @Column(nullable = false, columnDefinition = "text")
    private String description = "";

    /** La clase que tiene, en INGLÉS ("Warrior", "Fighter"), sacada del nombre
     *  original. Vacío si la criatura no tiene niveles de clase. En español
     *  Warrior y Fighter se llaman casi igual, y no son la misma clase. */
    @Column(name = "class_name_en", nullable = false)
    private String classNameEn = "";

    /** A qué nivel de esa clase está. 0 si no tiene. */
    @Column(name = "class_level", nullable = false)
    private int classLevel = 0;

    /** 'criatura' o 'plantilla'. */
    @Column(nullable = false)
    private String kind = "criatura";

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
