import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { CampanasService } from '../../core/campaign.service';
import { NavBar } from '../../shared/nav';
import { EncargosPanel } from './quests-panel';
import { CronicaPanel } from './chronicle-panel';

type Pestana = 'encargos' | 'cronica';

/**
 * Panel de administración del DM. Reúne en un mismo sitio la gestión del clan:
 *  - Encargos: escribir, comprobar, guardar y publicar el tablón (lo que antes
 *    era la pantalla suelta del DM).
 *  - Crónica: añadir, editar y eliminar entradas de la crónica del clan.
 *
 * Solo entra el DM. Un jugador que llegue por la URL se va a su tablón.
 */
@Component({
  selector: 'arc-admin',
  imports: [NavBar, EncargosPanel, CronicaPanel],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Los Archivos · Panel del clan</p>
        <h1>Panel de administrador</h1>
      </header>

      <div class="pestanas" role="tablist">
        <button class="pestana" [class.activa]="pestana() === 'encargos'"
                role="tab" [attr.aria-selected]="pestana() === 'encargos'"
                (click)="pestana.set('encargos')">Encargos</button>
        <button class="pestana" [class.activa]="pestana() === 'cronica'"
                role="tab" [attr.aria-selected]="pestana() === 'cronica'"
                (click)="pestana.set('cronica')">Crónica</button>
      </div>

      @if (!campanaId()) {
        <p class="rotulo">Abriendo el panel…</p>
      } @else if (pestana() === 'encargos') {
        <arc-encargos-panel [campanaId]="campanaId()!" />
      } @else {
        <arc-cronica-panel />
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 16px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }

    .pestanas { display: flex; gap: 6px; border-bottom: 1px solid var(--linea); margin-bottom: 18px; flex-wrap: wrap; }
    .pestana {
      font-family: var(--dato); font-size: 11px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--sepia-claro); background: none; border: none; cursor: pointer;
      padding: 10px 14px; border-bottom: 2px solid transparent; margin-bottom: -1px;
    }
    .pestana:hover { color: var(--pergamino); }
    .pestana.activa { color: var(--pergamino); border-bottom-color: var(--oro); }
  `,
})
export class AdminPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly campanas = inject(CampanasService);
  private readonly router = inject(Router);

  readonly pestana = signal<Pestana>('encargos');

  /** La campaña de este personaje. Los encargos que se escriban aquí salen en
   *  SU tablón, así que el panel no se pinta hasta saber cuál es. */
  readonly campanaId = signal<string | null>(null);

  ngOnInit(): void {
    // El panel es del máster de esta campaña: si entra otro, a su tablón.
    this.campanas.contextoDe(this.personajeId()).subscribe({
      next: c => {
        if (!c.campaignId || !c.dm) { this.fuera(); return; }
        this.campanaId.set(c.campaignId);
      },
      error: () => this.fuera(),
    });
  }

  private fuera(): void {
    void this.router.navigate(['/personajes', this.personajeId(), 'tablon']);
  }
}
