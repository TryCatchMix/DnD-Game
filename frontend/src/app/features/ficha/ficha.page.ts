import { Component, ElementRef, OnInit, computed, inject, input, signal, viewChild } from '@angular/core';
import { Ficha, Inventory, InventoryLine, SkillDetail } from '../../core/api.types';

import { FormsModule } from '@angular/forms';
import { JuegoService } from '../../core/juego.service';
import { NavBar } from '../../shared/nav';
import { Router } from '@angular/router';

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

type Vista = 'ficha' | 'bolsa' | 'habilidades';

/**
 * La hoja de personaje D&D 3.5: vista completa y edición. Los modificadores,
 * la iniciativa, la presa y los totales de habilidad los calcula el backend;
 * al guardar, se recalcula todo y se repinta.
 *
 * La hoja se lee por pestañas (ficha · bolsa · habilidades) para que la
 * pantalla de mesa quepa de un vistazo: arriba lo que se consulta en cada
 * turno (PG, CA, salvaciones), y detrás lo que se consulta de vez en cuando.
 */
@Component({
  selector: 'arc-ficha',
  imports: [NavBar, FormsModule],
  template: `
    @if (personajeId(); as pid) { <arc-nav [personajeId]="pid" /> }

    <div class="contenedor contenedor--hoja">
      @if (cargando()) {
        <p class="estado">Abriendo la ficha…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (ficha(); as f) {

        <!-- ============ CABECERA ============ -->
        <header class="hoja cartela">
          <div class="cartela-alto">
            <div class="cartela-quien">
              <p class="rotulo">Hoja de personaje · D&amp;D 3.5</p>
              @if (!editando()) {
                <h1>{{ f.name }}</h1>
                <p class="subtitulo">
                  {{ f.clazz }} nivel {{ f.level }}
                  @if (f.race) { · {{ f.race }} }
                  @if (f.alignment) { · {{ f.alignment }} }
                  @if (f.deity) { · devoto de {{ f.deity }} }
                </p>
              } @else {
                <h1>Editando ficha</h1>
                <p class="subtitulo">{{ f.name }} · {{ f.clazz }} nivel {{ f.level }}</p>
              }
            </div>
            <div class="cartela-sello">
              <div class="sello-nivel">
                <span class="rotulo">Nivel</span>
                <span class="cifra-nivel">{{ f.level }}</span>
              </div>
              <div class="sello-lado">
                @if (!editando()) {
                  <button class="boton" (click)="editar()">Editar ficha</button>
                }
                @if (f.campaign) { <span class="dato campana">{{ f.campaign }}</span> }
              </div>
            </div>
          </div>

          <p class="meta">
            @if (f.size) { <span><i>tamaño</i> {{ f.size }}</span> }
            @if (f.sex) { <span><i>sexo</i> {{ f.sex }}</span> }
            @if (f.age) { <span><i>edad</i> {{ f.age }}</span> }
            @if (f.height) { <span><i>altura</i> {{ f.height }}</span> }
            @if (f.weight) { <span><i>peso</i> {{ f.weight }}</span> }
            @if (f.location) { <span><i>ciudad</i> {{ f.location }}</span> }
            @if (f.player) { <span><i>jugador</i> {{ f.player }}</span> }
          </p>
        </header>

        <!-- ============ PESTAÑAS ============ -->
        @if (!editando()) {
          <div class="pestanas" role="tablist">
            <button role="tab" class="pest" [class.activa]="vista() === 'ficha'"
                    [attr.aria-selected]="vista() === 'ficha'" (click)="vista.set('ficha')">Ficha</button>
            <button role="tab" class="pest" [class.activa]="vista() === 'bolsa'"
                    [attr.aria-selected]="vista() === 'bolsa'" (click)="vista.set('bolsa')">
              Bolsa @if (inventario(); as inv) { <span class="cuenta">{{ inv.items.length }}</span> }
            </button>
            <button role="tab" class="pest" [class.activa]="vista() === 'habilidades'"
                    [attr.aria-selected]="vista() === 'habilidades'" (click)="vista.set('habilidades')">
              Habilidades <span class="cuenta">{{ f.skills.length }}</span>
            </button>
          </div>
        }

        <!-- ============ VISTA · FICHA ============ -->
        @if (!editando() && vista() === 'ficha') {
          <div class="columnas">

            <div class="pila">
              <!-- Características -->
              <section class="hoja panel">
                <p class="rotulo titulo-panel">Características</p>
                <ul class="caracts">
                  @for (a of f.abilities; track a.key) {
                    <li class="caja caract">
                      <span class="dato clave">{{ a.key }}</span>
                      <span class="mod" [class.menos]="a.modifier < 0">{{ a.modifier >= 0 ? '+' : '' }}{{ a.modifier }}</span>
                      <span class="punt">{{ a.score }}</span>
                    </li>
                  }
                </ul>
              </section>

              <!-- Salvaciones -->
              <section class="hoja panel">
                <p class="rotulo titulo-panel">Tiradas de salvación</p>
                <ul class="salvaciones">
                  <li class="caja salv">
                    <span class="salv-nombre">Fortaleza</span><span class="guia"></span>
                    <span class="salv-valor">{{ f.saveFort >= 0 ? '+' : '' }}{{ f.saveFort }}</span>
                    <span class="dato salv-base">CON</span>
                  </li>
                  <li class="caja salv">
                    <span class="salv-nombre">Reflejos</span><span class="guia"></span>
                    <span class="salv-valor">{{ f.saveRef >= 0 ? '+' : '' }}{{ f.saveRef }}</span>
                    <span class="dato salv-base">DES</span>
                  </li>
                  <li class="caja salv">
                    <span class="salv-nombre">Voluntad</span><span class="guia"></span>
                    <span class="salv-valor">{{ f.saveWill >= 0 ? '+' : '' }}{{ f.saveWill }}</span>
                    <span class="dato salv-base">SAB</span>
                  </li>
                </ul>
              </section>

              <!-- Monedero y carga -->
              <section class="hoja panel">
                <p class="rotulo titulo-panel">Monedero y carga</p>
                <div class="monedas">
                  <div class="caja moneda moneda--oro">
                    <span class="moneda-n">{{ monedas().po }}</span><span class="dato">oro</span>
                  </div>
                  <div class="caja moneda moneda--plata">
                    <span class="moneda-n">{{ monedas().pp }}</span><span class="dato">plata</span>
                  </div>
                  <div class="caja moneda moneda--cobre">
                    <span class="moneda-n">{{ monedas().pc }}</span><span class="dato">cobre</span>
                  </div>
                </div>
                <p class="linea"><span class="rotulo">Carga</span><span>{{ f.carga || '—' }}</span></p>
                <p class="linea"><span class="rotulo">Reducción de daño</span><span>{{ f.damageReduction || '—' }}</span></p>
                <p class="linea"><span class="rotulo">Resist. a conjuros</span><span>{{ f.spellResistance || '—' }}</span></p>
              </section>
            </div>

            <div class="pila">
              <!-- Puntos de golpe -->
              <section class="hoja panel">
                <div class="franja">
                  <p class="rotulo titulo-panel">Puntos de golpe</p>
                  <span class="dato estado-pg" [class]="'estado-pg--' + estadoPg()">{{ etiquetaPg() }}</span>
                </div>
                <div class="pg-cifras">
                  <span class="pg-actual" [class]="'pg-actual--' + estadoPg()">{{ f.hpCurrent }}</span>
                  <span class="dato pg-max">/ {{ f.hpMax }} pg</span>
                  <!-- Ajuste rápido: en mesa el daño se anota entre turnos, no abriendo el editor. -->
                  <span class="ajuste">
                    <button type="button" class="paso paso--dano" [disabled]="ajustandoPg()"
                            (click)="ajustarPg(-5)" aria-label="Cinco puntos de daño">−5</button>
                    <button type="button" class="paso paso--dano" [disabled]="ajustandoPg()"
                            (click)="ajustarPg(-1)" aria-label="Un punto de daño">−1</button>
                    <button type="button" class="paso paso--cura" [disabled]="ajustandoPg()"
                            (click)="ajustarPg(1)" aria-label="Curar un punto">+1</button>
                    <button type="button" class="paso paso--cura" [disabled]="ajustandoPg()"
                            (click)="ajustarPg(5)" aria-label="Curar cinco puntos">+5</button>
                  </span>
                </div>
                <div class="barra" role="img" [attr.aria-label]="f.hpCurrent + ' de ' + f.hpMax + ' puntos de golpe'">
                  <div class="barra-fondo"><div class="barra-llena" [class]="'barra-llena--' + estadoPg()" [style.width.%]="porcentajePg()"></div></div>
                </div>
                <div class="franja franja--vigor">
                  <span class="rotulo">Vigor</span>
                  <span class="pips">
                    @for (lleno of pipsVigor(); track $index) {
                      <span class="pip" [class.lleno]="lleno"></span>
                    }
                  </span>
                  <span class="dato vigor-n">{{ f.vigor }} / {{ f.maxVigor }}</span>
                  <span class="ajuste ajuste--vigor">
                    <button type="button" class="paso" [disabled]="ajustandoVigor()"
                            (click)="ajustarVigor(-1)" aria-label="Gastar un punto de vigor">−</button>
                    <button type="button" class="paso" [disabled]="ajustandoVigor()"
                            (click)="ajustarVigor(1)" aria-label="Recuperar un punto de vigor">+</button>
                  </span>
                </div>
                @if (errorAjuste(); as e) { <p class="error-bolsa error-ajuste">{{ e }}</p> }
              </section>

              <!-- Defensa y ataque -->
              <section class="hoja panel">
                <p class="rotulo titulo-panel">Defensa</p>
                <div class="defensa">
                  <div class="caja stat stat--grande">
                    <span class="dato">Clase de armadura</span><span class="cifra">{{ f.acTotal }}</span>
                  </div>
                  <div class="caja stat"><span class="dato">CA toque</span><span class="cifra">{{ f.acTouch }}</span></div>
                  <div class="caja stat"><span class="dato">Desprevenido</span><span class="cifra">{{ f.acFlatFooted }}</span></div>
                </div>

                <p class="rotulo titulo-panel titulo-panel--siguiente">Ataque y movimiento</p>
                <div class="ataque">
                  <div class="caja stat">
                    <span class="dato">Ataque base</span>
                    <span class="cifra">{{ f.bab >= 0 ? '+' : '' }}{{ f.bab }}</span>
                    <span class="dato nota">BAB</span>
                  </div>
                  <div class="caja stat">
                    <span class="dato">Presa</span>
                    <span class="cifra">{{ f.grapple >= 0 ? '+' : '' }}{{ f.grapple }}</span>
                    <span class="dato nota">BAB + FUE</span>
                  </div>
                  <div class="caja stat">
                    <span class="dato">Iniciativa</span>
                    <span class="cifra">{{ f.initiative >= 0 ? '+' : '' }}{{ f.initiative }}</span>
                    <span class="dato nota">DES</span>
                  </div>
                  <div class="caja stat">
                    <span class="dato">Velocidad</span>
                    <span class="cifra">{{ f.speed }}</span>
                    <span class="dato nota">pies</span>
                  </div>
                </div>
              </section>

              <!-- Habilidades destacadas -->
              <section class="hoja panel">
                <div class="franja">
                  <p class="rotulo titulo-panel">Habilidades destacadas</p>
                  <button class="enlace" (click)="vista.set('habilidades')">Ver todas ({{ f.skills.length }})</button>
                </div>
                @if (f.skills.length === 0) {
                  <p class="estado estado--breve">Sin habilidades anotadas.</p>
                } @else {
                  <ul class="destacadas">
                    @for (s of habilidadesTop(); track s.name) {
                      <li>
                        <span class="hnombre">{{ s.name }}</span>
                        @if (s.keyAbility) { <span class="hcar">{{ s.keyAbility }}</span> }
                        <span class="guia"></span>
                        <span class="htotal" [class.menos]="s.total < 0">{{ s.total >= 0 ? '+' : '' }}{{ s.total }}</span>
                      </li>
                    }
                  </ul>
                }
              </section>
            </div>
          </div>
        }

        <!-- ============ VISTA · BOLSA ============ -->
        @if (!editando() && vista() === 'bolsa') {
          <section class="hoja panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Bolsa</p>
              @if (inventario(); as inv) {
                <span class="carga-total">Carga total · {{ inv.totalWeight }} lb @if (f.carga) { · {{ f.carga }} }</span>
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
                    <li class="caja obj" [class.obj--tienda]="it.sellable">
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
          </section>
        }

        <!-- ============ VISTA · HABILIDADES ============ -->
        @if (!editando() && vista() === 'habilidades') {
          <section class="hoja panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Habilidades · {{ f.skills.length }} anotadas</p>
              <input class="buscador" placeholder="Buscar habilidad…" [(ngModel)]="busca" />
            </div>
            @if (f.skills.length === 0) {
              <p class="estado">Sin habilidades anotadas.</p>
            } @else if (habilidadesFiltradas().length === 0) {
              <p class="estado">Ninguna habilidad coincide con «{{ busca() }}».</p>
            } @else {
              <ul class="habs">
                @for (s of habilidadesFiltradas(); track s.name) {
                  <li class="caja hab">
                    <div class="hab-alto">
                      <span class="hnombre">{{ s.name }}</span>
                      @if (s.keyAbility) { <span class="hcar">{{ s.keyAbility }}</span> }
                      <span class="guia"></span>
                      <span class="htotal" [class.menos]="s.total < 0">{{ s.total >= 0 ? '+' : '' }}{{ s.total }}</span>
                    </div>
                    <p class="hdesglose">{{ s.ranks }} rangos@if (s.miscMod) { · {{ s.miscMod >= 0 ? '+' : '' }}{{ s.miscMod }} varios }</p>
                  </li>
                }
              </ul>
            }
          </section>
        }

        @if (!editando()) {
          <div class="acciones">
            <button class="boton boton--lacre" (click)="alTablon(f.id)">Ir al tablón</button>
            <button class="boton boton--noche" (click)="alaTienda(f.id)">Tienda</button>
          </div>
        }

        <!-- ============ EDICIÓN ============ -->
        @if (editando() && edit; as e) {
          <form class="hoja panel editor" (ngSubmit)="guardar()">
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
    /* La hoja respira más ancha que el resto de pantallas: son dos columnas
       de documento, no una lista. */
    .contenedor--hoja { max-width: 1040px; }

    /* ---------------- cartela (cabecera) ---------------- */
    .cartela { border-top: 3px solid var(--vino); padding: 18px 22px 14px; margin: 18px 0 14px; }
    .cartela-alto { display: flex; align-items: flex-start; gap: 20px; flex-wrap: wrap; }
    .cartela-quien { flex: 1 1 320px; min-width: 0; }
    .cartela-quien h1 { font-size: 40px; line-height: 1.05; margin-top: 4px; color: var(--tinta); }
    .subtitulo { margin: 6px 0 0; color: var(--sepia-hondo); }

    .cartela-sello { display: flex; align-items: stretch; gap: 10px; }
    .sello-nivel {
      display: grid; align-content: center; justify-items: center; gap: 2px;
      min-width: 78px; padding: 8px 14px; text-align: center;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-hueso);
    }
    .cifra-nivel { font-family: var(--display); font-size: 32px; line-height: 1.1; color: var(--tinta); }
    .sello-lado { display: grid; gap: 6px; align-content: center; justify-items: center; }
    .campana { color: var(--sepia); letter-spacing: .12em; text-transform: uppercase; font-size: 9px; }

    .meta {
      display: flex; flex-wrap: wrap; gap: 6px 8px;
      margin: 14px 0 0; padding-top: 12px; border-top: 1px dashed var(--linea);
    }
    .meta span {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia-hondo); border: 1px solid var(--linea); border-radius: var(--radio);
      padding: 3px 7px; background: rgba(255,255,255,.28);
    }
    .meta i { font-style: normal; color: var(--sepia-claro); margin-right: 4px; }

    /* ---------------- pestañas ---------------- */
    .pestanas { display: flex; gap: 6px; flex-wrap: wrap; margin: 0 0 16px; }
    .pest {
      font-family: var(--dato); font-size: 10px; letter-spacing: .16em; text-transform: uppercase;
      padding: 9px 16px; border-radius: var(--radio);
      border: 1px solid var(--linea-noche); background: transparent; color: var(--sepia-claro);
      transition: background .15s ease, color .15s ease;
    }
    .pest:hover { color: var(--pergamino); background: rgba(239,228,205,.06); }
    .pest.activa { background: var(--pergamino); border-color: var(--pergamino); color: var(--tinta); }
    .cuenta { margin-left: 8px; color: var(--sepia); }
    .pest.activa .cuenta { color: var(--sepia); }

    /* ---------------- rejilla de columnas ---------------- */
    .columnas { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 14px; align-items: start; }
    .pila { display: grid; gap: 14px; }

    .panel { padding: 14px 16px 16px; }
    .titulo-panel { margin: 0 0 12px; }
    .titulo-panel--siguiente { margin-top: 16px; }
    .franja { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
    .franja .titulo-panel { margin-bottom: 10px; }

    /* Las cajas son las casillas impresas de la hoja. */
    .caja { border: 1px solid var(--linea); border-radius: var(--radio); background: var(--pergamino-claro); }

    /* ---------------- características ---------------- */
    .caracts { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
    .caract { padding: 8px 4px 6px; text-align: center; display: grid; gap: 1px; }
    .caract .clave { font-size: 9px; letter-spacing: .14em; color: var(--sepia); }
    .caract .mod { font-family: var(--display); font-size: 28px; line-height: 1.15; color: var(--tinta); }
    .caract .mod.menos { color: var(--vino); }
    .caract .punt {
      justify-self: center; min-width: 26px; padding-top: 3px;
      font-family: var(--dato); font-size: 10px; color: var(--sepia-hondo);
      border-top: 1px solid var(--linea-clara);
    }

    /* ---------------- salvaciones ---------------- */
    .salvaciones { list-style: none; margin: 0; padding: 0; display: grid; gap: 6px; }
    .salv { display: flex; align-items: center; gap: 10px; padding: 8px 12px; }
    .salv-nombre { flex: 0 0 auto; color: var(--tinta); }
    .salv-valor { flex: 0 0 auto; font-family: var(--dato); font-size: 18px; font-variant-numeric: tabular-nums; color: var(--tinta); }
    .salv-base { flex: 0 0 46px; text-align: right; color: var(--sepia-claro); letter-spacing: .08em; text-transform: uppercase; font-size: 9px; }

    /* La guía de puntos: el gesto de la hoja impresa. */
    .guia { flex: 1 1 auto; height: 1px; border-bottom: 1px dotted var(--linea-fuerte); }

    /* ---------------- monedero ---------------- */
    .monedas { display: flex; gap: 8px; margin-bottom: 10px; }
    .moneda { flex: 1 1 0; text-align: center; padding: 7px 4px; display: grid; gap: 1px; }
    .moneda .dato { font-size: 8px; letter-spacing: .16em; text-transform: uppercase; color: var(--sepia); }
    .moneda-n { font-family: var(--dato); font-size: 16px; font-variant-numeric: tabular-nums; }
    .moneda--oro { border-color: rgba(157,122,47,.5); } .moneda--oro .moneda-n { color: var(--oro); }
    .moneda--plata .moneda-n { color: var(--sepia-hondo); }
    .moneda--cobre { border-color: rgba(143,46,34,.3); } .moneda--cobre .moneda-n { color: var(--vino); }

    .linea { display: flex; justify-content: space-between; gap: 12px; margin: 0; padding: 6px 0; color: var(--tinta); border-top: 1px dashed var(--linea); }
    .linea .rotulo { color: var(--sepia); letter-spacing: .14em; }

    /* ---------------- puntos de golpe ---------------- */
    .pg-cifras { display: flex; align-items: flex-end; gap: 12px; }
    .pg-actual { font-family: var(--display); font-size: 52px; line-height: .9; font-variant-numeric: tabular-nums; color: var(--musgo); }
    .pg-actual--medio { color: var(--oro); } .pg-actual--mal { color: var(--vino); }
    .pg-max { color: var(--sepia); font-size: 14px; padding-bottom: 6px; }
    .estado-pg { letter-spacing: .08em; text-transform: uppercase; color: var(--musgo); }
    .estado-pg--medio { color: var(--oro); } .estado-pg--mal { color: var(--vino); }

    .barra { margin-top: 12px; }
    .barra-fondo { height: 10px; background: var(--pergamino-hueso); border: 1px solid var(--linea); border-radius: var(--radio); overflow: hidden; }
    .barra-llena { height: 100%; background: var(--musgo); transition: width .25s ease; }
    .barra-llena--medio { background: var(--oro); } .barra-llena--mal { background: var(--vino); }

    .franja--vigor { align-items: center; margin-top: 14px; padding-top: 12px; border-top: 1px dashed var(--linea); }
    .pips { display: flex; gap: 4px; }
    .pip { width: 14px; height: 14px; border-radius: 50%; border: 1px solid rgba(157,122,47,.7); }
    .pip.lleno { background: var(--oro); }
    .vigor-n { color: var(--sepia-hondo); font-size: 12px; }

    /* Ajuste rápido: botones de 38 px, tamaño de dedo, con el color del gesto. */
    .ajuste { display: flex; gap: 6px; margin-left: auto; padding-bottom: 4px; }
    .ajuste--vigor { padding-bottom: 0; }
    .paso {
      min-width: 44px; height: 38px; font-family: var(--dato); font-size: 12px;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-claro); color: var(--tinta);
    }
    .ajuste--vigor .paso { min-width: 34px; height: 30px; font-size: 14px; }
    .paso:hover:not(:disabled) { background: rgba(43,33,23,.07); }
    .paso--dano { color: var(--vino); }
    .paso--cura { color: var(--musgo); }
    .error-ajuste { margin: 10px 0 0; }

    /* ---------------- defensa y ataque ---------------- */
    .defensa { display: grid; grid-template-columns: 1.4fr 1fr 1fr; gap: 8px; }
    .ataque { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; }
    .stat { padding: 10px 6px; text-align: center; display: grid; gap: 1px; }
    .stat .dato { font-size: 8px; letter-spacing: .16em; text-transform: uppercase; color: var(--sepia); }
    .stat .cifra { font-family: var(--display); font-size: 24px; line-height: 1.2; color: var(--tinta); font-variant-numeric: tabular-nums; }
    .stat--grande .cifra { font-size: 40px; line-height: 1.15; }
    .stat .nota { color: var(--sepia-claro); letter-spacing: .08em; }

    /* ---------------- habilidades ---------------- */
    .enlace { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; border: none; background: transparent; color: var(--vino); padding: 0; }
    .destacadas { list-style: none; margin: 0; padding: 0; display: grid; gap: 5px; }
    .destacadas li { display: flex; align-items: baseline; gap: 8px; }

    .buscador { flex: 0 1 260px; width: auto; padding: 9px 12px; }

    .habs { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 6px; }
    .hab { padding: 8px 12px; }
    .hab-alto { display: flex; align-items: baseline; gap: 8px; }
    .hnombre { flex: 0 0 auto; color: var(--tinta); }
    .hcar { flex: 0 0 auto; font-family: var(--dato); font-size: 8px; letter-spacing: .1em; color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio); padding: 0 4px; }
    .htotal { flex: 0 0 auto; font-family: var(--dato); font-size: 16px; color: var(--musgo); font-variant-numeric: tabular-nums; }
    .htotal.menos { color: var(--vino); }
    .hdesglose { margin: 3px 0 0; font-family: var(--dato); font-size: 9px; letter-spacing: .06em; text-transform: uppercase; color: var(--sepia-claro); }

    /* ---------------- bolsa ---------------- */
    .carga-total { font-family: var(--dato); font-size: 11px; letter-spacing: .06em; color: var(--oro); }

    .add-row { display: flex; gap: 8px; flex-wrap: wrap; margin: 4px 0 14px; padding: 12px; border: 1px dashed var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); }
    .add-row input { background: var(--pergamino); }
    .add-nombre { flex: 1 1 200px; min-width: 0; width: auto; }
    .add-num { flex: 0 0 84px; width: 84px; font-family: var(--dato); }
    .add-row .boton { flex: 0 0 auto; }
    .error-bolsa { font-size: 13px; color: #d98a7c; margin: 0 0 8px; }

    .bolsa { list-style: none; margin: 0; padding: 0; display: grid; gap: 6px; }
    .obj { display: flex; align-items: center; gap: 10px; padding: 8px 10px 8px 12px; border-left: 3px solid var(--linea-fuerte); }
    .obj--tienda { border-left-color: var(--musgo); }
    .obj-nombre { flex: 1 1 auto; min-width: 0; color: var(--tinta); }
    .obj-tienda { font-family: var(--dato); font-size: 8px; letter-spacing: .12em; text-transform: uppercase; color: var(--musgo); border: 1px solid rgba(76,106,55,.4); border-radius: var(--radio); padding: 1px 4px; margin-left: 8px; }
    .stepper { display: inline-flex; align-items: center; gap: 2px; flex: 0 0 auto; }
    .stepper button { width: 30px; height: 30px; border: 1px solid var(--linea-fuerte); background: var(--pergamino); color: var(--tinta); border-radius: var(--radio); font-size: 16px; line-height: 1; }
    .stepper button:hover { background: rgba(43,33,23,.07); }
    .stepper .cant { min-width: 28px; text-align: center; font-family: var(--dato); font-variant-numeric: tabular-nums; color: var(--tinta); }
    .obj-peso { flex: 0 0 130px; text-align: right; font-family: var(--dato); font-size: 10px; letter-spacing: .04em; color: var(--sepia); white-space: nowrap; }
    .obj-peso strong { color: var(--sepia-hondo); }
    .obj-quitar { flex: 0 0 auto; width: 30px; height: 30px; border: 1px solid rgba(143,46,34,.35); background: transparent; color: var(--vino); border-radius: var(--radio); }
    .obj-quitar:hover { background: rgba(143,46,34,.08); }

    /* ---------------- acciones y editor ---------------- */
    .acciones { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 18px; }
    .acciones--editor { margin-top: 22px; padding-top: 16px; border-top: 1px dashed var(--linea); }
    /* En fondo de noche el botón secundario necesita su propio borde. */
    .boton--noche { border-color: rgba(239,228,205,.28); color: var(--sepia-claro); }
    .boton--noche:hover:not(:disabled) { background: rgba(239,228,205,.06); color: var(--pergamino); }

    .editor { border-top: 3px solid var(--oro); padding: 18px 20px 22px; }
    .editor-nota { margin: 0 0 4px; color: var(--sepia-hondo); }
    .separador { margin: 20px 0 10px; padding-bottom: 6px; border-bottom: 1px solid var(--linea); color: var(--sepia); }
    .campos { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 10px; margin-bottom: 6px; }
    .campos--num { grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); }
    .campos label { display: grid; gap: 4px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }

    .habs-edit { list-style: none; margin: 0 0 10px; padding: 0; display: grid; gap: 6px; }
    .fila-hab { display: flex; gap: 6px; align-items: center; }
    .fila-hab .h-nombre { flex: 1 1 auto; min-width: 0; width: auto; }
    .fila-hab .h-num { width: 74px; flex: 0 0 auto; font-family: var(--dato); }
    .fila-hab select { width: 80px; flex: 0 0 auto; font: inherit; font-family: var(--dato); font-size: 13px; padding: 10px 6px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta); }
    .quitar { flex: 0 0 auto; border: 1px solid rgba(143,46,34,.4); background: transparent; color: var(--vino); border-radius: var(--radio); width: 34px; height: 38px; }

    .error { font-size: 14px; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 14px 0 0; color: #d98a7c; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
    .estado--breve { padding: 8px 0 0; }
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

  /** Pestaña visible. Es estado de interfaz, no del personaje. */
  readonly vista = signal<Vista>('ficha');
  readonly busca = signal('');

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

  // --- ajuste rápido de PG y vigor ---
  readonly ajustandoPg = signal(false);
  readonly ajustandoVigor = signal(false);
  readonly errorAjuste = signal<string | null>(null);

  // --- derivados de la vista ---

  /** Porcentaje de PG, para la barra. */
  readonly porcentajePg = computed(() => {
    const f = this.ficha();
    if (!f || !f.hpMax) return 0;
    return Math.max(0, Math.min(100, Math.round((f.hpCurrent / f.hpMax) * 100)));
  });

  /** El color cuenta el estado antes de leer la cifra: musgo, oro, vino. */
  readonly estadoPg = computed<'bien' | 'medio' | 'mal'>(() => {
    const p = this.porcentajePg();
    return p <= 25 ? 'mal' : (p <= 60 ? 'medio' : 'bien');
  });

  readonly etiquetaPg = computed(() => {
    const e = this.estadoPg();
    return e === 'mal' ? 'malherido' : (e === 'medio' ? 'herido' : 'entero');
  });

  readonly pipsVigor = computed(() => {
    const f = this.ficha();
    if (!f) return [] as boolean[];
    return Array.from({ length: Math.max(0, f.maxVigor) }, (_, i) => i < f.vigor);
  });

  /** El monedero se muestra en las tres monedas, igual que se edita. */
  readonly monedas = computed(() => {
    const cp = this.ficha()?.purseCp ?? 0;
    return { po: Math.floor(cp / 100), pp: Math.floor((cp % 100) / 10), pc: cp % 10 };
  });

  /** Las cinco mejores: lo que se consulta en mesa sin abrir la lista entera. */
  readonly habilidadesTop = computed(() =>
    [...(this.ficha()?.skills ?? [])].sort((a, b) => b.total - a.total).slice(0, 5));

  readonly habilidadesFiltradas = computed<SkillDetail[]>(() => {
    const q = this.busca().trim().toLowerCase();
    const todas = this.ficha()?.skills ?? [];
    return q ? todas.filter(s => s.name.toLowerCase().includes(q)) : todas;
  });

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

  // --- ajuste rápido (daño, curación, vigor) ---

  /**
   * Anota daño o curación sin abrir el editor. Se pinta al momento (la mesa no
   * espera) y, si el backend rechaza el cambio, se devuelve la ficha anterior.
   */
  ajustarPg(delta: number): void {
    const f = this.ficha();
    if (!f || this.ajustandoPg()) return;
    const nuevo = Math.max(0, Math.min(f.hpMax, f.hpCurrent + delta));
    if (nuevo === f.hpCurrent) return;

    this.ajustandoPg.set(true);
    this.errorAjuste.set(null);
    this.ficha.set({ ...f, hpCurrent: nuevo });

    this.juego.editarFicha(this.personajeId(), { hpCurrent: nuevo }).subscribe({
      next: actualizada => { this.ficha.set(actualizada); this.ajustandoPg.set(false); },
      error: () => {
        this.ficha.set(f);
        this.ajustandoPg.set(false);
        this.errorAjuste.set('No se han podido anotar los puntos de golpe.');
      },
    });
  }

  ajustarVigor(delta: number): void {
    const f = this.ficha();
    if (!f || this.ajustandoVigor()) return;
    const nuevo = Math.max(0, Math.min(f.maxVigor, f.vigor + delta));
    if (nuevo === f.vigor) return;

    this.ajustandoVigor.set(true);
    this.errorAjuste.set(null);
    this.ficha.set({ ...f, vigor: nuevo });

    this.juego.editarFicha(this.personajeId(), { vigor: nuevo }).subscribe({
      next: actualizada => { this.ficha.set(actualizada); this.ajustandoVigor.set(false); },
      error: () => {
        this.ficha.set(f);
        this.ajustandoVigor.set(false);
        this.errorAjuste.set('No se ha podido anotar el vigor.');
      },
    });
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