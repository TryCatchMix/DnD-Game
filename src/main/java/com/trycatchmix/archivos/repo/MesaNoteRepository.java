package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaNote;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaNoteRepository extends JpaRepository<MesaNote, UUID> {

    List<MesaNote> findByMissionIdOrderByOrdinalAscCreatedAtAsc(UUID missionId);

    long countByMissionId(UUID missionId);
}
