package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignAccess;
import com.trycatchmix.archivos.service.MesaService;
import com.trycatchmix.archivos.web.dto.MesaDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

/**
 * La Mesa: el escritorio donde se prepara una campaña. Cuelga de la campaña
 * porque lo que hay dentro es suyo: el guion, los mapas y los PDF de una
 * partida no pintan nada en otra.
 *
 *   GET    …/mesa/misiones                 -> rejilla de tarjetas
 *   POST   …/mesa/misiones                 -> crear
 *   GET    …/mesa/misiones/{id}            -> detalle (guion + material)
 *   PUT    …/mesa/misiones/{id}            -> editar
 *   DELETE …/mesa/misiones/{id}            -> borrar (el material se queda)
 *
 *   POST   …/mesa/misiones/{id}/notas      -> añadir paso al guion
 *   PUT    …/mesa/notas/{id}               -> editar paso
 *   POST   …/mesa/notas/{id}/mover?arriba= -> reordenar
 *   DELETE …/mesa/notas/{id}               -> quitar paso
 *
 *   GET    …/mesa/archivos                 -> la biblioteca entera
 *   POST   …/mesa/archivos                 -> subir (multipart)
 *   GET    …/mesa/archivos/{id}/contenido  -> los bytes
 *   PUT    …/mesa/archivos/{id}            -> renombrar / mover de misión
 *   DELETE …/mesa/archivos/{id}            -> borrar
 *
 * El permiso ya no es {@code hasRole('DM')} —eso hacía máster a alguien en
 * todas las mesas a la vez—, sino dirigir ESTA campaña: cada método empieza
 * por {@link #dm}, que resuelve la campaña y comprueba la membresía.
 *
 * Las operaciones sobre una misión devuelven el detalle entero ya actualizado,
 * como hace el bloc de notas: el frontend solo repinta.
 */
@RestController
@RequestMapping("/api/campanas/{campanaId}/mesa")
@RequiredArgsConstructor
public class MesaController {

    private final MesaService mesa;
    private final CampaignAccess access;

    // -------------------------------------------------------------- misiones

    @GetMapping("/misiones")
    public MesaView listar(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID campanaId) {
        return mesa.listar(dm(p, campanaId));
    }

    @PostMapping("/misiones")
    public MissionDetail crear(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID campanaId,
                               @RequestBody MissionRequest req) {
        return mesa.crear(user(p), dm(p, campanaId), req);
    }

    @GetMapping("/misiones/{misionId}")
    public MissionDetail abrir(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID campanaId,
                               @PathVariable UUID misionId) {
        return mesa.abrir(dm(p, campanaId), misionId);
    }

    @PutMapping("/misiones/{misionId}")
    public MissionDetail editar(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID campanaId,
                                @PathVariable UUID misionId,
                                @RequestBody MissionRequest req) {
        return mesa.editar(dm(p, campanaId), misionId, req);
    }

    @DeleteMapping("/misiones/{misionId}")
    public MesaView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                             @PathVariable UUID campanaId,
                             @PathVariable UUID misionId) {
        return mesa.eliminar(dm(p, campanaId), misionId);
    }

    // ----------------------------------------------------------------- guion

    @PostMapping("/misiones/{misionId}/notas")
    public MissionDetail anadirNota(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID campanaId,
                                    @PathVariable UUID misionId,
                                    @RequestBody NoteRequest req) {
        return mesa.anadirNota(dm(p, campanaId), misionId, req);
    }

    @PutMapping("/notas/{notaId}")
    public MissionDetail editarNota(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID campanaId,
                                    @PathVariable UUID notaId,
                                    @RequestBody NoteRequest req) {
        return mesa.editarNota(dm(p, campanaId), notaId, req);
    }

    @PostMapping("/notas/{notaId}/mover")
    public MissionDetail moverNota(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID campanaId,
                                   @PathVariable UUID notaId,
                                   @RequestParam(defaultValue = "true") boolean arriba) {
        return mesa.moverNota(dm(p, campanaId), notaId, arriba);
    }

    @DeleteMapping("/notas/{notaId}")
    public MissionDetail quitarNota(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID campanaId,
                                    @PathVariable UUID notaId) {
        return mesa.quitarNota(dm(p, campanaId), notaId);
    }

    // -------------------------------------------------------------- material

    @GetMapping("/archivos")
    public List<AssetView> biblioteca(@AuthenticationPrincipal AuthPrincipal p,
                                      @PathVariable UUID campanaId) {
        return mesa.biblioteca(dm(p, campanaId));
    }

    /** Buscar dentro del texto de los PDF, no solo por el título. */
    @GetMapping("/buscar")
    public List<AssetHit> buscar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID campanaId,
                                 @RequestParam(defaultValue = "") String q) {
        return mesa.buscar(dm(p, campanaId), q);
    }

    /** Indexar los PDF viejos que se subieron antes de la búsqueda por contenido. */
    @PostMapping("/archivos/reindexar")
    public int reindexar(@AuthenticationPrincipal AuthPrincipal p,
                         @PathVariable UUID campanaId) {
        return mesa.reindexar(dm(p, campanaId));
    }

    @PostMapping(value = "/archivos", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public AssetView subir(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID campanaId,
                           @RequestPart("archivo") MultipartFile archivo,
                           @RequestParam(required = false) String misionId,
                           @RequestParam(required = false) String titulo) {
        return mesa.subir(user(p), dm(p, campanaId), archivo, misionId, titulo);
    }

    /**
     * Los bytes del archivo. Va con Bearer como todo lo demás, así que el
     * frontend lo pide con HttpClient y lo pinta con un object URL: no se puede
     * poner esta ruta directamente en un &lt;img src&gt;.
     */
    @GetMapping("/archivos/{assetId}/contenido")
    public ResponseEntity<Resource> contenido(@AuthenticationPrincipal AuthPrincipal p,
                                              @PathVariable UUID campanaId,
                                              @PathVariable UUID assetId) {
        var d = mesa.descargar(dm(p, campanaId), assetId);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(d.mime()))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        ContentDisposition.inline().filename(d.filename()).build().toString())
                .header(HttpHeaders.CACHE_CONTROL, "private, max-age=3600")
                .body(new ByteArrayResource(d.bytes()));
    }

    @PutMapping("/archivos/{assetId}")
    public AssetView editarArchivo(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID campanaId,
                                   @PathVariable UUID assetId,
                                   @RequestBody AssetRequest req) {
        return mesa.editarArchivo(dm(p, campanaId), assetId, req);
    }

    @DeleteMapping("/archivos/{assetId}")
    public ResponseEntity<Void> borrarArchivo(@AuthenticationPrincipal AuthPrincipal p,
                                              @PathVariable UUID campanaId,
                                              @PathVariable UUID assetId) {
        mesa.borrarArchivo(dm(p, campanaId), assetId);
        return ResponseEntity.noContent().build();
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    /** La campaña, tras comprobar que quien pregunta la dirige. */
    private UUID dm(AuthPrincipal p, UUID campanaId) {
        return access.exigeDm(user(p), campanaId).getId();
    }
}
