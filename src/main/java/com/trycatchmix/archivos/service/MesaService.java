package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.MesaAsset;
import com.trycatchmix.archivos.domain.MesaMission;
import com.trycatchmix.archivos.domain.MesaNote;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.MesaAssetRepository;
import com.trycatchmix.archivos.repo.MesaMissionRepository;
import com.trycatchmix.archivos.repo.MesaNoteRepository;
import com.trycatchmix.archivos.web.dto.MesaDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.Instant;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

/**
 * La Mesa: preparar partidas. Misiones (carpetas), su guion (notas ordenadas)
 * y su material (imágenes y PDF).
 *
 * Todo es del DM que lo creó: cada consulta pasa por {@link #propia} o
 * {@link #propio}, que devuelven 403 si el recurso es de otro. El rol se
 * comprueba antes, en el controlador.
 */
@Service
@RequiredArgsConstructor
public class MesaService {

    /** Los estados de una misión, en el orden en que ocurren. */
    public static final List<String> ESTADOS = List.of("idea", "preparando", "lista", "jugada");

    /** Los tipos de nota del guion. */
    public static final List<String> TIPOS_NOTA = List.of("lectura", "escena", "pnj", "botin", "nota");

    private final MesaMissionRepository misiones;
    private final MesaNoteRepository notas;
    private final MesaAssetRepository archivos;
    private final MesaStorage armario;

    // ---------------------------------------------------------------- misiones

    @Transactional(readOnly = true)
    public MesaView listar(UUID userId) {
        return build(userId);
    }

    @Transactional
    public MissionDetail crear(UUID userId, MissionRequest r) {
        String titulo = r == null || r.title() == null ? "" : r.title().trim();
        if (titulo.isEmpty()) throw ApiException.badRequest("La misión necesita un título.");

        MesaMission m = new MesaMission();
        m.setUserId(userId);
        m.setTitle(titulo);
        m.setSummary(texto(r.summary()));
        m.setStatus(estadoDe(r.status()));
        m.setTags(texto(r.tags()));
        m.setSessionDate(fechaDe(r.sessionDate()));
        m.setOrdinal(siguienteOrdinal(userId));
        misiones.save(m);
        return detalle(m);
    }

    @Transactional(readOnly = true)
    public MissionDetail abrir(UUID userId, UUID misionId) {
        return detalle(propia(userId, misionId));
    }

    /** Editar. Lo que llegue a null se deja como estaba. */
    @Transactional
    public MissionDetail editar(UUID userId, UUID misionId, MissionRequest r) {
        MesaMission m = propia(userId, misionId);
        if (r != null) {
            if (r.title() != null && !r.title().isBlank()) m.setTitle(r.title().trim());
            if (r.summary() != null) m.setSummary(r.summary().trim());
            if (r.status() != null) m.setStatus(estadoDe(r.status()));
            if (r.tags() != null) m.setTags(r.tags().trim());
            // La fecha se borra mandando "" (no null, que significa "no tocar").
            if (r.sessionDate() != null) m.setSessionDate(fechaDe(r.sessionDate()));
            if (r.coverId() != null) m.setCoverId(portadaDe(userId, misionId, r.coverId()));
            m.setUpdatedAt(Instant.now());
        }
        return detalle(m);
    }

    /**
     * Borra la misión con su guion. Los archivos NO se borran: vuelven a la
     * biblioteca general, porque un mapa suele servir para otra partida.
     */
    @Transactional
    public MesaView eliminar(UUID userId, UUID misionId) {
        MesaMission m = propia(userId, misionId);
        m.setCoverId(null);
        archivos.findByMissionIdOrderByCreatedAtAsc(misionId).forEach(a -> a.setMissionId(null));
        // El guion se va con ella por el ON DELETE CASCADE de la migración: no
        // lo borramos aquí para no pelearnos con el orden de flush de Hibernate.
        misiones.delete(m);
        return build(userId);
    }

