package com.trycatchmix.archivos.web;

import com.trycatchmix.archivos.service.DomainService;
import com.trycatchmix.archivos.web.dto.DomainDtos.DomainDetail;
import com.trycatchmix.archivos.web.dto.DomainDtos.DomainSummary;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Los dominios divinos del clérigo: la lista para elegir y el detalle de cada
 * uno (poder otorgado + conjuros de dominio). Solo consulta; lo lee cualquier
 * jugador autenticado, igual que el grimorio.
 */
@RestController
@RequestMapping("/api/dominios")
@RequiredArgsConstructor
public class DomainController {

    private final DomainService domains;

    @GetMapping
    public List<DomainSummary> todos() {
        return domains.todos();
    }

    @GetMapping("/{code}")
    public DomainDetail detalle(@PathVariable String code) {
        return domains.detalle(code);
    }
}
