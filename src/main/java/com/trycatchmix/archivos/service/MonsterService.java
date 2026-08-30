package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Monster;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.domain.CharacterClass;
import com.trycatchmix.archivos.domain.ClassProgression;
import com.trycatchmix.archivos.repo.CharacterClassRepository;
import com.trycatchmix.archivos.repo.ClassProgressionRepository;
import com.trycatchmix.archivos.repo.MonsterRepository;
import com.trycatchmix.archivos.web.dto.MonsterDtos.BestiaryFilters;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterPage;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterRow;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterView;
import com.trycatchmix.archivos.web.dto.MonsterDtos.ScalingView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

/**
 * El bestiario: las criaturas del SRD que el máster saca en la mesa.
 *
 * Filtra y pagina EN EL SERVIDOR (como el grimorio) para no mandar las ~590
 * fichas de golpe. Son pocas filas, así que el filtro se hace en memoria sobre
 * la lista entera: así la búsqueda puede ignorar acentos, cosa que en SQL
 * costaría una extensión de Postgres.
 */
@Service
@RequiredArgsConstructor
public class MonsterService {

    private final MonsterRepository monsters;
    private final CharacterClassRepository classes;
    private final ClassProgressionRepository progression;

    /**
     * Lista filtrada y paginada.
     *
     * @param q       texto a buscar en el nombre (español o inglés), sin acentos
     * @param tipo    tipo de criatura ("Dragón", "No muerto"…); vacío = todos
     * @param entorno terreno donde vive; vacío = todos
     * @param vdMin   valor de desafío mínimo, o null
     * @param vdMax   valor de desafío máximo, o null
     * @param orden   "vd" para ordenar por peligro; cualquier otra cosa, por nombre
     * @param limite  cuántas devolver; &lt;= 0 significa todas
     */
    @Transactional(readOnly = true)
    public MonsterPage lista(String q, String tipo, String entorno,
                             Double vdMin, Double vdMax, String orden,
                             int limite, int offset) {
        String aguja = norm(q);
        boolean todosTipos = vacio(tipo) || "Todos".equalsIgnoreCase(tipo);
        boolean todosEntornos = vacio(entorno) || "Todos".equalsIgnoreCase(entorno);

        Comparator<Monster> porNombre = Comparator.comparing(Monster::getName);
        Comparator<Monster> comparador = "vd".equalsIgnoreCase(orden)
                // las plantillas no tienen VD: al final, no al principio
                ? Comparator.comparing((Monster m) -> m.getCr() == null
                        ? Double.MAX_VALUE : m.getCr().doubleValue()).thenComparing(porNombre)
                : porNombre;

        List<Monster> filtrados = monsters.findAllByOrderByNameAsc().stream()
                .filter(m -> aguja.isEmpty()
                        || norm(m.getName()).contains(aguja)
                        || norm(m.getNameEn()).contains(aguja))
                .filter(m -> todosTipos || tipo.equalsIgnoreCase(m.getCreatureType()))
                .filter(m -> todosEntornos || norm(m.getEnvironment()).contains(norm(entorno)))
                .filter(m -> dentroDelRango(m, vdMin, vdMax))
                .sorted(comparador)
                .toList();

        int total = filtrados.size();
        var stream = filtrados.stream().skip(Math.max(0, offset));
        if (limite > 0) stream = stream.limit(limite);
        return new MonsterPage(total, stream.map(this::toRow).toList());
    }

    @Transactional(readOnly = true)
    public MonsterView ficha(UUID id) {
        return ficha(id, null);
    }

    /**
     * La ficha de una criatura, opcionalmente a OTRO nivel de clase.
     *
     * Sin `nivel`, o pidiendo el suyo, devuelve el bloque del manual tal cual:
     * los números originales no se recalculan nunca, para que nadie se
     * pregunte por qué el trasgo del libro y el de la pantalla no coinciden.
     * Solo al pedir un nivel distinto se recalcula, y entonces se dice.
     */
    @Transactional(readOnly = true)
    public MonsterView ficha(UUID id, Integer nivel) {
        Monster m = monsters.findById(id)
                .orElseThrow(() -> ApiException.notFound("Esa criatura no está en el bestiario."));
        if (m.getClassNameEn().isBlank() || m.getClassLevel() <= 0) {
            return toView(m);          // sin niveles de clase no hay nada que escalar
        }
        CharacterClass clase = classes.findByNameEnIgnoreCase(m.getClassNameEn()).orElse(null);
        if (clase == null) return toView(m);

        int maximo = progression.findByClassEnIgnoreCaseOrderByLevelAsc(clase.getNameEn())
                .stream().mapToInt(ClassProgression::getLevel).max().orElse(20);
        int base = m.getClassLevel();
        int destino = nivel == null ? base : Math.max(1, Math.min(maximo, nivel));

        if (destino == base) return toView(m, escalado(m, clase, base, base, maximo, List.of()));
        return escalar(m, clase, base, destino, maximo);
    }

