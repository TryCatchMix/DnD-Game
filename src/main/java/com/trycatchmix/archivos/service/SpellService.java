package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Invocation;
import com.trycatchmix.archivos.domain.Spell;
import com.trycatchmix.archivos.domain.SpellClass;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.ClassFeatureRepository;
import com.trycatchmix.archivos.repo.InvocationRepository;
import com.trycatchmix.archivos.repo.SpellRepository;
import com.trycatchmix.archivos.web.dto.SpellDtos.FeatureView;
import com.trycatchmix.archivos.web.dto.SpellDtos.InvocationView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellClassInput;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellClassView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellCreate;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellPage;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/** El grimorio: todos los conjuros con las clases que los aprenden, y las
 *  invocaciones de warlock. El filtro por clase y la búsqueda por nombre los
 *  hace el frontend, para que sea instantáneo mientras escribes. */
@Service
@RequiredArgsConstructor
public class SpellService {

    private final SpellRepository spells;
    private final InvocationRepository invocations;
    private final ClassFeatureRepository classFeatures;

    /** Con qué atributo lanza cada clase: de ahí sale la CD. Así el formulario
     *  de "añadir habilidad" no tiene que preguntarlo; se deduce de la clase.
     *  Las claves van normalizadas (minúsculas y SIN acentos), como devuelve
     *  norm(), porque el nombre de la clase llega acentuado ("Clérigo"). */
    private static final Map<String, String> ATRIBUTO_POR_CLASE = Map.of(
            "mago", "Inteligencia",
            "hechicero", "Carisma",
            "bardo", "Carisma",
            "clerigo", "Sabiduría",
            "druida", "Sabiduría",
            "paladin", "Sabiduría",
            "explorador", "Sabiduría");

    /**
     * Conjuros filtrados y paginados EN EL SERVIDOR, para no mandar los ~500 de
     * golpe. Filtra por clase ("Todas" o vacío = todas) y por nombre (sin
     * acentos), ordena por nivel de la clase (o nivel mínimo si son todas) y
     * devuelve solo `limite` a partir de `offset`, más el total del filtro.
     * `limite <= 0` significa "todos".
     */
    @Transactional(readOnly = true)
    public SpellPage hechizos(String clase, String q, int limite, int offset) {
        boolean todas = clase == null || clase.isBlank() || "Todas".equalsIgnoreCase(clase);
        String needle = norm(q);

        List<Spell> filtrados = spells.findAllByOrderByNameAsc().stream()
                .filter(s -> todas || s.getClasses().stream()
                        .anyMatch(c -> c.getClazz().equalsIgnoreCase(clase)))
                .filter(s -> needle.isEmpty()
                        || norm(s.getName()).contains(needle)
                        || norm(s.getNameEn()).contains(needle))
                .sorted(Comparator.comparingInt((Spell s) -> nivelPara(s, todas ? null : clase))
                        .thenComparing(Spell::getName))
                .toList();

        int total = filtrados.size();
        int desde = Math.max(0, offset);
        var stream = filtrados.stream().skip(desde);
        if (limite > 0) stream = stream.limit(limite);
        List<SpellView> items = stream.map(this::toView).toList();

        return new SpellPage(total, items);
    }

    /** Aptitudes de clase (Bárbaro, Guerrero, Monje). Si `clase` viene vacío,
     *  las de todas. Son pocas, así que no se paginan. */
    @Transactional(readOnly = true)
    public List<FeatureView> aptitudes(String clase) {
        var lista = (clase == null || clase.isBlank())
                ? classFeatures.findAllByOrderByClazzAscLevelAscNameAsc()
                : classFeatures.findByClazzIgnoreCaseOrderByLevelAscNameAsc(clase);
        return lista.stream()
                .map(f -> new FeatureView(f.getClazz(), f.getName(), f.getLevel(),
                        f.getKind(), f.getDescription(), f.getSource()))
                .toList();
    }

    /** Nivel por el que ordenar: el de la clase pedida, o el mínimo si son todas. */
    private int nivelPara(Spell s, String clase) {
        if (clase == null) {
            return s.getClasses().stream().mapToInt(SpellClass::getLevel).min().orElse(99);
        }
        return s.getClasses().stream()
                .filter(c -> c.getClazz().equalsIgnoreCase(clase))
                .mapToInt(SpellClass::getLevel).min().orElse(99);
    }

    /** Construye la vista completa de un conjuro. Público para reutilizarlo al
     *  montar la lista de conjuros preparados de un personaje. */
    public SpellView vista(Spell s) {
        return toView(s);
    }

    private SpellView toView(Spell s) {
        List<SpellClassView> clases = s.getClasses().stream()
                .sorted(Comparator.comparingInt(SpellClass::getLevel)
                        .thenComparing(SpellClass::getClazz))
                .map(sc -> new SpellClassView(sc.getClazz(), sc.getLevel(),
                        sc.getKeyAbility(), dcFormula(sc.getLevel(), sc.getKeyAbility())))
                .toList();
        int minLevel = clases.stream().mapToInt(SpellClassView::level).min().orElse(0);
        return new SpellView(
                s.getId().toString(),
                s.getName(), s.getNameEn(), s.getSchool(), s.getSubschool(),
                s.getDescriptors(), s.getDescription(), minLevel,
                s.getComponents(), s.getCastingTime(), s.getSpellRange(),
                s.getTarget(), s.getTargetKind(), s.getDuration(),
                s.getSavingThrow(), s.getSpellResistance(),
                s.getDice(), s.getScaling(), s.getCap(),
                damageSummary(s.getDice(), s.getScaling(), s.getCap()),
                s.getSource(), s.isCustom(), clases);
    }

