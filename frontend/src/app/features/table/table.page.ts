import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { CampanasService } from '../../core/campaign.service';
import { MesaService } from '../../core/table.service';
import { NavBar } from '../../shared/nav';
import { BibliotecaPanel } from './library-panel';
import { CombatePanel } from './combat-panel';
import { EnemigosPanel } from './enemies-panel';
import { MisionDetalle } from './mission-detail';
import { MisionesPanel } from './missions-panel';

type Pestana = 'misiones' | 'biblioteca' | 'enemigos' | 'combate';

/**
 * La Mesa: donde el DM prepara las partidas.
 *
 * Dos pestañas y una tercera vista que no es pestaña:
 *  - Misiones:   la rejilla de tarjetas (crear, editar, eliminar).
 *  - Biblioteca: todo el material subido, se reparta como se reparta.
 *  - El detalle de una misión, que sustituye a la rejilla al abrir una tarjeta.
 *
 * El detalle no es una ruta aparte a propósito: se entra y se sale de él
 * constantemente mientras preparas, y volver con el botón del navegador tiene
 * que devolverte a la lista de personajes, no a la tarjeta anterior.
 *
 * La Mesa es DE UNA CAMPAÑA. Esta pantalla cuelga de un personaje porque la
 * barra de pestañas lo hace, así que lo primero que hace es traducir personaje
 * → campaña y decírselo al servicio; hasta entonces no se pinta ningún panel,
 * o pedirían datos sin saber de qué mesa.
 *
 * Entra quien dirija esa campaña. Un jugador que llegue por la URL se va a su
 * tablón, y quien traiga un personaje sin campaña, también.
 */
@Component({
  selector: 'arc-mesa',
  imports: [NavBar, MisionesPanel, MisionDetalle, BibliotecaPanel, EnemigosPanel, CombatePanel],
  template: `
    <arc-nav [personajeId]="personajeId()" [ancho]="true" />

    <div class="contenedor contenedor--ancho">
      @if (!lista()) {
        <p class="intro">Abriendo la mesa…</p>
      } @else if (abierta(); as id) {
        <arc-mision-detalle [misionId]="id" (volver)="cerrarMision()" />
      } @else {
        <header class="cabecera">
          <p class="rotulo">Los Archivos · Preparación</p>
          <h1>La Mesa</h1>
          <p class="intro">Todo lo que hace falta antes de sentarse a jugar: las misiones que estás
            cocinando, su guion y el material que vas a enseñar.</p>
        </header>

        <div class="pestanas" role="tablist">
          <button class="pestana" [class.activa]="pestana() === 'misiones'"
                  role="tab" [attr.aria-selected]="pestana() === 'misiones'"
                  (click)="pestana.set('misiones')">Misiones</button>
          <button class="pestana" [class.activa]="pestana() === 'biblioteca'"
                  role="tab" [attr.aria-selected]="pestana() === 'biblioteca'"
                  (click)="pestana.set('biblioteca')">Biblioteca</button>
          <button class="pestana" [class.activa]="pestana() === 'enemigos'"
                  role="tab" [attr.aria-selected]="pestana() === 'enemigos'"
                  (click)="pestana.set('enemigos')">Enemigos</button>
          <button class="pestana" [class.activa]="pestana() === 'combate'"
                  role="tab" [attr.aria-selected]="pestana() === 'combate'"
                  (click)="pestana.set('combate')">Combate</button>
        </div>

        @if (pestana() === 'misiones') {
          <arc-misiones-panel (abrir)="abrirMision($event)" />
        } @else if (pestana() === 'enemigos') {
          <arc-enemigos-panel />
        } @else if (pestana() === 'combate') {
          <arc-combate-panel />
        } @else {
          <arc-biblioteca-panel />
        }
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 16px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 30px; color: var(--pergamino); margin-top: 4px; }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 8px 0 0; max-width: 62ch; }

    .pestanas { display: flex; gap: 6px; border-bottom: 1px solid var(--linea-noche); margin-bottom: 20px; flex-wrap: wrap; }
    .pestana {
      font-family: var(--dato); font-size: 11px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--sepia-claro); background: none; border: none;
      padding: 10px 14px; border-bottom: 2px solid transparent; margin-bottom: -1px;
    }
    .pestana:hover { color: var(--pergamino); }
    .pestana.activa { color: var(--pergamino); border-bottom-color: var(--oro); }
  `,
})
export class MesaPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly campanas = inject(CampanasService);
  private readonly mesa = inject(MesaService);
  private readonly router = inject(Router);

  readonly pestana = signal<Pestana>('misiones');
  /** Id de la misión abierta, o null si estamos en la rejilla. */
  readonly abierta = signal<string | null>(null);

  /** Hasta que no está resuelta la campaña no se pinta nada: los paneles piden
   *  datos en cuanto se montan y no sabrían a qué mesa. */
  readonly lista = signal(false);

  ngOnInit(): void {
    this.campanas.contextoDe(this.personajeId()).subscribe({
      next: c => {
        if (!c.campaignId || !c.dm) { this.fuera(); return; }
        this.mesa.usar(c.campaignId);
        this.lista.set(true);
      },
      error: () => this.fuera(),
    });
  }

  private fuera(): void {
    void this.router.navigate(['/personajes', this.personajeId(), 'tablon']);
  }

  abrirMision(id: string): void {
    this.abierta.set(id);
    window.scrollTo({ top: 0 });
  }

  /**
   * Al volver, la rejilla se vuelve a montar (el @if la había destruido) y su
   * ngOnInit recarga las tarjetas solo: los contadores salen ya actualizados.
   */
  cerrarMision(): void {
    this.abierta.set(null);
    window.scrollTo({ top: 0 });
  }
}
