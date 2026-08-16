import { Component, computed, inject, signal, OnInit } from '@angular/core';
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
        <div>
          <p class="rotulo">Registro del clan</p>
          <h1>¿Con quién bajas hoy?</h1>
        </div>

        <!-- Cerrar sesión vive aquí arriba, no al final de la lista: es lo que
             se busca al terminar, y con muchos personajes quedaba fuera de
             pantalla. Al lado va de quién es la sesión, para no cerrar la de
             otro sin darse cuenta en un ordenador compartido. -->
        <div class="sesion">
          @if (quien(); as q) { <p class="dato quien">{{ q }}</p> }
          <button class="boton salir" (click)="salir()">Cerrar sesión</button>
        </div>
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
                <button class="verficha verficha--borrar" (click)="pedirBorrado(p, $event)"
                        [attr.aria-label]="'Borrar a ' + p.name">Borrar</button>
              </div>
            </li>
          }
        </ul>
      }

      <div class="acciones">
        <button class="boton boton--lacre" (click)="crear()">+ Crear personaje</button>
      </div>

      <!-- Borrar un personaje no se deshace, así que va con parada obligatoria:
           un diálogo que dice a quién y qué se lleva por delante. -->
      @if (borrando(); as p) {
        <div class="velo" (click)="cancelarBorrado()">
          <div class="hoja dialogo" role="alertdialog" aria-modal="true"
               [attr.aria-label]="'Borrar a ' + p.name" (click)="$event.stopPropagation()">
            <p class="rotulo">Borrar del registro</p>
            <h2>¿Seguro que quieres borrar a {{ p.name }}?</h2>
            <p class="letra-pequena">
              Se va con él su ficha, su bolsa, sus propiedades y los encargos que tuviera
              a medias. <strong>Esto no se puede deshacer.</strong>
            </p>

            @if (errorBorrado(); as e) { <p class="estado estado--mal" role="alert">{{ e }}</p> }

            <div class="acciones dialogo-acc">
              <button class="boton boton--lacre" [disabled]="borrandoYa()" (click)="confirmarBorrado(p)">
                {{ borrandoYa() ? 'Borrando…' : 'Sí, borrar' }}
              </button>
              <button class="boton" [disabled]="borrandoYa()" (click)="cancelarBorrado()">Cancelar</button>
            </div>
          </div>
        </div>
      }
    </div>
  `,
  // Escape cierra el diálogo, como cualquier ventana modal.
  host: { '(document:keydown.escape)': 'cancelarBorrado()' },
  styles: `
    .cabecera {
      margin-bottom: 22px;
      display: flex; align-items: flex-start; justify-content: space-between;
      gap: 14px; flex-wrap: wrap;
    }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .cabecera .rotulo { color: var(--sepia-claro); }

    .sesion { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
    .quien { color: var(--sepia); text-transform: uppercase; margin: 0; }
    .salir { color: var(--sepia-claro); border-color: var(--linea-noche); }
    .salir:hover:not(:disabled) { color: var(--pergamino); background: rgba(239,228,205,.07); }

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

    /* Borrar no es una acción más: se queda en sepia, apagada, y solo se
       enciende en rojo cuando vas a por ella. */
    .verficha--borrar { margin-left: 0; color: var(--sepia); border-color: var(--linea); }
    .verficha--borrar:hover { color: var(--vino); border-color: rgba(143,46,34,.45); }

    /* ---------------------------------------------------------- diálogo --- */
    .velo {
      position: fixed; inset: 0; z-index: 60;
      background: rgba(15, 11, 5, .82);
      backdrop-filter: blur(3px);
      display: grid; place-items: center;
      padding: 18px;
    }
    .dialogo { width: min(460px, 100%); padding: 22px 24px 20px; }
    .dialogo .rotulo { color: var(--sepia); margin: 0; }
    .dialogo h2 { font-size: 23px; color: var(--tinta); margin: 6px 0 0; }
    .letra-pequena { color: var(--sepia-hondo); font-size: 15px; margin: 10px 0 0; }
    .letra-pequena strong { color: var(--vino); font-weight: 400; }
    .dialogo-acc { margin-top: 18px; }
    .dialogo .estado { padding: 10px 0 0; }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 28px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class CharactersPage implements OnInit {

  private readonly juego = inject(JuegoService);
  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  /** «Mix · DM», o solo el nombre si el rol no dice nada interesante. */
  readonly quien = computed(() => {
    const nombre = this.auth.nombre();
    if (!nombre) return null;
    return this.auth.rol() === 'DM' ? nombre + ' · DM' : nombre;
  });

  readonly personajes = signal<Character[]>([]);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  /** El personaje que está en el diálogo de borrado, o null si no hay diálogo. */
  readonly borrando = signal<Character | null>(null);
  readonly borrandoYa = signal(false);
  readonly errorBorrado = signal<string | null>(null);

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

  pedirBorrado(p: Character, ev: Event): void {
    ev.stopPropagation();   // el clic en la tarjeta navega al tablón; este no
    this.errorBorrado.set(null);
    this.borrando.set(p);
  }

  /** No se cierra a medio borrar: sería mentirle al jugador sobre qué pasó. */
  cancelarBorrado(): void {
    if (!this.borrandoYa()) this.borrando.set(null);
  }

  confirmarBorrado(p: Character): void {
    this.borrandoYa.set(true);
    this.errorBorrado.set(null);
    this.juego.borrarPersonaje(p.id).subscribe({
      next: ps => {
        this.personajes.set(ps);
        this.borrandoYa.set(false);
        this.borrando.set(null);
      },
      error: err => {
        this.borrandoYa.set(false);
        this.errorBorrado.set(err?.error?.message ?? 'No se ha podido borrar el personaje.');
      },
    });
  }

  salir(): void {
    this.auth.logout();
  }
}
