package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

/**
 * Una línea de la bolsa de un personaje: un objeto y cuántos lleva.
 *
 * Puede venir de la tienda (itemCode apunta al catálogo, se puede vender) o
 * ser un objeto añadido a mano (itemCode null, con su nombre y peso propios).
 */
@Entity
@Table(name = "inventory")
@Getter @Setter
public class InventoryEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "character_id", nullable = false)
    private UUID characterId;

    /** Catálogo, o null si es un objeto manual. */
    @Column(name = "item_code")
    private String itemCode;

    /** Nombre visible (del catálogo o escrito a mano). */
    @Column(nullable = false)
    private String name = "";

    @Column(nullable = false)
    private int quantity;

    /** Peso por unidad, en libras. */
    @Column(name = "weight_lb", nullable = false)
    private double weightLb = 0;
}
