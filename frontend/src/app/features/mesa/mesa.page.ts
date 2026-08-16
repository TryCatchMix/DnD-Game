import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { AuthService } from '../../core/auth.service';
import { NavBar } from '../../shared/nav';
import { BibliotecaPanel } from './biblioteca-panel';
import { MisionDetalle } from './mision-detalle';
import { MisionesPanel } from './misiones-panel';

type Pestana = 'misiones' | 'biblioteca';

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
 * Solo entra el DM. Un jugador que llegue por la URL se va a su tablón.
 */
@Component({
  selector: 'arc-mesa',
  imports: [NavBar, MisionesPanel, MisionDetalle, BibliotecaPanel],
  template: `
    <arc-nav [personajeId]="personajeId()" [ancho]="true" />

    <div class="contenedor contenedor--ancho">
      @if (abierta(); as id) {
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
        </div>

        @if (pestana() === 'misiones') {
          <arc-misiones-panel (abrir)="abrirMision($event)" />
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

  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  readonly pestana = signal<Pestana>('misiones');
  /** Id de la misión abierta, o null si estamos en la rejilla. */
  readonly abierta = signal<string | null>(null);
  readonly esDM = computed(() => this.auth.rol() === 'DM');

  ngOnInit(): void {
    if (!this.esDM()) {
      void this.router.navigate(['/personajes', this.personajeId(), 'tablon']);
    }
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