    /** Minúsculas y sin acentos, para buscar como en el frontend. */
    private String norm(String s) {
        if (s == null) return "";
        String n = Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return n.toLowerCase().trim();
    }

    @Transactional(readOnly = true)
    public List<InvocationView> invocaciones() {
        return invocations.findAllByOrderByGradeOrderAscNameAsc().stream()
                .map(i -> new InvocationView(
                        i.getName(), i.getNameEn(), i.getGrade(), i.getGradeOrder(),
                        i.getSpellLevel(), i.getMinClassLevel(), i.getKind(),
                        i.getSavingThrow(), i.getSpellResistance(),
                        i.getDice(), i.getScaling(), i.getDescription(),
                        i.getKeyAbility(), dcFormula(i.getSpellLevel(), i.getKeyAbility()),
                        i.isAtWill(), i.getSource()))
                .toList();
    }

    // ------------------------------------------------------------------------
    // Conjuros "de la casa": los añade cualquier jugador jugando, y se guardan
    // como un conjuro más (aparecen en su categoría junto a los del SRD).
    // ------------------------------------------------------------------------

    /** Crea un conjuro nuevo y lo asigna a las clases indicadas. Solo el nombre
     *  y al menos una clase son obligatorios; el resto del bloque es opcional.
     *  Devuelve la vista completa, ya lista para pintar en la lista. */
    @Transactional
    public SpellView crearHechizo(SpellCreate req) {
        String nombre = req == null || req.name() == null ? "" : req.name().trim();
        if (nombre.isBlank())
            throw ApiException.badRequest("La habilidad necesita un nombre.");
        if (nombre.length() > 120)
            throw ApiException.badRequest("Ese nombre es demasiado largo.");
        if (req.classes() == null || req.classes().isEmpty())
            throw ApiException.badRequest("Elige al menos una clase que pueda usarla.");
        if (spells.findByNameIgnoreCase(nombre).isPresent())
            throw ApiException.conflict("Ya hay una habilidad con ese nombre.");

        Spell s = new Spell();
        s.setName(nombre);
        s.setNameEn(txt(req.nameEn()));
        s.setSchool(txt(req.school()));
        s.setSubschool(txt(req.subschool()));
        s.setDescriptors(txt(req.descriptors()));
        s.setDescription(txt(req.description()));
        s.setComponents(txt(req.components()));
        s.setCastingTime(txt(req.castingTime()));
        s.setSpellRange(txt(req.range()));
        s.setTarget(txt(req.target()));
        s.setTargetKind(txt(req.targetKind()));
        s.setDuration(txt(req.duration()));
        s.setSavingThrow(txt(req.savingThrow()));
        s.setSpellResistance(txt(req.spellResistance()));
        s.setDice(txt(req.dice()));
        s.setScaling(txt(req.scaling()));
        s.setCap(txt(req.cap()));
        s.setSource("De la casa");
        s.setCustom(true);

        for (SpellClassInput ci : req.classes()) {
            if (ci == null || ci.clazz() == null || ci.clazz().isBlank()) continue;
            String clazz = ci.clazz().trim();
            int level = Math.max(0, Math.min(9, ci.level()));
            SpellClass sc = new SpellClass();
            sc.setSpell(s);
            sc.setClazz(clazz);
            sc.setLevel(level);
            sc.setKeyAbility(ATRIBUTO_POR_CLASE.getOrDefault(norm(clazz), ""));
            s.getClasses().add(sc);
        }
        if (s.getClasses().isEmpty())
            throw ApiException.badRequest("Elige al menos una clase que pueda usarla.");

        spells.save(s);   // cascada: inserta también las spell_classes
        return toView(s);
    }

    /** Borra un conjuro "de la casa". Los del SRD no se tocan. Cualquier jugador
     *  puede borrar los de la casa: es una lista compartida de la mesa. */
    @Transactional
    public void borrarHechizo(UUID id) {
        Spell s = spells.findById(id)
                .orElseThrow(() -> ApiException.notFound("Esa habilidad ya no está."));
        if (!s.isCustom())
            throw ApiException.forbidden("Los conjuros del manual no se pueden borrar.");
        spells.delete(s);   // cascada: borra sus spell_classes (y prepared_spells por FK)
    }

    private String txt(String s) { return s == null ? "" : s.trim(); }

    /** "CD 13 + mod. de Sabiduría" — la fórmula ya resuelta salvo el modificador,
     *  que depende de quién lance. */
    private String dcFormula(int spellLevel, String keyAbility) {
        if (keyAbility == null || keyAbility.isBlank()) return "";
        return "CD " + (10 + spellLevel) + " + mod. de " + keyAbility;
    }

    /** "1d6 por nivel de lanzador (máx. 10d6)". */
    private String damageSummary(String dice, String scaling, String cap) {
        if ((dice == null || dice.isBlank()) && (scaling == null || scaling.isBlank()))
            return "";
        StringBuilder sb = new StringBuilder();
        if (dice != null && !dice.isBlank()) sb.append(dice);
        if (scaling != null && !scaling.isBlank())
            sb.append(sb.isEmpty() ? "" : " ").append(scaling);
        if (cap != null && !cap.isBlank()) sb.append(" (máx. ").append(cap).append(")");
        return sb.toString().trim();
    }
}
