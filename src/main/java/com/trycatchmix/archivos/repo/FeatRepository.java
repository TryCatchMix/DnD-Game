package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Feat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface FeatRepository extends JpaRepository<Feat, UUID> {
    List<Feat> findAllByOrderByNameAsc();
    Optional<Feat> findByNameIgnoreCase(String name);
}
