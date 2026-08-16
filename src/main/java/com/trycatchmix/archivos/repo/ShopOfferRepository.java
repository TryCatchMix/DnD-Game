package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.ShopOffer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ShopOfferRepository extends JpaRepository<ShopOffer, UUID> {

    /**
     * El mostrador entero. Por ahora la tienda es ÚNICA: da igual dónde esté el
     * personaje, ve lo mismo. La columna `location` sigue en la tabla (y en las
     * ofertas sembradas pone 'Dorakan') para poder volver a tiendas por ciudad
     * el día que haga falta, pero hoy no se filtra por ella.
     */
    List<ShopOffer> findAllByOrderByPriceCpAsc();

    /** Todas las ofertas de un objeto, sea cual sea la ciudad donde se pusiera. */
    List<ShopOffer> findByItemCode(String itemCode);
}
