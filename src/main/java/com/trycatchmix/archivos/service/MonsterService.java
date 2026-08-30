package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Monster;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.MonsterRepository;
import com.trycatchmix.archivos.web.dto.MonsterDtos.BestiaryFilters;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterPage;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterRow;
import com.trycatchmix.archivos.web.dto.MonsterDtos.MonsterView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.Normalizer;
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
        Monster m = monsters.findById(id)
                .orElseThrow(() -> ApiException.notFound("Esa criatura no está en el bestiario."));
        return toView(m);
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
                m.getKind(), m.getSource());
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
