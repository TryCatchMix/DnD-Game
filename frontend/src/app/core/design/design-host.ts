import { Component, Type, computed, effect, inject, input, signal } from '@angular/core';
import { NgComponentOutlet } from '@angular/common';

import { DisenoService } from './design.service';
import { PaginaId } from './design.types';

/**
 * El hueco donde se pinta el diseño elegido de una pantalla:
 *
 *   <arc-diseno pagina="ficha" />
 *
 * El componente que entra aquí se crea DENTRO del árbol de la página, así que
 * puede `inject()` lo que la página provea (el store con la lógica). Por eso un
 * diseño no necesita ni inputs ni outputs: pide el store y ya tiene todo.
 *
 * Mientras llega el módulo del diseño nuevo se sigue viendo el anterior; así
 * cambiar de diseño no parpadea en blanco.
 */
@Component({
  selector: 'arc-diseno',
  imports: [NgComponentOutlet],
  template: `
    @if (componente(); as c) {
      <ng-container *ngComponentOutlet="c" />
    } @else if (fallo()) {
      <div class="contenedor">
        <p class="aviso-diseno" role="alert">
          No se ha podido cargar el diseño elegido. Prueba a elegir otro en Ajustes.
        </p>
      </div>
    } @else {
      <div class="contenedor"><p class="aviso-diseno">Preparando la pantalla…</p></div>
    }
  `,
  styles: `
    .aviso-diseno { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
  `,
})
export class DisenoHost {

  readonly pagina = input.required<PaginaId>();

  private readonly disenos = inject(DisenoService);

  readonly componente = signal<Type<unknown> | null>(null);
  readonly fallo = signal(false);

  private readonly opcion = computed(() => this.disenos.opcion(this.pagina())());

  constructor() {
    effect(onCleanup => {
      const opcion = this.opcion();
      let vigente = true;
      onCleanup(() => { vigente = false; });   // cambio rápido de diseño: la carga vieja se descarta

      if (!opcion) { this.componente.set(null); this.fallo.set(true); return; }

      this.fallo.set(false);
      opcion.cargar().then(
        c => { if (vigente) this.componente.set(c); },
        () => { if (vigente) { this.componente.set(null); this.fallo.set(true); } },
      );
    });
  }
}
