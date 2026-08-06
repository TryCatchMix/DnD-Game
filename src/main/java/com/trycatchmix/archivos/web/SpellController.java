package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.service.SpellService;
import com.trycatchmix.archivos.web.dto.SpellDtos.FeatureView;
import com.trycatchmix.archivos.web.dto.SpellDtos.InvocationView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellPage;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Las "Habilidades": conjuros, invocaciones de warlock y aptitudes de clase.
 * Lo consulta cualquier jugador.
 *
 * Los conjuros se paginan en el servidor (por defecto 25) para no mandar los
 * ~500 de una vez. Invocaciones y aptitudes son pocas y se devuelven enteras.
 */
@RestController
@RequestMapping("/api/habilidades")
@RequiredArgsConstructor
public class SpellController {

    private final SpellService spells;

    @GetMapping("/hechizos")
    public SpellPage hechizos(
            @RequestParam(required = false) String clase,
            @RequestParam(required = false) String q,
            @RequestParam(defaultValue = "25") int limite,
            @RequestParam(defaultValue = "0") int offset) {
        return spells.hechizos(clase, q, limite, offset);
    }

    /** Las invocaciones de warlock: no son conjuros (se usan a voluntad). */
    @GetMapping("/invocaciones")
    public List<InvocationView> invocaciones() {
        return spells.invocaciones();
    }

    /** Aptitudes de clase de Bárbaro, Guerrero y Monje (que no lanzan conjuros). */
    @GetMapping("/aptitudes")
    public List<FeatureView> aptitudes(@RequestParam(required = false) String clase) {
        return spells.aptitudes(clase);
    }
}
