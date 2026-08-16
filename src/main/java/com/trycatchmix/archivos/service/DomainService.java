package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Spell;
import com.trycatchmix.archivos.repo.SpellRepository;
import com.trycatchmix.archivos.service.DomainCatalog.DomainDef;
import com.trycatchmix.archivos.web.dto.DomainDtos.DomainDetail;
import com.trycatchmix.archivos.web.dto.DomainDtos.DomainSpellView;
import com.trycatchmix.archivos.web.dto.DomainDtos.DomainSummary;
import com.trycatchmix.archivos.error.ApiException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * Los dominios del clérigo (ver {@link DomainCatalog}). Este servicio solo
 * resuelve los conjuros de dominio, guardados por nombre inglés del SRD, contra
 * el grimorio en español (`spells.name_en`) para poder enlazarlos y mostrar su
 * nombre traducido. Los que no tenemos scrapeados se devuelven como referencia.
 */
@Service
@RequiredArgsConstructor
public class DomainService {

    private final SpellRepository spells;

    /** La lista para el selector: código + nombre, en el orden del catálogo. */
    public List<DomainSummary> todos() {
        return DomainCatalog.TODOS.stream()
                .map(d -> new DomainSummary(d.code(), d.nombre()))
                .toList();
    }

    @Transactional(readOnly = true)
    public DomainDetail detalle(String code) {
        DomainDef def = DomainCatalog.porCodigo(code);
        if (def == null) throw ApiException.notFound("No existe ese dominio.");

        // name_en (normalizado) -> conjuro, para traducir cada conjuro de dominio.
        Map<String, Spell> porNombreEn = spells.findAllByOrderByNameAsc().stream()
                .filter(s -> s.getNameEn() != null && !s.getNameEn().isBlank())
                .collect(Collectors.toMap(s -> norm(s.getNameEn()), Function.identity(), (a, b) -> a));

        List<DomainSpellView> lista = IntStream.range(0, def.spellsEn().size())
                .mapToObj(i -> {
                    String en = def.spellsEn().get(i);
                    Spell s = porNombreEn.get(norm(en));
                    return new DomainSpellView(i + 1, s != null ? s.getName() : en, en, s != null);
                })
                .toList();

        return new DomainDetail(def.code(), def.nombre(), def.poder(), lista);
    }

    /** Minúsculas, sin acentos y con las comillas/guiones normalizados, para
     *  casar "Summon Nature's Ally" venga como venga escrito. */
    private String norm(String s) {
        if (s == null) return "";
        String n = Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return n.toLowerCase().replace('’', '\'').replace('–', '-')
                .replaceAll("\\s+", " ").trim();
    }
}
