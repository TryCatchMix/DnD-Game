package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Npc;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface NpcRepository extends JpaRepository<Npc, UUID> {

    /** El elenco de una mesa, en el orden que le puso el máster. */
    List<Npc> findByCampaignIdOrderByOrdinalAscNameAsc(UUID campaignId);

    /** Para saber si un retrato sigue en uso antes de borrarlo del armario. */
    List<Npc> findByPortraitId(UUID portraitId);
}
