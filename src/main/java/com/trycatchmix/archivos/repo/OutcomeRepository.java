package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Outcome;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface OutcomeRepository extends JpaRepository<Outcome, UUID> {
    Optional<Outcome> findByOptionIdAndGrade(UUID optionId, int grade);
    void deleteByOptionId(UUID optionId);
}
