package com.trycatchmix.archivos.config;

import jakarta.annotation.PostConstruct;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.nio.charset.StandardCharsets;

/**
 * Configuración del JWT. La clave se valida al arrancar: si es corta, la
 * aplicación se niega a subir, igual que documenta la guía.
 */
@ConfigurationProperties(prefix = "archivos.jwt")
public class JwtProperties {

    private String secret = "";
    private long accessTtlSeconds = 900;
    private int refreshTtlDays = 30;

    @PostConstruct
    void check() {
        if (secret == null || secret.getBytes(StandardCharsets.UTF_8).length < 32) {
            throw new IllegalStateException(
                "ARCHIVOS_JWT_SECRET necesita al menos 32 bytes. "
                + "Genera uno con:  export ARCHIVOS_JWT_SECRET=$(openssl rand -base64 48)");
        }
    }

    public String getSecret() { return secret; }
    public void setSecret(String secret) { this.secret = secret; }

    public long getAccessTtlSeconds() { return accessTtlSeconds; }
    public void setAccessTtlSeconds(long accessTtlSeconds) { this.accessTtlSeconds = accessTtlSeconds; }

    public int getRefreshTtlDays() { return refreshTtlDays; }
    public void setRefreshTtlDays(int refreshTtlDays) { this.refreshTtlDays = refreshTtlDays; }
}
