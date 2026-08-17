import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { FichaStore } from './sheet.store';

/**
 * El formulario de edición de la ficha.
 *
 * Está aparte de los diseños a propósito: es un formulario largo (identidad,
 * características, combate, monedero, habilidades) y duplicarlo en cada diseño
 * sería copiar 150 líneas de campos para cambiar cuatro colores. Los diseños lo
 * usan tal cual con `<arc-ficha-editor />`.
 *
 * Un diseño que quiera su propio editor no lo importa y escribe el suyo: el
 * estado (`store.edit`, `store.editSkills`, `store.guardar()`) es el mismo.
 */
@Component({
  selector: 'arc-ficha-editor',
  imports: [FormsModule],
  template: `
    @if (store.edit; as e) {
      <form class="hoja panel editor" (ngSubmit)="store.guardar()">
        <p class="editor-nota">Los modificadores, la iniciativa, la presa y los totales de habilidad
          los recalcula el sistema al guardar.</p>

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

        @if (store.esClerigo()) {
          <p class="rotulo separador">Dominios</p>
          <p class="editor-nota">Un clérigo elige dos. Cada uno da su poder otorgado
            y una lista de conjuros de dominio.</p>
          <div class="campos">
            <label>Dominio 1
              <select name="e_dom1" [(ngModel)]="e.domain1">
                <option value="">— ninguno —</option>
                @for (d of store.dominios(); track d.code) {
                  <option [value]="d.code">{{ d.nombre }}</option>
                }
              </select>
            </label>
            <label>Dominio 2
              <select name="e_dom2" [(ngModel)]="e.domain2">
                <option value="">— ninguno —</option>
                @for (d of store.dominios(); track d.code) {
                  <option [value]="d.code">{{ d.nombre }}</option>
                }
              </select>
            </label>
          </div>
        }

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
          <label>Oro (po)<input name="e_po" type="number" min="0" [(ngModel)]="store.purseOro" /></label>
          <label>Plata (pp)<input name="e_pp" type="number" min="0" [(ngModel)]="store.pursePlata" /></label>
          <label>Cobre (pc)<input name="e_pc" type="number" min="0" [(ngModel)]="store.purseCobre" /></label>
        </div>

        <p class="rotulo separador">Habilidades</p>
        <ul class="habs-edit">
          @for (row of store.editSkills(); track $index) {
            <li class="fila-hab">
              <input class="h-nombre" name="h_name_{{$index}}" placeholder="Nombre" [(ngModel)]="row.name" />
              <select name="h_car_{{$index}}" [(ngModel)]="row.keyAbility">
                @for (c of store.caracts; track c) { <option [value]="c">{{ c || '—' }}</option> }
              </select>
              <input class="h-num" name="h_rk_{{$index}}" type="number" placeholder="rangos" [(ngModel)]="row.ranks" />
              <input class="h-num" name="h_mc_{{$index}}" type="number" placeholder="varios" [(ngModel)]="row.miscMod" />
              <button type="button" class="quitar" (click)="store.quitarHabilidad($index)">✕</button>
            </li>
          }
        </ul>
        <button type="button" class="boton" (click)="store.anadirHabilidad()">+ Añadir habilidad</button>

        @if (store.errorEdit(); as err) { <p class="error" role="alert">{{ err }}</p> }

        <div class="acciones acciones--editor">
          <button class="boton boton--lacre" type="submit" [disabled]="store.guardando()">
            {{ store.guardando() ? 'Guardando…' : 'Guardar' }}
          </button>
          <button class="boton" type="button" (click)="store.cancelar()">Cancelar</button>
        </div>
      </form>
    }
  `,
  styles: `
    .editor { border-top: 3px solid var(--oro); padding: 18px 20px 22px; }
    .editor-nota { margin: 0 0 4px; color: var(--sepia-hondo); }
    .separador { margin: 20px 0 10px; padding-bottom: 6px; border-bottom: 1px solid var(--linea); color: var(--sepia); }
    .campos { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 10px; margin-bottom: 6px; }
    .campos--num { grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); }
    .campos label { display: grid; gap: 4px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }
    .campos select { font: inherit; font-size: 13px; padding: 10px 8px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta); }

    .habs-edit { list-style: none; margin: 0 0 10px; padding: 0; display: grid; gap: 6px; }
    .fila-hab { display: flex; gap: 6px; align-items: center; }
    .fila-hab .h-nombre { flex: 1 1 auto; min-width: 0; width: auto; }
    .fila-hab .h-num { width: 74px; flex: 0 0 auto; font-family: var(--dato); }
    .fila-hab select { width: 80px; flex: 0 0 auto; font: inherit; font-family: var(--dato); font-size: 13px; padding: 10px 6px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta); }
    .quitar { flex: 0 0 auto; border: 1px solid rgba(143,46,34,.4); background: transparent; color: var(--vino); border-radius: var(--radio); width: 34px; height: 38px; }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 18px; }
    .acciones--editor { margin-top: 22px; padding-top: 16px; border-top: 1px dashed var(--linea); }
    .error { font-size: 14px; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 14px 0 0; color: #d98a7c; }
  `,
})
export class FichaEditor {
  readonly store = inject(FichaStore);
}
