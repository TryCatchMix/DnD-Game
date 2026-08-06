package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.config.JwtProperties;
import com.trycatchmix.archivos.domain.AppUser;
import com.trycatchmix.archivos.domain.RefreshToken;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.AppUserRepository;
import com.trycatchmix.archivos.repo.RefreshTokenRepository;
import com.trycatchmix.archivos.security.JwtService;
import com.trycatchmix.archivos.web.dto.AuthDtos.TokenResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

/**
 * Login, refresco ROTATORIO y logout.
 *
 * El refresh token es opaco y vive en la base de datos para poder revocarlo.
 * Cada refresco emite uno nuevo y revoca el anterior; si alguien presenta uno
 * ya revocado, se asume robo y se cae toda la familia del usuario.
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final AppUserRepository users;
    private final RefreshTokenRepository tokens;
    private final PasswordEncoder encoder;
    private final JwtService jwt;
    private final JwtProperties props;

    @Transactional
    public TokenResponse login(String email, String password) {
        AppUser user = users.findByEmail(email == null ? "" : email.trim().toLowerCase())
                .orElseThrow(ApiException::badCredentials);

        // Mismo error para correo inexistente y contraseña mala, a propósito.
        if (!encoder.matches(password, user.getPasswordHash()))
            throw ApiException.badCredentials();

        return issue(user);
    }

    @Transactional
    public TokenResponse refresh(String refreshToken) {
        RefreshToken rt = tokens.findByToken(refreshToken)
                .orElseThrow(ApiException::sessionExpired);

        if (rt.isRevoked()) {
            // Reutilización de un token ya quemado: robo. Se cae la familia.
            tokens.revokeAllForUser(rt.getUserId());
            throw ApiException.tokenReuse();
        }
        if (rt.getExpiresAt().isBefore(Instant.now()))
            throw ApiException.sessionExpired();

        rt.setRevoked(true);   // rotación: el anterior queda quemado

        AppUser user = users.findById(rt.getUserId())
                .orElseThrow(ApiException::sessionExpired);
        return issue(user);
    }

    @Transactional
    public void logout(String refreshToken) {
        if (refreshToken == null) return;
        tokens.findByToken(refreshToken).ifPresent(rt -> rt.setRevoked(true));
    }

    @Transactional(readOnly = true)
    public AppUser requireUser(UUID id) {
        return users.findById(id).orElseThrow(ApiException::sessionExpired);
    }

    // ------------------------------------------------------------------------

    private TokenResponse issue(AppUser user) {
        String access = jwt.issueAccessToken(user.getId(), user.getRole().name(), user.getDisplayName());

        RefreshToken rt = new RefreshToken();
        rt.setUserId(user.getId());
        rt.setToken(UUID.randomUUID().toString());
        rt.setExpiresAt(Instant.now().plus(props.getRefreshTtlDays(), ChronoUnit.DAYS));
        tokens.save(rt);

        return new TokenResponse(access, rt.getToken(), jwt.getAccessTtlSeconds(),
                user.getDisplayName(), user.getRole().name());
    }
}
