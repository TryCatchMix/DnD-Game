package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Property;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PropertyRepository extends JpaRepository<Property, UUID> {
    List<Property> findByCharacterIdOrderByPurchasedAtAsc(UUID characterId);
}
