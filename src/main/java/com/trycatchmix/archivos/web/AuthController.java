package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.domain.AppUser;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.AuthService;
import com.trycatchmix.archivos.web.dto.AuthDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService auth;

    @PostMapping("/register")
    public TokenResponse register(@RequestBody RegisterRequest req) {
        return auth.register(req.email(), req.displayName(), req.password());
    }

    @PostMapping("/login")
    public TokenResponse login(@RequestBody LoginRequest req) {
        return auth.login(req.email(), req.password());
    }

    @PostMapping("/refresh")
    public TokenResponse refresh(@RequestBody RefreshRequest req) {
        return auth.refresh(req.refreshToken());
    }

    @PostMapping("/logout")
    public void logout(@RequestBody(required = false) LogoutRequest req) {
        auth.logout(req == null ? null : req.refreshToken());
    }

    @GetMapping("/me")
    public MeResponse me(@AuthenticationPrincipal AuthPrincipal principal) {
        if (principal == null) throw ApiException.sessionExpired();
        AppUser u = auth.requireUser(principal.userId());
        return new MeResponse(u.getEmail(), u.getDisplayName(), u.getRole().name());
    }
}
