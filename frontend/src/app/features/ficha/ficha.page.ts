import { Component, ElementRef, inject, input, signal, viewChild, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

import { JuegoService } from '../../core/juego.service';
import { Ficha, Inventory, InventoryLine } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

interface EditRow { name: string; keyAbility: string; ranks: number; miscMod: number; }

interface EditModel {
  name: string; player: string; clazz: string; level: number; race: string;
  alignment: string; deity: string; size: string; age: string; sex: string;
  height: string; weight: string; campaign: string; location: string;
  strScore: number; dexScore: number; conScore: number;
  intScore: number; wisScore: number; chaScore: number;
  hpCurrent: number; hpMax: number; acTotal: number; acTouch: number; acFlatFooted: number;
  initiativeMisc: number; speed: number; bab: number; grappleMisc: number; spellResistance: number;
  saveFort: number; saveRef: number; saveWill: number; damageReduction: string;
  vigor: number; maxVigor: number; carga: string;
}

const CARACTS = ['', 'FUE', 'DES', 'CON', 'INT', 'SAB', 'CAR'];

/**
 * La hoja de personaje D&D 3.5: vista completa y edición. Los modificadores,
 * la iniciativa, la presa y los totales de habilidad los calcula el backend;
 * al guardar, se recalcula todo y se repinta.
 */
@Component({
  selector: 'arc-ficha',
  imports: [NavBar, FormsModule],
  template: `
    @if (personajeId(); as pid) { <arc-nav [personajeId]="pid" /> }

    <div class="contenedor">
      @if (cargando()) {
        <p class="estado">Abriendo la ficha…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (ficha(); as f) {

        <!-- ============ CABECERA ============ -->
        <header class="cabecera">
          <p class="rotulo">Hoja de personaje · D&D 3.5</p>
          @if (!editando()) {
            <div class="titulo">
              <h1>{{ f.name }}</h1>
              <button class="boton" (click)="editar()">Editar</button>
            </div>
            <p class="subtitulo">
              {{ f.clazz }} nivel {{ f.level }}
              @if (f.race) { · {{ f.race }} }
              @if (f.alignment) { · {{ f.alignment }} }
              @if (f.deity) { · devoto de {{ f.deity }} }
            </p>
            <p class="meta">
              @if (f.size) { <span>{{ f.size }}</span> }
              @if (f.sex) { <span>{{ f.sex }}</span> }
              @if (f.age) { <span>{{ f.age }}</span> }
              @if (f.height) { <span>{{ f.height }}</span> }
              @if (f.weight) { <span>{{ f.weight }}</span> }
              @if (f.location) { <span>{{ f.location }}</span> }
              @if (f.player) { <span>jugador: {{ f.player }}</span> }
            </p>
          } @else {
            <div class="titulo"><h1>Editando ficha</h1></div>
          }
        </header>

        <!-- ============ VISTA ============ -->
        @if (!editando()) {
          <!-- Características -->
          <ul class="caracts">
            @for (a of f.abilities; track a.key) {
              <li class="hoja caract">
                <span class="rotulo">{{ a.key }}</span>
                <span class="mod">{{ a.modifier >= 0 ? '+' : '' }}{{ a.modifier }}</span>
                <span class="punt">{{ a.score }}</span>
              </li>
            }
          </ul>

          <!-- Combate -->
          <div class="rejilla">
            <div class="hoja stat"><span class="rotulo">PG</span><span class="cifra">{{ f.hpCurrent }}<span class="de">/ {{ f.hpMax }}</span></span></div>
            <div class="hoja stat"><span class="rotulo">CA</span><span class="cifra">{{ f.acTotal }}</span></div>
            <div class="hoja stat"><span class="rotulo">CA toque</span><span class="cifra">{{ f.acTouch }}</span></div>
            <div class="hoja stat"><span class="rotulo">Desprevenido</span><span class="cifra">{{ f.acFlatFooted }}</span></div>
            <div class="hoja stat"><span class="rotulo">Iniciativa</span><span class="cifra">{{ f.initiative >= 0 ? '+' : '' }}{{ f.initiative }}</span></div>
            <div class="hoja stat"><span class="rotulo">Velocidad</span><span class="cifra">{{ f.speed }}</span></div>
            <div class="hoja stat"><span class="rotulo">At. base</span><span class="cifra">{{ f.bab >= 0 ? '+' : '' }}{{ f.bab }}</span></div>
            <div class="hoja stat"><span class="rotulo">Presa</span><span class="cifra">{{ f.grapple >= 0 ? '+' : '' }}{{ f.grapple }}</span></div>
          </div>

          <div class="rejilla salvaciones">
            <div class="hoja stat"><span class="rotulo">Fortaleza</span><span class="cifra">{{ f.saveFort >= 0 ? '+' : '' }}{{ f.saveFort }}</span></div>
            <div class="hoja stat"><span class="rotulo">Reflejos</span><span class="cifra">{{ f.saveRef >= 0 ? '+' : '' }}{{ f.saveRef }}</span></div>
            <div class="hoja stat"><span class="rotulo">Voluntad</span><span class="cifra">{{ f.saveWill >= 0 ? '+' : '' }}{{ f.saveWill }}</span></div>
          </div>

          <div class="hoja bloque">
            <p class="linea"><span class="rotulo">Monedero</span><span>{{ f.bolsa || '—' }}</span></p>
            <p class="linea"><span class="rotulo">Carga</span><span>{{ f.carga || '—' }}</span></p>
            <p class="linea"><span class="rotulo">Vigor</span><span>{{ f.vigor }} / {{ f.maxVigor }}</span></p>
            <p class="linea"><span class="rotulo">Reducción de daño</span><span>{{ f.damageReduction || '—' }}</span></p>
            <p class="linea"><span class="rotulo">Resist. a conjuros</span><span>{{ f.spellResistance || '—' }}</span></p>
          </div>

          <!-- Bolsa / inventario -->
          <div class="franja-bolsa">
            <p class="rotulo separador">Bolsa</p>
            @if (inventario(); as inv) {
              <span class="carga-total">Carga total · {{ inv.totalWeight }} lb</span>
            }
          </div>

          <!-- Añadido rápido: nombre, cantidad y peso; Enter añade -->
          <div class="add-row">
            <input #nombreInput class="add-nombre" placeholder="Nombre del objeto"
                   [(ngModel)]="nuevoNombre" (keydown.enter)="anadirItem()" />
            <input class="add-num" type="number" min="1" placeholder="Cant."
                   [(ngModel)]="nuevaCantidad" (keydown.enter)="anadirItem()" />
            <input class="add-num" type="number" min="0" step="0.5" placeholder="Peso"
                   [(ngModel)]="nuevoPeso" (keydown.enter)="anadirItem()" />
            <button class="boton boton--lacre" [disabled]="!nuevoNombre().trim()" (click)="anadirItem()">Añadir</button>
          </div>
          @if (errorBolsa(); as e) { <p class="error-bolsa">{{ e }}</p> }

          @if (inventario(); as inv) {
            @if (inv.items.length === 0) {
              <p class="estado">La bolsa está vacía. Añade algo arriba.</p>
            } @else {
              <ul class="bolsa">
                @for (it of inv.items; track it.id) {
                  <li class="hoja obj">
                    <span class="obj-nombre">{{ it.name }}
                      @if (it.sellable) { <span class="obj-tienda" title="Comprado en la tienda">tienda</span> }
                    </span>
                    <span class="stepper">
                      <button type="button" (click)="ajustar(it, -1)" aria-label="Menos">−</button>
                      <span class="cant">{{ it.quantity }}</span>
                      <button type="button" (click)="ajustar(it, 1)" aria-label="Más">+</button>
                    </span>
                    <span class="obj-peso">{{ it.weightLb }} lb/ud · <strong>{{ it.lineWeight }} lb</strong></span>
                    <button type="button" class="obj-quitar" (click)="eliminar(it)" aria-label="Quitar">✕</button>
                  </li>
                }
              </ul>
            }
          }

          <!-- Habilidades -->
          <p class="rotulo separador">Habilidades</p>
          @if (f.skills.length === 0) {
            <p class="estado">Sin habilidades anotadas.</p>
          } @else {
            <ul class="habs">
              @for (s of f.skills; track s.name) {
                <li class="hoja hab">
                  <span class="hnombre">{{ s.name }}
                    @if (s.keyAbility) { <span class="hcar">{{ s.keyAbility }}</span> }
                  </span>
                  <span class="htotal" [class.menos]="s.total < 0">{{ s.total >= 0 ? '+' : '' }}{{ s.total }}</span>
                  <span class="hdesglose">{{ s.ranks }} rangos@if (s.miscMod) { · {{ s.miscMod >= 0 ? '+' : '' }}{{ s.miscMod }} varios }</span>
                </li>
              }
            </ul>
          }

          <div class="acciones">
            <button class="boton boton--lacre" (click)="alTablon(f.id)">Ir al tablón</button>
            <button class="boton" (click)="alaTienda(f.id)">Tienda</button>
          </div>
        }

        <!-- ============ EDICIÓN ============ -->
        @if (editando() && edit; as e) {
          <form class="editor" (ngSubmit)="guardar()">

            <p class="rotulo separador">Identidad</p>
            <div class="campos">
              <label>Nombre<input name="e_name" [(ngModel)]="e.name" /></label>
              <label>Clase<input name="e_clazz" [(ngModel)]="e.clazz" /></label>
              <label>Nivel<input name="e_level" type="number" [(ngModel)]="e.level" /></label>
              <label>Raza<input name="e_race" [(ngModel)]="e.race" /></label>
              <label>Alineamiento<input name="e_align" [(ngModel)]="e.alignment" /></label>
              <label>Deidad<input name="e_deity" [(ngModel)]="e.deity" /></label>
              <label>Tamaño<input name="e_size" [(ngModel)]="e.size" /></label>
              <label>Edad<input name="e_age" [(ngModel)]="e.age" /></label>
              <label>Sexo<input name="e_sex" [(ngModel)]="e.sex" /></label>
              <label>Altura<input name="e_height" [(ngModel)]="e.height" /></label>
              <label>Peso<input name="e_weight" [(ngModel)]="e.weight" /></label>
              <label>Ciudad<input name="e_loc" [(ngModel)]="e.location" /></label>
              <label>Campaña<input name="e_camp" [(ngModel)]="e.campaign" /></label>
              <label>Jugador<input name="e_player" [(ngModel)]="e.player" /></label>
            </div>

            <p class="rotulo separador">Características</p>
            <div class="campos campos--num">
              <label>FUE<input name="e_str" type="number" [(ngModel)]="e.strScore" /></label>
              <label>DES<input name="e_dex" type="number" [(ngModel)]="e.dexScore" /></label>
              <label>CON<input name="e_con" type="number" [(ngModel)]="e.conScore" /></label>
              <label>INT<input name="e_int" type="number" [(ngModel)]="e.intScore" /></label>
              <label>SAB<input name="e_wis" type="number" [(ngModel)]="e.wisScore" /></label>
              <label>CAR<input name="e_cha" type="number" [(ngModel)]="e.chaScore" /></label>
            </div>

            <p class="rotulo separador">Combate</p>
            <div class="campos campos--num">
              <label>PG actual<input name="e_hpc" type="number" [(ngModel)]="e.hpCurrent" /></label>
              <label>PG máx<input name="e_hpm" type="number" [(ngModel)]="e.hpMax" /></label>
              <label>CA<input name="e_ac" type="number" [(ngModel)]="e.acTotal" /></label>
              <label>CA toque<input name="e_act" type="number" [(ngModel)]="e.acTouch" /></label>
              <label>Desprev.<input name="e_acf" type="number" [(ngModel)]="e.acFlatFooted" /></label>
              <label>Inic. varios<input name="e_ini" type="number" [(ngModel)]="e.initiativeMisc" /></label>
              <label>Velocidad<input name="e_spd" type="number" [(ngModel)]="e.speed" /></label>
              <label>At. base<input name="e_bab" type="number" [(ngModel)]="e.bab" /></label>
              <label>Presa varios<input name="e_grp" type="number" [(ngModel)]="e.grappleMisc" /></label>
              <label>Fortaleza<input name="e_fort" type="number" [(ngModel)]="e.saveFort" /></label>
              <label>Reflejos<input name="e_ref" type="number" [(ngModel)]="e.saveRef" /></label>
              <label>Voluntad<input name="e_will" type="number" [(ngModel)]="e.saveWill" /></label>
              <label>Resist. conjuros<input name="e_sr" type="number" [(ngModel)]="e.spellResistance" /></label>
              <label>Vigor<input name="e_vig" type="number" [(ngModel)]="e.vigor" /></label>
              <label>Vigor máx<input name="e_vigm" type="number" [(ngModel)]="e.maxVigor" /></label>
            </div>
            <div class="campos">
              <label>Reducción de daño<input name="e_dr" [(ngModel)]="e.damageReduction" /></label>
              <label>Carga<input name="e_carga" [(ngModel)]="e.carga" /></label>
            </div>

            <p class="rotulo separador">Monedero</p>
            <div class="campos campos--num">
              <label>Oro (po)<input name="e_po" type="number" min="0" [(ngModel)]="purseOro" /></label>
              <label>Plata (pp)<input name="e_pp" type="number" min="0" [(ngModel)]="pursePlata" /></label>
              <label>Cobre (pc)<input name="e_pc" type="number" min="0" [(ngModel)]="purseCobre" /></label>
            </div>

            <p class="rotulo separador">Habilidades</p>
            <ul class="habs-edit">
              @for (row of editSkills(); track $index) {
                <li class="fila-hab">
                  <input class="h-nombre" name="h_name_{{$index}}" placeholder="Nombre" [(ngModel)]="row.name" />
                  <select name="h_car_{{$index}}" [(ngModel)]="row.keyAbility">
                    @for (c of caracts; track c) { <option [value]="c">{{ c || '—' }}</option> }
                  </select>
                  <input class="h-num" name="h_rk_{{$index}}" type="number" placeholder="rangos" [(ngModel)]="row.ranks" />
                  <input class="h-num" name="h_mc_{{$index}}" type="number" placeholder="varios" [(ngModel)]="row.miscMod" />
                  <button type="button" class="quitar" (click)="quitarHabilidad($index)">✕</button>
                </li>
              }
            </ul>
            <button type="button" class="boton" (click)="anadirHabilidad()">+ Añadir habilidad</button>

            @if (errorEdit(); as e) { <p class="error" role="alert">{{ e }}</p> }

            <div class="acciones acciones--editor">
              <button class="boton boton--lacre" type="submit" [disabled]="guardando()">
                {{ guardando() ? 'Guardando…' : 'Guardar' }}
              </button>
              <button class="boton" type="button" (click)="cancelar()">Cancelar</button>
            </div>
          </form>
        }
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 20px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .titulo { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-top: 4px; }
    .titulo h1 { font-size: 28px; color: var(--pergamino); }
    .subtitulo { color: var(--sepia-claro); margin: 6px 0 0; }
    .meta { display: flex; flex-wrap: wrap; gap: 6px 14px; margin: 8px 0 0; font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }

    .caracts { list-style: none; margin: 0 0 14px; padding: 0; display: grid; grid-template-columns: repeat(6, 1fr); gap: 8px; }
    .caract { padding: 10px 6px; text-align: center; display: grid; gap: 2px; }
    .caract .mod { font-family: var(--display); font-size: 24px; color: var(--tinta); }
    .caract .punt { font-family: var(--dato); font-size: 11px; color: var(--sepia); }

    .rejilla { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-bottom: 8px; }
    .salvaciones { grid-template-columns: repeat(3, 1fr); margin-bottom: 14px; }
    .stat { padding: 10px 8px; text-align: center; display: grid; gap: 3px; }
    .stat .cifra { font-family: var(--display); font-size: 22px; color: var(--tinta); font-variant-numeric: tabular-nums; }
    .stat .de { font-family: var(--dato); font-size: 12px; color: var(--sepia); margin-left: 3px; }

    .bloque { padding: 14px 16px; margin-bottom: 8px; display: grid; gap: 8px; }
    .linea { display: flex; justify-content: space-between; gap: 12px; margin: 0; color: var(--tinta); }
    .linea .rotulo { color: var(--sepia); }

    .separador { margin: 24px 0 12px; color: var(--sepia); }

    .habs { list-style: none; margin: 0 0 20px; padding: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 8px; }
    .hab { padding: 8px 12px; display: grid; grid-template-columns: 1fr auto; align-items: baseline; column-gap: 8px; }
    .hnombre { color: var(--tinta); }
    .hcar { font-family: var(--dato); font-size: 9px; color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio); padding: 1px 4px; margin-left: 4px; }
    .htotal { font-family: var(--dato); font-size: 15px; color: var(--musgo); font-variant-numeric: tabular-nums; }
    .htotal.menos { color: var(--vino); }
    .hdesglose { grid-column: 1 / -1; font-family: var(--dato); font-size: 9px; letter-spacing: .06em; color: var(--sepia); text-transform: uppercase; }

    /* ---------- bolsa / inventario ---------- */
    .franja-bolsa { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; }
    .carga-total { font-family: var(--dato); font-size: 11px; letter-spacing: .06em; color: var(--oro); white-space: nowrap; }

    .add-row { display: flex; gap: 8px; margin-bottom: 6px; flex-wrap: wrap; }
    .add-nombre { flex: 1 1 180px; min-width: 0; }
    .add-num { flex: 0 0 84px; width: 84px; }
    .add-row .boton { flex: 0 0 auto; }
    .error-bolsa { font-size: 13px; color: #d98a7c; margin: 0 0 8px; }

    .bolsa { list-style: none; margin: 8px 0 4px; padding: 0; display: grid; gap: 8px; }
    .obj { padding: 8px 10px 8px 14px; display: flex; align-items: center; gap: 10px; }
    .obj-nombre { flex: 1 1 auto; min-width: 0; color: var(--tinta); }
    .obj-tienda { font-family: var(--dato); font-size: 8px; letter-spacing: .12em; text-transform: uppercase; color: var(--musgo); border: 1px solid rgba(76,106,55,.4); border-radius: var(--radio); padding: 1px 4px; margin-left: 6px; }
    .stepper { display: inline-flex; align-items: center; gap: 2px; flex: 0 0 auto; }
    .stepper button { width: 28px; height: 28px; border: 1px solid var(--linea-fuerte); background: var(--pergamino-claro); color: var(--tinta); border-radius: var(--radio); font-size: 16px; line-height: 1; }
    .stepper button:hover { background: rgba(43,33,23,.07); }
    .stepper .cant { min-width: 26px; text-align: center; font-family: var(--dato); font-variant-numeric: tabular-nums; color: var(--tinta); }
    .obj-peso { flex: 0 0 auto; font-family: var(--dato); font-size: 10px; letter-spacing: .04em; color: var(--sepia); white-space: nowrap; }
    .obj-peso strong { color: var(--sepia-hondo); }
    .obj-quitar { flex: 0 0 auto; width: 28px; height: 28px; border: 1px solid rgba(143,46,34,.35); background: transparent; color: var(--vino); border-radius: var(--radio); }
    .obj-quitar:hover { background: rgba(143,46,34,.08); }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; }
    .acciones--editor { margin-top: 18px; }

    /* editor */
    .editor { display: block; }
    .campos { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 10px; margin-bottom: 6px; }
    .campos--num { grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); }
    .campos label { display: grid; gap: 4px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia-claro); }

    .habs-edit { list-style: none; margin: 0 0 10px; padding: 0; display: grid; gap: 8px; }
    .fila-hab { display: flex; gap: 6px; align-items: center; }
    .fila-hab .h-nombre { flex: 1 1 auto; }
    .fila-hab .h-num { width: 74px; flex: 0 0 auto; }
    .fila-hab select { width: 72px; flex: 0 0 auto; font: inherit; padding: 10px 6px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta); }
    .quitar { flex: 0 0 auto; border: 1px solid rgba(143,46,34,.4); background: transparent; color: var(--vino); border-radius: var(--radio); width: 34px; height: 38px; }

    .error { font-size: 14px; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 14px 0 0; color: #d98a7c; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class FichaPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly router = inject(Router);

  readonly caracts = CARACTS;

  readonly ficha = signal<Ficha | null>(null);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  readonly editando = signal(false);
  readonly guardando = signal(false);
  readonly errorEdit = signal<string | null>(null);
  /** Modelo del formulario (objeto plano; ngModel lo muta en sitio). */
  edit: EditModel | null = null;
  readonly editSkills = signal<EditRow[]>([]);
  /** El monedero se edita en po/pp/pc; al guardar se recompone a piezas de cobre. */
  readonly purseOro = signal(0);
  readonly pursePlata = signal(0);
  readonly purseCobre = signal(0);

  // --- bolsa / inventario ---
  readonly inventario = signal<Inventory | null>(null);
  readonly errorBolsa = signal<string | null>(null);
  readonly nuevoNombre = signal('');
  readonly nuevaCantidad = signal(1);
  readonly nuevoPeso = signal(0);
  private readonly nombreInput = viewChild<ElementRef<HTMLInputElement>>('nombreInput');

  ngOnInit(): void { this.cargar(); this.cargarInventario(); }

  private cargar(): void {
    this.juego.ficha(this.personajeId()).subscribe({
      next: f => { this.ficha.set(f); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido abrir la ficha.');
      },
    });
  }

  editar(): void {
    const f = this.ficha();
    if (!f) return;
    const s = (k: string) => f.abilities.find(a => a.key === k)?.score ?? 10;
    this.edit = {
      name: f.name, player: f.player, clazz: f.clazz, level: f.level, race: f.race,
      alignment: f.alignment, deity: f.deity, size: f.size, age: f.age, sex: f.sex,
      height: f.height, weight: f.weight, campaign: f.campaign, location: f.location,
      strScore: s('FUE'), dexScore: s('DES'), conScore: s('CON'),
      intScore: s('INT'), wisScore: s('SAB'), chaScore: s('CAR'),
      hpCurrent: f.hpCurrent, hpMax: f.hpMax, acTotal: f.acTotal, acTouch: f.acTouch, acFlatFooted: f.acFlatFooted,
      initiativeMisc: f.initiativeMisc, speed: f.speed, bab: f.bab, grappleMisc: f.grappleMisc, spellResistance: f.spellResistance,
      saveFort: f.saveFort, saveRef: f.saveRef, saveWill: f.saveWill, damageReduction: f.damageReduction,
      vigor: f.vigor, maxVigor: f.maxVigor, carga: f.carga,
    };
    this.editSkills.set(f.skills.map(k => ({ name: k.name, keyAbility: k.keyAbility, ranks: k.ranks, miscMod: k.miscMod })));
    // Descomponer el monedero (cp) en po/pp/pc para editarlo con comodidad.
    const cp = f.purseCp ?? 0;
    this.purseOro.set(Math.floor(cp / 100));
    this.pursePlata.set(Math.floor((cp % 100) / 10));
    this.purseCobre.set(cp % 10);
    this.errorEdit.set(null);
    this.editando.set(true);
  }

  anadirHabilidad(): void {
    this.editSkills.update(rows => [...rows, { name: '', keyAbility: '', ranks: 0, miscMod: 0 }]);
  }

  quitarHabilidad(i: number): void {
    this.editSkills.update(rows => rows.filter((_, idx) => idx !== i));
  }

  guardar(): void {
    if (!this.edit || this.guardando()) return;
    this.guardando.set(true);
    this.errorEdit.set(null);

    const skills = this.editSkills()
      .filter(r => r.name.trim() !== '')
      .map(r => ({ name: r.name, keyAbility: r.keyAbility, ranks: Number(r.ranks) || 0, miscMod: Number(r.miscMod) || 0 }));

    const nn = (s: () => number) => Math.max(0, Math.floor(Number(s()) || 0));
    const purseCp = nn(this.purseOro) * 100 + nn(this.pursePlata) * 10 + nn(this.purseCobre);

    this.juego.editarFicha(this.personajeId(), { ...this.edit, purseCp, skills }).subscribe({
      next: f => {
        this.ficha.set(f);
        this.guardando.set(false);
        this.editando.set(false);
        this.edit = null;
      },
      error: err => {
        this.guardando.set(false);
        this.errorEdit.set(err?.error?.message ?? 'No se han podido guardar los cambios.');
      },
    });
  }

  cancelar(): void {
    this.editando.set(false);
    this.edit = null;
    this.errorEdit.set(null);
  }

  alTablon(id: string): void { void this.router.navigate(['/personajes', id, 'tablon']); }
  alaTienda(id: string): void { void this.router.navigate(['/personajes', id, 'tienda']); }

  // --- bolsa / inventario ---

  private cargarInventario(): void {
    this.juego.inventario(this.personajeId()).subscribe({
      next: inv => this.inventario.set(inv),
      error: () => { /* la bolsa es secundaria; no bloquea la ficha */ },
    });
  }

  anadirItem(): void {
    const nombre = this.nuevoNombre().trim();
    if (!nombre) return;
    const cantidad = Math.max(1, Math.floor(Number(this.nuevaCantidad()) || 1));
    const peso = Math.max(0, Number(this.nuevoPeso()) || 0);
    this.errorBolsa.set(null);

    this.juego.anadirItem(this.personajeId(), { name: nombre, quantity: cantidad, weightLb: peso }).subscribe({
      next: inv => {
        this.inventario.set(inv);
        // Vaciar y volver el foco al nombre para encadenar añadidos.
        this.nuevoNombre.set('');
        this.nuevaCantidad.set(1);
        this.nuevoPeso.set(0);
        this.nombreInput()?.nativeElement.focus();
      },
      error: err => this.errorBolsa.set(err?.error?.message ?? 'No se ha podido añadir.'),
    });
  }

  ajustar(it: InventoryLine, delta: number): void {
    const nueva = it.quantity + delta;   // 0 o menos: el backend lo elimina
    this.juego.fijarCantidad(this.personajeId(), it.id, nueva).subscribe({
      next: inv => this.inventario.set(inv),
      error: () => this.errorBolsa.set('No se ha podido actualizar la cantidad.'),
    });
  }

  eliminar(it: InventoryLine): void {
    this.juego.eliminarItem(this.personajeId(), it.id).subscribe({
      next: inv => this.inventario.set(inv),
      error: () => this.errorBolsa.set('No se ha podido quitar el objeto.'),
    });
  }
}
