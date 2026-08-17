import { Component, OnInit, inject, input } from '@angular/core';

import { DisenoHost } from '../../core/design/design-host';
import { FichaStore } from './sheet.store';
import { NavBar } from '../../shared/nav';

/**
 * La hoja de personaje D&D 3.5.
 *
 * Esta página ya no pinta la ficha: la monta. Provee `FichaStore` (el estado y
 * las llamadas al backend) y deja el hueco donde `<arc-diseno>` coloca el diseño
 * que el jugador haya elegido en Ajustes → Diseño.
 *
 * Los diseños viven en `disenos/` y solo tienen plantilla y estilos. Así se
 * pueden probar varias hojas distintas sin tocar ni una línea de lógica.
 */
@Component({
  selector: 'arc-ficha',
  imports: [NavBar, DisenoHost],
  providers: [FichaStore],   // una ficha por visita: nace y muere con la pantalla
  template: `
    @if (personajeId(); as pid) { <arc-nav [personajeId]="pid" /> }
    <arc-diseno pagina="ficha" />
  `,
})
export class FichaPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly store = inject(FichaStore);

  ngOnInit(): void { this.store.iniciar(this.personajeId()); }
}
