package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Alguien metido en un combate.
 *
 * Copia el nombre y los números en vez de mirarlos cada vez: durante la pelea
 * el trasgo tiene los PG que tiene, y si el DM borra su plantilla o el jugador
 * edita su ficha a mitad de asalto, el combate no se descuadra.
 */
@Entity
@Table(name = "mesa_combatientes")
@Getter @Setter
public class MesaCombatant {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "combate_id", nullable = false)
    private UUID combateId;

    /** enemigo | personaje | suelto. */
    @Column(nullable = false)
    private String kind = "enemigo";

    /** De dónde salió. Solo la procedencia; los números ya están copiados. */
    @Column(name = "enemigo_id")
    private UUID enemigoId;

    @Column(name = "character_id")
    private UUID characterId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private int initiative = 0;

    @Column(name = "hp_max", nullable = false)
    private int hpMax = 0;

    @Column(name = "hp_current", nullable = false)
    private int hpCurrent = 0;

    @Column(nullable = false)
    private int ac = 10;

    /** Estados, de momento texto libre: "derribado, cegado". */
    @Column(nullable = false, columnDefinition = "text")
    private String conditions = "";

    @Column(nullable = false, columnDefinition = "text")
    private String notes = "";

    /** Fuera de combate, pero sin sacarlo del orden. */
    @Column(nullable = false)
    private boolean defeated = false;

    @Column(name = "sort_ordinal", nullable = false)
    private int sortOrdinal = 0;
}
