import { Component, ElementRef, effect, inject, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { ConjurosPanel } from '../spells-panel';
import { FichaEditor } from '../sheet-editor';
import { FichaStore } from '../sheet.store';
import { KgPipe } from '../../../shared/weight.pipe';

/** Números romanos para el sello de nivel. Formato, no lógica: solo se pinta. */
function romano(n: number): string {
  if (!Number.isFinite(n) || n < 1 || n > 3999) return String(n);
  const tabla: [number, string][] = [
    [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'], [100, 'C'], [90, 'XC'],
    [50, 'L'], [40, 'XL'], [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I'],
  ];
  let resto = Math.floor(n), salida = '';
  for (const [valor, letra] of tabla) {
    while (resto >= valor) { salida += letra; resto -= valor; }
  }
  return salida;
}

/**
 * DISEÑO «CELESTE».
 *
 * La hoja como una carta astral: fondo de noche profunda con estrellas que
 * derivan despacio, paneles de cristal violeta, acentos en cian y oro pálido.
 * Mantiene la lectura por pestañas del pergamino, pero cambia el material: aquí
 * la ficha no es papel, es el cielo mirándote.
 *
 * Como todos los diseños, aquí no hay lógica: todo sale de `FichaStore`.
 */
@Component({
  selector: 'arc-ficha-celeste',
  imports: [FormsModule, FichaEditor, ConjurosPanel, KgPipe],
  template: `
    <!-- El cielo cubre la pantalla entera, también por detrás de la barra. -->
    <div class="cielo" aria-hidden="true"></div>
    <div class="estrellas" aria-hidden="true"></div>

    <div class="contenedor contenedor--celeste">
      @if (store.cargando()) {
        <p class="estado">Abriendo la ficha…</p>
      } @else if (store.error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (store.ficha(); as f) {

        <!-- ============ CARTELA ============ -->
        <header class="cartela">
          <svg class="constelacion" viewBox="0 0 900 220" preserveAspectRatio="none" fill="none" aria-hidden="true">
            <path d="M40 26 L150 54 L232 20 L318 62 L430 34" stroke="rgba(159,232,239,.35)" stroke-width=".7"></path>
            <path d="M600 180 L688 150 L742 186 L830 158" stroke="rgba(231,168,196,.3)" stroke-width=".7"></path>
            <circle class="lucero" cx="40" cy="26" r="2.2" fill="#cff6fa"></circle>
            <circle class="lucero" cx="150" cy="54" r="1.6" fill="#fff"></circle>
            <circle class="lucero" cx="232" cy="20" r="2" fill="#e7a8c4"></circle>
            <circle class="lucero" cx="318" cy="62" r="1.5" fill="#fff"></circle>
            <circle class="lucero" cx="430" cy="34" r="2.4" fill="#b9a6e8"></circle>
            <circle class="lucero" cx="688" cy="150" r="1.8" fill="#fff"></circle>
            <circle class="lucero" cx="830" cy="158" r="2.1" fill="#cff6fa"></circle>
          </svg>

          <div class="cartela-alto">
            <div class="cartela-quien">
              <p class="rotulo">Hoja de personaje · D&amp;D 3.5</p>
              @if (!store.editando()) {
                <h1>{{ f.name }}</h1>
                <p class="subtitulo">
                  {{ f.clazz }} nivel {{ f.level }}
                  @if (f.race) { · {{ f.race }} }
                  @if (f.alignment) { · {{ f.alignment }} }
                  @if (f.deity) { · <em>devoto de {{ f.deity }}</em> }
                </p>
              } @else {
                <h1>Editando ficha</h1>
                <p class="subtitulo">{{ f.name }} · {{ f.clazz }} nivel {{ f.level }}</p>
              }
            </div>

            <div class="cartela-sello">
              <div class="astrolabio">
                <svg viewBox="0 0 96 96" fill="none" aria-hidden="true">
                  <circle cx="48" cy="48" r="45" stroke="rgba(217,185,106,.55)" stroke-width=".8"></circle>
                  <circle cx="48" cy="48" r="38" stroke="rgba(159,232,239,.3)" stroke-width=".8" stroke-dasharray="2 6"></circle>
                  <circle cx="48" cy="48" r="30" stroke="rgba(185,166,232,.35)" stroke-width=".6"></circle>
                  <path d="M48 18 L74 63 L22 63 Z" stroke="rgba(217,185,106,.35)" stroke-width=".6"></path>
                  <circle cx="48" cy="18" r="1.6" fill="#d9b96a"></circle>
                  <circle cx="74" cy="63" r="1.6" fill="#d9b96a"></circle>
                  <circle cx="22" cy="63" r="1.6" fill="#d9b96a"></circle>
                </svg>
                <div class="astrolabio-centro">
                  <p class="rotulo">Nivel</p>
                  <p class="cifra-nivel" [attr.aria-label]="'Nivel ' + f.level">{{ nivelRomano(f.level) }}</p>
                </div>
              </div>
              @if (!store.editando()) {
                <button type="button" class="boton-cielo" (click)="store.editar()">Editar ficha</button>
              }
            </div>
          </div>

          <p class="meta">
            @if (f.size) { <span><i>tamaño</i> {{ f.size }}</span> }
            @if (f.sex) { <span><i>sexo</i> {{ f.sex }}</span> }
            @if (f.age) { <span><i>edad</i> {{ f.age }}</span> }
            @if (f.height) { <span><i>altura</i> {{ f.height }}</span> }
            @if (f.weight) { <span><i>peso</i> {{ f.weight }}</span> }
            @if (f.location) { <span><i>ciudad</i> {{ f.location }}</span> }
            @if (f.campaign) { <span><i>campaña</i> {{ f.campaign }}</span> }
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

            <!-- Las fases de la luna: adorno, no dato. -->
            <svg class="lunas" viewBox="0 0 120 16" fill="none" aria-hidden="true">
              <circle cx="8" cy="8" r="5.5" stroke="rgba(217,185,106,.7)" stroke-width=".8"></circle>
              <path d="M8 2.5a5.5 5.5 0 0 0 0 11 3.6 3.6 0 0 1 0-11Z" fill="rgba(217,185,106,.55)"></path>
              <circle cx="36" cy="8" r="5.5" stroke="rgba(217,185,106,.7)" stroke-width=".8"></circle>
              <path d="M36 2.5a5.5 5.5 0 0 1 0 11Z" fill="rgba(217,185,106,.75)"></path>
              <circle cx="64" cy="8" r="5.5" fill="rgba(217,185,106,.85)"></circle>
              <circle cx="92" cy="8" r="5.5" stroke="rgba(217,185,106,.7)" stroke-width=".8"></circle>
              <path d="M92 2.5a5.5 5.5 0 0 0 0 11Z" fill="rgba(217,185,106,.75)"></path>
              <circle cx="116" cy="8" r="1.6" fill="rgba(159,232,239,.8)"></circle>
            </svg>
          </div>
        }

        <!-- ============ VISTA · FICHA ============ -->
        @if (!store.editando() && store.vista() === 'ficha') {
          <div class="columnas">

            <div class="pila">
              <!-- Características -->
              <section class="panel panel--nebulosa">
                <p class="rotulo titulo-panel">Características</p>
                <ul class="caracts">
                  @for (a of f.abilities; track a.key) {
                    <li class="caja caract">
                      <span class="clave">{{ a.key }}</span>
                      <span class="mod" [class.menos]="a.modifier < 0">{{ a.modifier >= 0 ? '+' : '' }}{{ a.modifier }}</span>
                      <span class="punt">{{ a.score }}</span>
                    </li>
                  }
                </ul>
              </section>

              <!-- Salvaciones -->
              <section class="panel">
                <p class="rotulo titulo-panel">Tiradas de salvación</p>
                <ul class="salvaciones">
                  <li class="caja salv">
                    <span class="salv-nombre">Fortaleza</span><span class="guia"></span>
                    <span class="salv-valor">{{ f.saveFort >= 0 ? '+' : '' }}{{ f.saveFort }}</span>
                    <span class="salv-base">CON</span>
                  </li>
                  <li class="caja salv">
                    <span class="salv-nombre">Reflejos</span><span class="guia"></span>
                    <span class="salv-valor">{{ f.saveRef >= 0 ? '+' : '' }}{{ f.saveRef }}</span>
                    <span class="salv-base">DES</span>
                  </li>
                  <li class="caja salv">
                    <span class="salv-nombre">Voluntad</span><span class="guia"></span>
                    <span class="salv-valor">{{ f.saveWill >= 0 ? '+' : '' }}{{ f.saveWill }}</span>
                    <span class="salv-base">SAB</span>
                  </li>
                </ul>
              </section>

              <!-- Monedero y carga -->
              <section class="panel">
                <p class="rotulo titulo-panel">Monedero y carga</p>
                <div class="monedas">
                  <div class="caja moneda moneda--oro">
                    <span class="moneda-n">{{ store.monedas().po }}</span><span class="moneda-t">oro</span>
                  </div>
                  <div class="caja moneda moneda--plata">
                    <span class="moneda-n">{{ store.monedas().pp }}</span><span class="moneda-t">plata</span>
                  </div>
                  <div class="caja moneda moneda--cobre">
                    <span class="moneda-n">{{ store.monedas().pc }}</span><span class="moneda-t">cobre</span>
                  </div>
                </div>
                <p class="linea"><span class="rotulo">Carga</span><span>{{ f.carga || '—' }}</span></p>
                <p class="linea"><span class="rotulo">Reducción de daño</span><span>{{ f.damageReduction || '—' }}</span></p>
                <p class="linea"><span class="rotulo">Resist. a conjuros</span><span>{{ f.spellResistance || '—' }}</span></p>

                <svg class="rubrica" viewBox="0 0 96 34" fill="none" aria-hidden="true">
                  <path d="M6 26 L26 10 L48 22 L70 6 L90 18" stroke="rgba(159,232,239,.5)" stroke-width=".7"></path>
                  <circle class="lucero" cx="6" cy="26" r="1.6" fill="#cff6fa"></circle>
                  <circle class="lucero" cx="26" cy="10" r="2" fill="#fff"></circle>
                  <circle class="lucero" cx="48" cy="22" r="1.4" fill="#b9a6e8"></circle>
                  <circle class="lucero" cx="70" cy="6" r="1.8" fill="#fff"></circle>
                  <circle class="lucero" cx="90" cy="18" r="1.5" fill="#e7a8c4"></circle>
                </svg>
              </section>
            </div>

            <div class="pila">
              <!-- Puntos de golpe -->
              <section class="panel panel--marea">
                <div class="franja">
                  <p class="rotulo titulo-panel">Puntos de golpe</p>
                  <span class="estado-pg" [class]="'tinte--' + store.estadoPg()">{{ store.etiquetaPg() }}</span>
                </div>
                <div class="pg-cifras">
                  <span class="pg-actual" [class]="'tinte--' + store.estadoPg()">{{ f.hpCurrent }}</span>
                  <span class="pg-max">/ {{ f.hpMax }} pg</span>
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
                  <div class="barra-llena" [class]="'tinte--' + store.estadoPg()" [style.width.%]="store.porcentajePg()"></div>
                </div>

                <div class="franja franja--vigor">
                  <span class="rotulo">Vigor</span>
                  <span class="pips">
                    @for (lleno of store.pipsVigor(); track $index) {
                      <span class="pip" [class.lleno]="lleno"></span>
                    }
                  </span>
                  <span class="vigor-n">{{ f.vigor }} / {{ f.maxVigor }}</span>
                  <span class="ajuste ajuste--vigor">
                    <button type="button" class="paso paso--min" [disabled]="store.ajustandoVigor()"
                            (click)="store.ajustarVigor(-1)" aria-label="Gastar un punto de vigor">−</button>
                    <button type="button" class="paso paso--min" [disabled]="store.ajustandoVigor()"
                            (click)="store.ajustarVigor(1)" aria-label="Recuperar un punto de vigor">+</button>
                  </span>
                </div>
                @if (store.errorAjuste(); as e) { <p class="error">{{ e }}</p> }
              </section>

              <!-- Defensa y ataque -->
              <section class="panel">
                <p class="rotulo titulo-panel">Defensa</p>
                <div class="defensa">
                  <div class="caja stat stat--grande">
                    <svg class="orbitas" viewBox="0 0 120 120" fill="none" aria-hidden="true">
                      <circle cx="60" cy="60" r="46" stroke="rgba(159,232,239,.5)" stroke-width=".6" stroke-dasharray="1 7"></circle>
                      <circle cx="60" cy="60" r="34" stroke="rgba(185,166,232,.4)" stroke-width=".6"></circle>
                    </svg>
                    <span class="stat-t">Clase de armadura</span><span class="cifra">{{ f.acTotal }}</span>
                  </div>
                  <div class="caja stat"><span class="stat-t">CA toque</span><span class="cifra">{{ f.acTouch }}</span></div>
                  <div class="caja stat"><span class="stat-t">Desprevenido</span><span class="cifra">{{ f.acFlatFooted }}</span></div>
                </div>

                <p class="rotulo titulo-panel titulo-panel--siguiente">Ataque y movimiento</p>
                <div class="ataque">
                  <div class="caja stat">
                    <span class="stat-t">Ataque base</span>
                    <span class="cifra">{{ f.bab >= 0 ? '+' : '' }}{{ f.bab }}</span>
                    <span class="nota">BAB</span>
                  </div>
                  <div class="caja stat">
                    <span class="stat-t">Presa</span>
                    <span class="cifra">{{ f.grapple >= 0 ? '+' : '' }}{{ f.grapple }}</span>
                    <span class="nota">BAB + FUE</span>
                  </div>
                  <div class="caja stat">
                    <span class="stat-t">Iniciativa</span>
                    <span class="cifra">{{ f.initiative >= 0 ? '+' : '' }}{{ f.initiative }}</span>
                    <span class="nota">DES</span>
                  </div>
                  <div class="caja stat">
                    <span class="stat-t">Velocidad</span>
                    <span class="cifra">{{ f.speed }}</span>
                    <span class="nota">pies</span>
                  </div>
                </div>
              </section>

              <!-- Habilidades destacadas -->
              <section class="panel">
                <div class="franja">
                  <p class="rotulo titulo-panel">Habilidades destacadas</p>
                  <button type="button" class="enlace" (click)="store.vista.set('habilidades')">Ver todas ({{ f.skills.length }})</button>
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
          <section class="panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Bolsa</p>
              @if (store.inventario(); as inv) {
                <span class="carga-total">Carga total · {{ inv.totalWeight }} lb ({{ inv.totalWeight | kg }}) @if (f.carga) { · {{ f.carga }} }</span>
              }
            </div>

            <div class="add-row">
              <input #nombreInput class="add-nombre" placeholder="Nombre del objeto"
                     [(ngModel)]="store.nuevoNombre" (keydown.enter)="store.anadirItem()" />
              <input class="add-num" type="number" min="1" placeholder="Cant."
                     [(ngModel)]="store.nuevaCantidad" (keydown.enter)="store.anadirItem()" />
              <input class="add-num" type="number" min="0" step="0.5" placeholder="Peso"
                     [(ngModel)]="store.nuevoPeso" (keydown.enter)="store.anadirItem()" />
              <button type="button" class="boton-cielo boton-cielo--fuerte"
                      [disabled]="!store.nuevoNombre().trim()" (click)="store.anadirItem()">Añadir</button>
            </div>
            @if (store.errorBolsa(); as e) { <p class="error">{{ e }}</p> }

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
          <section class="panel">
            <div class="franja">
              <p class="rotulo titulo-panel">Conjuros preparados</p>
              <span class="carga-total">{{ store.totalPreparados() }} preparados</span>
            </div>
            <arc-conjuros-panel />
          </section>
        }

        <!-- ============ VISTA · HABILIDADES ============ -->
        @if (!store.editando() && store.vista() === 'habilidades') {
          <section class="panel">
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

        <!-- ============ ACCIONES ============ -->
        @if (!store.editando()) {
          <div class="acciones">
            <button type="button" class="boton-cielo boton-cielo--fuerte" (click)="store.alTablon(f.id)">Ir al tablón</button>
            <button type="button" class="boton-cielo boton-cielo--lila" (click)="store.alaTienda(f.id)">Tienda</button>
            @if (f.deity) { <span class="firma">anotado bajo el ojo de {{ f.deity }}</span> }
          </div>
        }

        <!-- ============ EDICIÓN ============ -->
        @if (store.editando()) { <arc-ficha-editor /> }
      }
    </div>
  `,
  styles: `
    :host {
      --tinta-cielo: #e7e3f2;
      --tinta-suave: #aeb4d8;
      --tinta-tenue: #8e97c4;
      --tinta-honda: #69739f;
      --cian:   #9fe8ef;
      --lila:   #b9a6e8;
      --oro-luz:#e2c37c;
      --rosa:   #e0a6bd;
      --borde:      rgba(185,166,232,.18);
      --borde-cian: rgba(159,232,239,.16);
      --vidrio: linear-gradient(158deg, rgba(23,26,52,.9), rgba(9,11,23,.92));
      --titular: Marcellus, Georgia, serif;
      --prosa:   Spectral, Georgia, serif;

      display: block;
      font-family: var(--prosa);
      color: var(--tinta-cielo);
    }

    /* ---------------- el cielo ---------------- */
    /* Va detrás de todo (z-index negativo) para cubrir también la barra. */
    .cielo, .estrellas { position: fixed; z-index: -1; pointer-events: none; }
    .cielo {
      inset: 0;
      background:
        radial-gradient(1100px 700px at 12% -10%, rgba(70,54,140,.38), transparent 65%),
        radial-gradient(900px 620px at 88% 8%, rgba(24,74,110,.32), transparent 62%),
        radial-gradient(800px 800px at 60% 105%, rgba(120,48,96,.18), transparent 60%),
        linear-gradient(180deg, #080a15 0%, #06070f 55%, #04050b 100%);
    }
    .estrellas {
      inset: -10%;
      opacity: .55;
      animation: deriva 90s linear infinite alternate;
      background-image:
        radial-gradient(1.4px 1.4px at 12% 18%, rgba(255,255,255,.85), transparent 60%),
        radial-gradient(1.2px 1.2px at 27% 62%, rgba(199,214,255,.7), transparent 60%),
        radial-gradient(1px 1px at 41% 12%, rgba(255,255,255,.6), transparent 60%),
        radial-gradient(1.6px 1.6px at 58% 78%, rgba(231,168,196,.7), transparent 60%),
        radial-gradient(1.1px 1.1px at 69% 33%, rgba(255,255,255,.7), transparent 60%),
        radial-gradient(1.3px 1.3px at 82% 58%, rgba(159,232,239,.8), transparent 60%),
        radial-gradient(1px 1px at 91% 22%, rgba(255,255,255,.6), transparent 60%),
        radial-gradient(1.2px 1.2px at 8% 88%, rgba(185,166,232,.7), transparent 60%),
        radial-gradient(1px 1px at 35% 92%, rgba(255,255,255,.5), transparent 60%),
        radial-gradient(1.1px 1.1px at 74% 6%, rgba(255,255,255,.55), transparent 60%);
    }
    @keyframes deriva { from { transform: translate3d(0,0,0); } to { transform: translate3d(-40px,-30px,0); } }
    @keyframes titilar { 0%, 100% { opacity: .25; } 50% { opacity: 1; } }
    .lucero { animation: titilar 5.5s ease-in-out infinite; }
    .lucero:nth-of-type(3n) { animation-duration: 7.5s; animation-delay: -2s; }
    .lucero:nth-of-type(4n) { animation-duration: 9s; animation-delay: -4s; }

    .contenedor--celeste { max-width: 1100px; }

    /* La versalita de este diseño es más ancha y más fría que la del pergamino. */
    .rotulo {
      font-family: var(--prosa); font-size: 10px; letter-spacing: .3em;
      text-transform: uppercase; color: var(--tinta-tenue);
    }

    /* ---------------- cartela ---------------- */
    .cartela {
      position: relative; overflow: hidden;
      margin: 22px 0 18px; padding: 26px 28px 20px;
      background: linear-gradient(155deg, rgba(28,26,58,.9), rgba(10,12,26,.92));
      border: 1px solid rgba(185,166,232,.22);
      box-shadow: 0 24px 60px -30px rgba(90,60,160,.7), inset 0 1px 0 rgba(255,255,255,.05);
    }
    .constelacion { position: absolute; inset: 0; width: 100%; height: 100%; opacity: .6; pointer-events: none; }
    .cartela-alto { position: relative; display: flex; align-items: flex-start; gap: 28px; flex-wrap: wrap; }
    .cartela-quien { flex: 1 1 340px; min-width: 0; }
    .cartela-quien h1 {
      margin: 8px 0 0; font-family: var(--titular); font-weight: 400;
      font-size: 50px; line-height: 1.02; letter-spacing: .02em;
      color: #f3eefb; text-shadow: 0 0 28px rgba(159,232,239,.28);
    }
    .subtitulo { margin: 10px 0 0; font-size: 15px; font-weight: 300; color: var(--tinta-suave); }
    .subtitulo em { font-family: 'IM Fell English', Georgia, serif; color: #c9bbee; }

    .cartela-sello { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
    .astrolabio { position: relative; width: 96px; height: 96px; display: grid; place-items: center; }
    .astrolabio svg { position: absolute; inset: 0; width: 96px; height: 96px; }
    .astrolabio-centro { text-align: center; }
    .astrolabio-centro .rotulo { font-size: 8px; }
    .cifra-nivel { margin: 2px 0 0; font-family: var(--titular); font-size: 30px; line-height: 1; color: #f3eefb; }

    .meta {
      position: relative; display: flex; flex-wrap: wrap; gap: 8px;
      margin: 20px 0 0; padding-top: 16px; border-top: 1px solid rgba(185,166,232,.16);
    }
    .meta span {
      font-size: 9px; letter-spacing: .18em; text-transform: uppercase; color: #9aa3ce;
      border: 1px solid rgba(185,166,232,.2); padding: 4px 9px; background: rgba(255,255,255,.03);
    }
    .meta i { font-style: normal; color: var(--tinta-honda); margin-right: 6px; }

    /* ---------------- botones ---------------- */
    .boton-cielo {
      padding: 12px 22px; background: transparent; border: 1px solid rgba(159,232,239,.4);
      color: #cfe9ee; font-family: var(--prosa); font-size: 11px; letter-spacing: .22em;
      text-transform: uppercase; cursor: pointer; transition: background .2s ease, color .2s ease;
    }
    .boton-cielo:hover:not(:disabled) { background: rgba(159,232,239,.12); color: #f3eefb; }
    .boton-cielo:disabled { opacity: .4; cursor: not-allowed; }
    .boton-cielo--fuerte { background: rgba(159,232,239,.1); border-color: rgba(159,232,239,.5); color: #e7f6f9; }
    .boton-cielo--lila { border-color: rgba(185,166,232,.32); color: #c9bbee; }
    .boton-cielo--lila:hover:not(:disabled) { background: rgba(185,166,232,.12); color: #efe9fb; }

    /* ---------------- pestañas ---------------- */
    .pestanas { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; margin: 0 0 18px; }
    .pest {
      padding: 10px 20px; background: transparent; border: 1px solid rgba(159,232,239,.28);
      color: #8b94c0; font-family: var(--prosa); font-size: 10px; letter-spacing: .26em;
      text-transform: uppercase; cursor: pointer; transition: background .2s ease, color .2s ease;
    }
    .pest:hover { color: #cfe9ee; }
    .pest.activa { background: rgba(159,232,239,.14); color: #eaf7fa; }
    .cuenta { margin-left: 8px; color: #8ba0b8; }
    .lunas { margin-left: auto; width: 120px; height: 16px; opacity: .75; }

    /* ---------------- rejilla ---------------- */
    .columnas { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 16px; align-items: start; }
    .pila { display: grid; gap: 16px; }

    /* Los paneles son cristal, no papel: fondo de nebulosa y filo frío. */
    .panel {
      position: relative; padding: 18px 20px 20px;
      background: var(--vidrio); border: 1px solid var(--borde-cian);
      box-shadow: inset 0 1px 0 rgba(255,255,255,.04);
    }
    .panel--nebulosa::before {
      content: ''; position: absolute; inset: 0; pointer-events: none;
      background: radial-gradient(420px 200px at 88% -10%, rgba(120,90,200,.22), transparent 70%);
    }
    .panel--marea { overflow: hidden; }
    .panel--marea::before {
      content: ''; position: absolute; inset: 0; pointer-events: none;
      background: radial-gradient(500px 240px at 10% 120%, rgba(60,110,150,.22), transparent 70%);
    }
    .panel > * { position: relative; }

    .titulo-panel { margin: 0 0 14px; }
    .titulo-panel--siguiente { margin-top: 18px; }
    .franja { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
    .franja .titulo-panel { margin-bottom: 12px; }

    .caja { border: 1px solid var(--borde); background: rgba(255,255,255,.025); }

    /* ---------------- características ---------------- */
    .caracts { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
    .caract { padding: 12px 6px 8px; text-align: center; display: grid; gap: 2px; }
    .caract .clave { font-size: 9px; letter-spacing: .24em; color: #8b94c0; }
    .caract .mod { font-family: var(--titular); font-size: 30px; line-height: 1.1; color: #f0ecfa; }
    .caract .mod.menos { color: var(--rosa); }
    .caract .punt {
      justify-self: center; min-width: 30px; padding-top: 4px; font-size: 10px;
      color: #7b85b2; border-top: 1px solid var(--borde);
    }

    /* ---------------- salvaciones ---------------- */
    .salvaciones { list-style: none; margin: 0; padding: 0; display: grid; gap: 8px; }
    .salv { display: flex; align-items: center; gap: 12px; padding: 11px 14px; }
    .salv-nombre { font-size: 16px; }
    .salv-valor { font-size: 19px; font-variant-numeric: tabular-nums; color: #cfe9ee; }
    .salv-base { flex: 0 0 44px; text-align: right; font-size: 9px; letter-spacing: .16em; text-transform: uppercase; color: var(--tinta-honda); }
    .guia { flex: 1 1 auto; height: 1px; border-bottom: 1px dotted rgba(185,166,232,.4); }

    /* ---------------- monedero ---------------- */
    .monedas { display: flex; gap: 10px; margin-bottom: 14px; }
    .moneda { flex: 1 1 0; text-align: center; padding: 10px 4px; display: grid; gap: 2px; }
    .moneda-n { font-size: 18px; font-variant-numeric: tabular-nums; }
    .moneda-t { font-size: 8px; letter-spacing: .24em; text-transform: uppercase; }
    .moneda--oro { border-color: rgba(217,185,106,.35); background: rgba(217,185,106,.06); }
    .moneda--oro .moneda-n { color: var(--oro-luz); } .moneda--oro .moneda-t { color: #8e8055; }
    .moneda--plata { border-color: rgba(185,196,232,.28); background: rgba(255,255,255,.03); }
    .moneda--plata .moneda-n { color: #c6cde8; } .moneda--plata .moneda-t { color: #79819f; }
    .moneda--cobre { border-color: rgba(231,168,196,.28); background: rgba(231,168,196,.05); }
    .moneda--cobre .moneda-n { color: var(--rosa); } .moneda--cobre .moneda-t { color: #96707f; }

    .linea { display: flex; justify-content: space-between; gap: 12px; margin: 0; padding: 9px 0; color: var(--tinta-suave); border-top: 1px dashed var(--borde); }
    .rubrica { display: block; width: 96px; height: 34px; margin-left: auto; margin-top: 8px; opacity: .5; }

    /* ---------------- puntos de golpe ---------------- */
    .tinte--bien  { color: var(--cian); }
    .tinte--medio { color: var(--oro-luz); }
    .tinte--mal   { color: var(--rosa); }
    .estado-pg { font-size: 10px; letter-spacing: .24em; text-transform: uppercase; }

    .pg-cifras { display: flex; align-items: flex-end; gap: 14px; flex-wrap: wrap; }
    .pg-actual { font-family: var(--titular); font-size: 56px; line-height: .9; font-variant-numeric: tabular-nums; }
    .pg-actual.tinte--bien  { text-shadow: 0 0 26px rgba(159,232,239,.45); }
    .pg-actual.tinte--medio { text-shadow: 0 0 26px rgba(226,195,124,.5); }
    .pg-actual.tinte--mal   { text-shadow: 0 0 26px rgba(224,166,189,.5); }
    .pg-max { font-size: 15px; color: var(--tinta-tenue); padding-bottom: 7px; }

    .barra { margin-top: 14px; height: 10px; border: 1px solid rgba(185,166,232,.22); background: rgba(255,255,255,.03); }
    .barra-llena { height: 100%; transition: width .3s ease; background: currentColor; }
    .barra-llena.tinte--bien  { box-shadow: 0 0 14px rgba(159,232,239,.45); }
    .barra-llena.tinte--medio { box-shadow: 0 0 14px rgba(226,195,124,.5); }
    .barra-llena.tinte--mal   { box-shadow: 0 0 14px rgba(224,166,189,.5); }

    .franja--vigor { align-items: center; margin-top: 16px; padding-top: 14px; border-top: 1px dashed var(--borde); }
    .pips { display: flex; gap: 5px; }
    .pip { width: 14px; height: 14px; border-radius: 50%; border: 1px solid rgba(217,185,106,.6); }
    .pip.lleno { background: rgba(226,195,124,.9); box-shadow: 0 0 8px rgba(226,195,124,.6); }
    .vigor-n { font-size: 12px; color: #9aa3ce; }

    .ajuste { display: flex; gap: 7px; margin-left: auto; padding-bottom: 4px; }
    .ajuste--vigor { padding-bottom: 0; gap: 6px; }
    .paso {
      min-width: 46px; height: 40px; font-family: var(--prosa); font-size: 13px;
      background: transparent; border: 1px solid rgba(185,166,232,.3); color: #d9cdf3; cursor: pointer;
    }
    .paso:disabled { opacity: .4; cursor: not-allowed; }
    .paso--dano { border-color: rgba(231,168,196,.35); background: rgba(231,168,196,.06); color: var(--rosa); }
    .paso--cura { border-color: rgba(159,232,239,.35); background: rgba(159,232,239,.06); color: var(--cian); }
    .paso--min { min-width: 36px; height: 32px; }

    /* ---------------- defensa y ataque ---------------- */
    .defensa { display: grid; grid-template-columns: 1.4fr 1fr 1fr; gap: 10px; }
    .ataque { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
    .stat { position: relative; overflow: hidden; padding: 12px 6px; text-align: center; display: grid; gap: 2px; }
    .stat-t { font-size: 8px; letter-spacing: .22em; text-transform: uppercase; color: var(--tinta-tenue); }
    .stat .cifra { position: relative; font-family: var(--titular); font-size: 25px; line-height: 1.2; color: #f0ecfa; font-variant-numeric: tabular-nums; }
    .stat .nota { font-size: 8px; letter-spacing: .16em; text-transform: uppercase; color: var(--tinta-honda); }
    .stat--grande { padding: 14px 8px; border-color: rgba(159,232,239,.24); background: rgba(159,232,239,.05); }
    .stat--grande .cifra { font-size: 42px; line-height: 1.1; color: #f3eefb; }
    .orbitas { position: absolute; inset: 0; margin: auto; width: 120px; height: 120px; opacity: .35; pointer-events: none; }
    .stat--grande .stat-t { position: relative; }

    /* ---------------- habilidades ---------------- */
    .enlace { border: none; background: transparent; padding: 0; font-family: var(--prosa); font-size: 9px; letter-spacing: .2em; text-transform: uppercase; color: var(--cian); cursor: pointer; }
    .destacadas { list-style: none; margin: 0; padding: 0; display: grid; gap: 9px; }
    .destacadas li { display: flex; align-items: baseline; gap: 9px; }
    .hnombre { font-size: 16px; }
    .hcar { font-size: 8px; letter-spacing: .14em; color: #8b94c0; border: 1px solid rgba(185,166,232,.25); padding: 1px 5px; }
    .htotal { font-size: 17px; font-variant-numeric: tabular-nums; color: #cfe9ee; }
    .htotal.menos { color: var(--rosa); }

    .habs { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 8px; }
    .hab { padding: 10px 14px; }
    .hab-alto { display: flex; align-items: baseline; gap: 9px; }
    .hdesglose { margin: 4px 0 0; font-family: 'IM Fell English', Georgia, serif; font-style: italic; font-size: 12px; letter-spacing: .04em; color: var(--tinta-honda); }

    .buscador, .add-row input {
      padding: 10px 13px; background: rgba(6,8,18,.7); border: 1px solid rgba(185,166,232,.25);
      color: var(--tinta-cielo); font-family: var(--prosa); font-size: 15px;
    }
    .buscador { flex: 0 1 260px; width: auto; }
    .buscador::placeholder, .add-row input::placeholder { color: #5c6690; }

    /* ---------------- bolsa ---------------- */
    .carga-total { font-size: 11px; letter-spacing: .08em; color: var(--oro-luz); }
    .add-row { display: flex; gap: 10px; flex-wrap: wrap; margin: 4px 0 18px; padding: 14px; border: 1px dashed rgba(185,166,232,.28); background: rgba(255,255,255,.02); }
    .add-nombre { flex: 1 1 220px; min-width: 0; width: auto; }
    .add-num { flex: 0 0 92px; width: 92px; }

    .bolsa { list-style: none; margin: 0; padding: 0; display: grid; gap: 8px; }
    .obj { display: flex; align-items: center; gap: 12px; padding: 10px 12px 10px 14px; border-left: 2px solid rgba(185,166,232,.3); }
    .obj--tienda { border-left-color: rgba(159,232,239,.55); }
    .obj-nombre { flex: 1 1 auto; min-width: 0; font-size: 16px; }
    .obj-tienda { font-size: 8px; letter-spacing: .12em; text-transform: uppercase; color: var(--cian); border: 1px solid rgba(159,232,239,.35); padding: 1px 5px; margin-left: 8px; }
    .stepper { display: inline-flex; align-items: center; gap: 3px; flex: 0 0 auto; }
    .stepper button { width: 30px; height: 30px; border: 1px solid rgba(185,166,232,.28); background: transparent; color: #d9cdf3; cursor: pointer; font-size: 15px; line-height: 1; }
    .stepper button:hover { background: rgba(185,166,232,.12); }
    .stepper .cant { min-width: 28px; text-align: center; font-variant-numeric: tabular-nums; }
    .obj-peso { flex: 0 0 140px; text-align: right; font-size: 10px; letter-spacing: .04em; color: #7b85b2; white-space: nowrap; }
    .obj-peso strong { color: var(--tinta-suave); font-weight: 500; }
    .obj-quitar { width: 30px; height: 30px; border: 1px solid rgba(231,168,196,.3); background: transparent; color: var(--rosa); cursor: pointer; }
    .obj-quitar:hover { background: rgba(231,168,196,.1); }

    /* ---------------- acciones ---------------- */
    .acciones { display: flex; gap: 14px; flex-wrap: wrap; align-items: center; margin-top: 22px; }
    .firma { margin-left: auto; font-family: 'IM Fell English', Georgia, serif; font-style: italic; font-size: 13px; color: #5f6893; }

    .estado { font-style: italic; color: var(--tinta-tenue); padding: 24px 0; }
    .estado--breve { padding: 10px 0 0; }
    .estado--mal { color: var(--rosa); font-style: normal; }
    .error { font-size: 13px; color: var(--rosa); margin: 10px 0 0; }
  `,
})
export class FichaCeleste {

  readonly store = inject(FichaStore);
  readonly nivelRomano = romano;

  private readonly nombreInput = viewChild<ElementRef<HTMLInputElement>>('nombreInput');

  constructor() {
    effect(() => {
      if (this.store.itemAnadido() === 0) return;
      this.nombreInput()?.nativeElement.focus();
    });
  }
}
