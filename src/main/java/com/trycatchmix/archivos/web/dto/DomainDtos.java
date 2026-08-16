package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** DTOs de los dominios divinos del clérigo. */
public final class DomainDtos {
    private DomainDtos() {}

    /** Un dominio en la lista para elegir: su código y su nombre. */
    public record DomainSummary(String code, String nombre) {}

    /** Un conjuro de dominio ya resuelto. `name` es el nombre en español si el
     *  conjuro está en el grimorio (`inGrimoire`), o el inglés si no lo tenemos.
     *  El nivel es el de dominio (1..9), no el de clérigo. */
    public record DomainSpellView(int level, String name, String nameEn, boolean inGrimoire) {}

    /** El detalle de un dominio: el poder otorgado (la «pasiva») y sus 9 conjuros. */
    public record DomainDetail(String code, String nombre, String poder, List<DomainSpellView> spells) {}
}
