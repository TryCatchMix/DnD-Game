package com.trycatchmix.archivos.error;

import org.springframework.http.HttpStatus;

/** Excepción con código y estado HTTP, para responder JSON coherente. */
public class ApiException extends RuntimeException {

    private final HttpStatus status;
    private final String code;

    public ApiException(HttpStatus status, String code, String message) {
        super(message);
        this.status = status;
        this.code = code;
    }

    public HttpStatus getStatus() { return status; }
    public String getCode() { return code; }

    // --- Atajos para los casos del juego ---

    public static ApiException badCredentials() {
        return new ApiException(HttpStatus.UNAUTHORIZED, "BAD_CREDENTIALS",
                "No se ha podido comprobar el registro.");
    }

    public static ApiException tokenReuse() {
        return new ApiException(HttpStatus.UNAUTHORIZED, "TOKEN_REUSE_DETECTED",
                "Se ha detectado un uso anómalo de tu sesión.");
    }

    public static ApiException sessionExpired() {
        return new ApiException(HttpStatus.UNAUTHORIZED, "SESSION_EXPIRED",
                "Tu sesión ha caducado. Entra de nuevo.");
    }

    public static ApiException notFound(String message) {
        return new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND", message);
    }

    public static ApiException conflict(String message) {
        return new ApiException(HttpStatus.CONFLICT, "CONFLICT", message);
    }

    public static ApiException blocked(String message) {
        return new ApiException(HttpStatus.CONFLICT, "BLOCKED", message);
    }

    public static ApiException forbidden(String message) {
        return new ApiException(HttpStatus.FORBIDDEN, "FORBIDDEN", message);
    }
}
