import { Component, inject, signal } from '@angular/core';

import { FichaStore } from './sheet.store';

/**
 * Las dotes del personaje.
 *
 * Cada dote se despliega para leer lo que hace: el beneficio viaja YA resuelto
 * en la ficha (el backend lo busca en el compendio por el nombre), así que el
 * jugador no tiene que irse a la pestaña de Habilidades a mirar qué hacía su
 * Ataque poderoso. Ese era medio motivo de importar las dotes.
 *
 * Va aparte de los diseños por lo mismo que el editor y el panel de conjuros:
 * es el mismo HTML en los tres y solo cambian los colores, que salen de las
 * variables CSS del diseño activo.
 */
@Component({
  selector: 'arc-dotes-panel',
  template: `
    @if (store.ficha(); as f) {
      @if (!f.feats?.length) {
        <p class="vacio">
          Sin dotes apuntadas. Se añaden en «Editar ficha»; el compendio de la
          pestaña Habilidades tiene las 110 del manual.
        </p>
      } @else {
        <ul class="dotes">
          @for (d of f.feats; track d.name + d.detail) {
            <li class="dote" [class.dote--abierta]="abierta() === d.name + d.detail">
              <button type="button" class="titular" (click)="alternar(d.name + d.detail)"
                      [attr.aria-expanded]="abierta() === d.name + d.detail">
                <span class="nombre">
                  {{ d.name }}@if (d.detail) { <span class="detalle">({{ d.detail }})</span> }
                </span>
                @if (d.kind) { <span class="tipo">{{ d.kind }}</span> }
              </button>

              @if (abierta() === d.name + d.detail) {
                @if (d.prerequisite) {
                  <p class="requisito"><strong>Requiere:</strong> {{ d.prerequisite }}</p>
                }
                @if (d.benefit) {
                  <p class="beneficio">{{ d.benefit }}</p>
                } @else {
                  <p class="beneficio beneficio--casa">
                    No está en el manual: es una dote de la casa, así que aquí no
                    hay texto que enseñar.
                  </p>
                }
              }
            </li>
          }
        </ul>
      }
    }
  `,
  styles: `
    .vacio { color: var(--sepia); font-size: 14px; margin: 0; line-height: 1.5; }

    .dotes { list-style: none; margin: 0; padding: 0; display: grid; gap: 6px; }
    .dote { border: 1px solid var(--linea-clara); border-radius: var(--radio); }
    .dote--abierta { border-color: rgba(157, 122, 47, .45); }

    .titular {
      display: flex; width: 100%; align-items: baseline; justify-content: space-between;
      gap: 10px; background: none; border: 0; font: inherit; color: inherit;
      padding: 8px 10px; cursor: pointer; text-align: left;
    }
    .titular:hover .nombre { color: var(--oro); }
    .nombre { color: var(--tinta); font-size: 15px; }
    .detalle { color: var(--sepia); font-size: 13px; margin-left: 5px; }
    .tipo {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); white-space: nowrap;
    }

    .requisito { margin: 0; padding: 0 10px 6px; font-size: 13px; color: var(--sepia-hondo); }
    .requisito strong { color: var(--tinta); }
    .beneficio {
      margin: 0; padding: 0 10px 10px; font-size: 14px;
      color: var(--sepia-hondo); line-height: 1.55;
    }
    .beneficio--casa { font-style: italic; color: var(--sepia); }
  `,
})
export class DotesPanel {
  readonly store = inject(FichaStore);

  /** Cuál está desplegada. Se identifica por nombre+detalle porque una dote se
   *  puede tener dos veces con cosas distintas (Arma focalizada con dos armas). */
  readonly abierta = signal<string | null>(null);

  alternar(clave: string): void {
    this.abierta.set(this.abierta() === clave ? null : clave);
  }
}
