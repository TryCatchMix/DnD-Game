package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Spell;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SpellRepository extends JpaRepository<Spell, UUID> {
    List<Spell> findAllByOrderByNameAsc();

    Optional<Spell> findByNameIgnoreCase(String name);
}
