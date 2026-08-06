package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.Property;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.GameCharacterRepository;
import com.trycatchmix.archivos.repo.PropertyRepository;
import com.trycatchmix.archivos.web.dto.PropertyDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * El juego de propiedades: comprar, recaudar la renta acumulada, mejorar de
 * nivel y vender. Todo el dinero sale y entra del monedero del personaje
 * (purseCp). La renta se acumula sola con el tiempo real transcurrido desde la
 * última recaudación, con un tope para que una propiedad abandonada no genere
 * una fortuna.
 */
@Service
@RequiredArgsConstructor
public class PropertyService {

    /** Tope de días que puede acumular una propiedad sin recaudar. */
    private static final double MAX_DIAS_ACUMULADOS = 30.0;
    private static final double SEGUNDOS_POR_DIA = 86_400.0;

    private final PropertyRepository properties;
    private final GameCharacterRepository characters;

    @Transactional(readOnly = true)
    public HoldingsView holdings(UUID userId, UUID charId, boolean admin) {
        return build(accessibleCharacter(userId, charId, admin));
    }

    @Transactional
    public HoldingsView comprar(UUID userId, UUID charId, boolean admin, BuyRequest req) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        PropertyKind kind = PropertyKind.fromCode(req.kind());

        String nombre = req.name() == null ? "" : req.name().trim();
        if (nombre.isBlank()) nombre = kind.nombre();       // por defecto, el tipo
        if (nombre.length() > 80) nombre = nombre.substring(0, 80);

        if (c.getPurseCp() < kind.basePriceCp())
            throw ApiException.conflict("No te llega el dinero para comprar eso.");

        c.setPurseCp(c.getPurseCp() - kind.basePriceCp());

        Property p = new Property();
        p.setCharacterId(c.getId());
        p.setKind(kind.code());
        p.setName(nombre);
        p.setLevel(1);
        p.setCity(c.getCity() == null ? "" : c.getCity());
        p.setPurchasedAt(Instant.now());
        p.setLastCollectedAt(Instant.now());
        properties.save(p);

        return build(c);
    }

    @Transactional
    public HoldingsView mejorar(UUID userId, UUID charId, boolean admin, UUID propId) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        Property p = ownedProperty(c, propId);
        PropertyKind kind = PropertyKind.fromCode(p.getKind());

        Long coste = kind.upgradeCostCp(p.getLevel());
        if (coste == null)
            throw ApiException.conflict("Ya está al nivel máximo.");
        if (c.getPurseCp() < coste)
            throw ApiException.conflict("No te llega el dinero para la mejora.");

        c.setPurseCp(c.getPurseCp() - coste);
        p.setLevel(p.getLevel() + 1);

        return build(c);
    }

    @Transactional
    public HoldingsView recaudar(UUID userId, UUID charId, boolean admin, UUID propId) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        Property p = ownedProperty(c, propId);

        long pendiente = pendingCp(p);
        if (pendiente <= 0)
            throw ApiException.conflict("Todavía no hay renta que recaudar.");

        c.setPurseCp(c.getPurseCp() + pendiente);
        p.setLastCollectedAt(Instant.now());

        return build(c);
    }

    @Transactional
    public HoldingsView vender(UUID userId, UUID charId, boolean admin, UUID propId) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        Property p = ownedProperty(c, propId);
        PropertyKind kind = PropertyKind.fromCode(p.getKind());

        // Al vender se cobra también la renta pendiente y el valor de reventa.
        long total = pendingCp(p) + kind.saleValueCp(p.getLevel());
        c.setPurseCp(c.getPurseCp() + total);
        properties.delete(p);

        return build(c);
    }

    // ------------------------------------------------------------------------

    /** Renta acumulada (pc) desde la última recaudación, con el tope aplicado. */
    private long pendingCp(Property p) {
        PropertyKind kind = PropertyKind.fromCode(p.getKind());
        double segundos = Duration.between(p.getLastCollectedAt(), Instant.now()).getSeconds();
        if (segundos < 0) segundos = 0;
        double dias = Math.min(segundos / SEGUNDOS_POR_DIA, MAX_DIAS_ACUMULADOS);
        return (long) Math.floor(kind.incomePerDayCp(p.getLevel()) * dias);
    }

    private HoldingsView build(GameCharacter c) {
        List<PropertyView> mias = properties.findByCharacterIdOrderByPurchasedAtAsc(c.getId())
                .stream().map(this::toView).toList();

        List<CatalogItem> catalogo = Arrays.stream(PropertyKind.values())
                .map(k -> new CatalogItem(
                        k.code(), k.emoji(), k.nombre(), k.blurb(),
                        k.basePriceCp(), Money.format(k.basePriceCp()),
                        k.incomePerDayCp(1), Money.format(k.incomePerDayCp(1)) + " / día"))
                .toList();

        return new HoldingsView(c.getPurseCp(), Money.format(c.getPurseCp()), mias, catalogo);
    }

    private PropertyView toView(Property p) {
        PropertyKind kind = PropertyKind.fromCode(p.getKind());
        long incomeDay = kind.incomePerDayCp(p.getLevel());
        long pendiente = pendingCp(p);
        Long mejora = kind.upgradeCostCp(p.getLevel());
        long venta = kind.saleValueCp(p.getLevel());

        // No sabemos aquí el monedero para "canUpgrade"; el frontend decide con
        // el purseCp del HoldingsView. Aquí solo marcamos si HAY siguiente nivel.
        boolean hayMejora = mejora != null;

        return new PropertyView(
                p.getId().toString(), kind.code(), kind.emoji(), kind.nombre(), p.getName(),
                p.getLevel(), PropertyKind.MAX_LEVEL, p.getCity(),
                incomeDay, Money.format(incomeDay) + " / día",
                pendiente, Money.format(pendiente),
                mejora, mejora == null ? null : Money.format(mejora),
                hayMejora,
                venta, Money.format(venta));
    }

    private Property ownedProperty(GameCharacter c, UUID propId) {
        Property p = properties.findById(propId)
                .orElseThrow(() -> ApiException.notFound("No existe esa propiedad."));
        if (!p.getCharacterId().equals(c.getId()))
            throw ApiException.forbidden("Esa propiedad no es de este personaje.");
        return p;
    }

    /** El dueño pasa siempre; el admin (máster) pasa para cualquier personaje. */
    private GameCharacter accessibleCharacter(UUID userId, UUID charId, boolean admin) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!admin && !c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }
}