    // ------------------------------------------------------------------- guion

    @Transactional
    public MissionDetail anadirNota(UUID userId, UUID misionId, NoteRequest r) {
        MesaMission m = propia(userId, misionId);
        MesaNote n = new MesaNote();
        n.setMissionId(misionId);
        n.setKind(tipoNotaDe(r == null ? null : r.kind()));
        n.setTitle(r == null ? "" : texto(r.title()));
        n.setBody(r == null ? "" : texto(r.body()));
        n.setOrdinal((int) notas.countByMissionId(misionId));
        notas.save(n);
        m.setUpdatedAt(Instant.now());
        return detalle(m);
    }

    @Transactional
    public MissionDetail editarNota(UUID userId, UUID notaId, NoteRequest r) {
        MesaNote n = notas.findById(notaId)
                .orElseThrow(() -> ApiException.notFound("No existe esa nota."));
        MesaMission m = propia(userId, n.getMissionId());
        if (r != null) {
            if (r.kind() != null) n.setKind(tipoNotaDe(r.kind()));
            if (r.title() != null) n.setTitle(r.title().trim());
            if (r.body() != null) n.setBody(r.body().trim());
            n.setUpdatedAt(Instant.now());
            m.setUpdatedAt(Instant.now());
        }
        return detalle(m);
    }

    /** Subir o bajar un paso del guion. {@code arriba} = hacia el principio. */
    @Transactional
    public MissionDetail moverNota(UUID userId, UUID notaId, boolean arriba) {
        MesaNote n = notas.findById(notaId)
                .orElseThrow(() -> ApiException.notFound("No existe esa nota."));
        MesaMission m = propia(userId, n.getMissionId());

        List<MesaNote> lista = notas.findByMissionIdOrderByOrdinalAscCreatedAtAsc(n.getMissionId());
        int i = indiceDe(lista, notaId);
        int j = arriba ? i - 1 : i + 1;
        if (j >= 0 && j < lista.size()) {
            // Renumeramos entero: barato (son pocas) y deja los ordinales sanos
            // aunque vinieran repetidos de un borrado anterior.
            var a = lista.get(i);
            lista.set(i, lista.get(j));
            lista.set(j, a);
            for (int k = 0; k < lista.size(); k++) lista.get(k).setOrdinal(k);
            m.setUpdatedAt(Instant.now());
        }
        return detalle(m);
    }

    @Transactional
    public MissionDetail quitarNota(UUID userId, UUID notaId) {
        MesaNote n = notas.findById(notaId)
                .orElseThrow(() -> ApiException.notFound("No existe esa nota."));
        MesaMission m = propia(userId, n.getMissionId());
        notas.delete(n);
        m.setUpdatedAt(Instant.now());
        return detalle(m);
    }

    // ---------------------------------------------------------------- material

    /** La biblioteca entera del DM: lo suyo esté o no asignado a una misión. */
    @Transactional(readOnly = true)
    public List<AssetView> biblioteca(UUID userId) {
        return archivos.findByUserIdOrderByCreatedAtDesc(userId).stream().map(this::vista).toList();
    }

    /**
     * Sube un archivo. Si viene {@code misionId}, entra directo en esa misión;
     * si no, se queda en la biblioteca general.
     */
    @Transactional
    public AssetView subir(UUID userId, MultipartFile file, String misionId, String titulo) {
        UUID mision = null;
        if (misionId != null && !misionId.isBlank()) {
            mision = propia(userId, uuid(misionId, "misión")).getId();
        }

        String kind = armario.kindDe(file == null ? null : file.getContentType());
        String storageName = armario.guardar(file);

        MesaAsset a = new MesaAsset();
        a.setUserId(userId);
        a.setMissionId(mision);
        a.setKind(kind);
        a.setFilename(nombreLimpio(file.getOriginalFilename()));
        a.setTitle(titulo != null && !titulo.isBlank() ? titulo.trim() : sinExtension(a.getFilename()));
        a.setMime(file.getContentType());
        a.setSizeBytes(file.getSize());
        a.setStorageName(storageName);
        archivos.save(a);
        return vista(a);
    }

