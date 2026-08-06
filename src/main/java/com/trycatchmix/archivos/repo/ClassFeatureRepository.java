package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.ClassFeature;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClassFeatureRepository extends JpaRepository<ClassFeature, java.util.UUID> {
    List<ClassFeature> findAllByOrderByClazzAscLevelAscNameAsc();
    List<ClassFeature> findByClazzIgnoreCaseOrderByLevelAscNameAsc(String clazz);
}
