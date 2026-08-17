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

/**
 * El trasfondo del personaje: su historia, escrita como un documento con
 * formato. Se guarda como HTML (negritas, colores, listas…) en la propia hoja.
 *
 * Cada personaje tiene UN solo trasfondo. Solo su dueño (o el máster) puede
 * leerlo y editarlo. Al guardar se pasa por {@link HtmlSanitizer} para quitar
 * lo que podría ejecutar código; el formato se respeta tal cual.
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
        c.setBackstory(HtmlSanitizer.limpiar(html));
        c.setBackstoryUpdatedAt(Instant.now());
        return build(c);
    }

    // ------------------------------------------------------------------------

    private BackstoryView build(GameCharacter c) {
        String iso = c.getBackstoryUpdatedAt() == null ? "" : c.getBackstoryUpdatedAt().toString();
        return new BackstoryView(c.getBackstory() == null ? "" : c.getBackstory(), iso);
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
