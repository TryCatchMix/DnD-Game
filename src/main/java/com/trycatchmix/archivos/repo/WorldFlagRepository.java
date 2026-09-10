package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.WorldFlag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface WorldFlagRepository extends JpaRepository<WorldFlag, UUID> {

    /** El estado de una bandera en una campaña. */
    Optional<WorldFlag> findByCampaignIdAndFlagKey(UUID campaignId, String flagKey);

    /** La plantilla base: de aquí copia su estado del mundo una campaña nueva. */
    List<WorldFlag> findByCampaignIdIsNull();
}
