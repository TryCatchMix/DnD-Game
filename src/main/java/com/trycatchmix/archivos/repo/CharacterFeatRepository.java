package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.CharacterFeat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface CharacterFeatRepository extends JpaRepository<CharacterFeat, UUID> {
    List<CharacterFeat> findByCharacterIdOrderBySortOrdinalAscNameAsc(UUID characterId);
    void deleteByCharacterId(UUID characterId);
}
