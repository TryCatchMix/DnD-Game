package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Quest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface QuestRepository extends JpaRepository<Quest, UUID> {

    /**
     * El tablón de una ciudad para un personaje de esa campaña: los encargos de
     * su mesa MÁS los comunes (campaign_id null), que son los sembrados y los
     * que ya existían antes de que hubiera campañas. Así una campaña recién
     * creada tiene algo que jugar desde el primer día.
     */
    @Query("""
           select q from Quest q
            where q.published = true
              and q.location = :location
              and (q.campaignId = :campaignId or q.campaignId is null)
            order by q.title asc
           """)
    List<Quest> tablon(@Param("location") String location, @Param("campaignId") UUID campaignId);

    /** Los de una campaña, para el editor del máster. */
    List<Quest> findByCampaignIdOrderByTitleAsc(UUID campaignId);

    /** Los comunes, que se ven desde cualquier campaña pero no se tocan. */
    List<Quest> findByCampaignIdIsNullOrderByTitleAsc();

    Optional<Quest> findByCampaignIdAndCode(UUID campaignId, String code);

    Optional<Quest> findByCampaignIdIsNullAndCode(String code);
}
