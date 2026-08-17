package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaAsset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaAssetRepository extends JpaRepository<MesaAsset, UUID> {

    List<MesaAsset> findByUserIdOrderByCreatedAtDesc(UUID userId);

    List<MesaAsset> findByMissionIdOrderByCreatedAtAsc(UUID missionId);

    long countByMissionIdAndKind(UUID missionId, String kind);

    List<MesaAsset> findByUserIdAndKindOrderByCreatedAtDesc(UUID userId, String kind);
}
