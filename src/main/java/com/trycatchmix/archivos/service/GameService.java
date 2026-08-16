package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.*;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.*;
import com.trycatchmix.archivos.web.dto.DevDtos.DevFicha;
import com.trycatchmix.archivos.web.dto.DevDtos.DevPersonaje;
import com.trycatchmix.archivos.web.dto.FichaDtos.*;
import com.trycatchmix.archivos.web.dto.GameDtos.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/** Todo el bucle de juego: ver el tablón, firmar, abrir la escena y resolverla. */
@Service
@RequiredArgsConstructor
public class GameService {

    private final GameCharacterRepository characters;
    private final CharacterSkillRepository characterSkills;
    private final QuestRepository quests;
    private final SceneRepository scenes;
    private final SceneOptionRepository options;
    private final OutcomeRepository outcomes;
    private final WorldFlagRepository worldFlags;
    private final QuestRunRepository runs;
    private final DiceService dice;

    // ---------------------------------------------------------- personajes ---

    @Transactional(readOnly = true)
    public List<CharacterView> listCharacters(UUID userId, boolean admin) {
        // El admin (máster) ve toda la mesa; un jugador, solo los suyos.
        var lista = admin
                ? characters.findAllByOrderByNameAsc()
                : characters.findByUserIdOrderByNameAsc(userId);
        return lista.stream()
                .map(c -> new CharacterView(c.getId().toString(), c.getName(), null,
                        c.getClazz(), c.getLevel(), c.getVigor(), c.getMaxVigor(), c.getCity()))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<DevPersonaje> devPersonajes(UUID userId) {
        return characters.findByUserIdOrderByNameAsc(userId).stream()
                .map(c -> new DevPersonaje(c.getId().toString(), c.getName(),
                        c.getClazz(), c.getVigor(), c.getCity()))
                .toList();
    }

    /** La hoja de personaje D&D 3.5 completa. */
    @Transactional(readOnly = true)
    public FichaView ficha(UUID userId, UUID charId, boolean admin) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        return buildFicha(c, c.getSkills());
    }

