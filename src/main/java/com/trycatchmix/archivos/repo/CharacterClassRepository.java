package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.CharacterClass;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CharacterClassRepository extends JpaRepository<CharacterClass, UUID> {
    Optional<CharacterClass> findByNameEnIgnoreCase(String nameEn);
    List<CharacterClass> findAllByOrderByNameAsc();
}
