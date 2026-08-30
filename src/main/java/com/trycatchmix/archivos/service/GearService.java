package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.domain.GameCharacter;
import com.trycatchmix.archivos.domain.InventoryEntry;
import com.trycatchmix.archivos.domain.Item;
import com.trycatchmix.archivos.repo.InventoryRepository;
import com.trycatchmix.archivos.repo.ItemRepository;
import com.trycatchmix.archivos.web.dto.FichaDtos.AtaqueView;
import com.trycatchmix.archivos.web.dto.FichaDtos.EquipoView;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Lo que sale de lo que el personaje lleva PUESTO.
 *
 * Desde V22 el catálogo sabe que unas placas completas dan +8 a la CA, topan la
 * Destreza en +1, penalizan −6 y hacen fallar el 35% de los conjuros arcanos.
 * Aquí se junta todo eso con las características del personaje.
 *
 * NO PISA LA FICHA. La CA, las salvaciones y demás siguen siendo campos que el
 * jugador escribe, porque ahí van también la armadura natural, los bonificadores
 * de desviación, los conjuros activos y las reglas de la casa. Esto CALCULA lo
 * que aporta el equipo y lo enseña al lado, para que se vea si cuadra; aplicarlo
 * es un botón, no un efecto secundario.
 */
@Service
@RequiredArgsConstructor
public class GearService {

    private final InventoryRepository inventory;
    private final ItemRepository items;

    /** Sin armadura no hay tope de Destreza; se usa este número como "ninguno". */
    private static final int SIN_TOPE = 99;

    @Transactional(readOnly = true)
    public EquipoView calcular(GameCharacter c) {
        int acArmadura = 0, acEscudo = 0;
        int topeDes = SIN_TOPE, penalizador = 0, fallo = 0;
        int velocidad = c.getSpeed();
        String armadura = "", escudo = "";
        List<AtaqueView> ataques = new ArrayList<>();

        for (InventoryEntry e : inventory.findByCharacterIdOrderByNameAsc(c.getId())) {
            if (!e.isEquipped() || e.getItemCode() == null) continue;
            Item item = items.findById(e.getItemCode()).orElse(null);
            if (item == null) continue;

            switch (Gear.kind(item)) {
                case Gear.ARMADURA -> {
                    armadura = item.getName();
                    acArmadura += Gear.entero(item.getAcBonus(), 0);
                    topeDes = Math.min(topeDes, Gear.entero(item.getMaxDex(), SIN_TOPE));
                    penalizador += Gear.entero(item.getArmorCheck(), 0);
                    fallo += Gear.porcentaje(item.getSpellFailure());
                    velocidad = velocidadCon(c.getSpeed(), item);
                }
                case Gear.ESCUDO -> {
                    escudo = item.getName();
                    acEscudo += Gear.entero(item.getAcBonus(), 0);
                    // casi ningún escudo topa la Destreza; el de torre sí
                    topeDes = Math.min(topeDes, Gear.entero(item.getMaxDex(), SIN_TOPE));
                    penalizador += Gear.entero(item.getArmorCheck(), 0);
                    fallo += Gear.porcentaje(item.getSpellFailure());
                }
                case Gear.ARMA -> ataques.add(ataque(c, item));
                default -> { }
            }
        }

        int modDes = c.abilityMod("DES");
        int desEfectiva = Math.min(modDes, topeDes);

        int caTotal = 10 + acArmadura + acEscudo + desEfectiva;
        int caContacto = 10 + desEfectiva;              // el contacto ignora armadura y escudo
        int caDesprevenido = 10 + acArmadura + acEscudo; // desprevenido: sin Destreza

        return new EquipoView(
                armadura, escudo,
                acArmadura, acEscudo,
                topeDes == SIN_TOPE ? null : topeDes,
                modDes, desEfectiva,
                penalizador, fallo, velocidad,
                caTotal, caContacto, caDesprevenido,
                ataques);
    }

    /**
     * Una línea de ataque como se lee en la ficha:
     * "Espada larga +5 cuerpo a cuerpo (1d8+3/19-20/×2)".
     *
     * SIMPLIFICACIONES a propósito: el ataque cuerpo a cuerpo usa Fuerza y el
     * de distancia Destreza, sin mirar si el arma es sutil ni el tamaño del
     * personaje. Con eso acierta en la inmensa mayoría de las fichas, y lo que
     * no cuadre se corrige a mano, que es como estaba antes de esto.
     */
    private AtaqueView ataque(GameCharacter c, Item item) {
        boolean distancia = "A distancia".equalsIgnoreCase(item.getHandling());
        int mod = c.abilityMod(distancia ? "DES" : "FUE");
        int bono = c.getBab() + mod;

        String dano = item.getDamageMedium();
        // el daño de un arma arrojadiza suma Fuerza; el de un arco, no
        int modDano = distancia ? 0 : c.abilityMod("FUE");
        if (!dano.isBlank() && modDano != 0) {
            dano += (modDano > 0 ? "+" : "−") + Math.abs(modDano);
        }

        return new AtaqueView(
                item.getName(),
                distancia ? "a distancia" : "cuerpo a cuerpo",
                (bono >= 0 ? "+" : "−") + Math.abs(bono),
                dano,
                item.getCritical(),
                item.getDamageType(),
                item.getRangeIncrement());
    }

    /** La velocidad con la armadura puesta, según se camine a 30 o a 20 pies. */
    private int velocidadCon(int base, Item item) {
        int con30 = Gear.pies(item.getSpeed30());
        int con20 = Gear.pies(item.getSpeed20());
        if (base >= 30 && con30 > 0) return con30;
        if (base <= 20 && con20 > 0) return con20;
        return base;
    }

    /** Para las pantallas que solo tienen el id del personaje. */
    @Transactional(readOnly = true)
    public boolean llevaAlgoPuesto(UUID charId) {
        return inventory.findByCharacterIdOrderByNameAsc(charId).stream()
                .anyMatch(InventoryEntry::isEquipped);
    }
}
