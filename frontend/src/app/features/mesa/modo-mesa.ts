import { Component, computed, input, output, signal } from '@angular/core';

import { Archivo, DetalleMision, NotaMesa, TIPOS_NOTA, TipoNota } from '../../core/mesa.types';
import { Lamina } from './lamina';

/**
 * Modo mesa: lo que el DM tiene delante MIENTRAS juega, no mientras prepara.
 *
 * Por eso aquí no hay ni un botón de editar: pantalla completa, letra grande,
 * el guion paso a paso y una tira de láminas para enseñar. Un paso cada vez,
 * con las flechas, porque en la partida no se lee, se ojea.
 */
@Component({
  selector: 'arc-modo-mesa',
  imports: [Lamina],
  template: `
    <div class="fondo" role="dialog" aria-modal="true" [attr.aria-label]="'Modo mesa: ' + mision().title">
      <header class="barra">
        <div>
          <p class="rotulo">Modo mesa · paso {{ i() + 1 }} de {{ Math.max(pasos().length, 1) }}</p>
          <h2>{{ mision().title }}</h2>
        </div>
        <button class="boton" (click)="cerrar.emit()">Salir ✕</button>
      </header>

      <div class="escenario">
        @if (paso(); as p) {
          <article class="paso" [class]="'paso paso--' + p.kind">
            <p class="tipo">{{ nombreTipo(p.kind) }}</p>
            @if (p.title) { <h3>{{ p.title }}</h3> }
            <p class="cuerpo">{{ p.body }}</p>
          </article>
        } @else {
          <p class="vacio">Esta misión aún no tiene guion. Sal y escribe el primer paso.</p>
        }
      </div>

      <nav class="pies">
        <button class="boton" [disabled]="i() === 0" (click)="mover(-1)">‹ Anterior</button>

        @if (laminas().length) {
          <ul class="tira">
            @for (a of laminas(); track a.id) {
              <li>
                <button class="mini" (click)="ensenar.emit(a)" [attr.aria-label]="'Enseñar ' + a.title">
                  <arc-lamina [assetId]="a.id" [alt]="a.title" />
                </button>
              </li>
            }
          </ul>
        }

        <button class="boton" [disabled]="i() >= pasos().length - 1" (click)="mover(1)">Siguiente ›</button>
      </nav>
    </div>
  `,
  host: { '(document:keydown)': 'tecla($event)' },
  styles: `
    .fondo {
      position: fixed; inset: 0; z-index: 40;
      background: var(--noche-honda);
      display: flex; flex-direction: column; gap: 14px;
      padding: 18px clamp(16px, 5vw, 60px) 20px;
    }

    .barra { display: flex; align-items: flex-end; justify-content: space-between; gap: 12px; }
    .barra .rotulo { color: var(--sepia); margin: 0; }
    .barra h2 { font-size: 26px; color: var(--pergamino); margin-top: 3px; }
    .barra .boton { color: var(--pergamino); border-color: var(--linea-noche); }

    .escenario { flex: 1; min-height: 0; overflow: auto; display: grid; place-items: center; }

    .paso {
      width: min(72ch, 100%);
      background: var(--pergamino); color: var(--tinta);
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      box-shadow: 0 16px 40px rgba(0,0,0,.5);
      padding: clamp(20px, 4vw, 40px);
    }
    .tipo {
      font-family: var(--dato); font-size: 10px; letter-spacing: .18em; text-transform: uppercase;
      color: var(--sepia); margin: 0 0 10px;
    }
    .paso h3 { font-size: clamp(22px, 3vw, 30px); margin-bottom: 12px; }
    .cuerpo { font-size: clamp(18px, 2.2vw, 23px); line-height: 1.6; white-space: pre-wrap; margin: 0; }

    /* El texto para leer en voz alta va destacado, como el recuadro de un módulo. */
    .paso--lectura { border-left: 4px solid var(--oro); background: var(--pergamino-claro); }
    .paso--lectura .cuerpo { font-style: italic; }
    .paso--pnj    { border-left: 4px solid var(--vino); }
    .paso--botin  { border-left: 4px solid var(--musgo); }

    .vacio { color: var(--sepia-claro); font-style: italic; }

    .pies { display: flex; align-items: center; gap: 12px; }
    .pies .boton { color: var(--pergamino); border-color: var(--linea-noche); }

    .tira { list-style: none; display: flex; gap: 8px; margin: 0; padding: 0; overflow-x: auto; flex: 1; }
    .mini {
      width: 92px; padding: 0; border: 1px solid var(--linea-noche); border-radius: var(--radio);
      background: none; overflow: hidden; display: block;
    }
    .mini:hover { border-color: var(--oro); }
    .mini arc-lamina { height: 58px; }
  `,
})
export class ModoMesa {

  readonly mision = input.required<DetalleMision>();
  readonly cerrar = output<void>();
  /** Pedir que se abra una lámina a pantalla completa para enseñarla. */
  readonly ensenar = output<Archivo>();

  protected readonly Math = Math;

  private readonly indice = signal(0);

  readonly pasos = computed<NotaMesa[]>(() => this.mision().notes);
  readonly laminas = computed(() => this.mision().assets.filter(a => a.kind === 'imagen'));
  readonly i = computed(() => Math.min(this.indice(), Math.max(this.pasos().length - 1, 0)));
  readonly paso = computed<NotaMesa | undefined>(() => this.pasos()[this.i()]);

  nombreTipo(k: TipoNota): string { return TIPOS_NOTA[k]; }

  mover(paso: number): void {
    this.indice.update(n => Math.min(Math.max(n + paso, 0), Math.max(this.pasos().length - 1, 0)));
  }

  tecla(e: KeyboardEvent): void {
    if (e.key === 'Escape') this.cerrar.emit();
    else if (e.key === 'ArrowLeft') this.mover(-1);
    else if (e.key === 'ArrowRight' || e.key === ' ') this.mover(1);
  }
}
