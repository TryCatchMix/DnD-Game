package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Quest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface QuestRepository extends JpaRepository<Quest, UUID> {
    List<Quest> findByLocationAndPublishedTrueOrderByTitleAsc(String location);
    Optional<Quest> findByCode(String code);
}
