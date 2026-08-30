package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.MesaCombat;
import com.trycatchmix.archivos.domain.MesaCombatant;
import com.trycatchmix.archivos.domain.MesaEnemy;
import com.trycatchmix.archivos.domain.Monster;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.*;
import com.trycatchmix.archivos.web.dto.CombatDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Los enemigos del máster y sus combates.
 *
 * La idea es que sacar un bicho a la mesa no cueste teclear su ficha. Se copia
 * del bestiario —con sus PG, su CA y su iniciativa ya en números, sacados del
 * bloque de texto por {@link StatBlockParser}—, se retoca lo que haga falta y
 * se mete en el combate. También se puede inventar uno de cero.
 *
 * UNA DECISIÓN QUE CONVIENE TENER PRESENTE: al meter a alguien en un combate se
 * COPIAN su nombre y sus números, no se consultan cada vez. Durante la pelea el
 * trasgo tiene los PG que tiene; si el DM borra su plantilla o un jugador edita
 * su ficha a mitad de asalto, el combate no se descuadra.
 */
@Service
@RequiredArgsConstructor
public class CombatService {

    private final MesaEnemyRepository enemies;
    private final MesaCombatRepository combats;
    private final MesaCombatantRepository combatants;
    private final MonsterRepository monsters;
    private final GameCharacterRepository characters;

    // ------------------------------------------------------------------ enemigos

    @Transactional(readOnly = true)
    public List<EnemyView> enemigos(UUID userId) {
        return enemies.findByUserIdOrderByNameAsc(userId).stream().map(this::toView).toList();
    }

    /**
     * Copiar un monstruo del bestiario a la lista del máster.
     *
     * El bestiario no se toca nunca: esto es una COPIA, y a partir de aquí el
     * enemigo es del DM. Los PG, la CA y la iniciativa se sacan ya en números
     * del bloque del SRD, que es lo que ahorra el trabajo.
     */
    @Transactional
    public EnemyView copiarDelBestiario(UUID userId, EnemyFromMonsterRequest req) {
        if (req == null || req.monsterId() == null || req.monsterId().isBlank())
            throw ApiException.badRequest("Dime qué criatura quieres copiar.");

        Monster m = monsters.findById(uuid(req.monsterId(), "criatura"))
                .orElseThrow(() -> ApiException.notFound("Esa criatura no está en el bestiario."));

        MesaEnemy e = new MesaEnemy();
        e.setUserId(userId);
        e.setMisionId(req.misionId() == null || req.misionId().isBlank()
                ? null : uuid(req.misionId(), "misión"));
        e.setMonsterId(m.getId());
        e.setName(vacio(req.name()) ? m.getName() : req.name().trim());
        e.setSizeType(m.getSizeType());
        e.setCr(m.getChallengeRating());

        e.setHpMax(StatBlockParser.puntosDeGolpe(m.getHitDice()));
        e.setAc(StatBlockParser.claseDeArmadura(m.getArmorClass(), 10));
        e.setAcTouch(StatBlockParser.caContacto(m.getArmorClass(), e.getAc()));
        e.setAcFlatFooted(StatBlockParser.caDesprevenido(m.getArmorClass(), e.getAc()));
        e.setInitMod(StatBlockParser.modificador(m.getInitiative()));

        e.setSpeed(m.getSpeed());
        e.setSaves(m.getSaves());
        e.setAbilities(m.getAbilities());
        e.setAttack(m.getAttack());
        e.setFullAttack(m.getFullAttack());
        e.setSpecialAttacks(m.getSpecialAttacks());
        e.setSpecialQualities(m.getSpecialQualities());
        e.setSkills(m.getSkills());
        e.setFeats(m.getFeats());

        enemies.save(e);
        return toView(e);
    }

    /** Un enemigo inventado de cero. Solo el nombre es obligatorio. */
    @Transactional
    public EnemyView crear(UUID userId, EnemyUpsertRequest req) {
        if (req == null || vacio(req.name()))
            throw ApiException.badRequest("El enemigo necesita un nombre.");
        MesaEnemy e = new MesaEnemy();
        e.setUserId(userId);
        e.setName(req.name().trim());
        aplicar(e, req);
        enemies.save(e);
        return toView(e);
    }

    @Transactional
    public EnemyView editar(UUID userId, UUID enemigoId, EnemyUpsertRequest req) {
        MesaEnemy e = miEnemigo(userId, enemigoId);
        if (!vacio(req.name())) e.setName(req.name().trim());
        aplicar(e, req);
        return toView(e);
    }

    @Transactional
    public void borrar(UUID userId, UUID enemigoId) {
        enemies.delete(miEnemigo(userId, enemigoId));
    }

