import { Component, input } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

import { SeccionMaster, SelectorMesa } from './campaign-picker';

/**
 * La barra del máster cuando entra POR LA CAMPAÑA y no por un personaje.
 *
 * {@link NavBar} cuelga todo de /personajes/:id y el máster no suele tener
 * personaje en su propia mesa. Esta barra lleva a la tienda y al elenco de la
 * campaña que está dirigiendo, con el selector para saltar a otra de las
 * suyas sin volver al registro de mesas.
 */
@Component({
  selector: 'arc-nav-master',
  imports: [RouterLink, RouterLinkActive, SelectorMesa],
  template: `
    <nav class="barra">
      <div class="interior" [class.ancha]="ancho()">
        <a class="tab tab--oro" [routerLink]="['/campanas', campanaId(), 'tienda']"
           routerLinkActive="activa">Tienda</a>
        <a class="tab tab--elenco" [routerLink]="['/campanas', campanaId(), 'elenco']"
           routerLinkActive="activa">Elenco</a>
        <arc-selector-mesa class="selector" [seccion]="seccion()" [actual]="campanaId()"
                           rotulo="Campaña" />
        <a class="tab tab--campana" routerLink="/campanas">Campañas</a>
        <a class="tab tab--fin" routerLink="/personajes">Mis personajes</a>
      </div>
    </nav>
  `,
  styles: `
    .barra {
      position: sticky; top: 0; z-index: 10;
      background: rgba(23, 18, 8, .92);
      backdrop-filter: blur(6px);
      border-bottom: 1px solid var(--linea-noche);
    }
    .interior {
      max-width: 1040px; margin: 0 auto;
      display: flex; gap: 4px; padding: 8px 12px;
      flex-wrap: wrap; align-items: center;
    }
    .interior.ancha { max-width: 1180px; }
    .tab {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia-claro);
      text-decoration: none; padding: 7px 12px;
      border: 1px solid transparent; border-radius: var(--radio);
    }
    .tab:hover { color: var(--pergamino); background: rgba(239, 228, 205, .06); }
    .tab.activa {
      color: var(--pergamino); border-color: var(--linea-noche);
      background: rgba(239, 228, 205, .08);
    }
    .tab--oro { color: var(--oro); }
    .tab--oro.activa { color: #c69a3d; border-color: rgba(157, 122, 47, .5); }
    .tab--elenco { color: #b48ea8; }
    .tab--elenco.activa { color: #c9a6bd; border-color: rgba(180, 142, 168, .5); }
    .tab--campana { color: #8a7bb0; }
    .selector { margin: 0 8px; }
    .tab--fin { margin-left: auto; }
  `,
})
export class NavMaster {
  readonly campanaId = input.required<string>();
  readonly seccion = input.required<SeccionMaster>();
  readonly ancho = input(false);
}
