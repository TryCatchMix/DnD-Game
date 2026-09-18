import { Component, computed, inject, input } from '@angular/core';
import { Router } from '@angular/router';

import { CampanasService } from '../core/campaign.service';

/** Las pantallas del máster que se pueden abrir por campaña. */
export type SeccionMaster = 'tienda' | 'elenco';

/**
 * EL SELECTOR DE MESA DEL MÁSTER: qué tienda o qué elenco está tocando.
 *
 * Quien dirige varias campañas tiene varios mostradores y varios elencos, y
 * antes solo llegaba a cada uno a través de un personaje que jugara en esa
 * mesa (que el máster casi nunca tiene). Este desplegable lista las campañas
 * que dirige y lleva a /campanas/:id/<sección>.
 *
 * Si no dirige ninguna no pinta nada: a un jugador no se le ofrece.
 */
@Component({
  selector: 'arc-selector-mesa',
  template: `
    @if (mesas().length > 0) {
      <label class="selector" [class.selector--claro]="claro()">
        <span>{{ rotulo() }}</span>
        <select [value]="actual() ?? ''" (change)="ir($any($event.target).value)"
                aria-label="Elegir la campaña que editas">
          @if (!actual()) { <option value="" disabled>Elige una campaña…</option> }
          @for (c of mesas(); track c.id) {
            <option [value]="c.id">{{ c.name }}</option>
          }
        </select>
      </label>
    }
  `,
  styles: `
    .selector { display: inline-flex; align-items: center; gap: 8px; flex-wrap: wrap; }
    .selector span {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--musgo-claro, #8fb06a);
    }
    .selector--claro span { color: var(--musgo); }
    select { width: auto; min-width: 180px; padding: 6px 10px; }
  `,
})
export class SelectorMesa {
  /** A qué pantalla se va al elegir. */
  readonly seccion = input.required<SeccionMaster>();
  /** La campaña que se está editando ahora, si hay. */
  readonly actual = input<string | null>(null);
  readonly rotulo = input('Editando la campaña');
  /** Para cuando va sobre pergamino y no sobre la noche. */
  readonly claro = input(false);

  private readonly campanas = inject(CampanasService);
  private readonly router = inject(Router);

  private readonly dirigidas = this.campanas.queDirijo();
  readonly mesas = computed(() => this.dirigidas() ?? []);

  ir(id: string): void {
    if (!id || id === this.actual()) return;
    void this.router.navigate(['/campanas', id, this.seccion()]);
  }
}
