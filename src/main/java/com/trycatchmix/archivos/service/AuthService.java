package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.config.JwtProperties;
import com.trycatchmix.archivos.domain.AppUser;
import com.trycatchmix.archivos.domain.RefreshToken;
import com.trycatchmix.archivos.domain.Role;
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

    /**
     * Alta de un jugador. Siempre nace con rol PLAYER: el rol nunca llega del
     * cliente, así que nadie puede darse permisos de máster registrándose.
     * Deja la sesión iniciada (devuelve tokens) para no pedir login justo
     * después de crear la cuenta.
     */
    @Transactional
    public TokenResponse register(String email, String displayName, String password) {
        String correo = email == null ? "" : email.trim().toLowerCase();
        String nombre = displayName == null ? "" : displayName.trim();

        if (!correo.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
            throw ApiException.badRequest("Ese correo no tiene buena pinta.");
        if (nombre.isBlank())
            throw ApiException.badRequest("Necesitas un nombre para mostrar.");
        if (nombre.length() > 60)
            throw ApiException.badRequest("El nombre para mostrar es demasiado largo.");
        if (password == null || password.length() < 8)
            throw ApiException.badRequest("La contraseña necesita al menos 8 caracteres.");
        if (users.findByEmail(correo).isPresent())
            throw ApiException.conflict("Ya hay una cuenta con ese correo.");

        AppUser user = new AppUser();
        user.setEmail(correo);
        user.setDisplayName(nombre);
        user.setPasswordHash(encoder.encode(password));
        user.setRole(Role.PLAYER);
        users.save(user);

        return issue(user);
    }

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
