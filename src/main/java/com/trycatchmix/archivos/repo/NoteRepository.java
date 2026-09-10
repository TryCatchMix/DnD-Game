package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Note;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface NoteRepository extends JpaRepository<Note, UUID> {

    /** El bloc del jugador EN esa campaña. Las fijadas primero, y dentro de
     *  cada grupo por nombre. */
    List<Note> findByCampaignIdAndUserIdOrderByPinnedDescTitleAsc(UUID campaignId, UUID userId);
}
