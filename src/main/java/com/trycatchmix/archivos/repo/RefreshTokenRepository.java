package com.trycatchmix.archivos.repo;

import com.trycatchmix.archivos.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, UUID> {

    Optional<RefreshToken> findByToken(String token);

    /** Robo detectado: se revoca la familia entera del usuario. */
    @Modifying
    @Query("update RefreshToken r set r.revoked = true where r.userId = :userId")
    void revokeAllForUser(@Param("userId") UUID userId);
}
