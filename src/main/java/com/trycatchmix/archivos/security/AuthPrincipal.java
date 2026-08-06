package com.trycatchmix.archivos.security;

import java.util.UUID;

/** Lo que queda en el SecurityContext tras validar el token. */
public record AuthPrincipal(UUID userId, String role, String displayName) {}
