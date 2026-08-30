package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Poison;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PoisonRepository extends JpaRepository<Poison, UUID> {
    List<Poison> findAllByOrderByNameAsc();
}
