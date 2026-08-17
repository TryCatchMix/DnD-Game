import { Component, ElementRef, effect, inject, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { ConjurosPanel } from '../conjuros-panel';
import { FichaEditor } from '../ficha-editor';
import { FichaStore } from '../ficha.store';
import { KgPipe } from '../../../shared/peso.pipe';

/**
 * DISEÑO «PERGAMINO» — el de fábrica.
 *
 * La hoja impresa: pergamino sobre tinta parda, dos columnas de documento y
 * casillas. Se lee por pestañas (ficha · bolsa · habilidades) para que la
 * pantalla de mesa quepa de un vistazo: arriba lo que se consulta en cada turno
 * (PG, CA, salvaciones), y detrás lo que se consulta de vez en cuando.
 *
 * Aquí NO hay lógica: todo sale de `FichaStore`, que provee `FichaPage`.
 */
@Component({
  selector: 'arc-ficha-pergamino',
  imports: [FormsModule, FichaEditor, ConjurosPanel, KgPipe],
  template: `
    <div class="contenedor contenedor--hoja">
      @if (store.cargando()) {
        <p class="estado">Abriendo la ficha…</p>
      } @else if (store.error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (store.ficha(); as f) {

        <!-- ============ CABECERA ============ -->
        <header class="hoja cartela">
          <div class="cartela-alto">
            <div class="cartela-quien">
              <p class="rotulo">Hoja de personaje · D&amp;D 3.5</p>
              @if (!store.editando()) {
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
                @if (!store.editando()) {
                  <button class="boton" (click)="store.editar()">Editar ficha</button>
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
        @if (!store.editando()) {
          <div class="pestanas" role="tablist">
            <button role="tab" class="pest" [class.activa]="store.vista() === 'ficha'"
                    [attr.aria-selected]="store.vista() === 'ficha'" (click)="store.vista.set('ficha')">Ficha</button>
            <button role="tab" class="pest" [class.activa]="store.vista() === 'bolsa'"
                    [attr.aria-selected]="store.vista() === 'bolsa'" (click)="store.vista.set('bolsa')">
              Bolsa @if (store.inventario(); as inv) { <span class="cuenta">{{ inv.items.length }}</span> }
            </button>
            <button role="tab" class="pest" [class.activa]="store.vista() === 'habilidades'"
                    [attr.aria-selected]="store.vista() === 'habilidades'" (click)="store.vista.set('habilidades')">
              Habilidades <span class="cuenta">{{ f.skills.length }}</span>
            </button>
            <button role="tab" class="pest" [class.activa]="store.vista() === 'conjuros'"
                    [attr.aria-selected]="store.vista() === 'conjuros'" (click)="store.vista.set('conjuros')">
              Conjuros @if (store.totalPreparados(); as n) { <span class="cuenta">{{ n }}</span> }
            </button>
          </div>
        }

        <!-- ============ VISTA · FICHA ============ -->
        @if (!store.editando() && store.vista() === 'ficha') {
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
                    <span class="moneda-n">{{ store.monedas().po }}</span><span class="dato">oro</span>
                  </div>
                  <div class="caja moneda moneda--plata">
                    <span class="moneda-n">{{ store.monedas().pp }}</span><span class="dato">plata</span>
                  </div>
                  <div class="caja moneda moneda--cobre">
                    <span class="moneda-n">{{ store.monedas().pc }}</span><span class="dato">cobre</span>
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
                  <span class="dato estado-pg" [class]="'estado-pg--' + store.estadoPg()">{{ store.etiquetaPg() }}</span>
                </div>
                <div class="pg-cifras">
                  <span class="pg-actual" [class]="'pg-actual--' + store.estadoPg()">{{ f.hpCurrent }}</span>
                  <span class="dato pg-max">/ {{ f.hpMax }} pg</span>
                  <!-- Ajuste rápido: en mesa el daño se anota entre turnos, no abriendo el editor. -->
                  <span class="ajuste">
                    <button type="button" class="paso paso--dano" [disabled]="store.ajustandoPg()"
                            (click)="store.ajustarPg(-5)" aria-label="Cinco puntos de daño">−5</button>
                    <button type="button" class="paso paso--dano" [disabled]="store.ajustandoPg()"
                            (click)="store.ajustarPg(-1)" aria-label="Un punto de daño">−1</button>
                    <button type="button" class="paso paso--cura" [disabled]="store.ajustandoPg()"
                            (click)="store.ajustarPg(1)" aria-label="Curar un punto">+1</button>
                    <button type="button" class="paso paso--cura" [disabled]="store.ajustandoPg()"
                            (click)="store.ajustarPg(5)" aria-label="Curar cinco puntos">+5</button>
                  </span>
                </div>
                <div class="barra" role="img" [attr.aria-label]="f.hpCurrent + ' de ' + f.hpMax + ' puntos de golpe'">
                  <div class="barra-fondo"><div class="barra-llena" [class]="'barra-llena--' + store.estadoPg()" [style.width.%]="store.porcentajePg()"></div></div>
                </div>
                <div class="franja franja--vigor">
                  <span class="rotulo">Vigor</span>
                  <span class="pips">
                    @for (lleno of store.pipsVigor(); track $index) {
                      <span class="pip" [class.lleno]="lleno"></span>
                    }
                  </span>
                  <span class="dato vigor-n">{{ f.vigor }} / {{ f.maxVigor }}</span>
                  <span class="ajuste ajuste--vigor">
                    <button type="button" class="paso" [disabled]="store.ajustandoVigor()"
                            (click)="store.ajustarVigor(-1)" aria-label="Gastar un punto de vigor">−</button>
                    <button type="button" class="paso" [disabled]="store.ajustandoVigor()"
                            (click)="store.ajustarVigor(1)" aria-label="Recuperar un punto de vigor">+</button>
                  </span>
                </div>
                @if (store.errorAjuste(); as e) { <p class="error-bolsa error-ajuste">{{ e }}</p> }
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
                  <button class="enlace" (click)="store.vista.set('habilidades')">Ver todas ({{ f.skills.length }})</button>
                </div>
                @if (f.skills.length === 0) {
                  <p class="estado estado--breve">Sin habilidades anotadas.</p>
                } @else {
                  <ul class="destacadas">
                    @for (s of store.habilidadesTop(); track s.name) {
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
        @if (!store.editando() && store.vista() === 'bolsa') {
          <section class="hoja panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Bolsa</p>
              @if (store.inventario(); as inv) {
                <span class="carga-total">Carga total · {{ inv.totalWeight }} lb ({{ inv.totalWeight | kg }}) @if (f.carga) { · {{ f.carga }} }</span>
              }
            </div>

            <!-- Añadido rápido: nombre, cantidad y peso; Enter añade -->
            <div class="add-row">
              <input #nombreInput class="add-nombre" placeholder="Nombre del objeto"
                     [(ngModel)]="store.nuevoNombre" (keydown.enter)="store.anadirItem()" />
              <input class="add-num" type="number" min="1" placeholder="Cant."
                     [(ngModel)]="store.nuevaCantidad" (keydown.enter)="store.anadirItem()" />
              <input class="add-num" type="number" min="0" step="0.5" placeholder="Peso"
                     [(ngModel)]="store.nuevoPeso" (keydown.enter)="store.anadirItem()" />
              <button class="boton boton--lacre" [disabled]="!store.nuevoNombre().trim()" (click)="store.anadirItem()">Añadir</button>
            </div>
            @if (store.errorBolsa(); as e) { <p class="error-bolsa">{{ e }}</p> }

            @if (store.inventario(); as inv) {
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
                        <button type="button" (click)="store.ajustar(it, -1)" aria-label="Menos">−</button>
                        <span class="cant">{{ it.quantity }}</span>
                        <button type="button" (click)="store.ajustar(it, 1)" aria-label="Más">+</button>
                      </span>
                      <span class="obj-peso"><strong>{{ it.lineWeight }} lb ({{ it.lineWeight | kg }})</strong></span>
                      <button type="button" class="obj-quitar" (click)="store.eliminar(it)" aria-label="Quitar">✕</button>
                    </li>
                  }
                </ul>
              }
            }
          </section>
        }

        <!-- ============ VISTA · CONJUROS ============ -->
        @if (!store.editando() && store.vista() === 'conjuros') {
          <section class="hoja panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Conjuros preparados</p>
              <span class="carga-total">{{ store.totalPreparados() }} preparados</span>
            </div>
            <arc-conjuros-panel />
          </section>
        }

        <!-- ============ VISTA · HABILIDADES ============ -->
        @if (!store.editando() && store.vista() === 'habilidades') {
          <section class="hoja panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Habilidades · {{ f.skills.length }} anotadas</p>
              <input class="buscador" placeholder="Buscar habilidad…" [(ngModel)]="store.busca" />
            </div>
            @if (f.skills.length === 0) {
              <p class="estado">Sin habilidades anotadas.</p>
            } @else if (store.habilidadesFiltradas().length === 0) {
              <p class="estado">Ninguna habilidad coincide con «{{ store.busca() }}».</p>
            } @else {
              <ul class="habs">
                @for (s of store.habilidadesFiltradas(); track s.name) {
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

        @if (!store.editando()) {
          <div class="acciones">
            <button class="boton boton--lacre" (click)="store.alTablon(f.id)">Ir al tablón</button>
            <button class="boton boton--noche" (click)="store.alaTienda(f.id)">Tienda</button>
          </div>
        }

        <!-- ============ EDICIÓN ============ -->
        @if (store.editando()) { <arc-ficha-editor /> }
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

    /* ---------------- acciones ---------------- */
    .acciones { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 18px; }
    /* En fondo de noche el botón secundario necesita su propio borde. */
    .boton--noche { border-color: rgba(239,228,205,.28); color: var(--sepia-claro); }
    .boton--noche:hover:not(:disabled) { background: rgba(239,228,205,.06); color: var(--pergamino); }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
    .estado--breve { padding: 8px 0 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class FichaPergamino {

  readonly store = inject(FichaStore);

  private readonly nombreInput = viewChild<ElementRef<HTMLInputElement>>('nombreInput');

  constructor() {
    // Tras añadir un objeto, el foco vuelve al nombre para encadenar añadidos.
    effect(() => {
      if (this.store.itemAnadido() === 0) return;   // el 0 es el arranque, no un añadido
      this.nombreInput()?.nativeElement.focus();
    });
  }
}
