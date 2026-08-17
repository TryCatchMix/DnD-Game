import { Component, inject, input } from '@angular/core';

import { DisenoService } from '../../core/diseno/diseno.service';
import { NavBar } from '../../shared/nav';
import { SelectorDiseno } from '../../core/diseno/selector-diseno';

/**
 * Ajustes · Diseño.
 *
 * Una lista de las pantallas que admiten varios diseños, con sus opciones. Sale
 * entera del catálogo (`core/diseno/diseno.catalogo.ts`): registrar la tienda o
 * las notas ahí las hace aparecer aquí solas, sin tocar esta pantalla.
 *
 * La elección se guarda en el aparato (no en el servidor): es tuya y viaja
 * contigo entre personajes, no entre dispositivos.
 */
@Component({
  selector: 'arc-ajustes',
  imports: [NavBar, SelectorDiseno],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Ajustes · Los Archivos</p>
        <h1>Diseño de las pantallas</h1>
        <p class="intro">Elige con qué cara quieres ver cada pantalla. Cambia solo el aspecto:
          los datos, las cuentas y los botones son los mismos en todos los diseños.</p>
      </header>

      @if (paginas.length === 0) {
        <p class="estado">Todavía no hay ninguna pantalla con diseños alternativos.</p>
      } @else {
        <div class="lista">
          @for (p of paginas; track p.id) {
            <arc-selector-diseno [pagina]="p.id" />
          }
        </div>
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 20px; }
    .cabecera h1 { font-size: 34px; line-height: 1.1; margin-top: 6px; }
    .intro { margin: 8px 0 0; color: var(--sepia-claro); }
    .lista { display: grid; gap: 14px; }
    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
  `,
})
export class AjustesPage {

  readonly personajeId = input.required<string>();

  readonly paginas = inject(DisenoService).paginas;
}
