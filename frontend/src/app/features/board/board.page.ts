import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { JuegoService } from '../../core/game.service';
import { QuestCard } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

@Component({
  selector: 'arc-board',
  imports: [NavBar],
  template: `
    <arc-nav [personajeId]="personajeId()" />
    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Tablón de encargos · Dorakan</p>
        <h1>Qué hay para hoy</h1>
      </header>

      @if (cargando()) {
        <p class="estado">Cotejando el tablón…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (encargos().length === 0) {
        <p class="estado">
          No hay nada clavado en el tablón. Vuelve cuando el capataz baje del pozo.
        </p>
      } @else {

        @if (jugables().length > 0) {
          <ul class="lista">
            @for (q of jugables(); track q.id) {
              <li class="hoja tarjeta">
                <div class="fila">
                  <h2>{{ q.title }}</h2>
                  @if (q.faction) { <span class="sello">{{ q.faction }}</span> }
                </div>

                <p class="gancho">{{ q.hook }}</p>

                @if (q.skills.length > 0) {
                  <p class="habilidades">
                    @for (s of q.skills; track s) {
                      <span>{{ s }}</span>
                    }
                  </p>
                }

                <div class="pie-tarjeta">
                  <span class="dato">Vigor {{ q.vigorCost }}</span>
                  <span class="sep">·</span>
                  <span class="dato">{{ q.duration }}</span>
                  <span class="sep">·</span>
                  <span class="dato">{{ q.sceneCount }} escenas</span>
                  @if (q.rewardNote) {
                    <span class="sep">·</span>
                    <span class="dato oro">{{ q.rewardNote }}</span>
                  }
                </div>

                @if (q.signatures) {
                  <p class="firmas">
                    {{ q.signatures }}
                    @if (q.closesIn) { <span class="sep">·</span> {{ q.closesIn }} }
                  </p>
                }

                <button class="boton boton--lacre"
                        [disabled]="firmando() === q.id"
                        (click)="firmar(q)">
                  {{ firmando() === q.id ? 'Firmando…'
                     : q.availability === 'JOINED' ? 'Continuar' : 'Firmar' }}
                </button>
              </li>
            }
          </ul>
        }

        <!-- Los bloqueados NO se ocultan. Ver "requiere Puente Norte en pie" es
             lo que le cuenta al jugador que otro cambió el mundo. -->
        @if (bloqueados().length > 0) {
          <p class="rotulo separador">Fuera de tu alcance ahora mismo</p>
          <ul class="lista">
            @for (q of bloqueados(); track q.id) {
              <li class="hoja tarjeta tarjeta--gris">
                <div class="fila">
                  <h2>{{ q.title }}</h2>
                </div>
                <p class="gancho">{{ q.hook }}</p>
                <p class="motivo">{{ q.reason }}</p>
              </li>
            }
          </ul>
        }
      }
    </div>
  `,
  styles: `
    .cabecera { margin-bottom: 22px; }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .cabecera .rotulo { color: var(--sepia-claro); }

    .navegacion { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
    .enlace {
      font-family: var(--dato);
      font-size: 10px;
      letter-spacing: .12em;
      text-transform: uppercase;
      color: var(--sepia-claro);
      background: transparent;
      border: 1px solid var(--linea-noche);
      border-radius: var(--radio);
      padding: 6px 10px;
    }
    .enlace:hover { color: var(--pergamino); border-color: rgba(239,228,205,.4); }
    .enlace--tienda { color: var(--oro); border-color: rgba(157,122,47,.5); }
    .enlace--tienda:hover { color: #c69a3d; }

    .lista { list-style: none; margin: 0 0 8px; padding: 0; display: grid; gap: 14px; }

    .tarjeta { padding: 20px 20px 18px; }

    .fila { display: flex; align-items: baseline; gap: 10px; justify-content: space-between; }

    h2 { font-size: 21px; color: var(--tinta); line-height: 1.25; }

    .sello {
      font-family: var(--dato);
      font-size: 9px;
      letter-spacing: .16em;
      text-transform: uppercase;
      color: var(--vino);
      border: 1px solid rgba(143,46,34,.4);
      border-radius: var(--radio);
      padding: 3px 6px;
      white-space: nowrap;
    }

    .gancho {
      font-size: 16px;
      color: var(--sepia-hondo);
      margin: 10px 0 12px;
      line-height: 1.5;
    }

    .habilidades {
      display: flex; flex-wrap: wrap; gap: 6px;
      margin: 0 0 12px; padding: 0;
    }
    .habilidades span {
      font-family: var(--dato);
      font-size: 9px;
      letter-spacing: .14em;
      text-transform: uppercase;
      color: var(--sepia);
      border-bottom: 1px solid var(--linea);
      padding-bottom: 2px;
    }

    .pie-tarjeta {
      display: flex; flex-wrap: wrap; align-items: center; gap: 6px;
      color: var(--sepia);
      border-top: 1px solid var(--linea-clara);
      padding-top: 10px;
      margin-bottom: 14px;
    }
    .sep { color: var(--linea-fuerte); }
    .oro { color: var(--oro); }

    .firmas {
      font-family: var(--dato);
      font-size: 11px;
      color: var(--musgo);
      margin: -6px 0 12px;
    }

    /* Bloqueado: se apaga el papel, no se esconde la tarjeta. */
    .tarjeta--gris {
      background: var(--pergamino-hueso);
      opacity: .62;
      box-shadow: none;
    }
    .tarjeta--gris h2 { color: var(--sepia-hondo); }

    .motivo {
      font-family: var(--dato);
      font-size: 11px;
      letter-spacing: .04em;
      color: var(--vino);
      border-top: 1px solid var(--linea-clara);
      padding-top: 10px;
      margin: 0;
    }

    .separador { margin: 28px 0 12px; color: var(--sepia); }

    .estado {
      font-style: italic;
      color: var(--sepia-claro);
      padding: 28px 0;
    }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class BoardPage implements OnInit {

  /** Llega de la ruta /personajes/:personajeId/tablon */
  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly router = inject(Router);

  readonly encargos = signal<QuestCard[]>([]);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);
  readonly firmando = signal<string | null>(null);

  readonly jugables = computed(() =>
    this.encargos().filter(q => this.esJugable(q.availability)));

  readonly bloqueados = computed(() =>
    this.encargos().filter(q => !this.esJugable(q.availability)));

  ngOnInit(): void {
    this.juego.tablon(this.personajeId()).subscribe({
      next: qs => { this.encargos.set(qs); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido leer el tablón. Inténtalo otra vez.');
      },
    });
  }

  firmar(q: QuestCard): void {
    if (q.availability === 'JOINED') {
      void this.router.navigate(['/personajes', this.personajeId(), 'escena']);
      return;
    }

    this.firmando.set(q.id);
    this.juego.firmar(this.personajeId(), q.id).subscribe({
      next: () => {
        this.firmando.set(null);
        void this.router.navigate(['/personajes', this.personajeId(), 'escena']);
      },
      error: err => {
        this.firmando.set(null);
        // 409 trae el motivo real ("Ya estás en otro encargo", "Requiere:
        // Puente Norte en pie"). Es más útil que un mensaje genérico.
        this.error.set(err?.error?.message ?? 'No se ha podido firmar el encargo.');
      },
    });
  }

  verFicha(): void {
    void this.router.navigate(['/personajes', this.personajeId(), 'ficha']);
  }

  verTienda(): void {
    void this.router.navigate(['/personajes', this.personajeId(), 'tienda']);
  }

  cambiarPersonaje(): void {
    void this.router.navigate(['/personajes']);
  }

  private esJugable(a: QuestCard['availability']): boolean {
    return a === 'AVAILABLE' || a === 'RECRUITING' || a === 'JOINED';
  }
}
