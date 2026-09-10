package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Campaign;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CampaignRepository extends JpaRepository<Campaign, UUID> {

    /** Para entrar con el código. Se guarda siempre en mayúsculas. */
    Optional<Campaign> findByJoinCode(String joinCode);

    boolean existsByJoinCode(String joinCode);

    List<Campaign> findByIdInOrderByCreatedAtDesc(List<UUID> ids);
}
