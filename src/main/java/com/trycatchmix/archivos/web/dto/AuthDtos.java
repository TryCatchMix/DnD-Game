package com.trycatchmix.archivos.web.dto;

/** DTOs de autenticación, agrupados. */
public final class AuthDtos {
    private AuthDtos() {}

    public record LoginRequest(String email, String password) {}
    public record RefreshRequest(String refreshToken) {}
    public record LogoutRequest(String refreshToken) {}

    /** La respuesta de login y refresh. Trae de todo para que el frontend y
     *  probar.sh no necesiten otra llamada. */
    public record TokenResponse(
            String accessToken,
            String refreshToken,
            long expiresIn,
            String displayName,
            String role) {}

    public record MeResponse(String email, String displayName, String role) {}
}
