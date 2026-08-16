package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.MesaMission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface MesaMissionRepository extends JpaRepository<MesaMission, UUID> {

    /** Las del DM, en el orden que él las haya dejado. */
    List<MesaMission> findByUserIdOrderByOrdinalAscCreatedAtDesc(UUID userId);
}
