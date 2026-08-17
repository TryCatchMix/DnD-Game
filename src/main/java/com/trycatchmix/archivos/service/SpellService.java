package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.CustomAbility;
import com.trycatchmix.archivos.domain.Invocation;
import com.trycatchmix.archivos.domain.Spell;
import com.trycatchmix.archivos.domain.SpellClass;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.ClassFeatureRepository;
import com.trycatchmix.archivos.repo.CustomAbilityRepository;
import com.trycatchmix.archivos.repo.InvocationRepository;
import com.trycatchmix.archivos.repo.SpellRepository;
import com.trycatchmix.archivos.web.dto.SpellDtos.CustomAbilityCreate;
import com.trycatchmix.archivos.web.dto.SpellDtos.CustomAbilityView;
import com.trycatchmix.archivos.web.dto.SpellDtos.FeatureView;
import com.trycatchmix.archivos.web.dto.SpellDtos.InvocationView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellClassView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellPage;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.util.Comparator;
import java.util.List;
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
    private final CustomAbilityRepository customAbilities;

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
                s.getName(), s.getNameEn(), s.getSchool(), s.getSubschool(),
                s.getDescriptors(), s.getDescription(), minLevel,
                s.getComponents(), s.getCastingTime(), s.getSpellRange(),
                s.getTarget(), s.getTargetKind(), s.getDuration(),
                s.getSavingThrow(), s.getSpellResistance(),
                s.getDice(), s.getScaling(), s.getCap(),
                damageSummary(s.getDice(), s.getScaling(), s.getCap()),
                s.getSource(), clases);
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
    // Habilidades personalizadas ("de la casa"): las añade cualquier jugador.
    // ------------------------------------------------------------------------

    /** Todas las personalizadas, las más nuevas arriba. `viewer` sirve para
     *  marcar cuáles son de quien mira (y puede así borrarlas cómodamente). */
    @Transactional(readOnly = true)
    public List<CustomAbilityView> personalizadas(UUID viewer) {
        return customAbilities.findAllByOrderByCreatedAtDesc().stream()
                .map(a -> toCustomView(a, viewer))
                .toList();
    }

    /** Crea una habilidad personalizada. Solo el nombre es obligatorio. */
    @Transactional
    public CustomAbilityView crearPersonalizada(UUID userId, String userName, CustomAbilityCreate req) {
        String nombre = req == null || req.name() == null ? "" : req.name().trim();
        if (nombre.isBlank())
            throw ApiException.badRequest("La habilidad necesita un nombre.");
        if (nombre.length() > 120)
            throw ApiException.badRequest("Ese nombre es demasiado largo.");

        CustomAbility a = new CustomAbility();
        a.setName(nombre);
        a.setKind(req.kind() == null ? "" : req.kind().trim());
        a.setDescription(req.description() == null ? "" : req.description().trim());
        a.setCreatedBy(userId);
        a.setCreatedByName(userName == null ? "" : userName);
        customAbilities.save(a);

        return toCustomView(a, userId);
    }

    /** Borra una personalizada. Cualquier jugador puede hacerlo: es una lista
     *  compartida de la mesa y lo importante es que sea fácil de mantener. */
    @Transactional
    public void borrarPersonalizada(UUID id) {
        if (!customAbilities.existsById(id))
            throw ApiException.notFound("Esa habilidad ya no está.");
        customAbilities.deleteById(id);
    }

    private CustomAbilityView toCustomView(CustomAbility a, UUID viewer) {
        return new CustomAbilityView(
                a.getId().toString(), a.getName(), a.getKind(), a.getDescription(),
                a.getCreatedByName(), a.getCreatedBy().equals(viewer));
    }

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
