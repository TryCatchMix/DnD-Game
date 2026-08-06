package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Scene;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SceneRepository extends JpaRepository<Scene, UUID> {
    List<Scene> findByQuestIdOrderByOrdinalAsc(UUID questId);
    void deleteByQuestId(UUID questId);
}
