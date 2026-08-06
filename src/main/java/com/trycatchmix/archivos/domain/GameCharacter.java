package com.trycatchmix.archivos.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/** Un personaje jugable. Se llama GameCharacter para no chocar con java.lang.Character. */
@Entity
@Table(name = "characters")
@Getter @Setter
public class GameCharacter {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(nullable = false)
    private String name;

    /** La clase de juego: "Bárbaro", "Pícara"… Se muestra como `role`/`clase`. */
    @Column(name = "clazz", nullable = false)
    private String clazz;

    @Column(nullable = false)
    private String city;

    @Column(nullable = false)
    private int level = 1;

    @Column(nullable = false)
    private int vigor = 10;

    @Column(name = "max_vigor", nullable = false)
    private int maxVigor = 10;

    /** Puntos de golpe y clase de armadura, para la ficha del script. */
    @Column(nullable = false)
    private int pg = 10;

    @Column(nullable = false)
    private int ca = 10;

    /** El monedero, en piezas de cobre (la unidad base). Se formatea a
     *  "214 po · 6 pp · 2 pc" para mostrarlo (ver Money). */
    @Column(name = "purse_cp", nullable = false)
    private long purseCp = 0;

    /** Texto libre de respaldo. Ya no se usa para mostrar la bolsa: esa se
     *  deriva de purseCp para que no se desincronice tras comprar. */
    @Column(nullable = false)
    private String bolsa = "";

    /** "61 lb / 86 lb ligera". */
    @Column(nullable = false)
    private String carga = "";

    // ===================== Hoja de personaje D&D 3.5 =====================

    // --- Identidad ---
    @Column(nullable = false) private String player = "";
    @Column(nullable = false) private String race = "";
    @Column(nullable = false) private String alignment = "";
    @Column(nullable = false) private String deity = "";
    @Column(nullable = false) private String size = "Mediano";
    @Column(nullable = false) private String age = "";
    @Column(nullable = false) private String sex = "";
    @Column(nullable = false) private String height = "";
    @Column(nullable = false) private String weight = "";
    @Column(nullable = false) private String campaign = "";

    // --- Características (la puntuación; el modificador se calcula) ---
    @Column(name = "str_score", nullable = false) private int strScore = 10;
    @Column(name = "dex_score", nullable = false) private int dexScore = 10;
    @Column(name = "con_score", nullable = false) private int conScore = 10;
    @Column(name = "int_score", nullable = false) private int intScore = 10;
    @Column(name = "wis_score", nullable = false) private int wisScore = 10;
    @Column(name = "cha_score", nullable = false) private int chaScore = 10;

    // --- Combate --- (pg = PG máx, ca = CA total; editables directos)
    @Column(name = "hp_current", nullable = false)   private int hpCurrent = 0;
    @Column(name = "ac_touch", nullable = false)     private int acTouch = 10;
    @Column(name = "ac_flat_footed", nullable = false) private int acFlatFooted = 10;
    @Column(name = "initiative_misc", nullable = false) private int initiativeMisc = 0;
    @Column(nullable = false)                        private int speed = 30;
    @Column(nullable = false)                        private int bab = 0;   // ataque base
    @Column(name = "grapple_misc", nullable = false) private int grappleMisc = 0;
    @Column(name = "spell_resistance", nullable = false) private int spellResistance = 0;
    @Column(name = "save_fort", nullable = false)    private int saveFort = 0;
    @Column(name = "save_ref", nullable = false)     private int saveRef = 0;
    @Column(name = "save_will", nullable = false)    private int saveWill = 0;
    @Column(name = "damage_reduction", nullable = false) private String damageReduction = "";

    @OneToMany(mappedBy = "character", fetch = FetchType.EAGER)
    @OrderBy("name ASC")
    private List<CharacterSkill> skills = new ArrayList<>();

    // ---- Cálculos derivados (no se guardan) ----

    /** Modificador de una característica: floor((puntuación - 10) / 2). */
    public int abilityMod(String key) {
        int score = switch (key == null ? "" : key.toUpperCase()) {
            case "FUE" -> strScore;
            case "DES" -> dexScore;
            case "CON" -> conScore;
            case "INT" -> intScore;
            case "SAB" -> wisScore;
            case "CAR" -> chaScore;
            default -> 10;
        };
        return Math.floorDiv(score - 10, 2);
    }

    /** Total de una habilidad = mod. de característica + rangos + varios. */
    public int skillTotal(CharacterSkill s) {
        int base = (s.getKeyAbility() == null || s.getKeyAbility().isBlank())
                ? 0 : abilityMod(s.getKeyAbility());
        return base + s.getRanks() + s.getMiscMod();
    }
}
