package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.error.ApiException;

/**
 * Los tipos de propiedad que se pueden comprar y su economía, en piezas de
 * cobre (1 po = 100 pc). La renta indicada es la de NIVEL 1; sube proporcional
 * al nivel (nivel N produce base × N por día).
 *
 * Guardamos aquí los números para poder afinar el balance del juego sin tocar
 * la base de datos: la tabla `properties` solo guarda el código del tipo.
 */
public enum PropertyKind {
    //        code            emoji  nombre               precio(pc)  renta/día(pc)  descripción
    TABERNA   ("taberna",     "🍺", "Taberna",              50_000L,    2_500L, "Cerveza, dados y rumores. Renta modesta pero fiable."),
    POSADA    ("posada",      "🏨", "Posada",               80_000L,    3_500L, "Camas calientes para viajeros; se llena las noches de feria."),
    HERRERIA  ("herreria",    "⚒️", "Herrería",             40_000L,    2_000L, "Clavos, herraduras y algún encargo de guerra."),
    TIENDA_MAGIA("tienda_magia","🧙","Tienda de magia",    250_000L,    8_000L, "Pergaminos y baratijas arcanas. Cara de montar, generosa de tener."),
    ESTABLOS  ("establos",    "🐴", "Establos",             30_000L,    1_400L, "Monturas y forraje. Poco glamour, ingreso constante."),
    GRANJA    ("granja",      "🌾", "Granja",               25_000L,    1_200L, "Grano y ganado. Barata y sin sorpresas."),
    MINA      ("mina",        "⛏️", "Mina",                180_000L,    7_000L, "Hierro y quizá algo más brillante. Alto coste, alta renta."),
    PUERTO    ("puerto",      "🚢", "Puerto",              350_000L,   11_000L, "Aranceles y carga. La joya de la corona... si puedes pagarla."),
    GREMIO    ("gremio",      "🏛️", "Gremio",              220_000L,    7_500L, "Cuotas y contratos. El poder tras el mostrador."),
    TEATRO    ("teatro",      "🎭", "Teatro",              120_000L,    4_500L, "Comedia y tragedia por unas monedas."),
    BURDEL    ("burdel",      "🌹", "Burdel",              100_000L,    5_000L, "Discreción, vino y compañía. Rinde de noche.");

    /** Nivel máximo al que se puede mejorar una propiedad. */
    public static final int MAX_LEVEL = 5;

    private final String code;
    private final String emoji;
    private final String nombre;
    private final long basePriceCp;
    private final long incomePerDayCp;
    private final String blurb;

    PropertyKind(String code, String emoji, String nombre,
                 long basePriceCp, long incomePerDayCp, String blurb) {
        this.code = code;
        this.emoji = emoji;
        this.nombre = nombre;
        this.basePriceCp = basePriceCp;
        this.incomePerDayCp = incomePerDayCp;
        this.blurb = blurb;
    }

    public String code()          { return code; }
    public String emoji()         { return emoji; }
    public String nombre()        { return nombre; }
    public long basePriceCp()     { return basePriceCp; }
    public String blurb()         { return blurb; }

    /** Renta diaria (pc) a un nivel dado: la base multiplicada por el nivel. */
    public long incomePerDayCp(int level) {
        return incomePerDayCp * Math.max(1, level);
    }

    /** Coste (pc) de subir del nivel actual al siguiente. null si ya es máximo. */
    public Long upgradeCostCp(int currentLevel) {
        if (currentLevel >= MAX_LEVEL) return null;
        return basePriceCp * currentLevel;   // 2→ base, 3→ 2×base, ...
    }

    /** Total invertido (pc) para tener una propiedad de este tipo a ese nivel:
     *  la compra más todas las mejoras hasta ahí. */
    public long investedCp(int level) {
        long total = basePriceCp;                 // la compra
        for (int l = 1; l < level; l++) total += basePriceCp * l;
        return total;
    }

    /** Lo que paga el mercado al vender: la mitad de lo invertido. */
    public long saleValueCp(int level) {
        return investedCp(level) / 2;
    }

    public static PropertyKind fromCode(String code) {
        for (PropertyKind k : values())
            if (k.code.equalsIgnoreCase(code)) return k;
        throw ApiException.badRequest("Ese tipo de propiedad no existe.");
    }
}
