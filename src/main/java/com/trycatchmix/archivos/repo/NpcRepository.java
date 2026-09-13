package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Npc;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface NpcRepository extends JpaRepository<Npc, UUID> {

    /** El elenco de una mesa, en el orden que le puso el máster. */
    List<Npc> findByCampaignIdOrderByOrdinalAscNameAsc(UUID campaignId);

    /**
     * El elenco suelto de alguien: las fichas que escribió y se quedaron sin
     * mesa al borrarse su campaña. Por nombre, que aquí no hay orden de máster
     * que respetar: el de la mesa se perdió con ella.
     */
    List<Npc> findByUserIdAndCampaignIdIsNullOrderByNameAsc(UUID userId);

    /** Para saber si un retrato sigue en uso antes de borrarlo del armario. */
    List<Npc> findByPortraitId(UUID portraitId);
}
