import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

import { JuegoService } from '../../core/juego.service';
import { CharacterCreate } from '../../core/api.types';

interface Modelo {
  name: string; clazz: string; race: string; alignment: string; player: string;
  city: string; level: number;
  strScore: number; dexScore: number; conScore: number;
  intScore: number; wisScore: number; chaScore: number;
  hpMax: number; acTotal: number; maxVigor: number;
}

const CLASES = ['Bárbaro', 'Pícaro', 'Clérigo', 'Mago', 'Guerrero', 'Explorador', 'Bardo', 'Paladín', 'Druida', 'Hechicero', 'Monje', 'Aventurero'];

/**
 * El creador de personaje. Recoge lo esencial (identidad, características y
 * combate básico) y crea la ficha; los PG arrancan a tope y el vigor lleno.
 * El resto (salvaciones, habilidades, monedero…) se afina luego en la ficha,
 * a donde lleva nada más crear.
 */
@Component({
  selector: 'arc-creador',
  imports: [FormsModule],
  template: `
    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Registro del clan · alta</p>
        <h1>Crear personaje</h1>
        <p class="intro">Solo el nombre es obligatorio. Lo demás trae valores por
          defecto y podrás afinarlo en la ficha después.</p>
      </header>

      <form class="editor" (ngSubmit)="crear()">

        <p class="rotulo separador">Identidad</p>
        <div class="campos">
          <label class="req">Nombre
            <input name="c_name" [(ngModel)]="m.name" placeholder="Nombre del héroe" autofocus />
          </label>
          <label>Clase
            <input name="c_clazz" list="clases" [(ngModel)]="m.clazz" placeholder="Aventurero" />
            <datalist id="clases">
              @for (c of clases; track c) { <option [value]="c"></option> }
            </datalist>
          </label>
          <label>Raza<input name="c_race" [(ngModel)]="m.race" /></label>
          <label>Alineamiento<input name="c_align" [(ngModel)]="m.alignment" /></label>
          <label>Ciudad<input name="c_city" [(ngModel)]="m.city" /></label>
          <label>Nivel<input name="c_level" type="number" min="1" [(ngModel)]="m.level" /></label>
          <label>Jugador<input name="c_player" [(ngModel)]="m.player" /></label>
        </div>

        <p class="rotulo separador">Características</p>
        <div class="campos campos--num">
          <label>FUE<input name="c_str" type="number" [(ngModel)]="m.strScore" /></label>
          <label>DES<input name="c_dex" type="number" [(ngModel)]="m.dexScore" /></label>
          <label>CON<input name="c_con" type="number" [(ngModel)]="m.conScore" /></label>
          <label>INT<input name="c_int" type="number" [(ngModel)]="m.intScore" /></label>
          <label>SAB<input name="c_wis" type="number" [(ngModel)]="m.wisScore" /></label>
          <label>CAR<input name="c_cha" type="number" [(ngModel)]="m.chaScore" /></label>
        </div>

        <p class="rotulo separador">Combate</p>
        <div class="campos campos--num">
          <label>PG máx<input name="c_hp" type="number" min="1" [(ngModel)]="m.hpMax" /></label>
          <label>CA<input name="c_ac" type="number" [(ngModel)]="m.acTotal" /></label>
          <label>Vigor máx<input name="c_vig" type="number" min="0" [(ngModel)]="m.maxVigor" /></label>
        </div>

        @if (error(); as e) { <p class="error" role="alert">{{ e }}</p> }

        <div class="acciones">
          <button class="boton boton--lacre" type="submit" [disabled]="!m.name.trim() || guardando()">
            {{ guardando() ? 'Creando…' : 'Crear personaje' }}
          </button>
          <button class="boton" type="button" (click)="cancelar()">Cancelar</button>
        </div>
      </form>
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 20px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 8px 0 0; max-width: 52ch; }

    .separador { margin: 24px 0 12px; color: var(--sepia); }

    .campos { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px; margin-bottom: 6px; }
    .campos--num { grid-template-columns: repeat(auto-fill, minmax(96px, 1fr)); }
    .campos label { display: grid; gap: 4px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia-claro); }
    .campos label.req::after { content: ' *'; color: var(--vino); }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 20px; }

    .error { font-size: 14px; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 14px 0 0; color: #d98a7c; }
  `,
})
export class CreadorPage {

  private readonly juego = inject(JuegoService);
  private readonly router = inject(Router);

  readonly guardando = signal(false);
  readonly error = signal<string | null>(null);

  /** Modelo del formulario con los valores por defecto ya puestos. */
  m: Modelo = {
    name: '', clazz: '', race: '', alignment: '', player: '',
    city: 'Dorakan', level: 1,
    strScore: 10, dexScore: 10, conScore: 10, intScore: 10, wisScore: 10, chaScore: 10,
    hpMax: 8, acTotal: 10, maxVigor: 8,
  };

  readonly clases = CLASES;

  crear(): void {
    if (!this.m.name.trim() || this.guardando()) return;
    this.guardando.set(true);
    this.error.set(null);

    const datos: CharacterCreate = {
      name: this.m.name.trim(),
      clazz: this.m.clazz.trim() || undefined,
      race: this.m.race.trim() || undefined,
      alignment: this.m.alignment.trim() || undefined,
      player: this.m.player.trim() || undefined,
      city: this.m.city.trim() || undefined,
      level: Number(this.m.level) || 1,
      strScore: Number(this.m.strScore), dexScore: Number(this.m.dexScore), conScore: Number(this.m.conScore),
      intScore: Number(this.m.intScore), wisScore: Number(this.m.wisScore), chaScore: Number(this.m.chaScore),
      hpMax: Number(this.m.hpMax), acTotal: Number(this.m.acTotal), maxVigor: Number(this.m.maxVigor),
    };

    this.juego.crearPersonaje(datos).subscribe({
      next: f => {
        this.guardando.set(false);
        // Al recién creado, directo a su ficha para rematar los detalles.
        void this.router.navigate(['/personajes', f.id, 'ficha']);
      },
      error: err => {
        this.guardando.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido crear el personaje.');
      },
    });
  }

  cancelar(): void {
    void this.router.navigate(['/personajes']);
  }
}
