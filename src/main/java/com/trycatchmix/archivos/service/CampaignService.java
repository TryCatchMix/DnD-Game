package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.*;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.*;
import com.trycatchmix.archivos.web.dto.CampaignDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.*;

/**
 * Las campañas: crear una mesa, repartir el código y que la gente entre con sus
 * personajes.
 *
 * DOS DECISIONES QUE CONVIENE TENER PRESENTES:
 *
 * 1. EL MÁSTER LO ES DE SU CAMPAÑA. Quien crea una es su DM y ahí manda; en la
 *    de al lado puede ser un jugador más. El rol de la cuenta ya no pinta nada
 *    en esto (ver {@link CampaignAccess}).
 *
 * 2. UNA CAMPAÑA NUEVA NACE CON TIENDA. Se le copia el surtido base —las
 *    antorchas, la cuerda, la poción— para que el primer día haya algo que
 *    comprar. A partir de ahí el mostrador es suyo: el DM pone y quita lo que
 *    quiera sin que se entere nadie más.
 */
@Service
@RequiredArgsConstructor
public class CampaignService {

    /** Sin O ni 0, sin I ni 1: el código se dicta en voz alta. */
    private static final String ALFABETO = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int LARGO_CODIGO = 6;
    private static final SecureRandom AZAR = new SecureRandom();

    private final CampaignRepository campaigns;
    private final CampaignMemberRepository members;
    private final GameCharacterRepository characters;
    private final AppUserRepository users;
    private final ShopOfferRepository offers;
    private final MesaAssetRepository assets;
    private final MesaStorage armario;
    private final QuestAuthoringService authoring;
    private final CampaignAccess access;

    // ------------------------------------------------------------- consultar ---

    /** Mis campañas y los personajes que aún no están en ninguna. */
    @Transactional(readOnly = true)
    public CampaignsView mias(UUID userId) {
        List<CampaignCard> tarjetas = members.findByUserIdOrderByJoinedAtAsc(userId).stream()
                .map(m -> campaigns.findById(m.getCampaignId()).map(c -> tarjeta(c, m, userId)).orElse(null))
                .filter(Objects::nonNull)
                .toList();

        List<CampaignCharacter> sueltos = characters.findByUserIdOrderByNameAsc(userId).stream()
                .filter(c -> c.getCampaignId() == null)
                .map(c -> personaje(c, userId))
                .toList();

        return new CampaignsView(tarjetas, sueltos);
    }

    /** Una campaña abierta: la tarjeta y el grupo entero. */
    @Transactional(readOnly = true)
    public CampaignDetail abrir(UUID userId, UUID campaignId) {
        CampaignMember mio = access.membresia(userId, campaignId);
        Campaign c = access.campaign(campaignId);

        var porUsuario = new LinkedHashMap<UUID, List<CampaignCharacter>>();
        for (GameCharacter ch : characters.findByCampaignIdOrderByNameAsc(campaignId))
            porUsuario.computeIfAbsent(ch.getUserId(), k -> new ArrayList<>()).add(personaje(ch, userId));

        List<CampaignMemberView> grupo = members.findByCampaignIdOrderByJoinedAtAsc(campaignId).stream()
                .map(m -> new CampaignMemberView(
                        m.getUserId().toString(),
                        nombreDe(m.getUserId()),
                        m.getRole().name(),
                        m.getUserId().equals(c.getOwnerId()),
                        m.getUserId().equals(userId),
                        porUsuario.getOrDefault(m.getUserId(), List.of())))
                .toList();

        return new CampaignDetail(tarjeta(c, mio, userId), grupo);
    }

    /**
     * En qué campaña está un personaje y qué soy yo en ella. Lo piden las
     * pantallas que cuelgan de un personaje para saber a qué mesa preguntarle
     * las cosas; devuelve todo a null si el personaje no se ha unido a nada.
     */
    @Transactional(readOnly = true)
    public CampaignContext contexto(UUID userId, UUID charId) {
        GameCharacter ch = access.exigePersonaje(userId, charId);
        if (ch.getCampaignId() == null) return new CampaignContext(null, null, null, false);

        Campaign c = access.campaign(ch.getCampaignId());
        var mia = access.membresiaSiLaHay(userId, c.getId());
        // El dueño del personaje puede no estar en la mesa (le echaron y el
        // personaje se quedó); entonces no es nada dentro de ella.
        return new CampaignContext(
                c.getId().toString(), c.getName(),
                mia.map(m -> m.getRole().name()).orElse(null),
                mia.map(CampaignMember::esDm).orElse(false));
    }

    // ----------------------------------------------------------------- crear ---

