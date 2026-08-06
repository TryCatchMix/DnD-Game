package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.ChronicleService;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleCreateRequest;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * La crónica del clan (pantalla 07). La lee todo el mundo; revelar verdades
 * selladas y anotar entradas nuevas es cosa del clan de Los Archivos: el DM.
 */
@RestController
@RequestMapping("/api/cronica")
@RequiredArgsConstructor
public class ChronicleController {

    private final ChronicleService chronicle;

    @GetMapping
    public List<ChronicleView> cronica(@AuthenticationPrincipal AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return chronicle.cronica("DM".equals(p.role()));
    }

    @PostMapping("/{id}/revelar")
    @PreAuthorize("hasRole('DM')")
    public List<ChronicleView> revelar(@PathVariable UUID id) {
        return chronicle.revelar(id);
    }

    @PostMapping
    @PreAuthorize("hasRole('DM')")
    public List<ChronicleView> anotar(@RequestBody ChronicleCreateRequest req) {
        return chronicle.anotar(req);
    }
}
