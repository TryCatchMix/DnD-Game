package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/** Un objeto a la venta en la tienda de una ciudad, con su precio y stock. */
@Entity
@Table(name = "shop_offers")
@Getter @Setter
public class ShopOffer {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /** Casa con GameCharacter.city y Quest.location. */
    @Column(nullable = false)
    private String location;

    @Column(name = "item_code", nullable = false)
    private String itemCode;

    @Column(name = "price_cp", nullable = false)
    private long priceCp;

    /** Unidades disponibles; -1 = sin límite. */
    @Column(nullable = false)
    private int stock = -1;
}
