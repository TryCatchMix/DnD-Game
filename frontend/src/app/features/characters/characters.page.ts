import { Component, inject, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { JuegoService } from '../../core/juego.service';
import { AuthService } from '../../core/auth.service';
import { Character } from '../../core/api.types';

/**
 * Pantalla 03: elegir con qué personaje juegas.
 *
 * No estaba entre los archivos originales; la reconstruí a partir de a dónde
 * navega el login (`/personajes`) y de a dónde tiene que llevar (el tablón de
 * cada personaje). Sigue el mismo sistema visual que el resto.
 */
@Component({
  selector: 'arc-characters',
  template: `
    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Registro del clan</p>
        <h1>¿Con quién bajas hoy?</h1>
      </header>

      @if (cargando()) {
        <p class="estado">Abriendo el registro…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (personajes().length === 0) {
        <p class="estado">No hay personajes en tu registro todavía. Crea el primero.</p>
      } @else {
        <ul class="lista">
          @for (p of personajes(); track p.id) {
            <li class="hoja ficha" (click)="elegir(p)">
              <div class="fila">
                <h2>{{ p.name }}</h2>
                @if (p.level) { <span class="dato nivel">Nivel {{ p.level }}</span> }
              </div>
              <p class="subtitulo">
                @if (p.ancestry) { {{ p.ancestry }} }
                @if (p.ancestry && p.role) { <span class="sep">·</span> }
                @if (p.role) { {{ p.role }} }
              </p>
              <div class="pie-ficha">
                @if (p.vigor != null) {
                  <span class="dato">Vigor {{ p.vigor }}@if (p.maxVigor != null) {/{{ p.maxVigor }}}</span>
                }
                @if (p.location) {
                  <span class="sep">·</span>
                  <span class="dato">{{ p.location }}</span>
                }
                <button class="verficha" (click)="verFicha(p, $event)">Ver ficha</button>
                <button class="verficha" (click)="verTienda(p, $event)">Tienda</button>
              </div>
            </li>
          }
        </ul>
      }

      <div class="acciones">
        <button class="boton boton--lacre" (click)="crear()">+ Crear personaje</button>
        <button class="boton salir" (click)="salir()">Salir del registro</button>
      </div>
    </div>
  `,
  styles: `
    .cabecera { margin-bottom: 22px; }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .cabecera .rotulo { color: var(--sepia-claro); }

    .lista { list-style: none; margin: 0 0 24px; padding: 0; display: grid; gap: 14px; }

    .ficha {
      padding: 18px 20px 16px;
      cursor: pointer;
      transition: transform .12s ease, box-shadow .12s ease;
    }
    .ficha:hover {
      transform: translateY(-1px);
      box-shadow: 0 1px 0 rgba(255,255,255,.35) inset, 0 16px 32px rgba(0,0,0,.5);
    }

    .fila { display: flex; align-items: baseline; gap: 10px; justify-content: space-between; }
    h2 { font-size: 22px; color: var(--tinta); }
    .nivel { color: var(--oro); white-space: nowrap; }

    .subtitulo { color: var(--sepia-hondo); margin: 6px 0 12px; }
    .sep { color: var(--linea-fuerte); margin: 0 4px; }

    .pie-ficha {
      display: flex; flex-wrap: wrap; align-items: center; gap: 6px;
      color: var(--sepia);
      border-top: 1px solid var(--linea-clara);
      padding-top: 10px;
    }
    .verficha {
      margin-left: auto;
      font-family: var(--dato);
      font-size: 10px;
      letter-spacing: .12em;
      text-transform: uppercase;
      color: var(--vino);
      background: transparent;
      border: 1px solid rgba(143,46,34,.4);
      border-radius: var(--radio);
      padding: 4px 8px;
    }
    .verficha:hover { background: rgba(143,46,34,.08); }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; }
    .salir { display: block; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 28px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class CharactersPage implements OnInit {

  private readonly juego = inject(JuegoService);
  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  readonly personajes = signal<Character[]>([]);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  ngOnInit(): void {
    this.juego.personajes().subscribe({
      next: ps => { this.personajes.set(ps); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido leer el registro del clan.');
      },
    });
  }

  crear(): void {
    void this.router.navigate(['/personajes', 'nuevo']);
  }

  elegir(p: Character): void {
    void this.router.navigate(['/personajes', p.id, 'tablon']);
  }

  verFicha(p: Character, ev: Event): void {
    ev.stopPropagation();   // no queremos que además navegue al tablón
    void this.router.navigate(['/personajes', p.id, 'ficha']);
  }

  verTienda(p: Character, ev: Event): void {
    ev.stopPropagation();
    void this.router.navigate(['/personajes', p.id, 'tienda']);
  }

  salir(): void {
    this.auth.logout();
  }
}
