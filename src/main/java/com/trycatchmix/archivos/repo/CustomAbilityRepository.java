package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.CustomAbility;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface CustomAbilityRepository extends JpaRepository<CustomAbility, UUID> {

    /** Las más nuevas primero: lo último añadido en la mesa se ve arriba. */
    List<CustomAbility> findAllByOrderByCreatedAtDesc();
}
