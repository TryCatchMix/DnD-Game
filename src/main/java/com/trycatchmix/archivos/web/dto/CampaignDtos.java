package com.trycatchmix.archivos.web.dto;

import java.util.List;

/** Lo que viaja entre el frontend y el backend en la pantalla de campañas. */
public final class CampaignDtos {

    private CampaignDtos() {}

    /** Crear o editar. Lo que llegue a null se deja como estaba. */
    public record CampaignRequest(String name, String description, Boolean open) {}

    /** Entrar con el código. `personajeId` es opcional: si viene, el personaje
     *  se une a la vez, que es lo que quiere hacer casi todo el mundo. */
    public record JoinRequest(String code, String personajeId) {}

    /** Un personaje visto desde la campaña. */
    public record CampaignCharacter(
            String id, String name, String clazz, int level, String city,
            String owner, boolean mine) {}

    /** Quién está en la mesa, con lo que haya traído. */
    public record CampaignMemberView(
            String userId, String displayName, String role, boolean owner, boolean me,
            List<CampaignCharacter> characters) {}

    /**
     * Una campaña en la lista. `joinCode` solo se rellena para su máster: el
     * código es la llave de la puerta, no tiene por qué verlo un jugador.
     */
    public record CampaignCard(
            String id, String name, String description,
            String role, boolean owner, boolean open, String joinCode,
            int memberCount, int characterCount,
            List<CampaignCharacter> myCharacters,
            String createdAt) {}

    /** La campaña abierta: la tarjeta más el grupo entero. */
    public record CampaignDetail(
            CampaignCard campaign, List<CampaignMemberView> members) {}

    /**
     * La pantalla entera: las campañas en las que estoy y los personajes que
     * todavía no están en ninguna, que son los que puedo apuntar a una.
     */
    public record CampaignsView(
            List<CampaignCard> campaigns, List<CampaignCharacter> free) {}

    /**
     * En qué campaña está un personaje y qué soy yo en ella. Es lo que preguntan
     * las pantallas que cuelgan de un personaje (bloc, tienda, La Mesa) para
     * saber a qué mesa pedirle los datos y qué pestañas enseñar.
     *
     * `campaignId` a null significa que el personaje aún no se ha unido a nada.
     */
    public record CampaignContext(
            String campaignId, String name, String role, boolean dm) {}
}
