package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.OptionModifier;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface OptionModifierRepository extends JpaRepository<OptionModifier, UUID> {
    void deleteByOptionId(UUID optionId);
}
