package com.trycatchmix.archivos.service;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Sube o baja de nivel a una criatura que tiene niveles de clase.
 *
 * QUÉ SE PUEDE CALCULAR Y QUÉ NO. En D&D 3.5, subir un nivel de clase cambia
 * unas cosas de forma determinista —los dados de golpe, el ataque base, las
 * salvaciones base— y otras que son una ELECCIÓN del jugador: qué dote coges,
 * dónde metes el +1 de característica cada cuatro niveles, en qué gastas los
 * puntos de habilidad. Esto calcula lo primero y AVISA de lo segundo, en vez
 * de inventarse una respuesta.
 *
 * Cuidado con los dados de golpe: muchas criaturas mezclan dados RACIALES con
 * los de clase ("8d8+56 más 10d4+70"). Solo se toca el grupo de la clase, que
 * se reconoce porque su número de dados coincide con el nivel y su dado con el
 * de la clase.
 */
public final class LevelScaler {
    private LevelScaler() {}

    /** "8d8+56", "10d4+70", "1d8" — un grupo de dados con su bonificador. */
    private static final Pattern GRUPO = Pattern.compile("(\\d+)d(\\d+)\\s*([+\\-−]\\s*\\d+)?");
    /** El bonificador de un ataque: "+12 cuerpo a cuerpo", "−1 a distancia". */
    private static final Pattern ATAQUE =
            Pattern.compile("([+\\-−]\\s*\\d+)(?=\\s*(?:cuerpo a cuerpo|a distancia))");
    private static final Pattern SALVACION =
            Pattern.compile("(Fort|Ref|Vol)\\s*([+\\-−]\\s*\\d+)", Pattern.CASE_INSENSITIVE);
    private static final Pattern CARACTERISTICA =
            Pattern.compile("(Fue|Des|Con|Int|Sab|Car)\\s+(\\d+|Ø)", Pattern.CASE_INSENSITIVE);

    /** Niveles de personaje a los que se gana una dote. */
    private static final int[] NIVELES_DOTE = {1, 3, 6, 9, 12, 15, 18};
    /** Niveles a los que se sube +1 una característica. */
    private static final int[] NIVELES_CARACT = {4, 8, 12, 16, 20};

    /** Un grupo de dados de golpe ya leído. */
    public record Dados(int cantidad, int caras, int bono, int desde, int hasta) {
        public int media() {
            return (int) Math.floor(cantidad * (caras + 1) / 2.0) + bono;
        }
    }

    /** El modificador de una característica del bloque ("Con 14" -> +2). */
    public static Integer modificador(String abilities, String cual) {
        Matcher m = CARACTERISTICA.matcher(abilities == null ? "" : abilities);
        while (m.find()) {
            if (m.group(1).equalsIgnoreCase(cual)) {
                if (m.group(2).equals("Ø")) return null;   // sin característica
                return Math.floorDiv(Integer.parseInt(m.group(2)) - 10, 2);
            }
        }
        return null;
    }

    /** Todos los grupos de dados de una línea de dados de golpe. */
    public static List<Dados> grupos(String hitDice) {
        List<Dados> fuera = new ArrayList<>();
        Matcher m = GRUPO.matcher(hitDice == null ? "" : hitDice);
        while (m.find()) {
            fuera.add(new Dados(Integer.parseInt(m.group(1)), Integer.parseInt(m.group(2)),
                    entero(m.group(3)), m.start(), m.end()));
        }
        return fuera;
    }

    /**
     * Cuál de los grupos es el de la clase: el que tiene tantos dados como
     * niveles y del tamaño que le toca. Si hay dos iguales (un troll explorador
     * tiene 6d8 raciales y 6d8 de clase) vale el último, que es el de clase.
     * Devuelve -1 si no se reconoce ninguno.
     */
    public static int indiceDeClase(List<Dados> grupos, int nivel, int dadoDeClase) {
        for (int i = grupos.size() - 1; i >= 0; i--) {
            Dados d = grupos.get(i);
            if (d.cantidad() == nivel && d.caras() == dadoDeClase) return i;
        }
        return -1;
    }