    /** Los bytes, para servirlos. Devuelve también el MIME y el nombre. */
    @Transactional(readOnly = true)
    public Descarga descargar(UUID userId, UUID assetId) {
        MesaAsset a = propio(userId, assetId);
        return new Descarga(armario.leer(a.getStorageName()), a.getMime(), a.getFilename());
    }

    /** Renombrar o mover de misión. {@code misionId} vacío = a la biblioteca. */
    @Transactional
    public AssetView editarArchivo(UUID userId, UUID assetId, AssetRequest r) {
        MesaAsset a = propio(userId, assetId);
        if (r != null) {
            if (r.title() != null && !r.title().isBlank()) a.setTitle(r.title().trim());
            if (r.misionId() != null) {
                if (r.misionId().isBlank()) {
                    soltarPortada(a);
                    a.setMissionId(null);
                } else {
                    UUID destino = propia(userId, uuid(r.misionId(), "misión")).getId();
                    if (!destino.equals(a.getMissionId())) soltarPortada(a);
                    a.setMissionId(destino);
                }
            }
        }
        return vista(a);
    }

    @Transactional
    public void borrarArchivo(UUID userId, UUID assetId) {
        MesaAsset a = propio(userId, assetId);
        soltarPortada(a);
        archivos.delete(a);
        armario.borrar(a.getStorageName());
    }

    public record Descarga(byte[] bytes, String mime, String filename) {}

    // ------------------------------------------------------------------ dentro

    private MesaView build(UUID userId) {
        List<MissionCard> tarjetas = misiones.findByUserIdOrderByOrdinalAscCreatedAtDesc(userId)
                .stream()
                .map(m -> {
                    var suyos = archivos.findByMissionIdOrderByCreatedAtAsc(m.getId());
                    int imgs = (int) suyos.stream().filter(a -> "imagen".equals(a.getKind())).count();
                    int pdfs = (int) suyos.stream().filter(a -> "pdf".equals(a.getKind())).count();
                    return new MissionCard(
                            m.getId().toString(), m.getTitle(), m.getSummary(), m.getStatus(),
                            etiquetas(m.getTags()),
                            m.getSessionDate() == null ? null : m.getSessionDate().toString(),
                            m.getCoverId() == null ? null : m.getCoverId().toString(),
                            imgs, pdfs, (int) notas.countByMissionId(m.getId()),
                            m.getUpdatedAt().toString());
                })
                // Lo que se va a jugar antes, primero; lo ya jugado, al final.
                .sorted(Comparator.comparingInt((MissionCard c) -> ESTADOS.indexOf(c.status()))
                        .thenComparing(c -> c.sessionDate() == null ? "9999" : c.sessionDate()))
                .toList();
        return new MesaView(tarjetas, ESTADOS);
    }

    private MissionDetail detalle(MesaMission m) {
        var guion = notas.findByMissionIdOrderByOrdinalAscCreatedAtAsc(m.getId()).stream()
                .map(n -> new NoteView(n.getId().toString(), n.getKind(), n.getTitle(),
                        n.getBody(), n.getOrdinal()))
                .toList();
        var material = archivos.findByMissionIdOrderByCreatedAtAsc(m.getId()).stream()
                .map(this::vista).toList();
        return new MissionDetail(
                m.getId().toString(), m.getTitle(), m.getSummary(), m.getStatus(),
                etiquetas(m.getTags()),
                m.getSessionDate() == null ? null : m.getSessionDate().toString(),
                m.getCoverId() == null ? null : m.getCoverId().toString(),
                m.getUpdatedAt().toString(), guion, material);
    }

