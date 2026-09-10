package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.ShopOffer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ShopOfferRepository extends JpaRepository<ShopOffer, UUID> {

    /**
     * El mostrador de una campaña. Dentro de ella la tienda sigue siendo ÚNICA:
     * da igual en qué ciudad esté el personaje, ve lo mismo. La columna
     * `location` sigue en la tabla por si algún día vuelven las tiendas por
     * ciudad, pero hoy no se filtra por ella.
     */
    List<ShopOffer> findByCampaignIdOrderByPriceCpAsc(UUID campaignId);

    /** La oferta de un objeto en esa campaña. */
    List<ShopOffer> findByCampaignIdAndItemCode(UUID campaignId, String itemCode);

    /**
     * El SURTIDO BASE: las filas sin campaña que dejó la migración V28. No se
     * enseña en ninguna tienda; es de donde se copia el mostrador de una
     * campaña recién creada.
     */
    List<ShopOffer> findByCampaignIdIsNull();
}
