import { Component, ElementRef, effect, inject, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { ConjurosPanel } from '../spells-panel';
import { DotesPanel } from '../feats-panel';
import { EquipoPanel } from '../gear-panel';
import { FichaEditor } from '../sheet-editor';
import { FichaStore } from '../sheet.store';
import { KgPipe } from '../../../shared/weight.pipe';

/**
 * DISEÑO «MESA ACERO» — el primo frío de «Mesa de noche».
 *
 * La misma idea que la mesa de noche —una sola columna para jugar con el móvil,
 * la franja de combate pegada arriba, todo a la vista sin pestañas— pero con
 * otra piel: acero azulado en vez de madera y lacre, cifras en Cormorant sobre
 * placas metálicas, y el rojo reservado para lo que sangra (el daño, los PG
 * bajos, lo que se puede vender). El vigor son rombos que brillan como brasas.
 *
 * Como todos los diseños, solo trae plantilla y estilos: el estado y la lógica
 * salen enteros de {@link FichaStore}, igual que en el pergamino.
 */
@Component({
  selector: 'arc-ficha-acero',
  imports: [FormsModule, FichaEditor, ConjurosPanel, DotesPanel, EquipoPanel, KgPipe],
  template: `
    <div class="acero">
      <div class="lienzo">
        @if (store.cargando()) {
          <p class="estado">Abriendo la ficha…</p>
        } @else if (store.error(); as e) {
          <p class="estado estado--mal" role="alert">{{ e }}</p>
        } @else if (store.ficha(); as f) {

          <!-- ============ FRANJA DE COMBATE (pegada arriba) ============ -->
          <div class="combate">
            <div class="combate-quien">
              <span class="nombre">{{ f.name }}</span>
              <span class="dato clase">{{ f.clazz }} · nivel {{ f.level }}</span>
            </div>
            <div class="combate-pg">
              <span class="pg" [class]="'pg--' + store.estadoPg()">{{ f.hpCurrent }}</span>
              <span class="dato pg-max">/{{ f.hpMax }}</span>
            </div>
            <div class="combate-pasos">
              <button type="button" class="paso paso--dano" [disabled]="store.ajustandoPg()"
                      (click)="store.ajustarPg(-5)" aria-label="Cinco puntos de daño">−5</button>
              <button type="button" class="paso paso--dano" [disabled]="store.ajustandoPg()"
                      (click)="store.ajustarPg(-1)" aria-label="Un punto de daño">−1</button>
              <button type="button" class="paso paso--cura" [disabled]="store.ajustandoPg()"
                      (click)="store.ajustarPg(1)" aria-label="Curar un punto">+1</button>
              <button type="button" class="paso paso--cura" [disabled]="store.ajustandoPg()"
                      (click)="store.ajustarPg(5)" aria-label="Curar cinco puntos">+5</button>
            </div>
            <div class="barra" role="img" [attr.aria-label]="f.hpCurrent + ' de ' + f.hpMax + ' puntos de golpe'">
              <div class="barra-llena" [class]="'barra-llena--' + store.estadoPg()" [style.width.%]="store.porcentajePg()"></div>
            </div>
          </div>
          @if (store.errorAjuste(); as e) { <p class="error">{{ e }}</p> }

          @if (!store.editando()) {
            <!-- ============ CIFRAS DE TURNO ============ -->
            <section class="bloque">
              <p class="rotulo">En tu turno</p>
              <div class="rejilla rejilla--turno">
                <div class="ficha ficha--ca"><span class="dato">CA</span><span class="cifra">{{ f.acTotal }}</span></div>
                <div class="ficha"><span class="dato">Toque</span><span class="cifra">{{ f.acTouch }}</span></div>
                <div class="ficha"><span class="dato">Desprev.</span><span class="cifra">{{ f.acFlatFooted }}</span></div>
                <div class="ficha"><span class="dato">Inic.</span><span class="cifra">{{ f.initiative >= 0 ? '+' : '' }}{{ f.initiative }}</span></div>
                <div class="ficha"><span class="dato">At. base</span><span class="cifra">{{ f.bab >= 0 ? '+' : '' }}{{ f.bab }}</span></div>
                <div class="ficha"><span class="dato">Presa</span><span class="cifra">{{ f.grapple >= 0 ? '+' : '' }}{{ f.grapple }}</span></div>
                <div class="ficha"><span class="dato">Vel.</span><span class="cifra">{{ f.speed }}</span></div>
                <div class="ficha ficha--salv"><span class="dato">FOR</span><span class="cifra">{{ f.saveFort >= 0 ? '+' : '' }}{{ f.saveFort }}</span></div>
                <div class="ficha ficha--salv"><span class="dato">REF</span><span class="cifra">{{ f.saveRef >= 0 ? '+' : '' }}{{ f.saveRef }}</span></div>
                <div class="ficha ficha--salv"><span class="dato">VOL</span><span class="cifra">{{ f.saveWill >= 0 ? '+' : '' }}{{ f.saveWill }}</span></div>
              </div>

              <div class="vigor">
                <span class="rotulo">Vigor</span>
                <span class="pips">
                  @for (lleno of store.pipsVigor(); track $index) { <span class="pip" [class.lleno]="lleno"></span> }
                </span>
                <span class="dato">{{ f.vigor }} / {{ f.maxVigor }}</span>
                <span class="vigor-pasos">
                  <button type="button" class="paso paso--min" [disabled]="store.ajustandoVigor()"
                          (click)="store.ajustarVigor(-1)" aria-label="Gastar un punto de vigor">−</button>
                  <button type="button" class="paso paso--min" [disabled]="store.ajustandoVigor()"
                          (click)="store.ajustarVigor(1)" aria-label="Recuperar un punto de vigor">+</button>
                </span>
              </div>
            </section>

            <!-- ============ CARACTERÍSTICAS ============ -->
            <section class="bloque">
              <p class="rotulo">Características</p>
              <div class="rejilla rejilla--caracts">
                @for (a of f.abilities; track a.key) {
                  <div class="ficha ficha--caract">
                    <span class="dato">{{ a.key }}</span>
                    <span class="cifra" [class.menos]="a.modifier < 0">{{ a.modifier >= 0 ? '+' : '' }}{{ a.modifier }}</span>
                    <span class="dato punt">{{ a.score }}</span>
                  </div>
                }
              </div>
            </section>

            <!-- ============ HABILIDADES (todas, sin pestaña) ============ -->
            <section class="bloque">
              <div class="alto">
                <p class="rotulo">Habilidades · {{ f.skills.length }}</p>
                <input class="buscador" placeholder="Buscar…" [(ngModel)]="store.busca" />
              </div>
              @if (f.skills.length === 0) {
                <p class="estado estado--breve">Sin habilidades anotadas.</p>
              } @else if (store.habilidadesFiltradas().length === 0) {
                <p class="estado estado--breve">Nada coincide con «{{ store.busca() }}».</p>
              } @else {
                <ul class="habs">
                  @for (s of store.habilidadesFiltradas(); track s.name) {
                    <li class="hab">
                      <span class="htotal" [class.menos]="s.total < 0">{{ s.total >= 0 ? '+' : '' }}{{ s.total }}</span>
                      <span class="hnombre">{{ s.name }}</span>
                      @if (s.keyAbility) { <span class="hcar">{{ s.keyAbility }}</span> }
                      <span class="hdesglose">{{ s.ranks }} rangos@if (s.miscMod) { · {{ s.miscMod >= 0 ? '+' : '' }}{{ s.miscMod }} }</span>
                    </li>
                  }
                </ul>
              }
            </section>

            <!-- ============ BOLSA ============ -->
            <section class="bloque">
              <div class="alto">
                <p class="rotulo">Bolsa</p>
                @if (store.inventario(); as inv) {
                  <span class="dato carga">{{ inv.totalWeight }} lb ({{ inv.totalWeight | kg }}) @if (f.carga) { · {{ f.carga }} }</span>
                }
              </div>

              <div class="add-row">
                <input #nombreInput class="add-nombre" placeholder="Objeto"
                       [(ngModel)]="store.nuevoNombre" (keydown.enter)="store.anadirItem()" />
                <input class="add-num" type="number" min="1" placeholder="Cant."
                       [(ngModel)]="store.nuevaCantidad" (keydown.enter)="store.anadirItem()" />
                <input class="add-num" type="number" min="0" step="0.5" placeholder="Peso"
                       [(ngModel)]="store.nuevoPeso" (keydown.enter)="store.anadirItem()" />
                <button class="btn btn--lacre" [disabled]="!store.nuevoNombre().trim()" (click)="store.anadirItem()">Añadir</button>
              </div>
              @if (store.errorBolsa(); as e) { <p class="error">{{ e }}</p> }

              @if (store.inventario(); as inv) {
                @if (inv.items.length === 0) {
                  <p class="estado estado--breve">La bolsa está vacía.</p>
                } @else {
                  <ul class="bolsa">
                    @for (it of inv.items; track it.id) {
                      <li class="obj" [class.obj--tienda]="it.sellable">
                        <span class="obj-nombre">{{ it.name }}</span>
                        <span class="stepper">
                          <button type="button" (click)="store.ajustar(it, -1)" aria-label="Menos">−</button>
                          <span class="cant">{{ it.quantity }}</span>
                          <button type="button" (click)="store.ajustar(it, 1)" aria-label="Más">+</button>
                        </span>
                        <span class="dato obj-peso">{{ it.lineWeight }} lb ({{ it.lineWeight | kg }})</span>
                        <button type="button" class="obj-quitar" (click)="store.eliminar(it)" aria-label="Quitar">✕</button>
                      </li>
                    }
                  </ul>
                }
              }
            </section>

            <!-- ============ CONJUROS PREPARADOS ============ -->
            <section class="bloque">
              <div class="alto">
                <p class="rotulo">Conjuros preparados</p>
                <span class="dato">{{ store.totalPreparados() }}</span>
              </div>
              <arc-conjuros-panel />
            </section>

            <!-- ============ EQUIPO PUESTO ============ -->
            <section class="bloque">
              <p class="rotulo">Equipo</p>
              <arc-equipo-panel />
            </section>

            <!-- ============ DOTES ============ -->
            <section class="bloque">
              <p class="rotulo">Dotes</p>
              <arc-dotes-panel />
            </section>

            <!-- ============ MONEDERO Y FILIACIÓN ============ -->
            <section class="bloque">
              <p class="rotulo">Monedero</p>
              <div class="rejilla rejilla--monedas">
                <div class="ficha ficha--oro"><span class="dato">oro</span><span class="cifra">{{ store.monedas().po }}</span></div>
                <div class="ficha"><span class="dato">plata</span><span class="cifra">{{ store.monedas().pp }}</span></div>
                <div class="ficha ficha--cobre"><span class="dato">cobre</span><span class="cifra">{{ store.monedas().pc }}</span></div>
              </div>

              <p class="rotulo rotulo--siguiente">Quién es</p>
              <p class="filiacion">
                @if (f.race) { <span>{{ f.race }}</span> }
                @if (f.alignment) { <span>{{ f.alignment }}</span> }
                @if (f.deity) { <span>devoto de {{ f.deity }}</span> }
                @if (f.size) { <span>tamaño {{ f.size }}</span> }
                @if (f.age) { <span>{{ f.age }}</span> }
                @if (f.location) { <span>{{ f.location }}</span> }
                @if (f.campaign) { <span>{{ f.campaign }}</span> }
                @if (f.player) { <span>jugador: {{ f.player }}</span> }
              </p>
              <ul class="lineas">
                <li><span class="dato">Carga</span><span>{{ f.carga || '—' }}</span></li>
                <li><span class="dato">Reducción de daño</span><span>{{ f.damageReduction || '—' }}</span></li>
                <li><span class="dato">Resist. a conjuros</span><span>{{ f.spellResistance || '—' }}</span></li>
              </ul>
            </section>

            <div class="acciones">
              <button class="btn btn--lacre" (click)="store.editar()">Editar ficha</button>
              <button class="btn" (click)="store.alTablon(f.id)">Tablón</button>
              <button class="btn" (click)="store.alaTienda(f.id)">Tienda</button>
            </div>
          } @else {
            <arc-ficha-editor />
          }
        }
      </div>
    </div>
  `,
  styles: `
    /* ================= PALETA ACERO ================= *
     * Todo el color vive aquí como valores literales: es un tema oscuro propio,
     * distinto del pergamino de la app, y no debe heredar sus variables.        */
    :host {
      /* Serif para las cifras (Cormorant), mono para lo demás (JetBrains); con
         las de la app de reserva por si las Google Fonts no cargaran. */
      --acero-serif: 'Cormorant Garamond', 'EB Garamond', Georgia, serif;
      --acero-mono: 'JetBrains Mono', 'IBM Plex Mono', ui-monospace, monospace;

      --acero-tinta: #d7d4cc;    /* texto normal */
      --acero-claro: #f2efe8;    /* cifras y nombres */
      --acero-tenue: #8b938f;    /* secundario */
      --acero-humo:  #667074;    /* etiquetas, unidades */
      --acero-linea: #46535a;    /* borde fuerte */
      --acero-veta:  #2c353a;    /* borde suave */
      --acero-fondo: #0f1417;    /* hueco de campos y barras */
      --acero-rojo:  #bd3a3a;    /* daño, PG bajos, vender */
      --acero-rojo-hondo: #8e1c21;
      --acero-verde: #7d9a73;    /* curar, éxito */
      --acero-oro:   #a1906a;    /* oro, carga */
      --acero-cobre: #a2705c;    /* cobre */
      --placa: linear-gradient(180deg, #1b2226, #14191c);
      --placa-alta: linear-gradient(180deg, #252d32, #171d21);
      --relieve: 0 0 0 1px var(--acero-veta), 0 1px 0 rgba(255,255,255,.04) inset;

      display: block;
      min-height: 100vh;
      color: var(--acero-tinta);
      font-family: var(--acero-mono);
      background:
        radial-gradient(120% 60% at 50% 0%, #182024 0%, transparent 70%),
        repeating-linear-gradient(90deg, rgba(255,255,255,.012) 0 1px, transparent 1px 3px),
        #0b0e10;
    }
    .lienzo { max-width: 620px; margin: 0 auto; padding: 0 16px 56px; }

    /* ---------------- rótulos de sección ---------------- */
    .rotulo {
      font-family: var(--acero-mono); font-size: 9px; letter-spacing: .28em;
      text-transform: uppercase; color: var(--acero-humo);
      margin: 0; padding-bottom: 6px; border-bottom: 1px solid var(--acero-veta);
    }
    .rotulo--siguiente { margin-top: 22px; }
    .dato { font-family: var(--acero-mono); font-size: 10px; letter-spacing: .14em; color: var(--acero-tenue); }

    /* ---------------- franja de combate ---------------- */
    .combate {
      position: sticky; top: 44px; z-index: 5;
      display: grid; grid-template-columns: 1fr auto; gap: 8px 14px; align-items: center;
      margin: 16px 0 22px; padding: 14px 16px 16px;
      background:
        linear-gradient(180deg, rgba(255,255,255,.045), transparent 38%),
        linear-gradient(180deg, #1b2226, #0f1417);
      border: 1px solid var(--acero-linea); border-top: 2px solid var(--acero-linea);
      box-shadow: 0 1px 0 rgba(255,255,255,.05) inset, 0 18px 34px -22px #000;
    }
    .combate-quien { display: grid; gap: 2px; min-width: 0; }
    .nombre {
      font-family: var(--acero-serif); font-weight: 600; font-size: 26px; line-height: 1.05;
      letter-spacing: .02em; text-transform: uppercase; color: var(--acero-claro);
    }
    .clase { color: var(--acero-tenue); }
    .combate-pg { display: flex; align-items: baseline; gap: 5px; justify-self: end; }
    .pg {
      font-family: var(--acero-serif); font-weight: 600; font-size: 50px; line-height: .85;
      font-variant-numeric: tabular-nums; color: var(--acero-verde);
    }
    .pg--medio { color: var(--acero-oro); }
    .pg--mal { color: var(--acero-rojo); text-shadow: 0 0 26px rgba(189,58,58,.45); }
    .pg-max { color: var(--acero-humo); }

    .combate-pasos { grid-column: 1 / -1; display: flex; gap: 1px; }
    .combate-pasos .paso { flex: 1 1 0; }
    .barra { grid-column: 1 / -1; height: 6px; background: var(--acero-fondo); border: 1px solid var(--acero-veta); overflow: hidden; }
    .barra-llena { height: 100%; background: linear-gradient(180deg, var(--acero-verde), #566b4e); transition: width .25s ease; }
    .barra-llena--medio { background: linear-gradient(180deg, var(--acero-oro), #6f6242); }
    .barra-llena--mal { background: linear-gradient(180deg, var(--acero-rojo), var(--acero-rojo-hondo)); }

    /* Botones-paso: placa de acero, texto rojo si resta, verde si suma. */
    .paso {
      min-height: 44px; padding: 0 12px; cursor: pointer;
      font-family: var(--acero-mono); font-size: 12px; letter-spacing: .12em;
      border: 1px solid var(--acero-linea); background: var(--placa-alta); color: var(--acero-tinta);
    }
    .paso:hover:not(:disabled) { background: linear-gradient(180deg, #2c363b, #1c2327); }
    .paso:disabled { opacity: .5; cursor: default; }
    .paso--dano { color: var(--acero-rojo); }
    .paso--dano:hover:not(:disabled) { border-color: var(--acero-rojo-hondo); }
    .paso--cura { color: var(--acero-verde); }
    .paso--min { min-height: 32px; padding: 0 14px; font-size: 15px; }

    /* ---------------- bloques y rejillas ---------------- */
    .bloque { margin-bottom: 26px; }
    .alto { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
    .carga { color: var(--acero-oro); }

    .rejilla { display: grid; gap: 1px; margin-top: 12px; }
    .rejilla--turno { grid-template-columns: repeat(auto-fit, minmax(84px, 1fr)); }
    .rejilla--caracts { grid-template-columns: repeat(auto-fit, minmax(84px, 1fr)); }
    .rejilla--monedas { grid-template-columns: repeat(3, 1fr); }

    /* Cada dato es una placa remachada, no una casilla. */
    .ficha { display: grid; gap: 3px; justify-items: center; padding: 12px 6px; background: var(--placa); box-shadow: var(--relieve); }
    .ficha .dato { font-size: 8px; letter-spacing: .2em; text-transform: uppercase; color: var(--acero-humo); }
    .ficha .cifra { font-family: var(--acero-serif); font-weight: 600; font-size: 30px; line-height: 1; color: var(--acero-claro); font-variant-numeric: tabular-nums; }
    .ficha .cifra.menos { color: var(--acero-rojo); }
    .ficha--ca { background: var(--placa-alta); }
    .ficha--ca .cifra { font-size: 38px; }
    /* Las salvaciones llevan una veta roja abajo: son lo que te salva la vida. */
    .ficha--salv { box-shadow: var(--relieve), 0 -2px 0 var(--acero-rojo-hondo) inset; }
    .ficha--caract .punt { color: var(--acero-humo); }
    .ficha--oro .cifra { color: var(--acero-oro); }
    .ficha--cobre .cifra { color: var(--acero-cobre); }

    /* ---------------- vigor (brasas en rombo) ---------------- */
    .vigor { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--acero-veta); }
    .vigor .dato { color: var(--acero-tenue); }
    .pips { display: flex; gap: 6px; }
    .pip { width: 12px; height: 12px; border: 1px solid var(--acero-linea); background: var(--acero-fondo); transform: rotate(45deg); }
    .pip.lleno { border-color: var(--acero-rojo); background: var(--acero-rojo-hondo); box-shadow: 0 0 10px rgba(189,58,58,.35); }
    .vigor-pasos { display: flex; gap: 1px; margin-left: auto; }

    /* ---------------- habilidades ---------------- */
    .buscador {
      flex: 0 1 180px; width: auto; padding: 9px 10px; margin-bottom: 6px;
      background: var(--acero-fondo); border: 1px solid var(--acero-linea); color: var(--acero-tinta);
      font-family: var(--acero-mono); font-size: 12px; letter-spacing: .08em;
    }
    .buscador::placeholder { color: var(--acero-humo); }

    .habs { list-style: none; margin: 12px 0 0; padding: 0; display: grid; gap: 0; }
    .hab { display: flex; align-items: baseline; gap: 10px; padding: 9px 10px; border-bottom: 1px solid rgba(44,53,58,.6); }
    .hab:nth-child(odd) { background: rgba(255,255,255,.018); }
    .htotal { flex: 0 0 48px; font-size: 16px; text-align: right; color: var(--acero-claro); font-variant-numeric: tabular-nums; }
    .htotal.menos { color: var(--acero-rojo); }
    .hnombre { color: var(--acero-tinta); }
    .hcar { font-family: var(--acero-mono); font-size: 8px; letter-spacing: .14em; color: var(--acero-humo); border: 1px solid var(--acero-veta); padding: 1px 5px; }
    .hdesglose { margin-left: auto; font-family: var(--acero-mono); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--acero-humo); white-space: nowrap; }

    /* ---------------- bolsa ---------------- */
    .add-row { display: flex; gap: 6px; flex-wrap: wrap; margin: 12px 0 14px; }
    .add-row input {
      background: var(--acero-fondo); border: 1px solid var(--acero-linea); color: var(--acero-tinta);
      padding: 9px 10px; font-family: var(--acero-mono); font-size: 12px;
    }
    .add-row input::placeholder { color: var(--acero-humo); }
    .add-nombre { flex: 1 1 160px; min-width: 0; width: auto; }
    .add-num { flex: 0 0 76px; width: 76px; }

    .bolsa { list-style: none; margin: 0; padding: 0; display: grid; gap: 0; }
    .obj { display: flex; align-items: center; gap: 10px; padding: 8px 10px; border-left: 2px solid var(--acero-linea); border-bottom: 1px solid rgba(44,53,58,.6); }
    .obj:nth-child(odd) { background: rgba(255,255,255,.018); }
    .obj--tienda { border-left-color: var(--acero-rojo-hondo); }
    .obj-nombre { flex: 1 1 auto; min-width: 0; color: var(--acero-tinta); }
    .stepper { display: inline-flex; align-items: center; gap: 1px; flex: 0 0 auto; }
    .stepper button { width: 32px; height: 32px; border: 1px solid var(--acero-linea); background: var(--placa-alta); color: var(--acero-tinta); font-size: 16px; line-height: 1; cursor: pointer; }
    .stepper button:hover { background: linear-gradient(180deg, #2c363b, #1c2327); }
    .stepper .cant { min-width: 28px; text-align: center; font-variant-numeric: tabular-nums; color: var(--acero-claro); }
    .obj-peso { flex: 0 0 118px; text-align: right; color: var(--acero-humo); white-space: nowrap; }
    .obj-quitar { flex: 0 0 auto; width: 30px; height: 30px; border: 1px solid var(--acero-veta); background: transparent; color: var(--acero-rojo); cursor: pointer; }
    .obj-quitar:hover { border-color: var(--acero-rojo-hondo); background: rgba(142,28,33,.16); }

    /* ---------------- filiación y líneas ---------------- */
    .filiacion { display: flex; flex-wrap: wrap; gap: 6px; margin: 12px 0 0; }
    .filiacion span {
      font-family: var(--acero-mono); font-size: 9px; letter-spacing: .14em; text-transform: uppercase;
      color: var(--acero-tenue); border: 1px solid var(--acero-veta); padding: 4px 8px; background: rgba(255,255,255,.02);
    }
    .lineas { list-style: none; margin: 14px 0 0; padding: 0; display: grid; gap: 0; }
    .lineas li { display: flex; justify-content: space-between; gap: 12px; padding: 9px 0; border-top: 1px solid var(--acero-veta); color: var(--acero-tinta); }
    .lineas .dato { color: var(--acero-humo); letter-spacing: .18em; text-transform: uppercase; font-size: 9px; }

    /* ---------------- botones de pie ---------------- */
    .acciones { display: flex; gap: 1px; flex-wrap: wrap; margin-top: 24px; }
    .btn {
      flex: 1 1 auto; min-height: 46px; padding: 0 18px; cursor: pointer;
      font-family: var(--acero-mono); font-size: 11px; letter-spacing: .2em; text-transform: uppercase;
      border: 1px solid var(--acero-linea); background: var(--placa-alta); color: var(--acero-tenue);
    }
    .btn:hover:not(:disabled) { background: linear-gradient(180deg, #2c363b, #1c2327); color: var(--acero-claro); }
    .btn:disabled { opacity: .5; cursor: default; }
    .btn--lacre {
      border-color: var(--acero-rojo-hondo); color: var(--acero-claro);
      background: linear-gradient(180deg, #5c1418, #330c0f);
    }
    .btn--lacre:hover:not(:disabled) { background: linear-gradient(180deg, #7a181d, #450f13); border-color: var(--acero-rojo); color: var(--acero-claro); }

    /* ---------------- estados ---------------- */
    .estado { font-style: italic; color: var(--acero-tenue); padding: 24px 0; }
    .estado--breve { padding: 10px 0 0; }
    .estado--mal { color: var(--acero-rojo); font-style: normal; }
    .error { font-size: 13px; color: var(--acero-rojo); margin: 0 0 10px; }
  `,
})
export class FichaAcero {

  readonly store = inject(FichaStore);

  private readonly nombreInput = viewChild<ElementRef<HTMLInputElement>>('nombreInput');

  constructor() {
    effect(() => {
      if (this.store.itemAnadido() === 0) return;
      this.nombreInput()?.nativeElement.focus();
    });
  }
}
