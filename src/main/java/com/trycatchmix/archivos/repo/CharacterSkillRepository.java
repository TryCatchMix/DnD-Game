package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.CharacterSkill;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface CharacterSkillRepository extends JpaRepository<CharacterSkill, UUID> {
    List<CharacterSkill> findByCharacterIdOrderByNameAsc(UUID characterId);
    void deleteByCharacterId(UUID characterId);
}