    /** Editar la ficha. Reemplaza todos los campos editables y la lista de
     *  habilidades entera (el JSON que llega es la verdad). */
    @Transactional
    public FichaView editarFicha(UUID userId, UUID charId, boolean admin, FichaEditRequest r) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);

        // identidad
        if (r.name() != null && !r.name().isBlank()) c.setName(r.name().trim());
        if (r.player() != null) c.setPlayer(r.player());
        if (r.clazz() != null) c.setClazz(r.clazz());
        if (r.level() != null) c.setLevel(r.level());
        if (r.race() != null) c.setRace(r.race());
        if (r.alignment() != null) c.setAlignment(r.alignment());
        if (r.deity() != null) c.setDeity(r.deity());
        if (r.size() != null) c.setSize(r.size());
        if (r.age() != null) c.setAge(r.age());
        if (r.sex() != null) c.setSex(r.sex());
        if (r.height() != null) c.setHeight(r.height());
        if (r.weight() != null) c.setWeight(r.weight());
        if (r.campaign() != null) c.setCampaign(r.campaign());
        if (r.location() != null && !r.location().isBlank()) c.setCity(r.location());
        if (r.domain1() != null) c.setDomain1(r.domain1().trim());
        if (r.domain2() != null) c.setDomain2(r.domain2().trim());

        // características
        if (r.strScore() != null) c.setStrScore(r.strScore());
        if (r.dexScore() != null) c.setDexScore(r.dexScore());
        if (r.conScore() != null) c.setConScore(r.conScore());
        if (r.intScore() != null) c.setIntScore(r.intScore());
        if (r.wisScore() != null) c.setWisScore(r.wisScore());
        if (r.chaScore() != null) c.setChaScore(r.chaScore());

        // combate
        if (r.hpCurrent() != null) c.setHpCurrent(r.hpCurrent());
        if (r.hpMax() != null) c.setPg(r.hpMax());
        if (r.acTotal() != null) c.setCa(r.acTotal());
        if (r.acTouch() != null) c.setAcTouch(r.acTouch());
        if (r.acFlatFooted() != null) c.setAcFlatFooted(r.acFlatFooted());
        if (r.initiativeMisc() != null) c.setInitiativeMisc(r.initiativeMisc());
        if (r.speed() != null) c.setSpeed(r.speed());
        if (r.bab() != null) c.setBab(r.bab());
        if (r.grappleMisc() != null) c.setGrappleMisc(r.grappleMisc());
        if (r.spellResistance() != null) c.setSpellResistance(r.spellResistance());
        if (r.saveFort() != null) c.setSaveFort(r.saveFort());
        if (r.saveRef() != null) c.setSaveRef(r.saveRef());
        if (r.saveWill() != null) c.setSaveWill(r.saveWill());
        if (r.damageReduction() != null) c.setDamageReduction(r.damageReduction());
        if (r.vigor() != null) c.setVigor(r.vigor());
        if (r.maxVigor() != null) c.setMaxVigor(r.maxVigor());
        if (r.purseCp() != null) c.setPurseCp(Math.max(0, r.purseCp()));
        if (r.carga() != null) c.setCarga(r.carga());

        // habilidades: reemplazo completo si viene la lista
        List<CharacterSkill> nuevas;
        if (r.skills() != null) {
            characterSkills.deleteByCharacterId(charId);
            characterSkills.flush();
            nuevas = new ArrayList<>();
            for (var s : r.skills()) {
                if (s.name() == null || s.name().isBlank()) continue;
                CharacterSkill cs = new CharacterSkill();
                cs.setCharacter(c);
                cs.setName(s.name().trim());
                cs.setCode(codeDe(s.name()));
                cs.setKeyAbility(s.keyAbility() == null ? "" : s.keyAbility().toUpperCase());
                cs.setRanks(s.ranks() == null ? 0 : s.ranks());
                cs.setMiscMod(s.miscMod() == null ? 0 : s.miscMod());
                nuevas.add(cs);
            }
            characterSkills.saveAll(nuevas);
        } else {
            nuevas = characterSkills.findByCharacterIdOrderByNameAsc(charId);
        }

        return buildFicha(c, nuevas);
    }

    /** Crear un personaje nuevo del usuario que ha entrado. Solo el nombre es
     *  obligatorio; el resto usa valores por defecto sensatos (afinables luego
     *  en la ficha). Los PG arrancan a tope y el vigor lleno. */
    @Transactional
    public FichaView crearPersonaje(UUID userId, CharacterCreateRequest r) {
        if (r == null || r.name() == null || r.name().isBlank())
            throw ApiException.conflict("Ponle un nombre al personaje.");

        GameCharacter c = new GameCharacter();
        c.setUserId(userId);
        c.setName(r.name().trim());
        c.setClazz(textoOr(r.clazz(), "Aventurero"));
        c.setCity(textoOr(r.city(), "Dorakan"));
        c.setLevel(r.level() == null || r.level() < 1 ? 1 : r.level());

        // Identidad opcional
        if (r.race() != null) c.setRace(r.race().trim());
        if (r.alignment() != null) c.setAlignment(r.alignment().trim());
        if (r.player() != null) c.setPlayer(r.player().trim());

        // Características (por defecto 10 si no vienen)
        if (r.strScore() != null) c.setStrScore(r.strScore());
        if (r.dexScore() != null) c.setDexScore(r.dexScore());
        if (r.conScore() != null) c.setConScore(r.conScore());
        if (r.intScore() != null) c.setIntScore(r.intScore());
        if (r.wisScore() != null) c.setWisScore(r.wisScore());
        if (r.chaScore() != null) c.setChaScore(r.chaScore());

        // Combate básico
        int pg = r.hpMax() == null ? 8 : Math.max(1, r.hpMax());
        c.setPg(pg);
        c.setHpCurrent(pg);                 // arranca a tope de vida
        if (r.acTotal() != null) c.setCa(r.acTotal());
        int vig = r.maxVigor() == null ? 8 : Math.max(0, r.maxVigor());
        c.setMaxVigor(vig);
        c.setVigor(vig);                    // y con el vigor lleno

        characters.save(c);
        return buildFicha(c, List.of());
    }

    private String textoOr(String v, String porDefecto) {
        return v == null || v.isBlank() ? porDefecto : v.trim();
    }

    @Transactional(readOnly = true)
    public DevFicha devFicha(UUID userId, UUID charId) {
        GameCharacter c = ownedCharacter(userId, charId);
        Map<String, Integer> hab = new LinkedHashMap<>();
        c.getSkills().forEach(s -> hab.put(s.getName(), c.skillTotal(s)));
        return new DevFicha(c.getPg(), c.getCa(), c.getVigor(),
                Money.format(c.getPurseCp()), c.getCarga(), hab);
    }

    private FichaView buildFicha(GameCharacter c, List<CharacterSkill> skillList) {
        List<AbilityView> abilities = List.of(
                new AbilityView("FUE", "Fuerza",       c.getStrScore(), c.abilityMod("FUE")),
                new AbilityView("DES", "Destreza",      c.getDexScore(), c.abilityMod("DES")),
                new AbilityView("CON", "Constitución",  c.getConScore(), c.abilityMod("CON")),
                new AbilityView("INT", "Inteligencia",  c.getIntScore(), c.abilityMod("INT")),
                new AbilityView("SAB", "Sabiduría",     c.getWisScore(), c.abilityMod("SAB")),
                new AbilityView("CAR", "Carisma",       c.getChaScore(), c.abilityMod("CAR")));

        List<SkillDetailView> skills = skillList.stream()
                .sorted(Comparator.comparing(CharacterSkill::getName))
                .map(s -> new SkillDetailView(s.getName(), s.getCode(), s.getKeyAbility(),
                        s.getRanks(), s.getMiscMod(), c.skillTotal(s)))
                .toList();

        int initiative = c.abilityMod("DES") + c.getInitiativeMisc();
        int grapple = c.getBab() + c.abilityMod("FUE") + c.getGrappleMisc();

        return new FichaView(
                c.getId().toString(),
                c.getName(), c.getPlayer(), c.getClazz(), c.getLevel(), c.getRace(),
                c.getAlignment(), c.getDeity(), c.getSize(), c.getAge(), c.getSex(),
                c.getHeight(), c.getWeight(), c.getCampaign(), c.getCity(),
                c.getDomain1(), c.getDomain2(),
                abilities,
                c.getHpCurrent(), c.getPg(),
                c.getCa(), c.getAcTouch(), c.getAcFlatFooted(),
                initiative, c.getInitiativeMisc(),
                c.getSpeed(),
                c.getBab(), grapple, c.getGrappleMisc(),
                c.getSpellResistance(),
                c.getSaveFort(), c.getSaveRef(), c.getSaveWill(),
                c.getDamageReduction(),
                c.getVigor(), c.getMaxVigor(), c.getPurseCp(), Money.format(c.getPurseCp()), c.getCarga(),
                skills);
    }

    /** Código en minúsculas y sin espacios para casar con las opciones de escena. */
    private String codeDe(String name) {
        return name.trim().toLowerCase()
                .replace('á', 'a').replace('é', 'e').replace('í', 'i')
                .replace('ó', 'o').replace('ú', 'u').replace('ñ', 'n')
                .replaceAll("[^a-z0-9]+", "_");
    }

    // -------------------------------------------------------------- tablón ---

    @Transactional(readOnly = true)
    public List<QuestCardView> tablon(UUID userId, UUID charId) {
        GameCharacter c = ownedCharacter(userId, charId);
        Optional<QuestRun> abierta = runs.findByCharacterIdAndStatus(charId, RunStatus.IN_PROGRESS);
        UUID enCursoQuestId = abierta.map(QuestRun::getQuestId).orElse(null);

        return quests.findByLocationAndPublishedTrueOrderByTitleAsc(c.getCity()).stream()
                .map(q -> toCard(q, enCursoQuestId))
                .toList();
    }

    private QuestCardView toCard(Quest q, UUID enCursoQuestId) {
        String bloqueo = bloqueoDe(q);
        String availability;
        String reason = null;

        if (bloqueo != null) {
            availability = "BLOCKED_BY_WORLD";
            reason = bloqueo;
        } else if (q.getId().equals(enCursoQuestId)) {
            availability = "JOINED";
        } else {
            availability = "AVAILABLE";
        }

        return new QuestCardView(
                q.getId().toString(), q.getTitle(), q.getFaction(), q.getHook(),
                skillTags(q), q.getVigorCost(), q.getDuration(), q.getSceneCount(),
                q.getRewardNote(), null, null, availability, reason);
    }

    /** Devuelve la etiqueta del requisito si el encargo está bloqueado, o null. */
    private String bloqueoDe(Quest q) {
        if (q.getRequiredFlag() == null) return null;
        boolean esperado = q.getRequiredFlagState() == null || q.getRequiredFlagState();
        boolean real = worldFlags.findById(q.getRequiredFlag()).map(WorldFlag::isState).orElse(false);
        if (real == esperado) return null;
        return q.getRequirementLabel() != null ? q.getRequirementLabel() : "Requiere: " + q.getRequiredFlag();
    }

    private List<String> skillTags(Quest q) {
        if (q.getSkillTags() == null || q.getSkillTags().isBlank()) return List.of();
        return Arrays.stream(q.getSkillTags().split(",")).map(String::trim).filter(s -> !s.isEmpty()).toList();
    }

    // -------------------------------------------------------------- firmar ---

    @Transactional
    public SceneView firmar(UUID userId, UUID charId, UUID questId) {
        GameCharacter c = ownedCharacter(userId, charId);
        Quest q = quests.findById(questId)
                .orElseThrow(() -> ApiException.notFound("No existe ese encargo."));

        if (!q.isPublished())
            throw ApiException.conflict("Ese encargo no está disponible.");

        String bloqueo = bloqueoDe(q);
        if (bloqueo != null) throw ApiException.blocked(bloqueo);

        Optional<QuestRun> abierta = runs.findByCharacterIdAndStatus(charId, RunStatus.IN_PROGRESS);
        if (abierta.isPresent()) {
            if (abierta.get().getQuestId().equals(questId))
                return escenaDe(q, currentScene(abierta.get()), c);   // ya dentro: continúa
            throw ApiException.conflict("Ya estás en otro encargo. Termínalo antes de firmar otro.");
        }

        Scene primera = q.getScenes().stream()
                .min(Comparator.comparingInt(Scene::getOrdinal))
                .orElseThrow(() -> ApiException.conflict("Ese encargo no tiene escenas todavía."));

        QuestRun run = new QuestRun();
        run.setCharacterId(charId);
        run.setQuestId(questId);
        run.setCurrentSceneId(primera.getId());
        run.setStatus(RunStatus.IN_PROGRESS);
        runs.save(run);

        return escenaDe(q, primera, c);
    }

    // -------------------------------------------------------------- escena ---

    @Transactional(readOnly = true)
    public SceneView escenaActual(UUID userId, UUID charId) {
        GameCharacter c = ownedCharacter(userId, charId);
        QuestRun run = runs.findByCharacterIdAndStatus(charId, RunStatus.IN_PROGRESS)
                .orElseThrow(() -> ApiException.notFound("No tienes ningún encargo abierto."));
        Quest q = quests.findById(run.getQuestId())
                .orElseThrow(() -> ApiException.notFound("El encargo ya no existe."));
        return escenaDe(q, currentScene(run), c);
    }

    private Scene currentScene(QuestRun run) {
        return scenes.findById(run.getCurrentSceneId())
                .orElseThrow(() -> ApiException.conflict("Tu escena actual ya no existe."));
    }

    private SceneView escenaDe(Quest q, Scene sc, GameCharacter c) {
        List<SceneOptionView> opts = sc.getOptions().stream().map(op -> {
            boolean tira = op.getSkill() != null && op.getDc() != null;
            int mod = tira ? skillMod(c, op.getSkill()) : 0;
            Integer chance = tira ? dice.successChance(mod, op.getModifiers(), op.getDc()) : null;
            String skillLabel = op.getSkill() == null ? null : skillLabel(c, op.getSkill());
            return new SceneOptionView(
                    op.getId().toString(), op.getLabel(), skillLabel, op.getDc(), chance,
                    op.getVigorCost(), c.getVigor() >= op.getVigorCost(), op.getRisk(), op.getNote());
        }).toList();

        return new SceneView(q.getTitle(), sc.getOrdinal(), q.getSceneCount(),
                sc.getTitle(), sc.getBody(), null, opts);
    }

    // -------------------------------------------------------------- elegir ---

    @Transactional
    public ResolutionView elegir(UUID userId, UUID charId, UUID optionId) {
        GameCharacter c = ownedCharacter(userId, charId);
        QuestRun run = runs.findByCharacterIdAndStatus(charId, RunStatus.IN_PROGRESS)
                .orElseThrow(() -> ApiException.conflict("No tienes ningún encargo abierto."));

        SceneOption op = options.findById(optionId)
                .orElseThrow(() -> ApiException.notFound("Esa opción no existe."));
        if (!op.getScene().getId().equals(run.getCurrentSceneId()))
            throw ApiException.conflict("Esa opción no es de tu escena actual.");

        if (c.getVigor() < op.getVigorCost())
            throw ApiException.conflict("Te falta Vigor para eso.");

        boolean tira = op.getSkill() != null && op.getDc() != null;
        RollView roll = null;
        int grade;
        if (tira) {
            roll = dice.roll(skillLabel(c, op.getSkill()), skillMod(c, op.getSkill()),
                    op.getModifiers(), op.getDc());
            grade = roll.grade();
        } else {
            grade = 4;   // opción sin tirada: éxito directo
        }

        Outcome outcome = resolveOutcome(op, grade);

        List<String> changes = new ArrayList<>();
        if (op.getVigorCost() > 0) {
            c.setVigor(Math.max(0, c.getVigor() - op.getVigorCost()));
            changes.add("Vigor -" + op.getVigorCost());
        }

        boolean finished = outcome.isEndsQuest() || outcome.getNextSceneId() == null;
        if (finished) {
            run.setStatus(RunStatus.FINISHED);
        } else {
            run.setCurrentSceneId(outcome.getNextSceneId());
        }

        return new ResolutionView(roll, outcome.getNarrative(), changes, finished, null);
    }

    /** Busca el desenlace del grado exacto; si falta, el más cercano por debajo. */
    private Outcome resolveOutcome(SceneOption op, int grade) {
        return outcomes.findByOptionIdAndGrade(op.getId(), grade)
                .orElseGet(() -> op.getOutcomes().stream()
                        .min(Comparator.comparingInt(o -> Math.abs(o.getGrade() - grade)))
                        .orElseThrow(() -> ApiException.conflict("Esa opción no tiene desenlaces.")));
    }

    // --------------------------------------------------------------- utils ---

    private GameCharacter ownedCharacter(UUID userId, UUID charId) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }

    /** Igual que {@link #accessibleCharacter}, expuesto para que otros servicios
     *  (conjuros preparados) reusen el MISMO control de propiedad: dueño o DM. */
    public GameCharacter accesible(UUID userId, UUID charId, boolean admin) {
        return accessibleCharacter(userId, charId, admin);
    }

    /** Como {@link #ownedCharacter} pero el admin (máster) pasa el filtro para
     *  cualquier personaje: es quien lleva la mesa. */
    private GameCharacter accessibleCharacter(UUID userId, UUID charId, boolean admin) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!admin && !c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }

    private int skillMod(GameCharacter c, String code) {
        return c.getSkills().stream()
                .filter(s -> s.getCode().equalsIgnoreCase(code))
                .mapToInt(c::skillTotal)
                .findFirst().orElse(0);
    }

    private String skillLabel(GameCharacter c, String code) {
        return c.getSkills().stream()
                .filter(s -> s.getCode().equalsIgnoreCase(code))
                .map(CharacterSkill::getName)
                .findFirst()
                .orElseGet(() -> code.substring(0, 1).toUpperCase() + code.substring(1));
    }
}