    /** Recalcula el bloque para el nivel pedido. */
    private MonsterView escalar(Monster m, CharacterClass clase, int base, int destino, int maximo) {
        ClassProgression desde = progression
                .findByClassEnIgnoreCaseAndLevel(clase.getNameEn(), base).orElse(null);
        ClassProgression hasta = progression
                .findByClassEnIgnoreCaseAndLevel(clase.getNameEn(), destino).orElse(null);
        if (desde == null || hasta == null) return toView(m);

        int dBab = hasta.getBab() - desde.getBab();
        int dFort = hasta.getFort() - desde.getFort();
        int dRef = hasta.getRef() - desde.getRef();
        int dWill = hasta.getWill() - desde.getWill();

        Integer modCon = LevelScaler.modificador(m.getAbilities(), "Con");
        var grupos = LevelScaler.grupos(m.getHitDice());
        int idx = LevelScaler.indiceDeClase(grupos, base, clase.getHitDie());

        List<String> avisos = new ArrayList<>();
        String dados = m.getHitDice();
        if (idx >= 0) {
            dados = LevelScaler.dadosDeGolpe(m.getHitDice(), idx, destino, clase.getHitDie(), modCon);
        } else {
            avisos.add("No se ha reconocido cuáles de sus dados de golpe son los de clase, "
                     + "así que los puntos de golpe se han dejado como estaban.");
        }

        MonsterView v = toView(m);
        return new MonsterView(
                v.id(), v.name(), v.nameEn(), v.family(), v.creatureType(), v.sizeType(),
                v.cr(), v.challengeRating(),
                dados, v.initiative(), v.speed(), v.armorClass(),
                LevelScaler.desplazarAtaqueBase(v.baseAttack(), dBab),
                LevelScaler.desplazarAtaques(v.attack(), dBab),
                LevelScaler.desplazarAtaques(v.fullAttack(), dBab),
                v.spaceReach(), v.specialAttacks(), v.specialQualities(),
                LevelScaler.desplazarSalvaciones(v.saves(), dFort, dRef, dWill),
                v.abilities(), v.skills(), v.feats(), v.environment(), v.organization(),
                v.treasure(), v.alignment(), v.advancement(), v.levelAdjustment(),
                v.description(), v.kind(), v.source(),
                escalado(m, clase, base, destino, maximo, avisos));
    }

    /** El bloque de información del selector de nivel. */
    private ScalingView escalado(Monster m, CharacterClass clase, int base, int destino,
                                 int maximo, List<String> avisosPrevios) {
        List<String> avisos = new ArrayList<>(avisosPrevios);
        int dotes = LevelScaler.dotesGanadas(base, destino);
        int subidas = LevelScaler.subidasDeCaracteristica(base, destino);

        Integer modInt = LevelScaler.modificador(m.getAbilities(), "Int");
        int porNivel = Math.max(1, clase.getSkillPoints() + (modInt == null ? 0 : modInt));
        int puntos = destino > base ? porNivel * (destino - base) : 0;

        if (destino != base) {
            if (dotes > 0) avisos.add("Gana " + dotes + " dote(s): elígelas tú, el manual no lo decide.");
            if (subidas > 0) avisos.add("Gana " + subidas + " subida(s) de +1 a una característica, "
                    + "y con ellas cambian los modificadores que dependan de esa característica.");
            if (puntos > 0) avisos.add("Reparte " + puntos + " punto(s) de habilidad "
                    + "(" + porNivel + " por nivel).");
            avisos.add("Las aptitudes de clase que gane por el camino no están aplicadas: "
                    + "míralas en la pestaña Habilidades.");
        }

        return new ScalingView(
                m.getClassNameEn(), clase.getName(), base, destino, 1, maximo,
                destino == base, dotes, subidas, puntos,
                vdEstimado(m, clase, base, destino), avisos);
    }

    /**
     * El VD al cambiar de nivel. Siempre es una ESTIMACIÓN y la interfaz lo dice.
     *
     * Se usan dos reglas distintas a propósito. Para alguien que SOLO tiene
     * niveles de una clase de PNJ (los quince "guerrero de nivel 1" del
     * bestiario), la guía del máster dice que su VD es su nivel menos uno: un
     * guerrero de nivel 5 vale 4, no 5, porque una clase de PNJ rinde menos que
     * una de personaje. Para todo lo demás —los que tienen dados raciales
     * encima, o clases de personaje— se suma un punto por nivel, que es la
     * regla de andar por casa.
     */
    private String vdEstimado(Monster m, CharacterClass clase, int base, int destino) {
        if (m.getCr() == null) return "—";
        if (destino == base) return vd(m.getCr());

        boolean soloClase = LevelScaler.grupos(m.getHitDice()).size() == 1;
        if (clase.isNpc() && soloClase) {
            return String.valueOf(Math.max(1, destino - 1));
        }
        double v = m.getCr().doubleValue() + (destino - base);
        if (v < 1) return vd(BigDecimal.valueOf(Math.max(0.1, v)));
        return String.valueOf((long) Math.max(1, Math.round(v)));
    }

