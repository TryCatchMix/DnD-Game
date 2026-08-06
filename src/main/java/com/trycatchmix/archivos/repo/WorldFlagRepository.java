package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.WorldFlag;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WorldFlagRepository extends JpaRepository<WorldFlag, String> {
}
