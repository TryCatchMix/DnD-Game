package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una invocación de warlock (Complete Arcane).
 *
 * OJO: el warlock NO lanza conjuros. Sus invocaciones son aptitudes
 * sobrenaturales que usa A VOLUNTAD, sin espacios diarios y sin nivel de
 * conjuro 0-9. Por eso viven en su propia tabla y no en `spells`:
 *
 *   · se agrupan por grado (menor, inferior, superior, oscura), y cada grado
 *     pide un nivel mínimo de clase (1, 6, 11 y 16);
 *   · `spellLevel` es solo el "nivel de conjuro equivalente", que se usa para
 *     la CD:  CD = 10 + spellLevel + modificador de Carisma.
 */
@Entity
@Table(name = "invocations")
@Getter @Setter
public class Invocation {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** Menor, Inferior, Superior u Oscura. */
    @Column(nullable = false)
    private String grade;

    /** 1..4, para ordenar los grados de menor a mayor. */
    @Column(name = "grade_order", nullable = false)
    private int gradeOrder;

    /** Nivel de conjuro equivalente (solo para la CD). */
    @Column(name = "spell_level", nullable = false)
    private int spellLevel;

    /** Nivel de warlock necesario para elegirla. */
    @Column(name = "min_class_level", nullable = false)
    private int minClassLevel;

    /** "Forma de descarga", "Esencia sobrenatural" o vacío. */
    @Column(nullable = false)
    private String kind = "";

    @Column(name = "saving_throw", nullable = false)
    private String savingThrow = "";

    @Column(name = "spell_resistance", nullable = false)
    private String spellResistance = "";

    @Column(nullable = false)
    private String dice = "";

    @Column(nullable = false)
    private String scaling = "";

    @Column(nullable = false, length = 2000)
    private String description = "";

    /** Siempre Carisma en el warlock. */
    @Column(name = "key_ability", nullable = false)
    private String keyAbility = "Carisma";

    /** Todas las invocaciones son a voluntad; se guarda explícito para que la
     *  pantalla lo pueda decir sin que nadie tenga que saberlo de memoria. */
    @Column(name = "at_will", nullable = false)
    private boolean atWill = true;

    @Column(nullable = false)
    private String source = "";
}
