import { Component, ElementRef, effect, inject, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { ConjurosPanel } from '../conjuros-panel';
import { FichaEditor } from '../ficha-editor';
import { FichaStore } from '../ficha.store';
import { KgPipe } from '../../../shared/peso.pipe';

/**
 * DISEÑO «MESA DE NOCHE» — alternativa al pergamino.
 *
 * Pensado para jugar con el móvil en la mano y la partida en marcha: una sola
 * columna sobre el fondo oscuro de la mesa, sin pestañas (todo está en el mismo
 * scroll) y con una franja pegada arriba que lleva siempre los PG y los botones
 * de daño, que es lo único que se toca cada turno. Las cifras van grandes y
 * claras; el papel se queda para leer la ficha con calma.
 *
 * Mismo estado, misma lógica: solo cambia el HTML y el CSS.
 */
@Component({
  selector: 'arc-ficha-mesa',
  imports: [FormsModule, FichaEditor, ConjurosPanel, KgPipe],
  template: `
    <div class="contenedor contenedor--mesa">
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
              <button class="boton boton--lacre" [disabled]="!store.nuevoNombre().trim()" (click)="store.anadirItem()">Añadir</button>
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

          <!-- ============ QUIÉN ES Y QUÉ LLEVA ENCIMA ============ -->
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
            <button class="boton boton--lacre" (click)="store.editar()">Editar ficha</button>
            <button class="boton" (click)="store.alTablon(f.id)">Tablón</button>
            <button class="boton" (click)="store.alaTienda(f.id)">Tienda</button>
          </div>
        } @else {
          <arc-ficha-editor />
        }
      }
    </div>
  `,
  styles: `
    /* Una columna estrecha: se lee de arriba abajo con el pulgar. */
    .contenedor--mesa { max-width: 620px; padding-top: 0; }

    /* ---------------- franja de combate ---------------- */
    .combate {
      position: sticky; top: 44px; z-index: 5;
      display: grid; grid-template-columns: 1fr auto; gap: 6px 12px; align-items: center;
      margin: 14px 0 18px; padding: 12px 14px 14px;
      background: rgba(23,18,8,.94); backdrop-filter: blur(6px);
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
    }
    .combate-quien { display: grid; min-width: 0; }
    .nombre { font-family: var(--display); font-size: 22px; line-height: 1.1; color: var(--pergamino); }
    .clase { color: var(--sepia-claro); }
    .combate-pg { display: flex; align-items: baseline; gap: 4px; justify-self: end; }
    .pg { font-family: var(--display); font-size: 44px; line-height: .9; font-variant-numeric: tabular-nums; color: var(--musgo); }
    .pg--medio { color: var(--oro); } .pg--mal { color: var(--vino); }
    .pg-max { color: var(--sepia); }
    .combate-pasos { grid-column: 1 / -1; display: flex; gap: 6px; }
    .combate-pasos .paso { flex: 1 1 0; }

    .barra { grid-column: 1 / -1; height: 4px; background: rgba(239,228,205,.12); border-radius: var(--radio); overflow: hidden; }
    .barra-llena { height: 100%; background: var(--musgo); transition: width .25s ease; }
    .barra-llena--medio { background: var(--oro); } .barra-llena--mal { background: var(--vino); }

    .paso {
      min-height: 40px; padding: 0 12px; font-family: var(--dato); font-size: 12px;
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
      background: rgba(239,228,205,.04); color: var(--pergamino);
    }
    .paso:hover:not(:disabled) { background: rgba(239,228,205,.1); }
    .paso--dano { color: #d98a7c; }
    .paso--cura { color: #8fae70; }
    .paso--min { min-height: 30px; padding: 0 12px; font-size: 15px; }

    /* ---------------- bloques ---------------- */
    .bloque { margin-bottom: 18px; }
    .alto { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
    .rotulo--siguiente { margin-top: 18px; }
    .carga { color: var(--oro); }

    /* Las fichas son piezas sobre la mesa, no casillas de papel. */
    .rejilla { display: grid; gap: 6px; margin-top: 10px; }
    .rejilla--turno { grid-template-columns: repeat(auto-fit, minmax(84px, 1fr)); }
    .rejilla--caracts { grid-template-columns: repeat(auto-fit, minmax(84px, 1fr)); }
    .rejilla--monedas { grid-template-columns: repeat(3, 1fr); }

    .ficha {
      display: grid; gap: 2px; justify-items: center; padding: 10px 6px;
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
      background: rgba(239,228,205,.045);
    }
    .ficha .dato { font-size: 8px; letter-spacing: .16em; text-transform: uppercase; color: var(--sepia-claro); }
    .ficha .cifra { font-family: var(--display); font-size: 26px; line-height: 1.1; color: var(--pergamino); font-variant-numeric: tabular-nums; }
    .ficha .cifra.menos { color: #d98a7c; }
    .ficha--ca { background: rgba(239,228,205,.1); }
    .ficha--ca .cifra { font-size: 34px; }
    .ficha--salv { border-color: rgba(157,122,47,.35); }
    .ficha--caract .punt { color: var(--sepia); }
    .ficha--oro .cifra { color: #c69a3d; }
    .ficha--cobre .cifra { color: #c2705f; }

    /* ---------------- vigor ---------------- */
    .vigor { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-top: 12px; padding-top: 12px; border-top: 1px dashed var(--linea-noche); }
    .vigor .dato { color: var(--sepia-claro); }
    .pips { display: flex; gap: 4px; }
    .pip { width: 12px; height: 12px; border-radius: 50%; border: 1px solid rgba(157,122,47,.7); }
    .pip.lleno { background: var(--oro); }
    .vigor-pasos { display: flex; gap: 6px; margin-left: auto; }

    /* ---------------- habilidades ---------------- */
    .buscador { flex: 0 1 180px; width: auto; padding: 8px 10px; background: rgba(239,228,205,.06); border-color: var(--linea-noche); color: var(--pergamino); }
    .buscador::placeholder { color: var(--sepia); }

    .habs { list-style: none; margin: 10px 0 0; padding: 0; display: grid; gap: 2px; }
    .hab { display: flex; align-items: baseline; gap: 8px; padding: 7px 10px; border-radius: var(--radio); }
    .hab:nth-child(odd) { background: rgba(239,228,205,.04); }
    .htotal { flex: 0 0 46px; font-family: var(--dato); font-size: 16px; text-align: right; color: #8fae70; font-variant-numeric: tabular-nums; }
    .htotal.menos { color: #d98a7c; }
    .hnombre { color: var(--pergamino); }
    .hcar { font-family: var(--dato); font-size: 8px; letter-spacing: .1em; color: var(--sepia); border: 1px solid var(--linea-noche); border-radius: var(--radio); padding: 0 4px; }
    .hdesglose { margin-left: auto; font-family: var(--dato); font-size: 9px; letter-spacing: .06em; text-transform: uppercase; color: var(--sepia); white-space: nowrap; }

    /* ---------------- bolsa ---------------- */
    .add-row { display: flex; gap: 6px; flex-wrap: wrap; margin: 10px 0 12px; }
    .add-row input { background: rgba(239,228,205,.06); border-color: var(--linea-noche); color: var(--pergamino); }
    .add-row input::placeholder { color: var(--sepia); }
    .add-nombre { flex: 1 1 160px; min-width: 0; width: auto; }
    .add-num { flex: 0 0 76px; width: 76px; font-family: var(--dato); }
    .add-row .boton { flex: 0 0 auto; }

    .bolsa { list-style: none; margin: 0; padding: 0; display: grid; gap: 2px; }
    .obj { display: flex; align-items: center; gap: 10px; padding: 7px 10px; border-left: 2px solid var(--linea-noche); border-radius: var(--radio); }
    .obj:nth-child(odd) { background: rgba(239,228,205,.04); }
    .obj--tienda { border-left-color: var(--musgo); }
    .obj-nombre { flex: 1 1 auto; min-width: 0; color: var(--pergamino); }
    .stepper { display: inline-flex; align-items: center; gap: 2px; flex: 0 0 auto; }
    .stepper button { width: 30px; height: 30px; border: 1px solid var(--linea-noche); background: rgba(239,228,205,.04); color: var(--pergamino); border-radius: var(--radio); font-size: 16px; line-height: 1; }
    .stepper button:hover { background: rgba(239,228,205,.1); }
    .stepper .cant { min-width: 26px; text-align: center; font-family: var(--dato); font-variant-numeric: tabular-nums; color: var(--pergamino); }
    .obj-peso { flex: 0 0 118px; text-align: right; color: var(--sepia); white-space: nowrap; }
    .obj-quitar { flex: 0 0 auto; width: 28px; height: 28px; border: 1px solid rgba(143,46,34,.4); background: transparent; color: #d98a7c; border-radius: var(--radio); }

    /* ---------------- filiación y líneas ---------------- */
    .filiacion { display: flex; flex-wrap: wrap; gap: 6px; margin: 10px 0 0; }
    .filiacion span {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia-claro); border: 1px solid var(--linea-noche); border-radius: var(--radio); padding: 3px 7px;
    }
    .lineas { list-style: none; margin: 12px 0 0; padding: 0; display: grid; gap: 0; }
    .lineas li { display: flex; justify-content: space-between; gap: 12px; padding: 7px 0; border-top: 1px dashed var(--linea-noche); color: var(--pergamino); }
    .lineas .dato { color: var(--sepia); letter-spacing: .12em; text-transform: uppercase; font-size: 9px; }

    .acciones { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 18px; }
    .acciones .boton { border-color: var(--linea-noche); color: var(--sepia-claro); }
    .acciones .boton:hover:not(:disabled) { background: rgba(239,228,205,.06); color: var(--pergamino); }
    .acciones .boton--lacre { color: var(--pergamino-claro); border-color: var(--vino); }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
    .estado--breve { padding: 10px 0 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
    .error { font-size: 13px; color: #d98a7c; margin: 0 0 10px; }
  `,
})
export class FichaMesa {

  readonly store = inject(FichaStore);

  private readonly nombreInput = viewChild<ElementRef<HTMLInputElement>>('nombreInput');

  constructor() {
    effect(() => {
      if (this.store.itemAnadido() === 0) return;
      this.nombreInput()?.nativeElement.focus();
    });
  }
}
