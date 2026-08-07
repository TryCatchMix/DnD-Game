package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.config.JwtProperties;
import com.trycatchmix.archivos.domain.AppUser;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.AuthService;
import com.trycatchmix.archivos.web.dto.AuthDtos.*;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    /**
     * En la WEB el refresh token viaja en esta cookie httpOnly, nunca en el
     * cuerpo de la respuesta: así ningún script (ni uno inyectado por XSS)
     * puede leerlo. La app NATIVA no usa la cookie; sigue recibiendo el token
     * en el cuerpo, porque persiste por su cuenta en el almacenamiento nativo.
     *
     * El cliente declara su plataforma con la cabecera X-Client-Platform. Si no
     * llega, se asume nativo (modo cuerpo), que es el comportamiento antiguo:
     * así una app ya instalada sigue funcionando aunque no mande la cabecera.
     */
    private static final String COOKIE_REFRESH = "archivos_rt";
    private static final String RUTA_COOKIE = "/api/auth";

    private final AuthService auth;
    private final JwtProperties props;

    @PostMapping("/register")
    public TokenResponse register(@RequestBody RegisterRequest req,
                                  HttpServletRequest http, HttpServletResponse res) {
        return emitir(auth.register(req.email(), req.displayName(), req.password()), http, res);
    }

    @PostMapping("/login")
    public TokenResponse login(@RequestBody LoginRequest req,
                               HttpServletRequest http, HttpServletResponse res) {
        return emitir(auth.login(req.email(), req.password()), http, res);
    }

    @PostMapping("/refresh")
    public TokenResponse refresh(@RequestBody(required = false) RefreshRequest req,
                                 HttpServletRequest http, HttpServletResponse res) {
        // El token del cuerpo (nativo) manda; si no viene, se lee de la cookie (web).
        String token = tieneToken(req == null ? null : req.refreshToken())
                ? req.refreshToken()
                : leerCookie(http);
        return emitir(auth.refresh(token), http, res);
    }

    @PostMapping("/logout")
    public void logout(@RequestBody(required = false) LogoutRequest req,
                       HttpServletRequest http, HttpServletResponse res) {
        String token = tieneToken(req == null ? null : req.refreshToken())
                ? req.refreshToken()
                : leerCookie(http);
        auth.logout(token);
        if (esWeb(http)) res.addHeader(HttpHeaders.SET_COOKIE, cookieBorrado().toString());
    }

    @GetMapping("/me")
    public MeResponse me(@AuthenticationPrincipal AuthPrincipal principal) {
        if (principal == null) throw ApiException.sessionExpired();
        AppUser u = auth.requireUser(principal.userId());
        return new MeResponse(u.getEmail(), u.getDisplayName(), u.getRole().name());
    }

    // ------------------------------------------------------------------------

    /**
     * Devuelve la respuesta al cliente. En web, mete el refresh token en la
     * cookie httpOnly y lo borra del cuerpo; en nativo, lo deja en el cuerpo.
     */
    private TokenResponse emitir(TokenResponse t, HttpServletRequest http, HttpServletResponse res) {
        if (!esWeb(http)) return t;
        res.addHeader(HttpHeaders.SET_COOKIE, cookieRefresh(t.refreshToken()).toString());
        return new TokenResponse(t.accessToken(), null, t.expiresIn(), t.displayName(), t.role());
    }

    private boolean esWeb(HttpServletRequest http) {
        return "web".equalsIgnoreCase(http.getHeader("X-Client-Platform"));
    }

    private static boolean tieneToken(String s) {
        return s != null && !s.isBlank();
    }

    private ResponseCookie cookieRefresh(String value) {
        return ResponseCookie.from(COOKIE_REFRESH, value)
                .httpOnly(true)
                .secure(props.isCookieSecure())
                .sameSite("Strict")
                .path(RUTA_COOKIE)
                .maxAge(Duration.ofDays(props.getRefreshTtlDays()))
                .build();
    }

    private ResponseCookie cookieBorrado() {
        return ResponseCookie.from(COOKIE_REFRESH, "")
                .httpOnly(true)
                .secure(props.isCookieSecure())
                .sameSite("Strict")
                .path(RUTA_COOKIE)
                .maxAge(0)
                .build();
    }

    private String leerCookie(HttpServletRequest http) {
        if (http.getCookies() == null) return null;
        for (Cookie c : http.getCookies()) {
            if (COOKIE_REFRESH.equals(c.getName())) return c.getValue();
        }
        return null;
    }
}
