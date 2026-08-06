package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.Invocation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface InvocationRepository extends JpaRepository<Invocation, UUID> {
    List<Invocation> findAllByOrderByGradeOrderAscNameAsc();
}
