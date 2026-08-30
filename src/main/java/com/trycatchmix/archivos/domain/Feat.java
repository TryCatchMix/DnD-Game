package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una dote del manual. Es lo que el personaje ELIGE al subir de nivel, a
 * diferencia de las aptitudes de clase ({@link ClassFeature}), que le vienen
 * dadas.
 *
 * El texto va traducido entero (prerrequisito, beneficio, normal y especial):
 * una dote son dos o tres frases, así que aquí no se aplica el corte que sí se
 * hizo con la prosa de los conjuros y los monstruos.
 */
@Entity
@Table(name = "feats")
@Getter @Setter
public class Feat {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    /** Nombre original del SRD, para buscarlo en el manual en inglés. */
    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** General, Metamágica, Creación de objetos, Especial. */
    @Column(nullable = false)
    private String kind = "General";

    /** Lo que hace falta para poder tomarla. Vacío = no pide nada. */
    @Column(nullable = false, columnDefinition = "text")
    private String prerequisite = "";

    /** Lo que te da. Es lo que se lee en la mesa. */
    @Column(nullable = false, columnDefinition = "text")
    private String benefit = "";

    /** Qué pasaría SIN la dote: el contraste es lo que la hace entender. */
    @Column(nullable = false, columnDefinition = "text")
    private String normal = "";

    /** Excepciones: quién la tiene de serie, si se puede tomar varias veces… */
    @Column(nullable = false, columnDefinition = "text")
    private String special = "";

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
