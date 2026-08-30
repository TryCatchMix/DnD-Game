package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Un veneno del SRD, con su CD y sus dos daños (el de golpe y el de un minuto
 *  después), que es justo lo que falta cuando un monstruo dice "veneno". */
@Entity
@Table(name = "poisons")
@Getter @Setter
public class Poison {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "name_en", nullable = false)
    private String nameEn = "";

    /** Contacto, Ingerido, Inhalado o Herida. */
    @Column(nullable = false)
    private String kind = "";

    @Column(nullable = false)
    private int dc = 0;

    @Column(name = "initial_damage", nullable = false)
    private String initialDamage = "";

    @Column(name = "secondary_damage", nullable = false)
    private String secondaryDamage = "";

    /** En piezas de cobre, como el resto de la app. */
    @Column(name = "price_cp", nullable = false)
    private long priceCp = 0;

    @Column(nullable = false)
    private String source = "SRD 3.5";
}
