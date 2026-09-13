package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.ElencoService;
import com.trycatchmix.archivos.web.dto.ElencoDtos.SueltosView;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * EL ELENCO SUELTO: las fichas que se quedaron sin mesa.
 *
 *   GET    /api/elenco-suelto                 -> las mías
 *   DELETE /api/elenco-suelto/{id}            -> tirar una para siempre
 *   GET    /api/elenco-suelto/{id}/retrato    -> los bytes de su cara
 *
 * Cuelga de la cuenta y no de una campaña porque eso es exactamente lo que le
 * pasa a estas fichas: borrar la mesa ya no las borra (ver V32), se quedan
 * sueltas y siguen siendo de quien las escribió hasta que las trae a otra
 * partida con {@code POST /api/campanas/{id}/elenco/traer}.
 *
 * El permiso aquí no lo da la campaña —no hay— sino la autoría: el servicio
 * comprueba en cada operación que la ficha no tiene mesa y que es tuya.
 */
@RestController
@RequestMapping("/api/elenco-suelto")
@RequiredArgsConstructor
public class ElencoSueltoController {

    private final ElencoService elenco;

    @GetMapping
    public SueltosView mios(@AuthenticationPrincipal AuthPrincipal p) {
        return elenco.sueltos(user(p));
    }

    @DeleteMapping("/{npcId}")
    public SueltosView descartar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID npcId) {
        return elenco.descartar(user(p), npcId);
    }

    /**
     * La cara, para poder elegir por el retrato y no por el nombre. Sin
     * comprobación de sellos: aquí no hay mesa que haya descubierto nada y
     * quien pide la foto es quien la subió.
     */
    @GetMapping("/{npcId}/retrato")
    public ResponseEntity<Resource> retrato(@AuthenticationPrincipal AuthPrincipal p,
                                            @PathVariable UUID npcId) {
        var d = elenco.retratoSuelto(user(p), npcId);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(d.mime()))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        ContentDisposition.inline().filename(d.filename()).build().toString())
                .header(HttpHeaders.CACHE_CONTROL, "private, max-age=3600")
                .body(new ByteArrayResource(d.bytes()));
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
