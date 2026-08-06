package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.ChronicleEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ChronicleEntryRepository extends JpaRepository<ChronicleEntry, UUID> {
    List<ChronicleEntry> findAllByOrderByYearAscSortOrdinalAsc();
}
