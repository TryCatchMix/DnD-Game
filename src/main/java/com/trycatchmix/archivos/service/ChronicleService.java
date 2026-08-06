package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.ChronicleEntry;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.ChronicleEntryRepository;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleCreateRequest;
import com.trycatchmix.archivos.web.dto.ChronicleDtos.ChronicleView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/** La crónica del clan: leerla, revelar verdades selladas y anotar entradas. */
@Service
@RequiredArgsConstructor
public class ChronicleService {

    private static final String CENSURADO =
            "▓▓▓▓▓▓▓▓  Sellado por la Orden del Velo. Su contenido no consta en "
            + "los registros que se os permite consultar.  ▓▓▓▓▓▓▓▓";

    private final ChronicleEntryRepository entries;

    @Transactional(readOnly = true)
    public List<ChronicleView> cronica(boolean esDM) {
        return entries.findAllByOrderByYearAscSortOrdinalAsc().stream()
                .map(e -> toView(e, esDM))
                .toList();
    }

    /** Destapar una verdad sellada. Cosa del clan de Los Archivos (el DM). */
    @Transactional
    public List<ChronicleView> revelar(java.util.UUID id) {
        ChronicleEntry e = entries.findById(id)
                .orElseThrow(() -> ApiException.notFound("No existe esa entrada."));
        if (!e.isSealed())
            throw ApiException.conflict("Esa entrada no está sellada.");
        e.setRevealed(true);
        return cronica(true);
    }

    /** Anotar una entrada nueva (solo el DM). */
    @Transactional
    public List<ChronicleView> anotar(ChronicleCreateRequest r) {
        if (r.title() == null || r.title().isBlank())
            throw ApiException.conflict("La entrada necesita un título.");

        ChronicleEntry e = new ChronicleEntry();
        e.setYear(r.year() == null ? 1127 : r.year());
        e.setEra(r.era() == null ? "" : r.era());
        e.setTitle(r.title().trim());
        e.setBody(r.body() == null ? "" : r.body());
        e.setCategory(r.category() == null ? "MUNDO" : r.category());
        e.setFaction(r.faction());
        e.setSealed(Boolean.TRUE.equals(r.sealed()));
        e.setSortOrdinal(999);   // lo nuevo, al final de su año
        entries.save(e);
        return cronica(true);
    }

    private ChronicleView toView(ChronicleEntry e, boolean esDM) {
        boolean oculta = e.isSealed() && !e.isRevealed();
        return new ChronicleView(
                e.getId().toString(), e.getYear(), e.getEra(), e.getTitle(),
                oculta ? CENSURADO : e.getBody(),
                e.getCategory(), e.getFaction(),
                e.isSealed(), e.isRevealed(),
                oculta && esDM);
    }
}
