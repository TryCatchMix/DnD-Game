package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.PreparedSpell;
import com.trycatchmix.archivos.domain.Spell;
import com.trycatchmix.archivos.domain.SpellClass;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.PreparedSpellRepository;
import com.trycatchmix.archivos.repo.SpellRepository;
import com.trycatchmix.archivos.web.dto.PreparedDtos.PreparedList;
import com.trycatchmix.archivos.web.dto.PreparedDtos.PreparedView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.UUID;

/**
 * La lista de conjuros preparados de un personaje: lo típico de una ficha de
 * rol, prepararse los conjuros antes de jugar. Solo enlaza conjuros del grimorio
 * (para tener su bloque de estadísticas y su CD ya resueltos) y guarda cuántas
 * veces se lleva cada uno. El control de propiedad es el mismo de la ficha:
 * dueño o DM ({@link GameService#accesible}).
 */
@Service
@RequiredArgsConstructor
public class PreparedSpellService {

    private final PreparedSpellRepository prepared;
    private final SpellRepository spells;
    private final GameService game;
    private final SpellService spellService;

    @Transactional(readOnly = true)
    public PreparedList listar(UUID userId, UUID charId, boolean admin) {
        GameCharacter c = game.accesible(userId, charId, admin);
        return build(c);
    }

    @Transactional
    public PreparedList preparar(UUID userId, UUID charId, boolean admin, String name, Integer count) {
        GameCharacter c = game.accesible(userId, charId, admin);
        if (name == null || name.isBlank())
            throw ApiException.badRequest("Falta el nombre del conjuro.");

        Spell s = spells.findByNameIgnoreCase(name.trim())
                .orElseThrow(() -> ApiException.notFound("Ese conjuro no está en el grimorio."));

        int cuantos = Math.max(1, count == null ? 1 : count);
        prepared.findByCharacterIdAndSpellId(charId, s.getId())
                .ifPresentOrElse(
                        ps -> ps.setPrepared(ps.getPrepared() + cuantos),
                        () -> {
                            PreparedSpell ps = new PreparedSpell();
                            ps.setCharacter(c);
                            ps.setSpell(s);
                            ps.setPrepared(cuantos);
                            prepared.save(ps);
                        });
        return build(c);
    }

    @Transactional
    public PreparedList fijarCantidad(UUID userId, UUID charId, boolean admin, UUID prepId, Integer count) {
        GameCharacter c = game.accesible(userId, charId, admin);
        PreparedSpell ps = mio(charId, prepId);
        if (count == null || count <= 0) {
            prepared.delete(ps);
        } else {
            ps.setPrepared(count);
        }
        return build(c);
    }

    @Transactional
    public PreparedList quitar(UUID userId, UUID charId, boolean admin, UUID prepId) {
        GameCharacter c = game.accesible(userId, charId, admin);
        prepared.delete(mio(charId, prepId));
        return build(c);
    }

    /** La fila preparada, comprobando que es de ESTE personaje (no de otro). */
    private PreparedSpell mio(UUID charId, UUID prepId) {
        PreparedSpell ps = prepared.findById(prepId)
                .orElseThrow(() -> ApiException.notFound("Ese conjuro preparado no existe."));
        if (!ps.getCharacter().getId().equals(charId))
            throw ApiException.forbidden("Ese conjuro preparado no es de este personaje.");
        return ps;
    }

    private PreparedList build(GameCharacter c) {
        var items = prepared.findByCharacterIdOrderByCreatedAtAsc(c.getId()).stream()
                .map(ps -> new PreparedView(
                        ps.getId().toString(),
                        ps.getPrepared(),
                        nivelPara(ps.getSpell(), c.getClazz()),
                        spellService.vista(ps.getSpell())))
                .sorted(Comparator.comparingInt(PreparedView::level)
                        .thenComparing(pv -> pv.spell().name()))
                .toList();
        return new PreparedList(items);
    }

    /** El nivel al que ESTE personaje lanza el conjuro: el de su clase si la
     *  aprende, o el mínimo entre las clases que lo tienen. */
    private int nivelPara(Spell s, String clazz) {
        return s.getClasses().stream()
                .filter(sc -> sc.getClazz().equalsIgnoreCase(clazz))
                .mapToInt(SpellClass::getLevel)
                .min()
                .orElseGet(() -> s.getClasses().stream()
                        .mapToInt(SpellClass::getLevel).min().orElse(0));
    }
}
