package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.CampaignMember;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CampaignMemberRepository extends JpaRepository<CampaignMember, UUID> {

    /** La membresía de alguien en una campaña: es el permiso, se consulta mucho. */
    Optional<CampaignMember> findByCampaignIdAndUserId(UUID campaignId, UUID userId);

    List<CampaignMember> findByUserIdOrderByJoinedAtAsc(UUID userId);

    List<CampaignMember> findByCampaignIdOrderByJoinedAtAsc(UUID campaignId);

    long countByCampaignId(UUID campaignId);
}
