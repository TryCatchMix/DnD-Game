package com.trycatchmix.archivos.web.dto;

import com.trycatchmix.archivos.web.dto.SpellDtos.SpellView;

import java.util.List;

/** DTOs de la lista de conjuros preparados de un personaje. */
public final class PreparedDtos {
    private PreparedDtos() {}

    /** Un conjuro preparado: la fila (con su id, para editarla o quitarla),
     *  cuántas veces se lleva preparado, el nivel al que lo lanza ESTE personaje
     *  (según su clase) y el conjuro completo del grimorio. */
    public record PreparedView(String id, int prepared, int level, SpellView spell) {}

    /** Lo que se manda para preparar un conjuro: su nombre (el del grimorio) y,
     *  opcionalmente, cuántas veces. */
    public record PrepareRequest(String name, Integer prepared) {}

    /** Lo que se manda para cambiar cuántas veces se lleva preparado. 0 o menos
     *  lo quita de la lista. */
    public record CountRequest(Integer prepared) {}

    /** La lista entera, ya ordenada por nivel. */
    public record PreparedList(List<PreparedView> items) {}
}
