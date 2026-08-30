package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaEnemy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaEnemyRepository extends JpaRepository<MesaEnemy, UUID> {
    List<MesaEnemy> findByUserIdOrderByNameAsc(UUID userId);
    List<MesaEnemy> findByMisionIdOrderByNameAsc(UUID misionId);
}
