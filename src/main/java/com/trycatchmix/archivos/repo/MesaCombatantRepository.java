package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaCombatant;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaCombatantRepository extends JpaRepository<MesaCombatant, UUID> {
    List<MesaCombatant> findByCombateIdOrderBySortOrdinalAsc(UUID combateId);
    void deleteByCombateId(UUID combateId);
}
