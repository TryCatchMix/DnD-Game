package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.PreparedSpell;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PreparedSpellRepository extends JpaRepository<PreparedSpell, UUID> {

    List<PreparedSpell> findByCharacterIdOrderByCreatedAtAsc(UUID characterId);

    Optional<PreparedSpell> findByCharacterIdAndSpellId(UUID characterId, UUID spellId);
}
