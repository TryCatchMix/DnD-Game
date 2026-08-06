package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una entrada de la crónica del clan: la memoria compartida del mundo.
 *
 * Algunas entradas están SELLADAS por la Orden del Velo —los religiosos que
 * ocultan lo que de verdad pasó en el Cataclismo—. El clan de Los Archivos las
 * va destapando: revelar una entrada sellada es sacar a la luz una verdad.
 */
@Entity
@Table(name = "chronicle_entries")
@Getter @Setter
public class ChronicleEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** Año del mundo (0 = el Cataclismo; 1127 = el presente). Ordena la línea. */
    @Column(nullable = false)
    private int year;

    /** Etiqueta corta del momento: "El Cataclismo", "Año 1127 · Dorakan". */
    @Column(nullable = false)
    private String era = "";

    @Column(nullable = false)
    private String title;

    /** El contenido verdadero. Si está sellada y sin revelar, no se envía. */
    @Column(nullable = false, length = 2000)
    private String body;

    /** CATACLISMO | MUNDO | CLAN | VERDAD | RUMOR */
    @Column(nullable = false)
    private String category = "MUNDO";

    /** Quién la firma u oculta: "La Orden del Velo", "Los Archivos"… */
    private String faction;

    /** Una verdad que la Orden del Velo mantiene oculta. */
    @Column(nullable = false)
    private boolean sealed = false;

    /** Ya destapada por el clan. Solo tiene sentido si sealed = true. */
    @Column(nullable = false)
    private boolean revealed = false;

    /** Desempate dentro del mismo año. */
    @Column(name = "sort_ordinal", nullable = false)
    private int sortOrdinal = 0;
}
