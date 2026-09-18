package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.security.AuthPrincipal;
import com.trycatchmix.archivos.service.ShopService;
import com.trycatchmix.archivos.web.dto.ShopDtos.ShopOfferCreateRequest;
import com.trycatchmix.archivos.web.dto.ShopDtos.ShopView;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * La trastienda de una campaña, para su máster, sin pasar por un personaje.
 *
 *   GET    /api/campanas/{id}/tienda                    -> el mostrador (DM)
 *   POST   /api/campanas/{id}/tienda/ofertas            -> poner algo a la venta (DM)
 *   DELETE /api/campanas/{id}/tienda/ofertas/{itemCode} -> retirarlo (DM)
 *
 * La tienda del jugador sigue en {@link ShopController}, colgada del personaje
 * porque compra con su monedero. Esta existe porque el máster no suele tener
 * personaje en su propia mesa, y porque si dirige varias tiene que poder
 * elegir cuál está surtiendo.
 */
@RestController
@RequestMapping("/api/campanas/{campanaId}/tienda")
@RequiredArgsConstructor
public class CampaignShopController {

    private final ShopService shop;

    @GetMapping
    public ShopView mostrador(@AuthenticationPrincipal AuthPrincipal p, @PathVariable UUID campanaId) {
        return shop.mostrador(user(p), campanaId);
    }

    @PostMapping("/ofertas")
    public ShopView crearOferta(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID campanaId,
                                @RequestBody ShopOfferCreateRequest req) {
        return shop.crearOfertaEnCampana(user(p), campanaId, req);
    }

    @DeleteMapping("/ofertas/{itemCode}")
    public ShopView quitarOferta(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID campanaId, @PathVariable String itemCode) {
        return shop.quitarOfertaEnCampana(user(p), campanaId, itemCode);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
