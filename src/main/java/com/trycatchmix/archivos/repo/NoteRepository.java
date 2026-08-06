package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Note;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface NoteRepository extends JpaRepository<Note, UUID> {
    /** Las fijadas primero, y dentro de cada grupo por nombre. */
    List<Note> findByUserIdOrderByPinnedDescTitleAsc(UUID userId);
}
