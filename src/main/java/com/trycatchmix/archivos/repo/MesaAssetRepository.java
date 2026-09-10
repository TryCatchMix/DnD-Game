package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaAsset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaAssetRepository extends JpaRepository<MesaAsset, UUID> {

    /** La biblioteca de la campaña: lo suyo, esté o no asignado a una misión. */
    List<MesaAsset> findByCampaignIdOrderByCreatedAtDesc(UUID campaignId);

    List<MesaAsset> findByCampaignIdAndKindOrderByCreatedAtDesc(UUID campaignId, String kind);

    List<MesaAsset> findByMissionIdOrderByCreatedAtAsc(UUID missionId);

    long countByMissionIdAndKind(UUID missionId, String kind);
}
