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
 * La tienda (pantalla 06). Comprar y vender devuelven la vista entera ya
 * actualizada, así el frontend solo tiene que repintar.
 *
 * La ruta sigue colgando del personaje porque el monedero y la bolsa son suyos;
 * el mostrador que ve sale de la campaña en la que juega. Quién puede tocar qué
 * lo decide el servicio contra la membresía, no el rol de la cuenta: por eso
 * aquí ya no hay ningún {@code @PreAuthorize}.
 */
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

    /** El máster de la campaña de este personaje pone algo a la venta. */
    @PostMapping("/ofertas")
    public ShopView crearOferta(@AuthenticationPrincipal AuthPrincipal p,
                                @PathVariable UUID charId,
                                @RequestBody ShopOfferCreateRequest req) {
        return shop.crearOferta(user(p), charId, req);
    }

    /** El máster retira una oferta del mostrador de su campaña. */
    @DeleteMapping("/ofertas/{itemCode}")
    public ShopView quitarOferta(@AuthenticationPrincipal AuthPrincipal p,
                                 @PathVariable UUID charId, @PathVariable String itemCode) {
        return shop.quitarOferta(user(p), charId, itemCode);
    }

    private UUID user(AuthPrincipal p) {
        if (p == null) throw ApiException.sessionExpired();
        return p.userId();
    }
}
