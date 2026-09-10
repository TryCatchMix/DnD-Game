package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.GameCharacter;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface GameCharacterRepository extends JpaRepository<GameCharacter, UUID> {
    List<GameCharacter> findByUserIdOrderByNameAsc(UUID userId);

    /** El grupo de una campaña: lo que ve su máster. */
    List<GameCharacter> findByCampaignIdOrderByNameAsc(UUID campaignId);

    List<GameCharacter> findByCampaignIdInOrderByNameAsc(List<UUID> campaignIds);

    List<GameCharacter> findByUserIdAndCampaignIdOrderByNameAsc(UUID userId, UUID campaignId);

    long countByCampaignId(UUID campaignId);

    /** Para el admin de la instalación: todos los personajes que hay. */
    List<GameCharacter> findAllByOrderByNameAsc();
}
