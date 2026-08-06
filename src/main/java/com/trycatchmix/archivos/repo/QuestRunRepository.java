package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.QuestRun;
import com.trycatchmix.archivos.domain.RunStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface QuestRunRepository extends JpaRepository<QuestRun, UUID> {

    Optional<QuestRun> findByCharacterIdAndStatus(UUID characterId, RunStatus status);

    Optional<QuestRun> findByCharacterIdAndQuestId(UUID characterId, UUID questId);

    List<QuestRun> findByCharacterId(UUID characterId);

    long countByQuestIdAndStatus(UUID questId, RunStatus status);
}
