package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignAccess;
import com.trycatchmix.archivos.service.ElencoService;
import com.trycatchmix.archivos.web.dto.ElencoDtos.ElencoView;
import com.trycatchmix.archivos.web.dto.ElencoDtos.NpcRequest;
import com.trycatchmix.archivos.web.dto.ElencoDtos.RelationRequest;
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

import java.util.UUID;

/**
 * EL ELENCO de una campaña: quién ha ido saliendo y qué se sabe de cada uno.
 *
 *   GET    …/elenco                          -> el elenco, filtrado por quien mira
 *   POST   …/elenco                          -> crear una ficha (máster)
 *   PUT    …/elenco/{id}                     -> editarla
 *   DELETE …/elenco/{id}                     -> borrarla
 *   POST   …/elenco/{id}/mover?arriba=       -> reordenar
 *   POST   …/elenco/{id}/revelar?campo=      -> destapar o sellar UN campo
 *   POST   …/elenco/{id}/revelar-todo        -> destaparlo entero
 *   POST   …/elenco/{id}/retrato             -> subir la foto (multipart)
 *   DELETE …/elenco/{id}/retrato             -> quitarla
 *   GET    …/elenco/{id}/retrato             -> los bytes de la foto
 *   POST   …/elenco/{id}/tratos              -> añadir una relación
 *   PUT    …/elenco/tratos/{id}              -> editarla
 *   DELETE …/elenco/tratos/{id}              -> quitarla
 *
 * Dos permisos y la diferencia está en la primera línea de cada método:
 * escribir es de quien dirige la mesa ({@link #dm}), y mirar basta con estar
 * en ella ({@link #miembro}). Lo que el jugador no ha descubierto no se le
 * manda —ni el texto ni los bytes del retrato—, y de eso se ocupa
 * {@link ElencoService}, que es quien sabe qué está sellado.
 *
 * Todas las operaciones devuelven el elenco entero ya actualizado, como el
 * bloc de notas: el frontend solo repinta.
 */
@RestController
@RequestMapping("/api/campanas/{campanaId}/elenco")
@RequiredArgsConstructor
public class ElencoController {

    private final ElencoService elenco;
    private final CampaignAccess access;

    // ------------------------------------------------------------- consultar

    @GetMapping
    public ElencoView listar(@AuthenticationPrincipal AuthPrincipal p,
                             @PathVariable UUID campanaId) {
        UUID campana = miembro(p, campanaId);
        return elenco.listar(campana, access.esDm(user(p), campana));
    }

    // ---------------------------------------------------------------- fichas

    @PostMapping
    public ElencoView crear(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId,
                            @RequestBody NpcRequest req) {
        return elenco.crear(user(p), dm(p, campanaId), req);
    }

    @PutMapping("/{npcId}")
    public ElencoView editar(@AuthenticationPrincipal AuthPrincipal p,
                             @PathVariable UUID campanaId,
                             @PathVariable UUID npcId,
                             @RequestBody NpcRequest req) {
        return elenco.editar(dm(p, campanaId), npcId, req);
    }

    @DeleteMapping("/{npcId}")
    public ElencoView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID campanaId,
                               @PathVariable UUID npcId) {
        return elenco.eliminar(dm(p, campanaId), npcId);
    }

    @PostMapping("/{npcId}/mover")
    public ElencoView mover(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID campanaId,
                            @PathVariable UUID npcId,
                            @RequestParam(defaultValue = "true") boolean arriba) {
        return elenco.mover(dm(p, campanaId), npcId, arriba);
    }

    // --------------------------------------------------------------- revelar

    /**
     * Destapar o sellar un campo suelto. Sin {@code valor} alterna, que es lo
     * que hace el botón del ojo en la ficha.
     */
    @PostMapping("/{npcId}/revelar")
    public ElencoView revelar(@AuthenticationPrincipal AuthPrincipal p,
                              @PathVariable UUID campanaId,
                              @PathVariable UUID npcId,
                              @RequestParam String campo,
                              @RequestParam(required = false) Boolean valor) {
        return elenco.revelar(dm(p, campanaId), npcId, campo, valor);
    }

    @PostMapping("/{npcId}/revelar-todo")
    public ElencoView revelarTodo(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId,
                                  @PathVariable UUID npcId) {
        return elenco.revelarTodo(dm(p, campanaId), npcId);
    }

    // --------------------------------------------------------------- retrato

    @PostMapping(value = "/{npcId}/retrato", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ElencoView subirRetrato(@AuthenticationPrincipal AuthPrincipal p,
                                   @PathVariable UUID campanaId,
                                   @PathVariable UUID npcId,
                                   @RequestPart("archivo") MultipartFile archivo) {
        return elenco.subirRetrato(user(p), dm(p, campanaId), npcId, archivo);
    }

    @DeleteMapping("/{npcId}/retrato")
    public ElencoView quitarRetrato(@AuthenticationPrincipal AuthPrincipal p,
                                    @PathVariable UUID campanaId,
                                    @PathVariable UUID npcId) {
        return elenco.quitarRetrato(dm(p, campanaId), npcId);
    }

    /**
     * Los bytes del retrato. Entra cualquier miembro, pero el servicio devuelve
     * 403 si esa cara todavía no se ha descubierto: la comprobación va aquí
     * abajo y no en la interfaz, porque adivinar esta ruta es trivial.
     *
     * Va con Bearer como el resto de la API, así que el frontend lo baja con
     * HttpClient y lo pinta con un object URL; no vale para un &lt;img src&gt;.
     */
    @GetMapping("/{npcId}/retrato")
    public ResponseEntity<Resource> retrato(@AuthenticationPrincipal AuthPrincipal p,
                                            @PathVariable UUID campanaId,
                                            @PathVariable UUID npcId) {
        UUID campana = miembro(p, campanaId);
        var d = elenco.retrato(campana, npcId, access.esDm(user(p), campana));
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(d.mime()))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        ContentDisposition.inline().filename(d.filename()).build().toString())
                .header(HttpHeaders.CACHE_CONTROL, "private, max-age=3600")
                .body(new ByteArrayResource(d.bytes()));
    }

    // ------------------------------------------------------------- relaciones

    @PostMapping("/{npcId}/tratos")
    public ElencoView anadirTrato(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId,
                                  @PathVariable UUID npcId,
                                  @RequestBody RelationRequest req) {
        return elenco.anadirRelacion(dm(p, campanaId), npcId, req);
    }

    @PutMapping("/tratos/{tratoId}")
    public ElencoView editarTrato(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId,
                                  @PathVariable UUID tratoId,
                                  @RequestBody RelationRequest req) {
        return elenco.editarRelacion(dm(p, campanaId), tratoId, req);
    }

    @DeleteMapping("/tratos/{tratoId}")
    public ElencoView quitarTrato(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID campanaId,
                                  @PathVariable UUID tratoId) {
        return elenco.quitarRelacion(dm(p, campanaId), tratoId);
    }

    // -------------------------------------------------------------- permisos

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    /** Mirar el elenco: basta con estar en la mesa. */
    private UUID miembro(AuthPrincipal p, UUID campanaId) {
        return access.exigeMiembro(user(p), campanaId).getId();
    }

    /** Escribirlo: hay que dirigirla. */
    private UUID dm(AuthPrincipal p, UUID campanaId) {
        return access.exigeDm(user(p), campanaId).getId();
    }
}
