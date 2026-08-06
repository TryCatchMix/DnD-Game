package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.InventoryEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface InventoryRepository extends JpaRepository<InventoryEntry, UUID> {
    List<InventoryEntry> findByCharacterIdOrderByItemCodeAsc(UUID characterId);
    List<InventoryEntry> findByCharacterIdOrderByNameAsc(UUID characterId);
    Optional<InventoryEntry> findByCharacterIdAndItemCode(UUID characterId, String itemCode);
}