    // ------------------------------------------------------------------ combates

    @Transactional(readOnly = true)
    public List<CombatSummary> combates(UUID userId) {
        return combats.findByUserIdOrderByCreatedAtDesc(userId).stream()
                .map(c -> new CombatSummary(c.getId().toString(), c.getTitle(), c.getRound(),
                        combatants.findByCombateIdOrderBySortOrdinalAsc(c.getId()).size()))
                .toList();
    }

    @Transactional
    public CombatView crearCombate(UUID userId, CombatCreateRequest req) {
        MesaCombat c = new MesaCombat();
        c.setUserId(userId);
        c.setTitle(req == null || vacio(req.title()) ? "Combate" : req.title().trim());
        if (req != null && !vacio(req.misionId())) c.setMisionId(uuid(req.misionId(), "misión"));
        combats.save(c);
        return vista(c);
    }

    @Transactional(readOnly = true)
    public CombatView combate(UUID userId, UUID combateId) {
        return vista(miCombate(userId, combateId));
    }

    @Transactional
    public void borrarCombate(UUID userId, UUID combateId) {
        MesaCombat c = miCombate(userId, combateId);
        combatants.deleteByCombateId(c.getId());
        combatants.flush();
        combats.delete(c);
    }

    /**
     * Meter enemigos en el combate. Si se piden varios, se numeran
     * ("Trasgo 1", "Trasgo 2"), que es como se distinguen en la mesa.
     */
    @Transactional
    public CombatView anadirEnemigos(UUID userId, UUID combateId, AddEnemiesRequest req) {
        MesaCombat c = miCombate(userId, combateId);
        MesaEnemy e = miEnemigo(userId, uuid(req.enemigoId(), "enemigo"));
        int cuantos = req.count() == null ? 1 : Math.max(1, Math.min(20, req.count()));

        int orden = siguienteOrden(combateId);
        for (int i = 1; i <= cuantos; i++) {
            MesaCombatant k = new MesaCombatant();
            k.setCombateId(combateId);
            k.setKind("enemigo");
            k.setEnemigoId(e.getId());
            k.setName(cuantos > 1 ? e.getName() + " " + i : e.getName());
            k.setHpMax(e.getHpMax());
            k.setHpCurrent(e.getHpMax());
            k.setAc(e.getAc());
            k.setInitiative(0);
            k.setSortOrdinal(orden++);
            combatants.save(k);
        }
        return vista(c);
    }

