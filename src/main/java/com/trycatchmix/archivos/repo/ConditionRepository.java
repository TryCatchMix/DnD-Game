package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Condition;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ConditionRepository extends JpaRepository<Condition, UUID> {
    List<Condition> findAllByOrderByNameAsc();
}
