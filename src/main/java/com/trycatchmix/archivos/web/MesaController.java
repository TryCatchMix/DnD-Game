package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.MesaService;
import com.trycatchmix.archivos.web.dto.MesaDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

/**
 * La Mesa: el escritorio donde el DM prepara las partidas. Solo rol DM.
 *
 *   GET    /api/mesa/misiones                 -> rejilla de tarjetas
 *   POST   /api/mesa/misiones                 -> crear
 *   GET    /api/mesa/misiones/{id}            -> detalle (guion + material)
 *   PUT    /api/mesa/misiones/{id}            -> editar
 *   DELETE /api/mesa/misiones/{id}            -> borrar (el material se queda)
 *
 *   POST   /api/mesa/misiones/{id}/notas      -> añadir paso al guion
 *   PUT    /api/mesa/notas/{id}               -> editar paso
 *   POST   /api/mesa/notas/{id}/mover?arriba= -> reordenar
 *   DELETE /api/mesa/notas/{id}               -> quitar paso
 *
 *   GET    /api/mesa/archivos                 -> la biblioteca entera
 *   POST   /api/mesa/archivos                 -> subir (multipart)
 *   GET    /api/mesa/archivos/{id}/contenido  -> los bytes
 *   PUT    /api/mesa/archivos/{id}            -> renombrar / mover de misión
 *   DELETE /api/mesa/archivos/{id}            -> borrar
 *
 * Las operaciones sobre una misión devuelven el detalle entero ya actualizado,
 * como hace el bloc de notas: el frontend solo repinta.
 */
@RestController
@RequestMapping("/api/mesa")
@PreAuthorize("hasRole('DM')")
@RequiredArgsConstructor
public class MesaController {

    private final MesaService mesa;

    // -------------------------------------------------------------- misiones

    @GetMapping("/misiones")
    public MesaView listar(@AuthenticationPrincipal AuthPrincipal p) {
        return mesa.listar(user(p));
    }

    @PostMapping("/misiones")
    public MissionDetail crear(@AuthenticationPrincipal AuthPrincipal p,
                               @RequestBody MissionRequest req) {
        return mesa.crear(user(p), req);
    }

    @GetMapping("/misiones/{misionId}")
    public MissionDetail abrir(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID misionId) {
        return mesa.abrir(user(p), misionId);
    }

    @PutMapping("/misiones/{misionId}")
    public MissionDetail editar(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID misionId,
                                @RequestBody MissionRequest req) {
        return mesa.editar(user(p), misionId, req);
    }

    @DeleteMapping("/misiones/{misionId}")
    public MesaView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                             @PathVariable UUID misionId) {
        return mesa.eliminar(user(p), misionId);
    }

    // ----------------------------------------------------------------- guion

    @PostMapping("/misiones/{misionId}/notas")
    public MissionDetail anadirNota(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID misionId,
                                    @RequestBody NoteRequest req) {
        return mesa.anadirNota(user(p), misionId, req);
    }

    @PutMapping("/notas/{notaId}")
    public MissionDetail editarNota(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID notaId,
                                    @RequestBody NoteRequest req) {
        return mesa.editarNota(user(p), notaId, req);
    }

    @PostMapping("/notas/{notaId}/mover")
    public MissionDetail moverNota(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID notaId,
                                   @RequestParam(defaultValue = "true") boolean arriba) {
        return mesa.moverNota(user(p), notaId, arriba);
    }

    @DeleteMapping("/notas/{notaId}")
    public MissionDetail quitarNota(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID notaId) {
        return mesa.quitarNota(user(p), notaId);
    }

    // -------------------------------------------------------------- material

    @GetMapping("/archivos")
    public List<AssetView> biblioteca(@AuthenticationPrincipal AuthPrincipal p) {
        return mesa.biblioteca(user(p));
    }

    /** Buscar dentro del texto de los PDF, no solo por el título. */
    @GetMapping("/buscar")
    public List<AssetHit> buscar(@AuthenticationPrincipal AuthPrincipal p,
                                 @RequestParam(defaultValue = "") String q) {
        return mesa.buscar(user(p), q);
    }

    /** Indexar los PDF viejos que se subieron antes de la búsqueda por contenido. */
    @PostMapping("/archivos/reindexar")
    public int reindexar(@AuthenticationPrincipal AuthPrincipal p) {
        return mesa.reindexar(user(p));
    }

    @PostMapping(value = "/archivos", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public AssetView subir(@AuthenticationPrincipal AuthPrincipal p,
                           @RequestPart("archivo") MultipartFile archivo,
                           @RequestParam(required = false) String misionId,
                           @RequestParam(required = false) String titulo) {
        return mesa.subir(user(p), archivo, misionId, titulo);
    }

    /**
     * Los bytes del archivo. Va con Bearer como todo lo demás, así que el
     * frontend lo pide con HttpClient y lo pinta con un object URL: no se puede
     * poner esta ruta directamente en un &lt;img src&gt;.
     */
    @GetMapping("/archivos/{assetId}/contenido")
    public ResponseEntity<Resource> contenido(@AuthenticationPrincipal AuthPrincipal p,
                                              @PathVariable UUID assetId) {
        var d = mesa.descargar(user(p), assetId);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(d.mime()))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        ContentDisposition.inline().filename(d.filename()).build().toString())
                .header(HttpHeaders.CACHE_CONTROL, "private, max-age=3600")
                .body(new ByteArrayResource(d.bytes()));
    }

    @PutMapping("/archivos/{assetId}")
    public AssetView editarArchivo(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID assetId,
                                   @RequestBody AssetRequest req) {
        return mesa.editarArchivo(user(p), assetId, req);
    }

    @DeleteMapping("/archivos/{assetId}")
    public ResponseEntity<Void> borrarArchivo(@AuthenticationPrincipal AuthPrincipal p,
                                              @PathVariable UUID assetId) {
        mesa.borrarArchivo(user(p), assetId);
        return ResponseEntity.noContent().build();
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
