import { Component, computed, inject, input } from '@angular/core';

import { DisenoService } from './design.service';
import { PaginaId } from './design.types';

/**
 * Los diseños de UNA pantalla, en tarjetas para elegir.
 * Se usa en Ajustes, una vez por pantalla registrada en el catálogo.
 */
@Component({
  selector: 'arc-selector-diseno',
  template: `
    @if (pag(); as p) {
      <section class="hoja bloque">
        <div class="alto">
          <div>
            <p class="rotulo">{{ p.nombre }}</p>
            <p class="resumen">{{ p.resumen }}</p>
          </div>
          @if (!esPorDefecto()) {
            <button class="enlace" type="button" (click)="restablecer()">Volver al de fábrica</button>
          }
        </div>

        @if (p.opciones.length < 2) {
          <p class="unico">Esta pantalla todavía tiene un solo diseño.</p>
        }

        <ul class="opciones" role="radiogroup" [attr.aria-label]="'Diseño de ' + p.nombre">
          @for (o of p.opciones; track o.id) {
            <li>
              <button type="button" class="caja opcion" role="radio"
                      [class.elegida]="o.id === elegido()"
                      [attr.aria-checked]="o.id === elegido()"
                      (click)="elegir(o.id)">
                <span class="marca" aria-hidden="true"></span>
                <span class="cuerpo">
                  <span class="nombre">{{ o.nombre }}
                    @if (o.id === p.opciones[0].id) { <span class="fabrica">de fábrica</span> }
                  </span>
                  <span class="detalle">{{ o.resumen }}</span>
                </span>
              </button>
            </li>
          }
        </ul>
      </section>
    }
  `,
  styles: `
    .bloque { padding: 16px 18px 18px; }
    .alto { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
    .resumen { margin: 4px 0 0; color: var(--sepia-hondo); font-size: 15px; }
    .enlace { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; border: none; background: transparent; color: var(--vino); padding: 0; }
    .unico { margin: 10px 0 0; font-style: italic; color: var(--sepia-claro); font-size: 14px; }

    .opciones { list-style: none; margin: 14px 0 0; padding: 0; display: grid; gap: 8px; }
    .caja { border: 1px solid var(--linea); border-radius: var(--radio); background: var(--pergamino-claro); }
    .opcion {
      width: 100%; display: flex; align-items: flex-start; gap: 12px; text-align: left;
      padding: 12px 14px; font: inherit; color: var(--tinta); cursor: pointer;
    }
    .opcion:hover { background: rgba(43,33,23,.05); }
    .opcion.elegida { border-color: var(--vino); box-shadow: inset 3px 0 0 var(--vino); }

    /* La marca es la casilla marcada a mano de la hoja impresa. */
    .marca { flex: 0 0 auto; width: 14px; height: 14px; margin-top: 5px; border: 1px solid var(--linea-fuerte); border-radius: 50%; }
    .opcion.elegida .marca { border-color: var(--vino); box-shadow: inset 0 0 0 3px var(--pergamino-claro), inset 0 0 0 14px var(--vino); }

    .cuerpo { display: grid; gap: 2px; min-width: 0; }
    .nombre { font-family: var(--display); font-size: 20px; line-height: 1.2; }
    .fabrica { font-family: var(--dato); font-size: 8px; letter-spacing: .14em; text-transform: uppercase; color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio); padding: 1px 5px; margin-left: 8px; vertical-align: middle; }
    .detalle { color: var(--sepia-hondo); font-size: 14px; }
  `,
})
export class SelectorDiseno {

  readonly pagina = input.required<PaginaId>();

  private readonly disenos = inject(DisenoService);

  readonly pag = computed(() => this.disenos.pagina(this.pagina()));
  readonly elegido = computed(() => this.disenos.idElegido(this.pagina()));
  readonly esPorDefecto = computed(() => this.disenos.esPorDefecto(this.pagina()));

  elegir(id: string): void { this.disenos.elegir(this.pagina(), id); }
  restablecer(): void { this.disenos.restablecer(this.pagina()); }
}
