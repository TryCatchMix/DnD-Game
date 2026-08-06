package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

/** El estado compartido del mundo: "puente_norte_en_pie" = true/false. */
@Entity
@Table(name = "world_flags")
@Getter @Setter
public class WorldFlag {

    @Id
    @Column(name = "flag_key")
    private String flagKey;

    @Column(nullable = false)
    private boolean state;
}
