package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaCombat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaCombatRepository extends JpaRepository<MesaCombat, UUID> {
    List<MesaCombat> findByCampaignIdOrderByCreatedAtDesc(UUID campaignId);
}
