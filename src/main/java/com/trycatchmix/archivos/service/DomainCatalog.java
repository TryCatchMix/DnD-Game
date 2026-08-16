package com.trycatchmix.archivos.service;

import java.util.List;

/**
 * Los 21 dominios divinos del SRD 3.5 (Open Game Content, OGL). Un clérigo
 * elige dos: cada uno da un poder otorgado (la «pasiva») y una lista de nueve
 * conjuros de dominio, uno por nivel de conjuro (1..9).
 *
 * Igual que {@code PropertyKind}, los datos viven en código, no en la BD.
 * Los conjuros se guardan por su NOMBRE EN INGLÉS del SRD para resolverlos
 * contra {@code spells.name_en} (DomainService) y así enlazarlos al grimorio
 * en español; los que no scrapeamos (casi todos de la lista de druida) se
 * muestran como simple referencia.
 */
public final class DomainCatalog {
    private DomainCatalog() {}

    /** Un dominio: código, nombre en español, poder otorgado y sus 9 conjuros
     *  (índice 0 = nivel 1 … índice 8 = nivel 9), por nombre inglés del SRD. */
    public record DomainDef(String code, String nombre, String poder, List<String> spellsEn) {}

    public static final List<DomainDef> TODOS = List.of(
        new DomainDef("air", "Aire", "Expulsas o destruyes criaturas de tierra como un clérigo bueno expulsa a los muertos vivientes; y dominas o refuerzas criaturas de aire como uno malvado. Usable un total de 3 + tu mod. de Carisma veces al día (aptitud sobrenatural).",
            List.of("Obscuring Mist", "Wind Wall", "Gaseous Form", "Air Walk", "Control Winds", "Chain Lightning", "Control Weather", "Whirlwind", "Elemental Swarm")),
        new DomainDef("animal", "Animal", "Puedes usar hablar con los animales una vez al día como aptitud mágica.",
            List.of("Calm Animals", "Hold Animal", "Dominate Animal", "Summon Nature's Ally IV", "Commune with Nature", "Antilife Shell", "Animal Shapes", "Summon Nature's Ally VIII", "Shapechange")),
        new DomainDef("chaos", "Caos", "Lanzas los conjuros con el descriptor Caótico a +1 nivel de lanzador.",
            List.of("Protection from Law", "Shatter", "Magic Circle against Law", "Chaos Hammer", "Dispel Law", "Animate Objects", "Word of Chaos", "Cloak of Chaos", "Summon Monster IX")),
        new DomainDef("death", "Muerte", "Una vez al día puedes usar un toque mortal (aptitud sobrenatural con efecto de muerte). Con un ataque de toque cuerpo a cuerpo a una criatura viva, tira 1d6 por nivel de clérigo: si el total iguala o supera sus PG actuales, muere (sin salvación).",
            List.of("Cause Fear", "Death Knell", "Animate Dead", "Death Ward", "Slay Living", "Create Undead", "Destruction", "Create Greater Undead", "Wail of the Banshee")),
        new DomainDef("destruction", "Destrucción", "Obtienes la aptitud de golpe certero: una vez al día, un único ataque cuerpo a cuerpo con +4 a impactar y un bono al daño igual a tu nivel de clérigo (si impactas). Debes declararlo antes de atacar.",
            List.of("Inflict Light Wounds", "Shatter", "Contagion", "Inflict Critical Wounds", "Inflict Light Wounds, Mass", "Harm", "Disintegrate", "Earthquake", "Implosion")),
        new DomainDef("earth", "Tierra", "Expulsas o destruyes criaturas de aire como un clérigo bueno expulsa a los muertos vivientes; y dominas o refuerzas criaturas de tierra como uno malvado. Usable un total de 3 + tu mod. de Carisma veces al día (aptitud sobrenatural).",
            List.of("Magic Stone", "Soften Earth and Stone", "Stone Shape", "Spike Stones", "Wall of Stone", "Stoneskin", "Earthquake", "Iron Body", "Elemental Swarm")),
        new DomainDef("evil", "Maldad", "Lanzas los conjuros con el descriptor Maligno a +1 nivel de lanzador.",
            List.of("Protection from Good", "Desecrate", "Magic Circle against Good", "Unholy Blight", "Dispel Good", "Create Undead", "Blasphemy", "Unholy Aura", "Summon Monster IX")),
        new DomainDef("fire", "Fuego", "Expulsas o destruyes criaturas de agua como un clérigo bueno expulsa a los muertos vivientes; y dominas o refuerzas criaturas de fuego como uno malvado. Usable un total de 3 + tu mod. de Carisma veces al día (aptitud sobrenatural).",
            List.of("Burning Hands", "Produce Flame", "Resist Energy", "Wall of Fire", "Fire Shield", "Fire Seeds", "Fire Storm", "Incendiary Cloud", "Elemental Swarm")),
        new DomainDef("good", "Bien", "Lanzas los conjuros con el descriptor Bueno a +1 nivel de lanzador.",
            List.of("Protection from Evil", "Aid", "Magic Circle against Evil", "Holy Smite", "Dispel Evil", "Blade Barrier", "Holy Word", "Holy Aura", "Summon Monster IX")),
        new DomainDef("healing", "Curación", "Lanzas los conjuros de curación a +1 nivel de lanzador.",
            List.of("Cure Light Wounds", "Cure Moderate Wounds", "Cure Serious Wounds", "Cure Critical Wounds", "Cure Light Wounds, Mass", "Heal", "Regenerate", "Cure Critical Wounds, Mass", "Heal, Mass")),
        new DomainDef("knowledge", "Conocimiento", "Añades todas las habilidades de Conocimiento a tu lista de habilidades de clase.",
            List.of("Detect Secret Doors", "Detect Thoughts", "Clairaudience/Clairvoyance", "Divination", "True Seeing", "Find the Path", "Legend Lore", "Discern Location", "Foresight")),
        new DomainDef("law", "Ley", "Lanzas los conjuros con el descriptor Legal a +1 nivel de lanzador.",
            List.of("Protection from Chaos", "Calm Emotions", "Magic Circle against Chaos", "Order's Wrath", "Dispel Chaos", "Hold Monster", "Dictum", "Shield of Law", "Summon Monster IX")),
        new DomainDef("luck", "Suerte", "Obtienes el poder de la buena fortuna, una vez al día (aptitud extraordinaria): puedes repetir una tirada recién hecha, antes de que el DM diga si es éxito o fracaso. Debes quedarte con el segundo resultado, aunque sea peor.",
            List.of("Entropic Shield", "Aid", "Protection from Energy", "Freedom of Movement", "Break Enchantment", "Mislead", "Spell Turning", "Moment of Prescience", "Miracle")),
        new DomainDef("magic", "Magia", "Usas pergaminos, varitas y demás objetos de activación por conjuro (completar o activar conjuro) como un mago de la mitad de tu nivel de clérigo (mínimo 1). Si además eres mago, los niveles se suman a este efecto.",
            List.of("Magic Aura", "Identify", "Dispel Magic", "Imbue with Spell Ability", "Spell Resistance", "Antimagic Field", "Spell Turning", "Protection from Spells", "Mage's Disjunction")),
        new DomainDef("plant", "Vegetal", "Dominas o expulsas criaturas vegetales como un clérigo malvado domina a los muertos vivientes. Usable un total de 3 + tu mod. de Carisma veces al día (aptitud sobrenatural).",
            List.of("Entangle", "Barkskin", "Plant Growth", "Command Plants", "Wall of Thorns", "Repel Wood", "Animate Plants", "Control Plants", "Shambler")),
        new DomainDef("protection", "Protección", "Puedes generar una salvaguarda protectora (aptitud sobrenatural): con una acción estándar, otorgas a quien toques un bono de resistencia igual a tu nivel de clérigo en su próxima salvación. Dura 1 hora, una vez al día.",
            List.of("Sanctuary", "Shield Other", "Protection from Energy", "Spell Immunity", "Spell Resistance", "Antimagic Field", "Repulsion", "Mind Blank", "Prismatic Sphere")),
        new DomainDef("strength", "Fuerza", "Puedes realizar una proeza de fuerza (aptitud sobrenatural): ganas un bono de mejora a la Fuerza igual a tu nivel de clérigo. Es una acción libre, dura 1 asalto y se usa una vez al día.",
            List.of("Enlarge Person", "Bull's Strength", "Magic Vestment", "Spell Immunity", "Righteous Might", "Stoneskin", "Grasping Hand", "Clenched Fist", "Crushing Hand")),
        new DomainDef("sun", "Sol", "Una vez al día puedes realizar una expulsión mayor contra los muertos vivientes en lugar de una normal: los que serían expulsados quedan destruidos.",
            List.of("Endure Elements", "Heat Metal", "Searing Light", "Fire Shield", "Flame Strike", "Fire Seeds", "Sunbeam", "Sunburst", "Prismatic Sphere")),
        new DomainDef("travel", "Viaje", "Durante 1 asalto por nivel de clérigo al día puedes actuar con normalidad pese a los efectos mágicos que impidan el movimiento, como si te afectara libertad de movimiento. Se activa solo cuando hace falta y puede usarse varias veces al día hasta agotar los asaltos.",
            List.of("Longstrider", "Locate Object", "Fly", "Dimension Door", "Teleport", "Find the Path", "Teleport, Greater", "Phase Door", "Astral Projection")),
        new DomainDef("trickery", "Engaño", "Añades Engañar, Disfrazarse y Esconderse a tu lista de habilidades de clase.",
            List.of("Disguise Self", "Invisibility", "Nondetection", "Confusion", "False Vision", "Mislead", "Screen", "Polymorph Any Object", "Time Stop")),
        new DomainDef("war", "Guerra", "Obtienes gratis Competencia con arma marcial (el arma predilecta de tu deidad, si hace falta) y Soltura con esa misma arma.",
            List.of("Magic Weapon", "Spiritual Weapon", "Magic Vestment", "Divine Power", "Flame Strike", "Blade Barrier", "Power Word Blind", "Power Word Stun", "Power Word Kill")),
        new DomainDef("water", "Agua", "Expulsas o destruyes criaturas de fuego como un clérigo bueno expulsa a los muertos vivientes; y dominas o refuerzas criaturas de agua como uno malvado. Usable un total de 3 + tu mod. de Carisma veces al día (aptitud sobrenatural).",
            List.of("Obscuring Mist", "Fog Cloud", "Water Breathing", "Control Water", "Ice Storm", "Cone of Cold", "Acid Fog", "Horrid Wilting", "Elemental Swarm"))
    );

    public static DomainDef porCodigo(String code) {
        if (code == null) return null;
        return TODOS.stream().filter(d -> d.code().equalsIgnoreCase(code.trim()))
                .findFirst().orElse(null);
    }
}
