package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.GameCharacterRepository;
import com.trycatchmix.archivos.web.dto.BackstoryDtos.BackstoryView;
import com.trycatchmix.archivos.web.dto.BackstoryDtos.SaveRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;
import java.util.regex.Pattern;

/**
 * El trasfondo del personaje: su historia, escrita como un documento con
 * formato. Se guarda como HTML (negritas, colores, listas…) en la propia hoja.
 *
 * Cada personaje tiene UN solo trasfondo. Solo su dueño (o el máster) puede
 * leerlo y editarlo. Como es HTML que se vuelve a pintar, se limpia al guardar
 * lo que podría ejecutar código (scripts, iframes, manejadores on…); el resto
 * del formato se respeta tal cual.
 */
@Service
@RequiredArgsConstructor
public class BackstoryService {

    /** Tope de tamaño del documento (caracteres de HTML). Generoso: son unas
     *  60-80 páginas de texto con formato. Corta un pegado accidental enorme. */
    private static final int MAX_LARGO = 200_000;

    private final GameCharacterRepository characters;

    @Transactional(readOnly = true)
    public BackstoryView ver(UUID userId, UUID charId, boolean admin) {
        return build(accessibleCharacter(userId, charId, admin));
    }

    @Transactional
    public BackstoryView guardar(UUID userId, UUID charId, boolean admin, SaveRequest req) {
        GameCharacter c = accessibleCharacter(userId, charId, admin);
        String html = req == null || req.html() == null ? "" : req.html();
        if (html.length() > MAX_LARGO)
            throw ApiException.conflict("El trasfondo es demasiado largo.");
        c.setBackstory(limpiar(html));
        c.setBackstoryUpdatedAt(Instant.now());
        return build(c);
    }

    // ------------------------------------------------------------------------

    private BackstoryView build(GameCharacter c) {
        String iso = c.getBackstoryUpdatedAt() == null ? "" : c.getBackstoryUpdatedAt().toString();
        return new BackstoryView(c.getBackstory() == null ? "" : c.getBackstory(), iso);
    }

    // --- Limpieza del HTML ---
    // No es un saneador completo (el trasfondo solo lo ven su dueño y el máster),
    // pero quita lo que ejecuta código para no dispararnos en el pie: etiquetas
    // <script>/<iframe>/<object>/<embed>/<style>, atributos on… y urls javascript:.

    private static final String NOMBRES = "script|style|iframe|object|embed|link|meta";
    /** Un bloque entero: apertura + contenido + cierre (p.ej. <script>…</script>). */
    private static final Pattern BLOQUE_PELIGROSO =
            Pattern.compile("(?is)<\\s*(" + NOMBRES + ")\\b[^>]*>.*?<\\s*/\\s*\\1\\s*>");
    /** Cualquier etiqueta suelta de esos nombres (huérfana, vacía o de cierre). */
    private static final Pattern ETIQUETA_SUELTA =
            Pattern.compile("(?is)<\\s*/?\\s*(" + NOMBRES + ")\\b[^>]*>");
    private static final Pattern MANEJADORES_ON =
            Pattern.compile("(?i)\\son\\w+\\s*=\\s*(\"[^\"]*\"|'[^']*'|[^\\s>]+)");
    private static final Pattern JS_URL =
            Pattern.compile("(?i)(href|src)\\s*=\\s*(\"|')\\s*javascript:[^\"']*(\"|')");

    private String limpiar(String html) {
        String limpio = BLOQUE_PELIGROSO.matcher(html).replaceAll("");
        limpio = ETIQUETA_SUELTA.matcher(limpio).replaceAll("");
        limpio = MANEJADORES_ON.matcher(limpio).replaceAll("");
        limpio = JS_URL.matcher(limpio).replaceAll("$1=$2$3");
        return limpio;
    }

    /** El dueño pasa siempre; el máster (admin) pasa para cualquier personaje. */
    private GameCharacter accessibleCharacter(UUID userId, UUID charId, boolean admin) {
        GameCharacter c = characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
        if (!admin && !c.getUserId().equals(userId))
            throw ApiException.forbidden("Ese personaje no es tuyo.");
        return c;
    }
}
