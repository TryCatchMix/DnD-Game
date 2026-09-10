package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.CampaignAccess;
import com.trycatchmix.archivos.service.ChronicleService;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleCreateRequest;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleUpdateRequest;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * La crónica del clan (pantalla 07). La lee todo el mundo; revelar verdades
 * selladas y anotar entradas nuevas es cosa del clan de Los Archivos: el máster.
 *
 * LA CRÓNICA NO SE PARTE POR CAMPAÑAS, y es a propósito: es la historia del
 * mundo, como el bestiario o el grimorio. Lo que cambia de una mesa a otra es
 * lo que se juega en ella, no en qué año se agrietó el cielo.
 *
 * Sí cambia quién puede escribirla. Ya no vale «tener el rol DM en la cuenta»,
 * porque el papel de máster es de cada campaña: escribe quien dirija al menos
 * una mesa. Un jugador que abre su campaña se convierte en archivista; uno que
 * solo juega, no.
 */
@RestController
@RequestMapping("/api/cronica")
@RequiredArgsConstructor
public class ChronicleController {

    private final ChronicleService chronicle;
    private final CampaignAccess access;

    @GetMapping
    public List<ChronicleView> cronica(@AuthenticationPrincipal AuthPrincipal p) {
        return chronicle.cronica(dirigeAlgo(user(p)));
    }

    @PostMapping("/{id}/revelar")
    public List<ChronicleView> revelar(@AuthenticationPrincipal AuthPrincipal p,
                                       @PathVariable UUID id) {
        exigeMaster(p);
        return chronicle.revelar(id);
    }

    @PostMapping
    public List<ChronicleView> anotar(@AuthenticationPrincipal AuthPrincipal p,
                                      @RequestBody ChronicleCreateRequest req) {
        exigeMaster(p);
        return chronicle.anotar(req);
    }

    // === Panel de administración (solo quien dirija alguna campaña) =========
    // Devuelven la lista SIN censurar, para poder gestionar hasta lo sellado.

    @GetMapping("/admin")
    public List<ChronicleView> listaAdmin(@AuthenticationPrincipal AuthPrincipal p) {
        exigeMaster(p);
        return chronicle.cronicaAdmin();
    }

    @PostMapping("/admin")
    public List<ChronicleView> crear(@AuthenticationPrincipal AuthPrincipal p,
                                     @RequestBody ChronicleCreateRequest req) {
        exigeMaster(p);
        return chronicle.crearAdmin(req);
    }

    @PutMapping("/admin/{id}")
    public List<ChronicleView> editar(@AuthenticationPrincipal AuthPrincipal p,
                                      @PathVariable UUID id,
                                      @RequestBody ChronicleUpdateRequest req) {
        exigeMaster(p);
        return chronicle.editar(id, req);
    }

    @DeleteMapping("/admin/{id}")
    public List<ChronicleView> eliminar(@AuthenticationPrincipal AuthPrincipal p,
                                        @PathVariable UUID id) {
        exigeMaster(p);
        return chronicle.eliminar(id);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }

    private boolean dirigeAlgo(UUID userId) {
        return !access.campanasQueDirige(userId).isEmpty();
    }

    private void exigeMaster(AuthPrincipal p) {
        if (!dirigeAlgo(user(p)))
            throw ApiException.forbidden("Esto lo escribe quien dirige una campaña.");
    }
}
