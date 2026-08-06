package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.SceneOption;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SceneOptionRepository extends JpaRepository<SceneOption, UUID> {
    List<SceneOption> findBySceneId(UUID sceneId);
    void deleteBySceneId(UUID sceneId);
}
