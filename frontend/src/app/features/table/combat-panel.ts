import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { Character } from '../../core/api.types';
import { Combate, Combatiente, Enemigo, ResumenCombate } from '../../core/table.types';
import { JuegoService } from '../../core/game.service';
import { MesaService } from '../../core/table.service';

/**
 * El combate: quién va antes, cuántos puntos de golpe le quedan y de quién es
 * el turno.
 *
 * Lo importante es que meter un bicho no cuesta teclear su ficha: sale de la
 * lista de enemigos, que a su vez salió del bestiario. Pedir tres trasgos los
 * mete numerados, que es como se distinguen en la mesa.
 *
 * La iniciativa se tira solo por quien no la tenga puesta: los jugadores suelen
 * tirar sus propios dados y cantarla, y sería absurdo pisársela.
 */
@Component({
  selector: 'arc-combate-panel',
  imports: [FormsModule],
  template: `
    @if (error(); as e) { <p class="estado estado--mal" role="alert">{{ e }}</p> }

    <!-- ============ ELEGIR O ABRIR UN COMBATE ============ -->
    @if (!combate()) {
      <div class="abrir">
        <label class="ctrl ctrl--ancho">
          <span class="rotulo">Abrir un combate nuevo</span>
          <input [(ngModel)]="titulo" placeholder="La emboscada del puente"
                 (keydown.enter)="abrir()" />
        </label>
        <button class="boton boton--lacre" type="button" [disabled]="abriendo()" (click)="abrir()">
          {{ abriendo() ? 'Abriendo…' : 'Abrir' }}
        </button>
      </div>

      @if (guardados().length) {
        <p class="recuento">Combates guardados</p>
        <ul class="guardados">
          @for (c of guardados(); track c.id) {
            <li>
              <button type="button" class="guardado" (click)="cargar(c.id)">
                <span class="g-nombre">{{ c.title }}</span>
                <span class="g-meta">
                  {{ c.combatants }} en liza
                  @if (c.round > 0) { · asalto {{ c.round }} } @else { · sin empezar }
                </span>
              </button>
            </li>
          }
        </ul>
      }
    }

    <!-- ============ EL COMBATE ============ -->
    @if (combate(); as c) {
      <header class="cabeza">
        <div>
          <h3>{{ c.title }}</h3>
          <p class="asalto">
            @if (c.round === 0) { sin empezar } @else { asalto {{ c.round }} }
          </p>
        </div>
        <div class="mandos">
          <button class="boton" type="button" (click)="iniciativa()">Tirar iniciativa</button>
          <button class="boton boton--lacre" type="button" [disabled]="!c.combatants.length"
                  (click)="siguiente()">Siguiente turno →</button>
          <button class="boton boton--fantasma" type="button" (click)="salir()">Cerrar</button>
        </div>
      </header>

      <!-- --- meter gente --- -->
      <div class="meter">
        <label class="ctrl">
          <span class="rotulo">Enemigo</span>
          <select [(ngModel)]="enemigoElegido">
            <option value="">—</option>
            @for (e of enemigos(); track e.id) {
              <option [value]="e.id">{{ e.name }} ({{ e.hpMax }} PG, CA {{ e.ac }})</option>
            }
          </select>
        </label>
        <label class="ctrl ctrl--corto">
          <span class="rotulo">Cuántos</span>
          <input type="number" min="1" max="20" [(ngModel)]="cuantos" />
        </label>
        <button class="boton" type="button" [disabled]="!enemigoElegido" (click)="meterEnemigos()">
          + Meter
        </button>

        <label class="ctrl">
          <span class="rotulo">Personaje</span>
          <select [(ngModel)]="personajeElegido">
            <option value="">—</option>
            @for (p of personajes(); track p.id) {
              <option [value]="p.id">{{ p.name }}</option>
            }
          </select>
        </label>
        <button class="boton" type="button" [disabled]="!personajeElegido" (click)="meterPersonaje()">
          + Meter
        </button>
      </div>

      @if (!c.combatants.length) {
        <p class="estado">Nadie en liza todavía. Mete enemigos y personajes ahí arriba.</p>
      } @else {
        <ul class="orden">
          @for (k of c.combatants; track k.id) {
            <li class="fila" [class.fila--activa]="k.active" [class.fila--caido]="k.defeated"
                [class.fila--pj]="k.kind === 'personaje'">
              <span class="ini">{{ k.initiative || '—' }}</span>

              <span class="quien">
                <span class="nombre">{{ k.name }}</span>
                <span class="tipo">{{ k.kind }}</span>
              </span>

              <span class="vida">
                <span class="pg" [class.pg--mal]="malherido(k)">
                  {{ k.hpCurrent }}@if (k.hpMax) { <span class="de">/{{ k.hpMax }}</span> }
                </span>
                @if (k.hpMax) {
                  <span class="barra"><span class="barra-dentro" [style.width.%]="porcentaje(k)"></span></span>
                }
              </span>

              <span class="ca">CA {{ k.ac }}</span>

              <span class="golpes">
                <button type="button" title="−5" (click)="pg(k, -5)">−5</button>
                <button type="button" title="−1" (click)="pg(k, -1)">−1</button>
                <button type="button" title="+1" (click)="pg(k, 1)">+1</button>
                <button type="button" class="quitar" title="Sacar del combate"
                        (click)="quitar(k)">✕</button>
              </span>
            </li>
          }
        </ul>
        <p class="nota">
          Al llegar a 0 se marca como caído solo. Curarlo lo levanta.
        </p>
      }
    }
  `,
  styles: `
    .abrir { display: flex; gap: 10px; align-items: end; flex-wrap: wrap; margin-bottom: 18px; }
    .ctrl { display: grid; gap: 4px; }
    .ctrl--ancho { flex: 1 1 240px; }
    .ctrl--corto { width: 80px; }
    .ctrl .rotulo { color: var(--sepia-claro); }
    input, select {
      font: inherit; padding: 9px 11px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
      width: 100%; box-sizing: border-box;
    }

    .recuento {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia); margin: 0 0 8px;
    }
    .guardados { list-style: none; margin: 0; padding: 0; display: grid; gap: 4px; }
    .guardado {
      display: flex; width: 100%; justify-content: space-between; align-items: baseline;
      gap: 10px; text-align: left; background: none; font: inherit; color: inherit;
      border: 1px solid var(--linea-clara); border-radius: var(--radio);
      padding: 9px 11px; cursor: pointer;
    }
    .guardado:hover { border-color: var(--vino); }
    .g-nombre { color: var(--tinta); }
    .g-meta { font-family: var(--dato); font-size: 10px; color: var(--sepia); }

    .cabeza {
      display: flex; justify-content: space-between; align-items: flex-start;
      gap: 12px; flex-wrap: wrap; margin-bottom: 14px;
    }
    h3 { margin: 0; font-size: 20px; color: var(--pergamino); }
    .asalto {
      margin: 2px 0 0; font-family: var(--dato); font-size: 10px;
      letter-spacing: .12em; text-transform: uppercase; color: var(--oro);
    }
    .mandos { display: flex; gap: 8px; flex-wrap: wrap; }
    .boton--fantasma {
      background: transparent; border: 1px solid var(--linea-noche); color: var(--sepia-claro);
    }

    .meter {
      display: flex; gap: 10px; align-items: end; flex-wrap: wrap;
      padding: 12px; border: 1px solid var(--linea-noche); border-radius: var(--radio);
      margin-bottom: 16px;
    }

    .orden { list-style: none; margin: 0; padding: 0; display: grid; gap: 4px; }
    .fila {
      display: grid; grid-template-columns: 42px 1fr auto auto auto;
      gap: 10px; align-items: center;
      border: 1px solid var(--linea-clara); border-left: 3px solid transparent;
      border-radius: var(--radio); padding: 8px 10px;
    }
    .fila--pj { border-left-color: rgba(76, 106, 55, .6); }
    .fila--activa { border-color: var(--oro); background: rgba(157, 122, 47, .08); }
    .fila--caido { opacity: .45; }

    .ini {
      font-family: var(--dato); font-size: 17px; color: var(--oro); text-align: center;
    }
    .quien { display: grid; gap: 1px; min-width: 0; }
    .nombre { color: var(--tinta); }
    .tipo {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia);
    }

    .vida { display: grid; gap: 3px; justify-items: end; min-width: 92px; }
    .pg { font-family: var(--dato); font-size: 14px; color: var(--tinta); }
    .pg--mal { color: var(--vino); }
    .de { color: var(--sepia); font-size: 11px; }
    .barra { display: block; width: 80px; height: 3px; background: var(--linea-clara); border-radius: 2px; }
    .barra-dentro { display: block; height: 100%; background: var(--musgo); border-radius: 2px; }

    .ca { font-family: var(--dato); font-size: 11px; color: var(--sepia); white-space: nowrap; }

    .golpes { display: flex; gap: 3px; }
    .golpes button {
      font-family: var(--dato); font-size: 11px; padding: 4px 7px; cursor: pointer;
      background: transparent; border: 1px solid var(--linea-clara);
      border-radius: var(--radio); color: var(--sepia-hondo);
    }
    .golpes button:hover { color: var(--tinta); border-color: var(--oro); }
    .golpes .quitar:hover { color: var(--vino); border-color: var(--vino); }

    .nota { margin: 10px 0 0; font-size: 12px; color: var(--sepia); font-style: italic; }
    .estado { color: var(--sepia-claro); margin: 12px 0; }
    .estado--mal { color: var(--vino); }
  `,
})
export class CombatePanel implements OnInit {

