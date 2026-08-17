import { Component, computed, inject, input } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

import { AuthService } from '../core/auth.service';

/**
 * Barra de pestañas fija (arriba) para moverse entre las pantallas de un
 * personaje: tablón, ficha, tienda, crónica y volver a elegir personaje.
 * La pestaña del editor (DM) solo aparece si quien mira es el DM.
 */
@Component({
  selector: 'arc-nav',
  imports: [RouterLink, RouterLinkActive],
  template: `
    <nav class="barra">
      <div class="interior" [class.ancha]="ancho()">
        <a class="tab" [routerLink]="['/personajes', personajeId(), 'tablon']"
           routerLinkActive="activa">Tablón</a>
        <a class="tab" [routerLink]="['/personajes', personajeId(), 'ficha']"
           routerLinkActive="activa">Ficha</a>
        <a class="tab tab--oro" [routerLink]="['/personajes', personajeId(), 'tienda']"
           routerLinkActive="activa">Tienda</a>
        <a class="tab" [routerLink]="['/personajes', personajeId(), 'cronica']"
           routerLinkActive="activa">Crónica</a>
        <a class="tab tab--arcano" [routerLink]="['/personajes', personajeId(), 'habilidades']"
           routerLinkActive="activa">Habilidades</a>
        <a class="tab tab--nota" [routerLink]="['/personajes', personajeId(), 'notas']"
           routerLinkActive="activa">Notas</a>
        <a class="tab tab--trasfondo" [routerLink]="['/personajes', personajeId(), 'trasfondo']"
           routerLinkActive="activa">Trasfondo</a>
        <a class="tab tab--casa" [routerLink]="['/personajes', personajeId(), 'propiedades']"
           routerLinkActive="activa">Propiedades</a>
        @if (esDM()) {
          <a class="tab tab--mesa" [routerLink]="['/personajes', personajeId(), 'mesa']"
             routerLinkActive="activa">La Mesa</a>
          <a class="tab tab--dm" [routerLink]="['/personajes', personajeId(), 'admin']"
             routerLinkActive="activa">Admin (DM)</a>
        }
        <a class="tab tab--ajuste" [routerLink]="['/personajes', personajeId(), 'ajustes']"
           routerLinkActive="activa">Diseño</a>
        <a class="tab tab--fin" [routerLink]="['/personajes']">Cambiar de personaje</a>
      </div>
    </nav>
  `,
  styles: `
    .barra {
      position: sticky;
      top: 0;
      z-index: 10;
      background: rgba(23, 18, 8, .92);
      backdrop-filter: blur(6px);
      border-bottom: 1px solid var(--linea-noche);
    }
    .interior.ancha { max-width: 1180px; }
    .interior {
      max-width: 720px;
      margin: 0 auto;
      display: flex;
      gap: 4px;
      padding: 8px 12px;
      flex-wrap: wrap;
    }
    .tab {
      font-family: var(--dato);
      font-size: 10px;
      letter-spacing: .12em;
      text-transform: uppercase;
      color: var(--sepia-claro);
      text-decoration: none;
      padding: 7px 12px;
      border: 1px solid transparent;
      border-radius: var(--radio);
    }
    .tab:hover { color: var(--pergamino); background: rgba(239, 228, 205, .06); }
    .tab.activa {
      color: var(--pergamino);
      border-color: var(--linea-noche);
      background: rgba(239, 228, 205, .08);
    }
    .tab--oro { color: var(--oro); }
    .tab--oro.activa { color: #c69a3d; border-color: rgba(157, 122, 47, .5); }
    .tab--mesa { color: var(--vino); }
    .tab--mesa.activa { color: #c4614f; border-color: rgba(143, 46, 34, .55); }
    .tab--dm { color: var(--musgo); }
    .tab--dm.activa { color: #6a8a4f; border-color: rgba(76, 106, 55, .5); }
    .tab--arcano { color: #8a7bb0; }
    .tab--arcano.activa { color: #a294c9; border-color: rgba(138, 123, 176, .5); }
    .tab--nota { color: var(--oro); }
    .tab--nota.activa { color: #c69a3d; border-color: rgba(157, 122, 47, .5); }
    .tab--trasfondo { color: #b0846a; }
    .tab--trasfondo.activa { color: #c99a7f; border-color: rgba(176, 132, 106, .5); }
    .tab--casa { color: var(--musgo); }
    .tab--casa.activa { color: #6a8a4f; border-color: rgba(76, 106, 55, .5); }
    .tab--ajuste { color: var(--sepia); }
    .tab--ajuste.activa { color: var(--sepia-claro); }
    .tab--fin { margin-left: auto; }
  `,
})
export class NavBar {
  readonly personajeId = input.required<string>();

  /** La Mesa usa el ancho completo; la barra tiene que acompañarla o el
   *  contenido queda desalineado con sus propias pestañas. */
  readonly ancho = input(false);

  private readonly auth = inject(AuthService);
  readonly esDM = computed(() => this.auth.rol() === 'DM');
}
