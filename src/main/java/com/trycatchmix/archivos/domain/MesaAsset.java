package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Un archivo del material del DM: un mapa, un retrato, el PDF con la historia.
 *
 * Los bytes viven en disco (ver MesaStorage); aquí solo queda la ficha del
 * archivo. {@code storageName} es un nombre generado por nosotros —nunca el que
 * mandó el navegador— para que no se pueda salir del directorio.
 */
@Entity
@Table(name = "mesa_archivos")
@Getter @Setter
public class MesaAsset {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    /** null = está en la biblioteca general, sin misión asignada. */
    @Column(name = "mision_id")
    private UUID missionId;

    /** imagen | pdf | otro. */
    @Column(nullable = false)
    private String kind;

    @Column(nullable = false)
    private String title;

    /** El nombre original, solo para mostrar y para descargar. */
    @Column(nullable = false)
    private String filename;

    @Column(nullable = false)
    private String mime;

    @Column(name = "size_bytes", nullable = false)
    private long sizeBytes;

    @Column(name = "storage_name", nullable = false)
    private String storageName;

    /**
     * El texto extraído del PDF al subirlo, para buscar por contenido. Vacío en
     * imágenes y en PDF sin capa de texto (escaneados). Se rellena con PDFBox.
     */
    @Column(name = "text_content", nullable = false, columnDefinition = "text")
    private String textContent = "";

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();
}