  private readonly mesa = inject(MesaService);
  private readonly juego = inject(JuegoService);

  readonly combate = signal<Combate | null>(null);
  readonly guardados = signal<ResumenCombate[]>([]);
  readonly enemigos = signal<Enemigo[]>([]);
  readonly personajes = signal<Character[]>([]);
  readonly error = signal('');
  readonly abriendo = signal(false);

  titulo = '';
  enemigoElegido = '';
  personajeElegido = '';
  cuantos = 1;

  ngOnInit(): void {
    this.mesa.combates().subscribe({ next: cs => this.guardados.set(cs), error: () => {} });
    this.mesa.enemigos().subscribe({ next: es => this.enemigos.set(es), error: () => {} });
    // el DM ve todos los personajes, así que esta lista es el grupo entero
    this.juego.personajes().subscribe({ next: ps => this.personajes.set(ps), error: () => {} });
  }

  abrir(): void {
    if (this.abriendo()) return;
    this.abriendo.set(true);
    this.mesa.abrirCombate(this.titulo.trim() || 'Combate').subscribe({
      next: c => { this.combate.set(c); this.abriendo.set(false); this.titulo = ''; },
      error: () => { this.abriendo.set(false); this.error.set('No se ha podido abrir el combate.'); },
    });
  }

  cargar(id: string): void {
    this.mesa.combate(id).subscribe({
      next: c => this.combate.set(c),
      error: () => this.error.set('No se ha podido abrir ese combate.'),
    });
  }