    private AssetView vista(MesaAsset a) {
        return new AssetView(
                a.getId().toString(),
                a.getMissionId() == null ? null : a.getMissionId().toString(),
                a.getKind(), a.getTitle(), a.getFilename(), a.getMime(),
                a.getSizeBytes(), a.getCreatedAt().toString());
    }

    /** Si el archivo era la portada de su misión, la misión se queda sin ella. */
    private void soltarPortada(MesaAsset a) {
        if (a.getMissionId() == null) return;
        misiones.findById(a.getMissionId())
                .filter(m -> a.getId().equals(m.getCoverId()))
                .ifPresent(m -> m.setCoverId(null));
    }

    /** La portada tiene que ser una imagen y estar en esa misma misión. */
    private UUID portadaDe(UUID userId, UUID misionId, String coverId) {
        if (coverId.isBlank()) return null;
        MesaAsset a = propio(userId, uuid(coverId, "archivo"));
        if (!"imagen".equals(a.getKind()))
            throw ApiException.badRequest("La portada tiene que ser una imagen.");
        if (!misionId.equals(a.getMissionId()))
            throw ApiException.badRequest("Esa imagen no está en esta misión.");
        return a.getId();
    }

    private MesaMission propia(UUID userId, UUID misionId) {
        MesaMission m = misiones.findById(misionId)
                .orElseThrow(() -> ApiException.notFound("No existe esa misión."));
        if (!m.getUserId().equals(userId))
            throw ApiException.forbidden("Esa misión no es tuya.");
        return m;
    }

    private MesaAsset propio(UUID userId, UUID assetId) {
        MesaAsset a = archivos.findById(assetId)
                .orElseThrow(() -> ApiException.notFound("No existe ese archivo."));
        if (!a.getUserId().equals(userId))
            throw ApiException.forbidden("Ese archivo no es tuyo.");
        return a;
    }

    private int siguienteOrdinal(UUID userId) {
        return misiones.findByUserIdOrderByOrdinalAscCreatedAtDesc(userId).stream()
                .mapToInt(MesaMission::getOrdinal).max().orElse(-1) + 1;
    }

    private static int indiceDe(List<MesaNote> lista, UUID id) {
        for (int i = 0; i < lista.size(); i++) if (lista.get(i).getId().equals(id)) return i;
        return -1;
    }

    private static List<String> etiquetas(String tags) {
        if (tags == null || tags.isBlank()) return List.of();
        return Arrays.stream(tags.split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }

    private static String texto(String s) { return s == null ? "" : s.trim(); }

    private String estadoDe(String s) {
        String v = s == null ? "" : s.trim().toLowerCase();
        return ESTADOS.contains(v) ? v : "idea";
    }

    private String tipoNotaDe(String s) {
        String v = s == null ? "" : s.trim().toLowerCase();
        return TIPOS_NOTA.contains(v) ? v : "nota";
    }

    private static LocalDate fechaDe(String s) {
        if (s == null || s.isBlank()) return null;
        try {
            return LocalDate.parse(s.trim());
        } catch (DateTimeParseException e) {
            throw ApiException.badRequest("La fecha tiene que ser AAAA-MM-DD.");
        }
    }

    private static UUID uuid(String s, String que) {
        try {
            return UUID.fromString(s.trim());
        } catch (IllegalArgumentException e) {
            throw ApiException.badRequest("Identificador de " + que + " inválido.");
        }
    }

    /** Quita rutas del nombre que mandó el navegador: solo es para mostrar. */
    private static String nombreLimpio(String original) {
        if (original == null || original.isBlank()) return "archivo";
        String n = original.replace('\\', '/');
        n = n.substring(n.lastIndexOf('/') + 1);
        return n.isBlank() ? "archivo" : n;
    }

    private static String sinExtension(String filename) {
        int p = filename.lastIndexOf('.');
        return p > 0 ? filename.substring(0, p) : filename;
    }
}
