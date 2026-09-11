package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.NpcRelation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

public interface NpcRelationRepository extends JpaRepository<NpcRelation, UUID> {

    List<NpcRelation> findByNpcIdOrderByOrdinalAscCreatedAtAsc(UUID npcId);

    /** Las de todo el elenco de una vez: el listado las pinta todas. */
    List<NpcRelation> findByNpcIdInOrderByOrdinalAscCreatedAtAsc(Collection<UUID> npcIds);

    /** Al borrar un PNJ hay que quitar también lo que apuntaba a él. */
    void deleteByOtherNpcId(UUID otherNpcId);
}
