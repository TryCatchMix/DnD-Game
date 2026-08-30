package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Disease;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DiseaseRepository extends JpaRepository<Disease, UUID> {
    List<Disease> findAllByOrderByNameAsc();
}
