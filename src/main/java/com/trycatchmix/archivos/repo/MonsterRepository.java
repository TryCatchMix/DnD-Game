package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Monster;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MonsterRepository extends JpaRepository<Monster, UUID> {
    List<Monster> findAllByOrderByNameAsc();
}