    /** Los tipos y entornos que existen de verdad en los datos, para poblar los
     *  desplegables sin llevarlos escritos a mano en el frontend. */
    @Transactional(readOnly = true)
    public BestiaryFilters filtros() {
        List<Monster> todos = monsters.findAllByOrderByNameAsc();
        List<String> tipos = todos.stream()
                .map(Monster::getCreatureType)
                .filter(s -> !vacio(s))
                .distinct().sorted().toList();
        List<String> entornos = todos.stream()
                .map(Monster::getEnvironment)
                .filter(s -> !vacio(s))
                .distinct().sorted().toList();
        var vds = todos.stream().map(Monster::getCr).filter(java.util.Objects::nonNull)
                .mapToDouble(BigDecimal::doubleValue);
        var resumen = vds.summaryStatistics();
        return new BestiaryFilters(tipos, entornos,
                resumen.getCount() == 0 ? 0 : resumen.getMin(),
                resumen.getCount() == 0 ? 0 : resumen.getMax());
    }

    // ------------------------------------------------------------------------

    private boolean dentroDelRango(Monster m, Double min, Double max) {
        if (min == null && max == null) return true;
        if (m.getCr() == null) return false;      // las plantillas no tienen VD
        double vd = m.getCr().doubleValue();
        return (min == null || vd >= min) && (max == null || vd <= max);
    }

    private MonsterRow toRow(Monster m) {
        return new MonsterRow(m.getId().toString(), m.getName(), m.getNameEn(),
                m.getSizeType(), m.getCreatureType(), vd(m.getCr()),
                m.getEnvironment(), m.getKind());
    }

    private MonsterView toView(Monster m, ScalingView escalado) {
        MonsterView v = toView(m);
        return new MonsterView(v.id(), v.name(), v.nameEn(), v.family(), v.creatureType(),
                v.sizeType(), v.cr(), v.challengeRating(), v.hitDice(), v.initiative(),
                v.speed(), v.armorClass(), v.baseAttack(), v.attack(), v.fullAttack(),
                v.spaceReach(), v.specialAttacks(), v.specialQualities(), v.saves(),
                v.abilities(), v.skills(), v.feats(), v.environment(), v.organization(),
                v.treasure(), v.alignment(), v.advancement(), v.levelAdjustment(),
                v.description(), v.kind(), v.source(), escalado);
    }

    private MonsterView toView(Monster m) {
        return new MonsterView(
                m.getId().toString(), m.getName(), m.getNameEn(), m.getFamily(),
                m.getCreatureType(), m.getSizeType(), vd(m.getCr()), m.getChallengeRating(),
                m.getHitDice(), m.getInitiative(), m.getSpeed(), m.getArmorClass(),
                m.getBaseAttack(), m.getAttack(), m.getFullAttack(), m.getSpaceReach(),
                m.getSpecialAttacks(), m.getSpecialQualities(), m.getSaves(),
                m.getAbilities(), m.getSkills(), m.getFeats(), m.getEnvironment(),
                m.getOrganization(), m.getTreasure(), m.getAlignment(),
                m.getAdvancement(), m.getLevelAdjustment(), m.getDescription(),
                m.getKind(), m.getSource(), null);
    }

    /** El VD listo para leer: los del SRD por debajo de 1 son fracciones. */
    private String vd(BigDecimal cr) {
        if (cr == null) return "—";
        double v = cr.doubleValue();
        if (v >= 1) return String.valueOf((long) v);
        if (aprox(v, 0.5)) return "½";
        if (aprox(v, 1.0 / 3)) return "⅓";
        if (aprox(v, 0.25)) return "¼";
        if (aprox(v, 1.0 / 6)) return "1/6";
        if (aprox(v, 0.125)) return "1/8";
        if (aprox(v, 0.1)) return "1/10";
        return cr.stripTrailingZeros().toPlainString();
    }

    private boolean aprox(double a, double b) {
        return Math.abs(a - b) < 0.005;
    }

    private boolean vacio(String s) {
        return s == null || s.isBlank();
    }

    /** Minúsculas y sin acentos, para buscar "arana" y encontrar "araña". */
    private String norm(String s) {
        if (s == null) return "";
        return Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
                .toLowerCase().trim();
    }
}
