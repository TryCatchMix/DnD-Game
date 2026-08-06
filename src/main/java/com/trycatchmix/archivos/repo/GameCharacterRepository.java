package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.GameCharacter;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface GameCharacterRepository extends JpaRepository<GameCharacter, UUID> {
    List<GameCharacter> findByUserIdOrderByNameAsc(UUID userId);
}
