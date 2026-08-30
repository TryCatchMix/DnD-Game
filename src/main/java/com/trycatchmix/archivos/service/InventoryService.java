package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.InventoryEntry;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.GameCharacterRepository;
import com.trycatchmix.archivos.repo.InventoryRepository;
import com.trycatchmix.archivos.repo.ItemRepository;
import com.trycatchmix.archivos.web.dto.InventoryDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

/** La bolsa del personaje: verla, añadir a mano, ajustar cantidades y tirar cosas. */
@Service
@RequiredArgsConstructor
public class InventoryService {

    private final GameCharacterRepository characters;
    private final InventoryRepository inventory;
    private final ItemRepository items;

    @Transactional(readOnly = true)
    public InventoryView inventario(UUID userId, UUID charId) {
        ownedCharacter(userId, charId);
        return build(charId);
    }

    /** Añadir un objeto a mano. Si ya hay uno manual con el mismo nombre y peso,
     *  suma cantidades en vez de duplicar la línea. */
    @Transactional
    public InventoryView anadir(UUID userId, UUID charId, AddItemRequest r) {
        ownedCharacter(userId, charId);

        String nombre = r.name() == null ? "" : r.name().trim();
        if (nombre.isEmpty()) throw ApiException.conflict("El objeto necesita un nombre.");
        int cantidad = r.quantity() == null ? 1 : Math.max(1, r.quantity());
        double peso = r.weightLb() == null ? 0 : Math.max(0, r.weightLb());

        InventoryEntry existente = inventory.findByCharacterIdOrderByNameAsc(charId).stream()
                .filter(e -> e.getItemCode() == null
                        && e.getName().equalsIgnoreCase(nombre)
                        && e.getWeightLb() == peso)
                .findFirst().orElse(null);

        if (existente != null) {
            existente.setQuantity(existente.getQuantity() + cantidad);
        } else {
            InventoryEntry e = new InventoryEntry();
            e.setCharacterId(charId);
            e.setItemCode(null);
            e.setName(nombre);
            e.setQuantity(cantidad);
            e.setWeightLb(peso);
            inventory.save(e);
        }
        return build(charId);
    }

    /** Fijar la cantidad de una línea. Cero o menos, se elimina. */
    @Transactional
    public InventoryView fijarCantidad(UUID userId, UUID charId, UUID entryId, Integer cantidad) {
        ownedCharacter(userId, charId);
        InventoryEntry e = linea(charId, entryId);
        int q = cantidad == null ? 0 : cantidad;
        if (q <= 0) inventory.delete(e);
        else e.setQuantity(q);
        return build(charId);
    }

    /**
     * Ponerse o quitarse un objeto.
     *
     * Solo se puede llevar UNA armadura y UN escudo a la vez, así que al
     * equipar uno se quita solo el que hubiera: es lo que espera cualquiera y
     * evita fichas con dos corazas puestas sumando CA.
     *
     * Las armas no compiten entre sí: se pueden llevar varias empuñadas o al
     * cinto, y quién ataca con cuál es cosa de la mesa.
     */
    @Transactional
    public InventoryView equipar(UUID userId, UUID charId, UUID entryId, boolean puesto) {
        ownedCharacter(userId, charId);
        InventoryEntry e = linea(charId, entryId);

        String tipo = Gear.kind(catalogo(e));
        if (tipo.isEmpty())
            throw ApiException.conflict("Eso no es algo que se lleve puesto.");

        if (puesto && (tipo.equals(Gear.ARMADURA) || tipo.equals(Gear.ESCUDO))) {
            for (InventoryEntry otro : inventory.findByCharacterIdOrderByNameAsc(charId)) {
                if (otro.getId().equals(e.getId()) || !otro.isEquipped()) continue;
                if (Gear.kind(catalogo(otro)).equals(tipo)) otro.setEquipped(false);
            }
        }
        e.setEquipped(puesto);
        return build(charId);
    }

    @Transactional
    public InventoryView eliminar(UUID userId, UUID charId, UUID entryId) {
        ownedCharacter(userId, charId);
        inventory.delete(linea(charId, entryId));
        return build(charId);
    }

    // ------------------------------------------------------------------------

    private InventoryView build(UUID charId) {
        List<InventoryLine> lines = inventory.findByCharacterIdOrderByNameAsc(charId).stream()
                .map(e -> {
                    var item = catalogo(e);
                    return new InventoryLine(
                            e.getId().toString(), e.getName(), e.getQuantity(), e.getWeightLb(),
                            redondear(e.getWeightLb() * e.getQuantity()), e.getItemCode() != null,
                            e.isEquipped(), Gear.equipable(item), Gear.kind(item), Gear.stats(item));
                })
                .toList();
        double total = lines.stream().mapToDouble(InventoryLine::lineWeight).sum();
        return new InventoryView(lines, redondear(total));
    }

    private double redondear(double v) { return Math.round(v * 100.0) / 100.0; }

    /** La ficha del catálogo de una línea de la bolsa, o null si es un objeto
     *  añadido a mano (esos no tienen estadísticas del SRD). */
    private com.trycatchmix.archivos.domain.Item catalogo(InventoryEntry e) {
        return e.getItemCode() == null ? null : items.findById(e.getItemCode()).orElse(null);
    }

    private InventoryEntry linea(UUID charId, UUID entryId) {
        InventoryEntry e = inventory.findById(entryId)
                .orElseThrow(() -> ApiException.notFound("No existe ese objeto en la bolsa."));
        if (!e.getCharacterId().equals(charId))
            throw ApiException.forbidden("Ese objeto no es de este personaje.");
        return e;
    }

    private GameCharacter ownedCharacter(UUID userId, UUID charId) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }
}
