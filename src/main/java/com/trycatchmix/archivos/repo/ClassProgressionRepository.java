package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.ClassProgression;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ClassProgressionRepository extends JpaRepository<ClassProgression, UUID> {
    Optional<ClassProgression> findByClassEnIgnoreCaseAndLevel(String classEn, int level);
    List<ClassProgression> findByClassEnIgnoreCaseOrderByLevelAsc(String classEn);
}