    @Transactional
    public CampaignDetail crear(UUID userId, CampaignRequest r) {
        String nombre = r == null || r.name() == null ? "" : r.name().trim();
        if (nombre.isEmpty()) throw ApiException.badRequest("La campaña necesita un nombre.");

        Campaign c = new Campaign();
        c.setOwnerId(userId);
        c.setName(nombre);
        c.setDescription(r.description() == null ? "" : r.description().trim());
        c.setJoinCode(codigoLibre());
        c.setOpen(r.open() == null || r.open());
        campaigns.save(c);

        CampaignMember dm = new CampaignMember();
        dm.setCampaignId(c.getId());
        dm.setUserId(userId);
        dm.setRole(Role.DM);
        members.save(dm);

        surtirTienda(c.getId());

        return abrir(userId, c.getId());
    }

    /** Copia el surtido base al mostrador de la campaña recién creada. */
    private void surtirTienda(UUID campaignId) {
        for (ShopOffer base : offers.findByCampaignIdIsNull()) {
            ShopOffer o = new ShopOffer();
            o.setCampaignId(campaignId);
            o.setLocation(base.getLocation());
            o.setItemCode(base.getItemCode());
            o.setPriceCp(base.getPriceCp());
            o.setStock(base.getStock());
            offers.save(o);
        }
    }

    // ---------------------------------------------------------------- editar ---

    @Transactional
    public CampaignDetail editar(UUID userId, UUID campaignId, CampaignRequest r) {
        Campaign c = access.exigeDm(userId, campaignId);
        if (r != null) {
            if (r.name() != null && !r.name().isBlank()) c.setName(r.name().trim());
            if (r.description() != null) c.setDescription(r.description().trim());
            if (r.open() != null) c.setOpen(r.open());
            c.setUpdatedAt(Instant.now());
        }
        return abrir(userId, campaignId);
    }

    /** Un código nuevo. El viejo deja de valer al instante. */
    @Transactional
    public CampaignDetail renovarCodigo(UUID userId, UUID campaignId) {
        Campaign c = access.exigeDm(userId, campaignId);
        c.setJoinCode(codigoLibre());
        c.setUpdatedAt(Instant.now());
        return abrir(userId, campaignId);
    }

    /**
     * Borrar la campaña entera. No hay papelera.
     *
     * La base se lleva por cascada las notas, la tienda, las misiones, el
     * material, los enemigos y los combates (ver V28). Tres cosas hay que hacer
     * a mano porque la cascada no llega o no basta:
     *   · los encargos, que arrastran escenas y partidas sin cascada;
     *   · los ficheros del material, que están en disco, no en la base;
     *   · los personajes, que NO se borran: salen de la mesa y siguen siendo de
     *     su jugador, con su ficha y su dinero.
     */
    @Transactional
    public CampaignsView eliminar(UUID userId, UUID campaignId) {
        Campaign c = access.exigeDueno(userId, campaignId);

        authoring.borrarEncargosDe(campaignId);

        var material = assets.findByCampaignIdOrderByCreatedAtDesc(campaignId);
        for (MesaAsset a : material) {
            try {
                armario.borrar(a.getStorageName());
            } catch (RuntimeException e) {
                // Fichero ya desaparecido: no es motivo para dejar la campaña a medio borrar.
            }
        }

        for (GameCharacter ch : characters.findByCampaignIdOrderByNameAsc(campaignId))
            ch.setCampaignId(null);
        characters.flush();

        campaigns.delete(c);
        campaigns.flush();
        return mias(userId);
    }

    // ----------------------------------------------------------------- entrar ---

    /** Entrar con el código. Si viene un personaje, entra con él. */
    @Transactional
    public CampaignDetail unirse(UUID userId, JoinRequest r) {
        String codigo = r == null || r.code() == null ? "" : r.code().trim().toUpperCase();
        if (codigo.isEmpty()) throw ApiException.badRequest("Escribe el código de la campaña.");

        Campaign c = campaigns.findByJoinCode(codigo)
                .orElseThrow(() -> ApiException.notFound("No hay ninguna campaña con ese código."));
        if (!c.isOpen())
            throw ApiException.conflict("Esa campaña tiene la puerta cerrada. Habla con su máster.");

        if (members.findByCampaignIdAndUserId(c.getId(), userId).isEmpty()) {
            CampaignMember m = new CampaignMember();
            m.setCampaignId(c.getId());
            m.setUserId(userId);
            m.setRole(Role.PLAYER);
            members.save(m);
        }

        if (r.personajeId() != null && !r.personajeId().isBlank())
            apuntar(userId, c.getId(), uuid(r.personajeId(), "personaje"));

        return abrir(userId, c.getId());
    }

