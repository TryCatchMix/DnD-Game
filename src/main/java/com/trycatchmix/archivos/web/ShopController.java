package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.ShopService;
import com.trycatchmix.archivos.web.dto.ShopDtos.ShopOfferCreateRequest;
import com.trycatchmix.archivos.web.dto.ShopDtos.ShopView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/** La tienda (pantalla 06). Comprar y vender devuelven la vista entera ya
 *  actualizada, así el frontend solo tiene que repintar. */
@RestController
@RequestMapping("/api/personajes/{charId}/tienda")
@RequiredArgsConstructor
public class ShopController {

    private final ShopService shop;

    @GetMapping
    public ShopView tienda(@AuthenticationPrincipal AuthPrincipal p, @PathVariable UUID charId) {
        return shop.tienda(user(p), charId);
    }

    @PostMapping("/comprar/{itemCode}")
    public ShopView comprar(@AuthenticationPrincipal AuthPrincipal p,
                            @PathVariable UUID charId, @PathVariable String itemCode) {
        return shop.comprar(user(p), charId, itemCode);
    }

    @PostMapping("/vender/{itemCode}")
    public ShopView vender(@AuthenticationPrincipal AuthPrincipal p,
                           @PathVariable UUID charId, @PathVariable String itemCode) {
        return shop.vender(user(p), charId, itemCode);
    }

    /** El DM pone algo a la venta en la ciudad de este personaje. */
    @PostMapping("/ofertas")
    @PreAuthorize("hasRole('DM')")
    public ShopView crearOferta(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID charId,
                                @RequestBody ShopOfferCreateRequest req) {
        user(p);
        return shop.crearOferta(charId, req);
    }

    /** El DM retira una oferta del mostrador de esta ciudad. */
    @DeleteMapping("/ofertas/{itemCode}")
    @PreAuthorize("hasRole('DM')")
    public ShopView quitarOferta(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId, @PathVariable String itemCode) {
        user(p);
        return shop.quitarOferta(charId, itemCode);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
