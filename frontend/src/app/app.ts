import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

import { ActualizarBanner } from './shared/update-banner';

@Component({
  selector: 'arc-root',
  imports: [RouterOutlet, ActualizarBanner],
  template: `
    <router-outlet />
    <arc-actualizar-banner />
  `,
})
export class App {}
