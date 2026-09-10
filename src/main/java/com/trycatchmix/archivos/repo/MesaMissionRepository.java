package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaMission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaMissionRepository extends JpaRepository<MesaMission, UUID> {

    /** Las de la campaña, en el orden que el máster las haya dejado. */
    List<MesaMission> findByCampaignIdOrderByOrdinalAscCreatedAtDesc(UUID campaignId);
}