    /** Meter un personaje mío en una campaña en la que ya estoy. */
    @Transactional
    public CampaignDetail apuntar(UUID userId, UUID campaignId, UUID charId) {
        access.membresia(userId, campaignId);

        GameCharacter ch = access.personaje(charId);
        if (!ch.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        if (campaignId.equals(ch.getCampaignId())) return abrir(userId, campaignId);
        if (ch.getCampaignId() != null)
            throw ApiException.conflict(
                    "%s ya está jugando en otra campaña. Sácalo de ella antes de traerlo aquí."
                            .formatted(ch.getName()));

        ch.setCampaignId(campaignId);
        return abrir(userId, campaignId);
    }

    /**
     * Sacar un personaje de la mesa. Lo puede hacer su jugador o el máster de la
     * campaña. El personaje no se toca: conserva ficha, bolsa y dinero, y podrá
     * unirse a otra partida.
     */
    @Transactional
    public CampaignDetail sacar(UUID userId, UUID campaignId, UUID charId) {
        access.membresia(userId, campaignId);

        GameCharacter ch = access.personaje(charId);
        if (!campaignId.equals(ch.getCampaignId()))
            throw ApiException.conflict("Ese personaje no está en esta campaña.");
        if (!ch.getUserId().equals(userId) && !access.esDm(userId, campaignId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");

        ch.setCampaignId(null);
        return abrir(userId, campaignId);
    }

    /** Salirse de la mesa, con los personajes que hubiera traído. */
    @Transactional
    public CampaignsView salir(UUID userId, UUID campaignId) {
        CampaignMember mio = access.membresia(userId, campaignId);
        Campaign c = access.campaign(campaignId);
        if (c.getOwnerId().equals(userId))
            throw ApiException.conflict(
                    "Diriges esta campaña: no puedes salirte de ella, solo borrarla.");

        for (GameCharacter ch : characters.findByUserIdAndCampaignIdOrderByNameAsc(userId, campaignId))
            ch.setCampaignId(null);
        members.delete(mio);
        return mias(userId);
    }

    /** Echar a alguien. Sus personajes salen con él. */
    @Transactional
    public CampaignDetail expulsar(UUID userId, UUID campaignId, UUID otroId) {
        Campaign c = access.exigeDm(userId, campaignId);
        if (c.getOwnerId().equals(otroId))
            throw ApiException.conflict("No se puede echar a quien creó la campaña.");

        CampaignMember suya = members.findByCampaignIdAndUserId(campaignId, otroId)
                .orElseThrow(() -> ApiException.notFound("Esa persona no está en la campaña."));

        for (GameCharacter ch : characters.findByUserIdAndCampaignIdOrderByNameAsc(otroId, campaignId))
            ch.setCampaignId(null);
        members.delete(suya);
        return abrir(userId, campaignId);
    }

    /** Nombrar co-máster o devolver a jugador. El dueño se queda como DM siempre. */
    @Transactional
    public CampaignDetail cambiarPapel(UUID userId, UUID campaignId, UUID otroId, String papel) {
        Campaign c = access.exigeDm(userId, campaignId);
        if (c.getOwnerId().equals(otroId))
            throw ApiException.conflict("Quien creó la campaña siempre la dirige.");

        CampaignMember suya = members.findByCampaignIdAndUserId(campaignId, otroId)
                .orElseThrow(() -> ApiException.notFound("Esa persona no está en la campaña."));
        suya.setRole("DM".equalsIgnoreCase(papel == null ? "" : papel.trim()) ? Role.DM : Role.PLAYER);
        return abrir(userId, campaignId);
    }

    // ------------------------------------------------------------------ dentro ---

    private CampaignCard tarjeta(Campaign c, CampaignMember mio, UUID userId) {
        List<CampaignCharacter> mios =
                characters.findByUserIdAndCampaignIdOrderByNameAsc(userId, c.getId()).stream()
                        .map(ch -> personaje(ch, userId))
                        .toList();
        return new CampaignCard(
                c.getId().toString(), c.getName(), c.getDescription(),
                mio.getRole().name(), c.getOwnerId().equals(userId), c.isOpen(),
                // El código es la llave: solo lo ve quien dirige.
                mio.esDm() ? c.getJoinCode() : null,
                (int) members.countByCampaignId(c.getId()),
                (int) characters.countByCampaignId(c.getId()),
                mios,
                c.getCreatedAt().toString());
    }

    private CampaignCharacter personaje(GameCharacter c, UUID userId) {
        return new CampaignCharacter(
                c.getId().toString(), c.getName(), c.getClazz(), c.getLevel(), c.getCity(),
                nombreDe(c.getUserId()), c.getUserId().equals(userId));
    }

    private String nombreDe(UUID userId) {
        return users.findById(userId).map(AppUser::getDisplayName).orElse("—");
    }

    /** Un código que no esté cogido. Con 32^6 combinaciones no suele repetir. */
    private String codigoLibre() {
        for (int intento = 0; intento < 20; intento++) {
            StringBuilder sb = new StringBuilder(LARGO_CODIGO);
            for (int i = 0; i < LARGO_CODIGO; i++)
                sb.append(ALFABETO.charAt(AZAR.nextInt(ALFABETO.length())));
            String codigo = sb.toString();
            if (!campaigns.existsByJoinCode(codigo)) return codigo;
        }
        throw ApiException.conflict("No se ha podido generar un código. Inténtalo otra vez.");
    }

    private static UUID uuid(String s, String que) {
        try {
            return UUID.fromString(s.trim());
        } catch (IllegalArgumentException e) {
            throw ApiException.badRequest("Identificador de " + que + " inválido.");
        }
    }
}
