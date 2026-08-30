import { Component, computed, inject } from '@angular/core';

import { FichaStore } from './sheet.store';

/**
 * Lo que el personaje lleva PUESTO y lo que eso le da.
 *
 * Dos mitades: arriba, los objetos de la bolsa que se pueden llevar puestos con
 * su interruptor; abajo, lo que sale de ellos —CA, tope de Destreza,
 * penalizador de armadura, fallo de conjuros, velocidad y las líneas de ataque
 * de las armas—, calculado por el backend a partir de las columnas del SRD.
 *
 * Los números de la ficha NO se tocan solos. Aquí se ven al lado los que dice
 * el equipo, y si no cuadran hay un botón para copiarlos: en la CA de la hoja
 * puede haber armadura natural o un conjuro activo, y machacarlos al ponerse un
 * escudo sería perderle datos al jugador.
 */
@Component({
  selector: 'arc-equipo-panel',
  template: `
    @if (store.ficha(); as f) {
      <!-- ---------- qué puede ponerse ---------- -->
      @if (equipables().length === 0) {
        <p class="vacio">
          Nada que ponerse. Las armas, armaduras y escudos que compres en la
          tienda aparecen aquí con su interruptor.
        </p>
      } @else {
        <ul class="puestos">
          @for (it of equipables(); track it.id) {
            <li class="pieza" [class.pieza--puesta]="it.equipped">
              <button type="button" class="interruptor"
                      [class.on]="it.equipped"
                      [disabled]="store.equipando() === it.id"
                      (click)="store.equipar(it)"
                      [attr.aria-pressed]="it.equipped"
                      [attr.aria-label]="(it.equipped ? 'Quitarse ' : 'Ponerse ') + it.name">
                <span class="perilla"></span>
              </button>
              <span class="pieza-texto">
                <span class="nombre">{{ it.name }}</span>
                @if (it.stats) { <span class="bloque">{{ it.stats }}</span> }
              </span>
              <span class="clase">{{ it.gearKind }}</span>
            </li>
          }
        </ul>
      }

      <!-- ---------- qué te da ---------- -->
      @if (f.equipo; as e) {
        @if (e.armor || e.shield || e.attacks.length) {
          <dl class="derivado">
            @if (e.armor) { <div><dt>Armadura</dt><dd>{{ e.armor }} (+{{ e.acFromArmor }})</dd></div> }
            @if (e.shield) { <div><dt>Escudo</dt><dd>{{ e.shield }} (+{{ e.acFromShield }})</dd></div> }
            <div>
              <dt>Destreza que cuenta</dt>
              <dd>
                {{ signo(e.dexApplied) }}
                @if (e.maxDex !== null && e.dexMod > e.maxDex) {
                  <span class="topada">de {{ signo(e.dexMod) }}, topada por la armadura</span>
                }
              </dd>
            </div>
            @if (e.armorCheck) {
              <div><dt>Penalizador de armadura</dt><dd class="malo">{{ e.armorCheck }}</dd></div>
            }
            @if (e.spellFailure) {
              <div><dt>Fallo de conjuros</dt><dd class="malo">{{ e.spellFailure }}%</dd></div>
            }
            <div><dt>Velocidad</dt><dd>{{ e.speed }} pies</dd></div>
          </dl>

          <!-- la CA que sale del equipo, frente a la que hay escrita -->
          <div class="ca">
            <div class="ca-cifra" [class.ca-cifra--difiere]="e.suggestedAc !== f.acTotal">
              <span class="ca-rotulo">CA</span>
              <span class="ca-valor">{{ e.suggestedAc }}</span>
              <span class="ca-sub">contacto {{ e.suggestedTouch }} · desprevenido {{ e.suggestedFlatFooted }}</span>
            </div>

            @if (e.suggestedAc !== f.acTotal) {
              <p class="ca-aviso">
                En la ficha pone <strong>{{ f.acTotal }}</strong>. La diferencia
                suele ser armadura natural, un bonificador de desviación o un
                conjuro activo: eso el equipo no lo sabe.
              </p>
              <button type="button" class="boton" [disabled]="store.aplicando()"
                      (click)="store.aplicarEquipo()">
                {{ store.aplicando() ? 'Aplicando…' : 'Copiar a la ficha' }}
              </button>
            } @else {
              <p class="ca-aviso ca-aviso--ok">Cuadra con lo que pone en la ficha.</p>
            }
          </div>

          @if (e.attacks.length) {
            <ul class="ataques">
              @for (a of e.attacks; track a.weapon) {
                <li class="ataque">
                  <span class="a-arma">{{ a.weapon }}</span>
                  <span class="a-bono">{{ a.attack }}</span>
                  <span class="a-modo">{{ a.mode }}</span>
                  <span class="a-dano">
                    {{ a.damage }}@if (a.critical) { /{{ a.critical }} }
                  </span>
                  @if (a.rangeIncrement) { <span class="a-alcance">{{ a.rangeIncrement }}</span> }
                </li>
              }
            </ul>
            <p class="nota">
              El ataque cuerpo a cuerpo usa Fuerza y el de distancia Destreza,
              sin mirar el tamaño ni si el arma es sutil. Lo que no cuadre, a mano.
            </p>
          }
        }
      }

      @if (store.errorBolsa(); as err) { <p class="error" role="alert">{{ err }}</p> }
    }
  `,
  styles: `
    .vacio { color: var(--sepia); font-size: 14px; margin: 0; line-height: 1.5; }

    .puestos { list-style: none; margin: 0 0 14px; padding: 0; display: grid; gap: 6px; }
    .pieza {
      display: flex; align-items: center; gap: 10px;
      border: 1px solid var(--linea-clara); border-radius: var(--radio); padding: 7px 10px;
    }
    .pieza--puesta { border-color: rgba(157, 122, 47, .5); background: rgba(157, 122, 47, .05); }
    .pieza-texto { flex: 1; min-width: 0; display: grid; gap: 1px; }
    .nombre { color: var(--tinta); font-size: 15px; }
    .bloque { font-family: var(--dato); font-size: 11px; color: var(--vino); }
    .clase {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia);
    }

    /* interruptor de dos estados: se ve de un vistazo qué llevas puesto */
    .interruptor {
      flex: 0 0 auto; width: 34px; height: 20px; border-radius: 10px; cursor: pointer;
      border: 1px solid var(--linea-fuerte); background: transparent; padding: 0;
      position: relative; transition: background .15s, border-color .15s;
    }
    .interruptor .perilla {
      position: absolute; top: 2px; left: 2px; width: 14px; height: 14px;
      border-radius: 50%; background: var(--sepia); transition: transform .15s, background .15s;
    }
    .interruptor.on { background: var(--oro); border-color: var(--oro); }
    .interruptor.on .perilla { transform: translateX(14px); background: var(--tinta); }
    .interruptor:disabled { opacity: .5; cursor: default; }

    .derivado {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
      gap: 4px 16px; margin: 0 0 12px; padding: 10px 0;
      border-top: 1px solid var(--linea-clara); border-bottom: 1px solid var(--linea-clara);
    }
    .derivado > div { display: flex; gap: 6px; align-items: baseline; min-width: 0; }
    .derivado dt {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); white-space: nowrap;
    }
    .derivado dd { margin: 0; color: var(--tinta); font-size: 14px; }
    .derivado dd.malo { color: var(--vino); }
    .topada { color: var(--sepia); font-size: 12px; margin-left: 4px; }

    .ca { margin: 0 0 12px; }
    .ca-cifra { display: flex; align-items: baseline; gap: 8px; flex-wrap: wrap; }
    .ca-rotulo {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia);
    }
    .ca-valor { font-size: 30px; color: var(--tinta); line-height: 1; }
    .ca-cifra--difiere .ca-valor { color: var(--vino); }
    .ca-sub { font-family: var(--dato); font-size: 11px; color: var(--sepia); }
    .ca-aviso { margin: 6px 0 8px; font-size: 13px; color: var(--sepia-hondo); line-height: 1.5; }
    .ca-aviso strong { color: var(--tinta); }
    .ca-aviso--ok { color: var(--musgo); }

    .ataques { list-style: none; margin: 0; padding: 0; display: grid; gap: 4px; }
    .ataque {
      display: flex; align-items: baseline; gap: 8px; flex-wrap: wrap;
      padding: 6px 0; border-top: 1px solid var(--linea-clara);
    }
    .a-arma { color: var(--tinta); font-size: 14px; }
    .a-bono { font-family: var(--dato); font-size: 15px; color: var(--oro); }
    .a-modo, .a-alcance { font-family: var(--dato); font-size: 10px; color: var(--sepia); }
    .a-dano { font-family: var(--dato); font-size: 13px; color: var(--vino); }

    .nota { margin: 8px 0 0; font-size: 12px; color: var(--sepia); font-style: italic; line-height: 1.5; }
    .error { color: var(--vino); font-size: 13px; margin: 8px 0 0; }
  `,
})
export class EquipoPanel {
  readonly store = inject(FichaStore);

  /** De la bolsa, solo lo que se puede llevar puesto: lo puesto primero. */
  readonly equipables = computed(() => {
    const items = this.store.inventario()?.items ?? [];
    return items
      .filter(i => i.equipable)
      .sort((a, b) => Number(b.equipped) - Number(a.equipped)
        || a.name.localeCompare(b.name, 'es'));
  });

  signo(n: number): string {
    return (n >= 0 ? '+' : '−') + Math.abs(n);
  }
}
