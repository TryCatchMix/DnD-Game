package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.InventoryService;
import com.trycatchmix.archivos.web.dto.InventoryDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/** La bolsa del personaje: ver, añadir a mano, ajustar cantidad y tirar cosas. */
@RestController
@RequestMapping("/api/personajes/{charId}/inventario")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryService inventory;

    @GetMapping
    public InventoryView inventario(@AuthenticationPrincipal AuthPrincipal p, @PathVariable UUID charId) {
        return inventory.inventario(user(p), charId);
    }

    @PostMapping
    public InventoryView anadir(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID charId, @RequestBody AddItemRequest req) {
        return inventory.anadir(user(p), charId, req);
    }

    @PatchMapping("/{entryId}")
    public InventoryView fijar(@AuthenticationPrincipal AuthPrincipal p,
                               @PathVariable UUID charId, @PathVariable UUID entryId,
                               @RequestBody SetQuantityRequest req) {
        return inventory.fijarCantidad(user(p), charId, entryId, req.quantity());
    }

    /** Ponerse o quitarse un objeto. `puesto=false` lo desequipa. */
    @PostMapping("/{entryId}/equipar")
    public InventoryView equipar(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId, @PathVariable UUID entryId,
                                 @RequestParam(defaultValue = "true") boolean puesto) {
        return inventory.equipar(user(p), charId, entryId, puesto);
    }

    @DeleteMapping("/{entryId}")
    public InventoryView eliminar(@AuthenticationPrincipal AuthPrincipal p,
                                  @PathVariable UUID charId, @PathVariable UUID entryId) {
        return inventory.eliminar(user(p), charId, entryId);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
