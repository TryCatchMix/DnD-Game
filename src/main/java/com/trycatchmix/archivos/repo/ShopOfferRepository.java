package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.ShopOffer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ShopOfferRepository extends JpaRepository<ShopOffer, UUID> {
    List<ShopOffer> findByLocationOrderByPriceCpAsc(String location);
    Optional<ShopOffer> findByLocationAndItemCode(String location, String itemCode);
}