    /**
     * Reescribe la línea de dados de golpe para el nivel pedido.
     *
     * El bonificador del grupo de clase es el modificador de Constitución por
     * nivel, así que se recalcula entero. Los dados raciales no se tocan.
     */
    public static String dadosDeGolpe(String original, int idxClase, int nivelNuevo,
                                      int dadoDeClase, Integer modCon) {
        List<Dados> gs = grupos(original);
        if (idxClase < 0 || idxClase >= gs.size()) return original;

        int bono = modCon == null ? 0 : modCon * nivelNuevo;
        String nuevo = nivelNuevo + "d" + dadoDeClase + (bono == 0 ? "" : (bono > 0 ? "+" : "−") + Math.abs(bono));

        Dados viejo = gs.get(idxClase);
        String linea = original.substring(0, viejo.desde()) + nuevo + original.substring(viejo.hasta());

        // recalcular los puntos de golpe medios de todos los grupos juntos
        int total = 0;
        for (Dados d : grupos(linea)) total += d.media();
        return quitarPg(linea) + " (" + Math.max(1, total) + " pg)";
    }

    /** Desplaza todos los bonificadores de ataque de una línea. */
    public static String desplazarAtaques(String linea, int delta) {
        if (linea == null || linea.isBlank() || delta == 0) return linea;
        Matcher m = ATAQUE.matcher(linea);
        StringBuilder sb = new StringBuilder();
        while (m.find()) {
            m.appendReplacement(sb, Matcher.quoteReplacement(conSigno(entero(m.group(1)) + delta)));
        }
        m.appendTail(sb);
        return sb.toString();
    }

    /** "Fort +2, Ref +1, Vol −1" con cada salvación desplazada lo suyo. */
    public static String desplazarSalvaciones(String linea, int dFort, int dRef, int dVol) {
        if (linea == null || linea.isBlank()) return linea;
        Matcher m = SALVACION.matcher(linea);
        StringBuilder sb = new StringBuilder();
        while (m.find()) {
            String cual = m.group(1);
            int delta = cual.equalsIgnoreCase("Fort") ? dFort
                      : cual.equalsIgnoreCase("Ref") ? dRef : dVol;
            m.appendReplacement(sb, Matcher.quoteReplacement(
                    cual + " " + conSigno(entero(m.group(2)) + delta)));
        }
        m.appendTail(sb);
        return sb.toString();
    }

    /** "+1/-4" (ataque base / presa) con los dos desplazados. */
    public static String desplazarAtaqueBase(String linea, int delta) {
        if (linea == null || linea.isBlank() || delta == 0) return linea;
        String[] trozos = linea.split("/");
        for (int i = 0; i < trozos.length; i++) {
            trozos[i] = conSigno(entero(trozos[i]) + delta);
        }
        return String.join("/", trozos);
    }

    /** Cuántas dotes se ganan al pasar de un nivel a otro. */
    public static int dotesGanadas(int desde, int hasta) {
        return cuenta(NIVELES_DOTE, desde, hasta);
    }

    /** Cuántas subidas de característica al pasar de un nivel a otro. */
    public static int subidasDeCaracteristica(int desde, int hasta) {
        return cuenta(NIVELES_CARACT, desde, hasta);
    }

    private static int cuenta(int[] hitos, int desde, int hasta) {
        int n = 0;
        for (int h : hitos) if (h > desde && h <= hasta) n++;
        return n;
    }

    private static String quitarPg(String s) {
        return s.replaceAll("\\s*\\(\\s*\\d+\\s*(?:pg|hp)\\s*\\)", "").trim();
    }

    private static String conSigno(int n) {
        return (n >= 0 ? "+" : "−") + Math.abs(n);
    }

    private static int entero(String v) {
        if (v == null) return 0;
        String t = v.replace("−", "-").replace("+", "").replace(" ", "").trim();
        if (t.isEmpty()) return 0;
        try {
            return Integer.parseInt(t);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
