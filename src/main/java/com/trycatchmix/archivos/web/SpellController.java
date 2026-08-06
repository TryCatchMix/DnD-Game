package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.service.SpellService;
import com.trycatchmix.archivos.web.dto.SpellDtos.InvocationView;
import com.trycatchmix.archivos.web.dto.SpellDtos.SpellView;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** El grimorio (pantalla de hechizos). Lo consulta cualquier jugador. */
@RestController
@RequestMapping("/api/hechizos")
@RequiredArgsConstructor
public class SpellController {

    private final SpellService spells;

    @GetMapping
    public List<SpellView> hechizos() {
        return spells.hechizos();
    }

    /** Las invocaciones de warlock. Van aparte de los conjuros porque no lo son:
     *  se usan a voluntad y se agrupan por grado, no por nivel de conjuro. */
    @GetMapping("/invocaciones")
    public List<InvocationView> invocaciones() {
        return spells.invocaciones();
    }
}
