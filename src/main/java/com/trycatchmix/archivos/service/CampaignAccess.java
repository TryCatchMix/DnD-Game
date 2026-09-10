package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.Campaign;
import com.trycatchmix.archivos.domain.CampaignMember;
import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.error.ApiException;
import com.trycatchmix.archivos.repo.CampaignMemberRepository;
import com.trycatchmix.archivos.repo.CampaignRepository;
import com.trycatchmix.archivos.repo.GameCharacterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * QUIÉN PUEDE QUÉ, EN QUÉ CAMPAÑA.
 *
 * Toda la autorización de la mesa pasa por aquí. Antes estaba repartida: cada
 * servicio comparaba {@code user_id} con el suyo y el rol DM se miraba en el
 * token, de forma que un máster lo era en todas partes a la vez. Con varias
 * campañas eso ya no vale, y tampoco quiero la comprobación copiada en seis
 * sitios: se pregunta aquí y aquí se responde.
 *
 * Dos permisos y nada más:
 *
 *   · MIEMBRO — está en la campaña, sea jugador o máster. Puede mirar el
 *     tablón, la tienda y su propio bloc de notas.
 *   · DM — dirige ESTA campaña. Puede preparar misiones, mover el material,
 *     escribir encargos, poner precios y sacar enemigos.
 *
 * El rol de la cuenta ({@code users.role}) ya no interviene: es administración
 * de la instalación, no permiso de juego. Un máster de siempre sigue teniendo
 * lo que tenía porque la migración lo metió como DM de su campaña, no porque
 * su cuenta diga DM.
 */
@Component
@RequiredArgsConstructor
public class CampaignAccess {

    private final CampaignRepository campaigns;
    private final CampaignMemberRepository members;
    private final GameCharacterRepository characters;

    // ------------------------------------------------------------- campañas ---

    public Campaign campaign(UUID campaignId) {
        return campaigns.findById(campaignId)
                .orElseThrow(() -> ApiException.notFound("No existe esa campaña."));
    }

    /** La campaña, comprobando antes que quien pregunta está dentro. */
    public Campaign exigeMiembro(UUID userId, UUID campaignId) {
        membresia(userId, campaignId);
        return campaign(campaignId);
    }

    /** La campaña, comprobando que quien pregunta la dirige. */
    public Campaign exigeDm(UUID userId, UUID campaignId) {
        CampaignMember m = membresia(userId, campaignId);
        if (!m.esDm()) throw ApiException.forbidden("Esto es cosa del máster de la campaña.");
        return campaign(campaignId);
    }

    /** El dueño: el único que puede borrarla o traspasarla. */
    public Campaign exigeDueno(UUID userId, UUID campaignId) {
        Campaign c = campaign(campaignId);
        if (!c.getOwnerId().equals(userId))
            throw ApiException.forbidden("Solo quien creó la campaña puede hacer esto.");
        return c;
    }

    public CampaignMember membresia(UUID userId, UUID campaignId) {
        return members.findByCampaignIdAndUserId(campaignId, userId)
                .orElseThrow(() -> ApiException.forbidden("No estás en esa campaña."));
    }

    public Optional<CampaignMember> membresiaSiLaHay(UUID userId, UUID campaignId) {
        if (campaignId == null) return Optional.empty();
        return members.findByCampaignIdAndUserId(campaignId, userId);
    }

    public boolean esMiembro(UUID userId, UUID campaignId) {
        return membresiaSiLaHay(userId, campaignId).isPresent();
    }

    public boolean esDm(UUID userId, UUID campaignId) {
        return membresiaSiLaHay(userId, campaignId).map(CampaignMember::esDm).orElse(false);
    }

    /** Las campañas en las que está, del orden en que entró. */
    public List<UUID> campanasDe(UUID userId) {
        return members.findByUserIdOrderByJoinedAtAsc(userId).stream()
                .map(CampaignMember::getCampaignId)
                .toList();
    }

    /** Las que dirige. Sirve para saber qué personajes ajenos puede mirar. */
    public List<UUID> campanasQueDirige(UUID userId) {
        return members.findByUserIdOrderByJoinedAtAsc(userId).stream()
                .filter(CampaignMember::esDm)
                .map(CampaignMember::getCampaignId)
                .toList();
    }

    // ----------------------------------------------------------- personajes ---

    public GameCharacter personaje(UUID charId) {
        return characters.findById(charId)
                .orElseThrow(() -> ApiException.notFound("No existe ese personaje."));
    }

    /**
     * El personaje, si quien pregunta puede tocarlo: o es suyo, o dirige la
     * campaña en la que está. Es el criterio de la ficha, la tienda y la bolsa.
     */
    public GameCharacter exigePersonaje(UUID userId, UUID charId) {
        GameCharacter c = personaje(charId);
        if (puedeVer(userId, c)) return c;
        throw ApiException.forbidden("Ese personaje no es tuyo.");
    }

    public boolean puedeVer(UUID userId, GameCharacter c) {
        return c.getUserId().equals(userId) || esDm(userId, c.getCampaignId());
    }

    /**
     * La campaña de un personaje, exigiendo que la tenga. Las pantallas que
     * cuelgan de un personaje pero pintan cosas de la mesa (la tienda, el bloc)
     * entran por aquí, y así el mensaje de "únete a una campaña" sale una vez y
     * dice lo mismo en todas.
     */
    public UUID exigeCampanaDe(GameCharacter c) {
        if (c.getCampaignId() == null)
            throw ApiException.conflict(
                    "Este personaje no está en ninguna campaña todavía. Únete a una para jugar.");
        return c.getCampaignId();
    }
}
