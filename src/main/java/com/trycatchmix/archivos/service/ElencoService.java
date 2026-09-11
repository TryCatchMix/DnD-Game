package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.MesaAsset;
import com.trycatchmix.archivos.domain.Npc;
import com.trycatchmix.archivos.domain.NpcRelation;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.GameCharacterRepository;
import com.trycatchmix.archivos.repo.MesaAssetRepository;
import com.trycatchmix.archivos.repo.NpcRelationRepository;
import com.trycatchmix.archivos.repo.NpcRepository;
import com.trycatchmix.archivos.web.dto.ElencoDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * EL ELENCO: la gente que ha ido saliendo en la campaña.
 *
 * Todo lo que hace este servicio se reduce a una pregunta: ¿esto ya lo saben?
 *
 * El máster escribe la ficha entera de una vez —nombre, cara, alineamiento,
 * quién es su hermano— y luego va destapando campos según la mesa los
 * descubre. Al jugador NO se le manda lo sellado con una marca para que la
 * interfaz lo tape: se le manda {@code null}. Lo que llega al navegador se
 * puede leer abriendo las herramientas del desarrollador, así que un secreto
 * escondido con CSS no es un secreto. Lo mismo vale para el retrato: los bytes
 * los sirve {@link #retrato} y comprueba el mismo permiso antes de leer el
 * fichero.
 *
 * El retrato se guarda en la biblioteca de La Mesa (mesa_archivos + el armario
 * de {@link MesaStorage}), que es donde ya vivían los mapas y las láminas. Así
 * no hay dos sitios donde caigan imágenes ni dos formas de subirlas.
 */
@Service
@RequiredArgsConstructor
public class ElencoService {

    /** Los que ofrece el desplegable. Se puede escribir otro: esto es la lista
     *  sugerida, no una validación. */
    public static final List<String> ALINEAMIENTOS = List.of(
            "Legal bueno", "Neutral bueno", "Caótico bueno",
            "Legal neutral", "Neutral", "Caótico neutral",
            "Legal malvado", "Neutral malvado", "Caótico malvado",
            "Desconocido");

    /** Cómo se lleva con alguien. Estos cuatro sí son cerrados: pintan color. */
    public static final List<String> TRATOS = List.of("amistoso", "neutral", "enemigo", "familiar");

    private static final String SIN_NOMBRE = "Desconocido";

    private final NpcRepository npcs;
    private final NpcRelationRepository relaciones;
    private final GameCharacterRepository personajes;
    private final MesaAssetRepository archivos;
    private final MesaStorage armario;

    // ------------------------------------------------------------- consultar

    @Transactional(readOnly = true)
    public ElencoView listar(UUID campaignId, boolean dm) {
        return build(campaignId, dm);
    }

    // ------------------------------------------------------------------ alta

    @Transactional
    public ElencoView crear(UUID userId, UUID campaignId, NpcRequest r) {
        String nombre = texto(r == null ? null : r.name());
        if (nombre.isEmpty()) throw ApiException.badRequest("El personaje necesita un nombre.");

        Npc n = new Npc();
        n.setCampaignId(campaignId);
        n.setUserId(userId);
        n.setName(nombre);
        n.setAlias(alias(r.alias()));
        n.setTitle(texto(r.title()));
        n.setLocation(texto(r.location()));
        n.setRace(texto(r.race()));
        n.setDescription(texto(r.description()));
        n.setTrivia(texto(r.trivia()));
        n.setAlignment(texto(r.alignment()));
        n.setOrdinal(siguienteOrdinal(campaignId));
        aplicarReveal(n, r.reveal());
        n.setCreatedAt(Instant.now());
        n.setUpdatedAt(Instant.now());
        npcs.save(n);
        return build(campaignId, true);
    }

    @Transactional
    public ElencoView editar(UUID campaignId, UUID npcId, NpcRequest r) {
        Npc n = propio(campaignId, npcId);
        if (r != null) {
            if (r.name() != null && !r.name().isBlank()) n.setName(r.name().trim());
            if (r.alias() != null)       n.setAlias(alias(r.alias()));
            if (r.title() != null)       n.setTitle(r.title().trim());
            if (r.location() != null)    n.setLocation(r.location().trim());
            if (r.race() != null)        n.setRace(r.race().trim());
            if (r.description() != null) n.setDescription(r.description().trim());
            if (r.trivia() != null)      n.setTrivia(r.trivia().trim());
            if (r.alignment() != null)   n.setAlignment(r.alignment().trim());
            aplicarReveal(n, r.reveal());
            n.setUpdatedAt(Instant.now());
        }
        return build(campaignId, true);
    }

    @Transactional
    public ElencoView eliminar(UUID campaignId, UUID npcId) {
        Npc n = propio(campaignId, npcId);
        // Lo que apuntaba a él deja de tener sentido: "enemigo de nadie".
        relaciones.deleteByOtherNpcId(n.getId());
        relaciones.deleteAll(relaciones.findByNpcIdOrderByOrdinalAscCreatedAtAsc(n.getId()));
        // Las relaciones se van AHORA, antes de tocar el PNJ. Si se dejan para
        // el flush final, el ON DELETE CASCADE de la base se las lleva al
        // borrar la fila del PNJ y el borrado que Hibernate manda después no
        // encuentra nada que borrar: sale un error de fila perdida por una
        // operación que en realidad fue bien.
        relaciones.flush();

        UUID retrato = n.getPortraitId();
        npcs.delete(n);
        // El retrato se va con él, pero solo si no lo usa nadie más.
        if (retrato != null) {
            npcs.flush();
            borrarRetratoSiSobra(retrato);
        }
        return build(campaignId, true);
    }

    /** Subir o bajar en la lista. El orden lo decide el máster, no el alfabeto. */
    @Transactional
    public ElencoView mover(UUID campaignId, UUID npcId, boolean arriba) {
        List<Npc> lista = new ArrayList<>(npcs.findByCampaignIdOrderByOrdinalAscNameAsc(campaignId));
        int i = indiceDe(lista, npcId);
        int j = arriba ? i - 1 : i + 1;
        if (j >= 0 && j < lista.size()) {
            Npc a = lista.get(i);
            lista.set(i, lista.get(j));
            lista.set(j, a);
        }
        for (int k = 0; k < lista.size(); k++) lista.get(k).setOrdinal(k);
        return build(campaignId, true);
    }

    // --------------------------------------------------------------- revelar

    /**
     * Destapar o volver a sellar UN campo, sin mandar el resto de la ficha.
     *
     * Es la operación que de verdad se usa en mesa: alguien pregunta el nombre,
     * el máster decide contarlo y toca un botón. Mandar el formulario entero
     * para eso sería pedirle que no se equivoque en los otros ocho campos.
     */
    @Transactional
    public ElencoView revelar(UUID campaignId, UUID npcId, String campo, Boolean valor) {
        Npc n = propio(campaignId, npcId);
        String c = campo == null ? "" : campo.trim().toLowerCase();
        boolean v = valor != null ? valor : !leerReveal(n, c);
        switch (c) {
            case "listed"      -> n.setListed(v);
            case "name"        -> n.setRevealName(v);
            case "portrait"    -> n.setRevealPortrait(v);
            case "title"       -> n.setRevealTitle(v);
            case "location"    -> n.setRevealLocation(v);
            case "race"        -> n.setRevealRace(v);
            case "description" -> n.setRevealDescription(v);
            case "trivia"      -> n.setRevealTrivia(v);
            case "alignment"   -> n.setRevealAlignment(v);
            default -> throw ApiException.badRequest("Ese campo no existe: " + campo);
        }
        n.setUpdatedAt(Instant.now());
        return build(campaignId, true);
    }

    /** Destapar la ficha entera de golpe: el PNJ se ha presentado y ya está. */
    @Transactional
    public ElencoView revelarTodo(UUID campaignId, UUID npcId) {
        Npc n = propio(campaignId, npcId);
        n.setListed(true);
        n.setRevealName(true);
        n.setRevealPortrait(true);
        n.setRevealTitle(true);
        n.setRevealLocation(true);
        n.setRevealRace(true);
        n.setRevealDescription(true);
        n.setRevealTrivia(true);
        n.setRevealAlignment(true);
        n.setUpdatedAt(Instant.now());
        return build(campaignId, true);
    }

    // ------------------------------------------------------------ relaciones

    @Transactional
    public ElencoView anadirRelacion(UUID campaignId, UUID npcId, RelationRequest r) {
        Npc n = propio(campaignId, npcId);
        NpcRelation rel = new NpcRelation();
        rel.setNpcId(n.getId());
        rel.setOrdinal(relaciones.findByNpcIdOrderByOrdinalAscCreatedAtAsc(n.getId()).size());
        rel.setCreatedAt(Instant.now());
        aplicarRelacion(campaignId, rel, r, true);
        relaciones.save(rel);
        return build(campaignId, true);
    }

    @Transactional
    public ElencoView editarRelacion(UUID campaignId, UUID relacionId, RelationRequest r) {
        NpcRelation rel = relacionDe(campaignId, relacionId);
        aplicarRelacion(campaignId, rel, r, false);
        return build(campaignId, true);
    }

    @Transactional
    public ElencoView quitarRelacion(UUID campaignId, UUID relacionId) {
        relaciones.delete(relacionDe(campaignId, relacionId));
        return build(campaignId, true);
    }

    // ----------------------------------------------------------------- foto

    /**
     * El retrato. Va al mismo armario que el material de La Mesa y queda
     * también en su biblioteca, así que el máster puede reutilizarlo como
     * lámina para enseñarlo a pantalla completa.
     */
    @Transactional
    public ElencoView subirRetrato(UUID userId, UUID campaignId, UUID npcId, MultipartFile file) {
        Npc n = propio(campaignId, npcId);
        if (!"imagen".equals(armario.kindDe(file == null ? null : file.getContentType())))
            throw ApiException.badRequest("El retrato tiene que ser una imagen (JPG, PNG, WEBP o GIF).");

        String storageName = armario.guardar(file);
        MesaAsset a = new MesaAsset();
        a.setUserId(userId);
        a.setCampaignId(campaignId);
        a.setKind("imagen");
        a.setTitle("Retrato · " + n.getName());
        a.setFilename(nombreLimpio(file.getOriginalFilename()));
        a.setMime(file.getContentType());
        a.setSizeBytes(file.getSize());
        a.setStorageName(storageName);
        archivos.save(a);

        UUID anterior = n.getPortraitId();
        n.setPortraitId(a.getId());
        n.setUpdatedAt(Instant.now());
        if (anterior != null) {
            npcs.flush();
            borrarRetratoSiSobra(anterior);
        }
        return build(campaignId, true);
    }

    @Transactional
    public ElencoView quitarRetrato(UUID campaignId, UUID npcId) {
        Npc n = propio(campaignId, npcId);
        UUID anterior = n.getPortraitId();
        n.setPortraitId(null);
        n.setUpdatedAt(Instant.now());
        if (anterior != null) {
            npcs.flush();
            borrarRetratoSiSobra(anterior);
        }
        return build(campaignId, true);
    }

    /**
     * Los bytes del retrato, con el permiso comprobado AQUÍ.
     *
     * Si la cara no está descubierta, el jugador no la baja aunque adivine la
     * ruta: sellar el campo en la vista y dejar el fichero abierto sería dejar
     * puesta la puerta de atrás.
     */
    @Transactional(readOnly = true)
    public MesaService.Descarga retrato(UUID campaignId, UUID npcId, boolean dm) {
        Npc n = propio(campaignId, npcId);
        if (n.getPortraitId() == null) throw ApiException.notFound("Ese personaje no tiene retrato.");
        if (!dm && !(n.isListed() && n.isRevealPortrait()))
            throw ApiException.forbidden("Todavía no le habéis visto la cara.");

        MesaAsset a = archivos.findById(n.getPortraitId())
                .orElseThrow(() -> ApiException.notFound("El retrato ya no está en el armario."));
        return new MesaService.Descarga(armario.leer(a.getStorageName()), a.getMime(), a.getFilename());
    }

    // ========================================================== la vista ====

    private ElencoView build(UUID campaignId, boolean dm) {
        List<Npc> todos = npcs.findByCampaignIdOrderByOrdinalAscNameAsc(campaignId);

        // Cómo se llama cada PNJ PARA QUIEN MIRA. Hace falta antes de pintar
        // las relaciones: si el hermano sigue siendo "el encapuchado", en la
        // ficha de su hermana tampoco puede salir su nombre.
        Map<UUID, String> comoSeLlaman = new HashMap<>();
        for (Npc n : todos) comoSeLlaman.put(n.getId(), nombreVisible(n, dm));

        Map<UUID, String> pjs = new HashMap<>();
        List<Quien> grupo = new ArrayList<>();
        for (GameCharacter c : personajes.findByCampaignIdOrderByNameAsc(campaignId)) {
            pjs.put(c.getId(), c.getName());
            grupo.add(new Quien(c.getId().toString(), c.getName()));
        }

        List<UUID> ids = todos.stream().map(Npc::getId).toList();
        Map<UUID, List<NpcRelation>> porNpc = new HashMap<>();
        if (!ids.isEmpty()) {
            for (NpcRelation r : relaciones.findByNpcIdInOrderByOrdinalAscCreatedAtAsc(ids))
                porNpc.computeIfAbsent(r.getNpcId(), k -> new ArrayList<>()).add(r);
        }

        List<NpcView> vistas = todos.stream()
                // El borrador del máster no existe para el jugador.
                .filter(n -> dm || n.isListed())
                .map(n -> vista(n, dm, porNpc.getOrDefault(n.getId(), List.of()), comoSeLlaman, pjs))
                .toList();

        return new ElencoView(vistas, dm, ALINEAMIENTOS, TRATOS, grupo);
    }

    private NpcView vista(Npc n, boolean dm, List<NpcRelation> rels,
                          Map<UUID, String> comoSeLlaman, Map<UUID, String> pjs) {

        List<RelationView> tratos = rels.stream()
                .filter(r -> dm || r.isRevealed())
                .map(r -> new RelationView(
                        r.getId().toString(),
                        r.getKind(),
                        aQuien(r, comoSeLlaman, pjs),
                        r.getNote(),
                        dm ? r.isRevealed() : null))
                .toList();

        return new NpcView(
                n.getId().toString(),
                nombreVisible(n, dm),
                dm ? n.getAlias() : null,
                visible(n.getTitle(),       dm || n.isRevealTitle()),
                visible(n.getLocation(),    dm || n.isRevealLocation()),
                visible(n.getRace(),        dm || n.isRevealRace()),
                visible(n.getDescription(), dm || n.isRevealDescription()),
                curiosidades(n, dm),
                visible(n.getAlignment(),   dm || n.isRevealAlignment()),
                n.getPortraitId() != null && (dm || n.isRevealPortrait()),
                tratos,
                porDescubrir(n, rels),
                dm ? new Reveal(n.isListed(), n.isRevealName(), n.isRevealPortrait(),
                        n.isRevealTitle(), n.isRevealLocation(), n.isRevealRace(),
                        n.isRevealDescription(), n.isRevealTrivia(), n.isRevealAlignment())
                   : null);
    }

    /** El nombre de verdad, o el alias mientras siga sellado. */
    private String nombreVisible(Npc n, boolean dm) {
        if (dm || n.isRevealName()) return n.getName();
        String a = n.getAlias() == null ? "" : n.getAlias().trim();
        return a.isEmpty() ? SIN_NOMBRE : a;
    }

    /** null si no se sabe todavía, y también si el campo está vacío: una ficha
     *  sin ubicación y una con la ubicación sellada se pintan igual de vacías,
     *  y es el contador de secretos el que dice si hay algo detrás. */
    private String visible(String valor, boolean sePuede) {
        if (!sePuede) return null;
        String v = valor == null ? "" : valor.trim();
        return v.isEmpty() ? null : v;
    }

    /** Las curiosidades van una por línea: llegan ya troceadas. */
    private List<String> curiosidades(Npc n, boolean dm) {
        if (!dm && !n.isRevealTrivia()) return null;
        return Arrays.stream(n.getTrivia().split("\\R"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }

    /**
     * Cuántas cosas SABIDAS POR EL MÁSTER quedan por descubrir. Solo cuentan
     * los campos rellenos: un alineamiento que nadie escribió no es un secreto,
     * es un hueco, y prometer misterio donde no hay nada se nota a la segunda
     * ficha.
     */
    private int porDescubrir(Npc n, List<NpcRelation> rels) {
        int c = 0;
        if (!n.isRevealName())                                        c++;
        if (n.getPortraitId() != null && !n.isRevealPortrait())       c++;
        if (!n.getTitle().isBlank()       && !n.isRevealTitle())       c++;
        if (!n.getLocation().isBlank()    && !n.isRevealLocation())    c++;
        if (!n.getRace().isBlank()        && !n.isRevealRace())        c++;
        if (!n.getDescription().isBlank() && !n.isRevealDescription()) c++;
        if (!n.getTrivia().isBlank()      && !n.isRevealTrivia())      c++;
        if (!n.getAlignment().isBlank()   && !n.isRevealAlignment())   c++;
        for (NpcRelation r : rels) if (!r.isRevealed()) c++;
        return c;
    }

    /** El otro extremo de una relación, con el nombre que toque enseñar. */
    private String aQuien(NpcRelation r, Map<UUID, String> comoSeLlaman, Map<UUID, String> pjs) {
        if (r.getOtherNpcId() != null) {
            String s = comoSeLlaman.get(r.getOtherNpcId());
            if (s != null) return s;
        }
        if (r.getCharacterId() != null) {
            String s = pjs.get(r.getCharacterId());
            if (s != null) return s;
        }
        String libre = r.getOtherName() == null ? "" : r.getOtherName().trim();
        return libre.isEmpty() ? SIN_NOMBRE : libre;
    }

    // ============================================================ ayudas ====

    private void aplicarReveal(Npc n, Reveal v) {
        if (v == null) return;
        n.setListed(v.listed());
        n.setRevealName(v.name());
        n.setRevealPortrait(v.portrait());
        n.setRevealTitle(v.title());
        n.setRevealLocation(v.location());
        n.setRevealRace(v.race());
        n.setRevealDescription(v.description());
        n.setRevealTrivia(v.trivia());
        n.setRevealAlignment(v.alignment());
    }

    private boolean leerReveal(Npc n, String campo) {
        return switch (campo) {
            case "listed"      -> n.isListed();
            case "name"        -> n.isRevealName();
            case "portrait"    -> n.isRevealPortrait();
            case "title"       -> n.isRevealTitle();
            case "location"    -> n.isRevealLocation();
            case "race"        -> n.isRevealRace();
            case "description" -> n.isRevealDescription();
            case "trivia"      -> n.isRevealTrivia();
            case "alignment"   -> n.isRevealAlignment();
            default -> throw ApiException.badRequest("Ese campo no existe: " + campo);
        };
    }

    /**
     * Rellena una relación desde lo que manda el máster. El destino es
     * excluyente: el que venga relleno gana y los otros dos se borran, para no
     * dejar una fila que apunte a dos sitios a la vez.
     */
    private void aplicarRelacion(UUID campaignId, NpcRelation rel, RelationRequest r, boolean alta) {
        if (r == null) return;
        if (r.kind() != null) rel.setKind(trato(r.kind()));
        if (r.note() != null) rel.setNote(r.note().trim());
        if (r.revealed() != null) rel.setRevealed(r.revealed());

        boolean tocaDestino = r.otherNpcId() != null || r.characterId() != null || r.otherName() != null;
        if (tocaDestino) {
            rel.setOtherNpcId(null);
            rel.setCharacterId(null);
            rel.setOtherName("");
            if (r.otherNpcId() != null && !r.otherNpcId().isBlank()) {
                Npc otro = propio(campaignId, uuid(r.otherNpcId(), "personaje"));
                if (otro.getId().equals(rel.getNpcId()))
                    throw ApiException.badRequest("Un personaje no se relaciona consigo mismo.");
                rel.setOtherNpcId(otro.getId());
            } else if (r.characterId() != null && !r.characterId().isBlank()) {
                GameCharacter pj = personajes.findById(uuid(r.characterId(), "personaje jugador"))
                        .orElseThrow(() -> ApiException.notFound("No existe ese personaje jugador."));
                if (!campaignId.equals(pj.getCampaignId()))
                    throw ApiException.forbidden("Ese personaje no juega en esta campaña.");
                rel.setCharacterId(pj.getId());
            } else {
                rel.setOtherName(texto(r.otherName()));
            }
        }

        if (alta && rel.getOtherNpcId() == null && rel.getCharacterId() == null
                 && rel.getOtherName().isBlank())
            throw ApiException.badRequest("Di con quién: otro del elenco, un jugador o un nombre.");
    }

    private String trato(String k) {
        String v = k == null ? "" : k.trim().toLowerCase();
        return TRATOS.contains(v) ? v : "neutral";
    }

    /** La ficha, comprobando que es de ESTA mesa. El permiso sobre la campaña
     *  ya lo miró el controlador; esto impide colarse con el id de otra. */
    private Npc propio(UUID campaignId, UUID npcId) {
        Npc n = npcs.findById(npcId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje del elenco."));
        if (!campaignId.equals(n.getCampaignId()))
            throw ApiException.forbidden("Ese personaje es de otra campaña.");
        return n;
    }

    private NpcRelation relacionDe(UUID campaignId, UUID relacionId) {
        NpcRelation r = relaciones.findById(relacionId)
                .orElseThrow(() -> ApiException.notFound("No existe esa relación."));
        propio(campaignId, r.getNpcId());   // la relación es de la mesa de su PNJ
        return r;
    }

    /** El retrato se borra del armario solo si ya no lo usa ningún otro PNJ. */
    private void borrarRetratoSiSobra(UUID assetId) {
        if (!npcs.findByPortraitId(assetId).isEmpty()) return;
        archivos.findById(assetId).ifPresent(a -> {
            // Si el máster lo metió además en una misión, es material suyo y se
            // queda en la biblioteca; solo se tira lo que solo era retrato.
            if (a.getMissionId() != null) return;
            archivos.delete(a);
            armario.borrar(a.getStorageName());
        });
    }

    private int siguienteOrdinal(UUID campaignId) {
        return npcs.findByCampaignIdOrderByOrdinalAscNameAsc(campaignId).stream()
                .map(Npc::getOrdinal)
                .max(Comparator.naturalOrder())
                .orElse(-1) + 1;
    }

    private int indiceDe(List<Npc> lista, UUID npcId) {
        for (int i = 0; i < lista.size(); i++) if (lista.get(i).getId().equals(npcId)) return i;
        throw ApiException.notFound("No existe ese personaje del elenco.");
    }

    private String texto(String s) { return s == null ? "" : s.trim(); }

    private String alias(String s) {
        String a = texto(s);
        return a.isEmpty() ? SIN_NOMBRE : a;
    }

    private String nombreLimpio(String original) {
        String s = original == null ? "" : original.trim();
        return s.isEmpty() ? "retrato" : s.replaceAll("[\\\\/\\r\\n]", "_");
    }

    private UUID uuid(String s, String que) {
        try {
            return UUID.fromString(s);
        } catch (IllegalArgumentException e) {
            throw ApiException.badRequest("Identificador de " + que + " inválido.");
        }
    }
}