  salir(): void {
    this.combate.set(null);
    this.mesa.combates().subscribe({ next: cs => this.guardados.set(cs), error: () => {} });
  }

  // --- meter gente ---

  meterEnemigos(): void {
    const c = this.combate();
    if (!c || !this.enemigoElegido) return;
    this.mesa.meterEnemigos(c.id, this.enemigoElegido, Number(this.cuantos) || 1).subscribe({
      next: act => this.combate.set(act),
      error: () => this.error.set('No se ha podido meter al enemigo.'),
    });
  }

  meterPersonaje(): void {
    const c = this.combate();
    if (!c || !this.personajeElegido) return;
    this.mesa.meterPersonaje(c.id, this.personajeElegido).subscribe({
      next: act => { this.combate.set(act); this.personajeElegido = ''; },
      error: () => this.error.set('No se ha podido meter al personaje.'),
    });
  }

  // --- llevar el combate ---

  iniciativa(): void {
    const c = this.combate();
    if (!c) return;
    this.mesa.tirarIniciativa(c.id, true).subscribe({
      next: act => this.combate.set(act),
      error: () => this.error.set('No se ha podido tirar iniciativa.'),
    });
  }

  siguiente(): void {
    const c = this.combate();
    if (!c) return;
    this.mesa.siguienteTurno(c.id).subscribe({
      next: act => this.combate.set(act),
      error: () => this.error.set('No se ha podido pasar el turno.'),
    });
  }

  pg(k: Combatiente, delta: number): void {
    const c = this.combate();
    if (!c) return;
    this.mesa.cambiarPg(c.id, k.id, delta).subscribe({
      next: act => this.combate.set(act),
      error: () => this.error.set('No se ha podido cambiar los puntos de golpe.'),
    });
  }

  quitar(k: Combatiente): void {
    const c = this.combate();
    if (!c) return;
    this.mesa.quitarCombatiente(c.id, k.id).subscribe({
      next: act => this.combate.set(act),
      error: () => this.error.set('No se ha podido sacarlo del combate.'),
    });
  }

  // --- pintar ---

  porcentaje(k: Combatiente): number {
    return k.hpMax > 0 ? Math.round((k.hpCurrent / k.hpMax) * 100) : 0;
  }

  malherido(k: Combatiente): boolean {
    return k.hpMax > 0 && k.hpCurrent <= k.hpMax / 4;
  }
}
