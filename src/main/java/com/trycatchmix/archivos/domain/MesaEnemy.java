package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Un enemigo del máster.
 *
 * El bestiario ({@link Monster}) es el MANUAL: intocable, igual para todos.
 * Esto es lo que hace falta para jugar: "el trasgo de la mina, que se llama
 * Cara-rota y tiene 5 PG porque ya le arreó Gorash". Nace copiado de un
 * monstruo o inventado de cero, y desde ese momento es del DM, que lo edita a
 * su gusto sin tocar el manual.
 *
 * Los cuatro números que se usan de verdad en combate (PG, CA, contacto,
 * desprevenido) viven aparte y como enteros; el resto del bloque se guarda
 * como texto, que es como se lee.
 */
@Entity
@Table(name = "mesa_enemigos")
@Getter @Setter
public class MesaEnemy {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    /** Opcional: prepararlo dentro de una misión concreta. */
    @Column(name = "mision_id")
    private UUID misionId;

    /** De qué monstruo se copió. Solo la procedencia: si el bestiario cambia,
     *  este enemigo no. Null si el DM se lo inventó. */
    @Column(name = "monster_id")
    private UUID monsterId;

    @Column(nullable = false)
    private String name;

    @Column(name = "size_type", nullable = false)
    private String sizeType = "";

    /** El VD tal cual se lee ("7", "½"). Informativo. */
    @Column(nullable = false)
    private String cr = "";

    @Column(name = "hp_max", nullable = false)
    private int hpMax = 0;

    @Column(nullable = false)
    private int ac = 10;

    @Column(name = "ac_touch", nullable = false)
    private int acTouch = 10;

    @Column(name = "ac_flat_footed", nullable = false)
    private int acFlatFooted = 10;

    @Column(name = "init_mod", nullable = false)
    private int initMod = 0;

    @Column(nullable = false, columnDefinition = "text")
    private String speed = "";

    @Column(nullable = false, columnDefinition = "text")
    private String saves = "";

    @Column(nullable = false, columnDefinition = "text")
    private String abilities = "";

    @Column(nullable = false, columnDefinition = "text")
    private String attack = "";

    @Column(name = "full_attack", nullable = false, columnDefinition = "text")
    private String fullAttack = "";

    @Column(name = "special_attacks", nullable = false, columnDefinition = "text")
    private String specialAttacks = "";

    @Column(name = "special_qualities", nullable = false, columnDefinition = "text")
    private String specialQualities = "";

    @Column(nullable = false, columnDefinition = "text")
    private String skills = "";

    @Column(nullable = false, columnDefinition = "text")
    private String feats = "";

    /** Las notas del máster: "cojea", "sabe dónde está la llave". */
    @Column(nullable = false, columnDefinition = "text")
    private String notes = "";

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}
