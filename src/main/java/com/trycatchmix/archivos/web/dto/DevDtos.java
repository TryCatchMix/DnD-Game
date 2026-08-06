package com.trycatchmix.archivos.web.dto;

import java.util.Map;

/** DTOs de los endpoints /api/dev/** que consume probar.sh (en español). */
public final class DevDtos {
    private DevDtos() {}

    public record DevPersonaje(String id, String nombre, String clase, int vigor, String ciudad) {}

    public record DevFicha(
            int pg,
            int ca,
            int vigor,
            String bolsa,
            String carga,
            Map<String, Integer> habilidades) {}
}