    /** Meter un personaje del grupo. Sus PG y su CA se copian de la ficha. */
    @Transactional
    public CombatView anadirPersonaje(UUID userId, UUID combateId, AddCharacterRequest req) {
        MesaCombat c = miCombate(userId, combateId);
        GameCharacter p = characters.findById(uuid(req.characterId(), "personaje"))
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));

        MesaCombatant k = new MesaCombatant();
        k.setCombateId(combateId);
        k.setKind("personaje");
        k.setCharacterId(p.getId());
        k.setName(p.getName());
        k.setHpMax(p.getPg());
        k.setHpCurrent(p.getHpCurrent());
        k.setAc(p.getCa());
        k.setSortOrdinal(siguienteOrden(combateId));
        combatants.save(k);
        return vista(c);
    }

    /** Alguien escrito a mano, sin plantilla: un guardia, un perro, lo que sea. */
    @Transactional
    public CombatView anadirSuelto(UUID userId, UUID combateId, AddLooseRequest req) {
        MesaCombat c = miCombate(userId, combateId);
        if (req == null || vacio(req.name()))
            throw ApiException.badRequest("Ponle un nombre.");

        MesaCombatant k = new MesaCombatant();
        k.setCombateId(combateId);
        k.setKind("suelto");
        k.setName(req.name().trim());
        k.setHpMax(req.hpMax() == null ? 0 : Math.max(0, req.hpMax()));
        k.setHpCurrent(k.getHpMax());
        k.setAc(req.ac() == null ? 10 : req.ac());
        k.setSortOrdinal(siguienteOrden(combateId));
        combatants.save(k);
        return vista(c);
    }

    /**
     * Tirar iniciativa por todos: 1d20 + el modificador de quien lo tenga.
     *
     * Los enemigos usan el de su plantilla; los personajes, el de su ficha. A
     * quien ya tuviera una iniciativa puesta a mano NO se le toca: el jugador
     * suele tirar sus dados y cantarla.
     */
    @Transactional
    public CombatView tirarIniciativa(UUID userId, UUID combateId, boolean incluirPersonajes) {
        MesaCombat c = miCombate(userId, combateId);
        var rnd = ThreadLocalRandom.current();

        for (MesaCombatant k : combatants.findByCombateIdOrderBySortOrdinalAsc(combateId)) {
            if (!incluirPersonajes && "personaje".equals(k.getKind())) continue;
            if (k.getInitiative() != 0) continue;      // ya la cantó alguien
            k.setInitiative(rnd.nextInt(1, 21) + modIniciativa(k));
        }
        ordenar(combateId);
        if (c.getRound() == 0) { c.setRound(1); c.setTurnOrdinal(0); }
        return vista(c);
    }

    /** Pasar al siguiente. Al dar la vuelta, sube el asalto. */
    @Transactional
    public CombatView siguienteTurno(UUID userId, UUID combateId) {
        MesaCombat c = miCombate(userId, combateId);
        List<MesaCombatant> lista = combatants.findByCombateIdOrderBySortOrdinalAsc(combateId);
        if (lista.isEmpty()) return vista(c);
        if (c.getRound() == 0) { c.setRound(1); c.setTurnOrdinal(0); return vista(c); }

        int siguiente = c.getTurnOrdinal() + 1;
        if (siguiente >= lista.size()) {
            siguiente = 0;
            c.setRound(c.getRound() + 1);
        }
        c.setTurnOrdinal(siguiente);
        return vista(c);
    }

    /** Daño (negativo) o curación (positivo). No baja de 0 ni pasa del máximo. */
    @Transactional
    public CombatView cambiarPg(UUID userId, UUID combateId, UUID combatantId, Integer delta) {
        MesaCombat c = miCombate(userId, combateId);
        MesaCombatant k = combatiente(combateId, combatantId);
        int d = delta == null ? 0 : delta;
        int nuevo = Math.max(0, k.getHpCurrent() + d);
        if (k.getHpMax() > 0) nuevo = Math.min(nuevo, k.getHpMax());
        k.setHpCurrent(nuevo);
        // a 0 se le da por caído solo; volver a curarlo lo levanta
        if (nuevo == 0 && k.getHpMax() > 0) k.setDefeated(true);
        else if (nuevo > 0) k.setDefeated(false);
        return vista(c);
    }

    @Transactional
    public CombatView editarCombatiente(UUID userId, UUID combateId, UUID combatantId,
                                        CombatantEditRequest req) {
        MesaCombat c = miCombate(userId, combateId);
        MesaCombatant k = combatiente(combateId, combatantId);
        if (!vacio(req.name())) k.setName(req.name().trim());
        if (req.initiative() != null) k.setInitiative(req.initiative());
        if (req.hpMax() != null) k.setHpMax(Math.max(0, req.hpMax()));
        if (req.hpCurrent() != null) k.setHpCurrent(Math.max(0, req.hpCurrent()));
        if (req.ac() != null) k.setAc(req.ac());
        if (req.conditions() != null) k.setConditions(req.conditions().trim());
        if (req.notes() != null) k.setNotes(req.notes().trim());
        if (req.defeated() != null) k.setDefeated(req.defeated());
        if (req.initiative() != null) ordenar(combateId);
        return vista(c);
    }

    @Transactional
    public CombatView quitarCombatiente(UUID userId, UUID combateId, UUID combatantId) {
        MesaCombat c = miCombate(userId, combateId);
        combatants.delete(combatiente(combateId, combatantId));
        combatants.flush();
        ordenar(combateId);
        // si se fue alguien de antes del turno actual, el índice se queda corto
        int total = combatants.findByCombateIdOrderBySortOrdinalAsc(combateId).size();
        if (c.getTurnOrdinal() >= total) c.setTurnOrdinal(0);
        return vista(c);
    }

    // ------------------------------------------------------------------ interior

    /** Reordena por iniciativa (de mayor a menor) y renumera los sitios. */
    private void ordenar(UUID combateId) {
        List<MesaCombatant> lista = new ArrayList<>(
                combatants.findByCombateIdOrderBySortOrdinalAsc(combateId));
        lista.sort(Comparator.comparingInt(MesaCombatant::getInitiative).reversed()
                .thenComparing(MesaCombatant::getName));
        for (int i = 0; i < lista.size(); i++) lista.get(i).setSortOrdinal(i);
    }

    private int modIniciativa(MesaCombatant k) {
        if (k.getEnemigoId() != null) {
            return enemies.findById(k.getEnemigoId()).map(MesaEnemy::getInitMod).orElse(0);
        }
        if (k.getCharacterId() != null) {
            return characters.findById(k.getCharacterId())
                    .map(p -> p.abilityMod("DES") + p.getInitiativeMisc()).orElse(0);
        }
        return 0;
    }

    private int siguienteOrden(UUID combateId) {
        return combatants.findByCombateIdOrderBySortOrdinalAsc(combateId).size();
    }

    private CombatView vista(MesaCombat c) {
        List<MesaCombatant> lista = combatants.findByCombateIdOrderBySortOrdinalAsc(c.getId());
        List<CombatantView> vistas = new ArrayList<>();
        for (MesaCombatant k : lista) {
            vistas.add(new CombatantView(
                    k.getId().toString(), k.getKind(), k.getName(), k.getInitiative(),
                    k.getHpMax(), k.getHpCurrent(), k.getAc(), k.getConditions(), k.getNotes(),
                    k.isDefeated(), k.getSortOrdinal(),
                    c.getRound() > 0 && k.getSortOrdinal() == c.getTurnOrdinal(),
                    k.getEnemigoId() == null ? null : k.getEnemigoId().toString(),
                    k.getCharacterId() == null ? null : k.getCharacterId().toString()));
        }
        return new CombatView(c.getId().toString(), c.getTitle(), c.getRound(),
                c.getTurnOrdinal(), c.getMisionId() == null ? null : c.getMisionId().toString(),
                vistas);
    }

    private EnemyView toView(MesaEnemy e) {
        String origen = e.getMonsterId() == null ? null
                : monsters.findById(e.getMonsterId()).map(Monster::getName).orElse(null);
        return new EnemyView(
                e.getId().toString(), e.getName(), e.getSizeType(), e.getCr(),
                e.getHpMax(), e.getAc(), e.getAcTouch(), e.getAcFlatFooted(), e.getInitMod(),
                e.getSpeed(), e.getSaves(), e.getAbilities(), e.getAttack(), e.getFullAttack(),
                e.getSpecialAttacks(), e.getSpecialQualities(), e.getSkills(), e.getFeats(),
                e.getNotes(),
                e.getMonsterId() == null ? null : e.getMonsterId().toString(), origen,
                e.getMisionId() == null ? null : e.getMisionId().toString());
    }

    private void aplicar(MesaEnemy e, EnemyUpsertRequest r) {
        if (r.sizeType() != null) e.setSizeType(r.sizeType().trim());
        if (r.cr() != null) e.setCr(r.cr().trim());
        if (r.hpMax() != null) e.setHpMax(Math.max(0, r.hpMax()));
        if (r.ac() != null) e.setAc(r.ac());
        if (r.acTouch() != null) e.setAcTouch(r.acTouch());
        if (r.acFlatFooted() != null) e.setAcFlatFooted(r.acFlatFooted());
        if (r.initMod() != null) e.setInitMod(r.initMod());
        if (r.speed() != null) e.setSpeed(r.speed().trim());
        if (r.saves() != null) e.setSaves(r.saves().trim());
        if (r.abilities() != null) e.setAbilities(r.abilities().trim());
        if (r.attack() != null) e.setAttack(r.attack().trim());
        if (r.fullAttack() != null) e.setFullAttack(r.fullAttack().trim());
        if (r.specialAttacks() != null) e.setSpecialAttacks(r.specialAttacks().trim());
        if (r.specialQualities() != null) e.setSpecialQualities(r.specialQualities().trim());
        if (r.skills() != null) e.setSkills(r.skills().trim());
        if (r.feats() != null) e.setFeats(r.feats().trim());
        if (r.notes() != null) e.setNotes(r.notes().trim());
        if (r.misionId() != null) {
            e.setMisionId(r.misionId().isBlank() ? null : uuid(r.misionId(), "misión"));
        }
    }

    private MesaEnemy miEnemigo(UUID userId, UUID enemigoId) {
        MesaEnemy e = enemies.findById(enemigoId)
                .orElseThrow(() -> ApiException.notFound("Ese enemigo ya no está."));
        if (!e.getUserId().equals(userId))
            throw ApiException.forbidden("Ese enemigo no es tuyo.");
        return e;
    }

    private MesaCombat miCombate(UUID userId, UUID combateId) {
        MesaCombat c = combats.findById(combateId)
                .orElseThrow(() -> ApiException.notFound("Ese combate ya no está."));
        if (!c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese combate no es tuyo.");
        return c;
    }

    private MesaCombatant combatiente(UUID combateId, UUID combatantId) {
        MesaCombatant k = combatants.findById(combatantId)
                .orElseThrow(() -> ApiException.notFound("Ese combatiente ya no está."));
        if (!k.getCombateId().equals(combateId))
            throw ApiException.forbidden("Ese combatiente no es de este combate.");
        return k;
    }

    private UUID uuid(String v, String que) {
        try {
            return UUID.fromString(v);
        } catch (Exception e) {
            throw ApiException.badRequest("Ese identificador de " + que + " no vale.");
        }
    }

    private boolean vacio(String s) {
        return s == null || s.isBlank();
    }
}
