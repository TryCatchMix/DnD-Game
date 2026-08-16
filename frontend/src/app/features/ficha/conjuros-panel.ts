import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { FichaStore } from './ficha.store';

/**
 * La lista de conjuros preparados y, si el personaje es clérigo, sus dominios.
 *
 * En D&D 3.5 los conjuros se preparan ANTES de aventurarse, así que esto es lo
 * que se rellena en casa y se consulta en la mesa: los conjuros agrupados por
 * nivel, con cuántas veces se llevan preparados y su bloque de estadísticas
 * desplegable (CD, alcance, duración…).
 *
 * Va aparte de los diseños por lo mismo que `FichaEditor`: es mucho HTML y
 * duplicarlo tres veces solo para cambiar colores no compensa. El estado vive
 * entero en `FichaStore`.
 */
@Component({
  selector: 'arc-conjuros-panel',
  imports: [FormsModule],
  template: `
    <!-- ============ PREPARAR: buscador contra el grimorio ============ -->
    <div class="preparar">
      <input class="buscar" placeholder="Buscar un conjuro para preparar…"
             [(ngModel)]="store.buscaConjuro" (ngModelChange)="store.buscarConjuro()" />
      @if (store.buscandoConjuro()) { <span class="buscando">buscando…</span> }
    </div>

    @if (store.resultados().length > 0) {
      <ul class="resultados">
        @for (s of store.resultados(); track s.name) {
          <li>
            <button type="button" class="res" (click)="store.preparar(s.name)">
              <span class="res-nombre">{{ s.name }}</span>
              <span class="res-meta">
                @for (c of s.classes; track c.clazz) { <span class="res-clase">{{ c.clazz }} {{ c.level }}</span> }
              </span>
              <span class="res-mas">+ preparar</span>
            </button>
          </li>
        }
      </ul>
    } @else if (store.buscaConjuro().trim().length >= 2 && !store.buscandoConjuro()) {
      <p class="estado">Ningún conjuro con ese nombre.</p>
    }

    @if (store.errorConjuros(); as e) { <p class="error-conj" role="alert">{{ e }}</p> }

    <!-- ============ LA LISTA PREPARADA, POR NIVEL ============ -->
    @if (store.conjuros().length === 0) {
      <p class="estado">No llevas ningún conjuro preparado. Búscalos arriba y prepáralos
        antes de salir de aventura.</p>
    } @else {
      @for (grupo of store.conjurosPorNivel(); track grupo.nivel) {
        <div class="nivel">
          <p class="nivel-tit">
            {{ grupo.nivel === 0 ? 'Trucos (nivel 0)' : 'Nivel ' + grupo.nivel }}
            <span class="nivel-cuenta">{{ grupo.items.length }}</span>
          </p>
          <ul class="conjuros">
            @for (c of grupo.items; track c.id) {
              <li class="conj">
                <div class="conj-fila">
                  <button type="button" class="conj-nombre" (click)="store.alternarConjuro(c.spell.name)">
                    {{ c.spell.name }}
                    @if (c.spell.school) { <span class="conj-escuela">{{ c.spell.school }}</span> }
                  </button>
                  <span class="stepper">
                    <button type="button" (click)="store.ajustarConjuro(c, -1)" aria-label="Menos">−</button>
                    <span class="cant">×{{ c.prepared }}</span>
                    <button type="button" (click)="store.ajustarConjuro(c, 1)" aria-label="Más">+</button>
                  </span>
                  <button type="button" class="conj-quitar" (click)="store.quitarConjuro(c)" aria-label="Quitar">✕</button>
                </div>

                <!-- El bloque de estadísticas, plegado hasta que hace falta -->
                @if (store.conjuroAbierto() === c.spell.name) {
                  <dl class="stat">
                    @if (c.spell.castingTime) { <div><dt>Tiempo</dt><dd>{{ c.spell.castingTime }}</dd></div> }
                    @if (c.spell.range) { <div><dt>Alcance</dt><dd>{{ c.spell.range }}</dd></div> }
                    @if (c.spell.target) { <div><dt>{{ c.spell.targetKind || 'Objetivo' }}</dt><dd>{{ c.spell.target }}</dd></div> }
                    @if (c.spell.duration) { <div><dt>Duración</dt><dd>{{ c.spell.duration }}</dd></div> }
                    @if (c.spell.components) { <div><dt>Componentes</dt><dd>{{ c.spell.components }}</dd></div> }
                    @if (c.spell.savingThrow) { <div><dt>Salvación</dt><dd>{{ c.spell.savingThrow }}</dd></div> }
                    @if (c.spell.spellResistance) { <div><dt>RC</dt><dd>{{ c.spell.spellResistance }}</dd></div> }
                    @if (c.spell.damageSummary) { <div><dt>Daño</dt><dd>{{ c.spell.damageSummary }}</dd></div> }
                    @for (cl of c.spell.classes; track cl.clazz) {
                      @if (cl.saveDcFormula) {
                        <div><dt>CD ({{ cl.clazz }})</dt><dd>{{ cl.saveDcFormula }}</dd></div>
                      }
                    }
                  </dl>
                  @if (c.spell.description) { <p class="conj-desc">{{ c.spell.description }}</p> }
                }
              </li>
            }
          </ul>
        </div>
      }
    }

    <!-- ============ DOMINIOS (solo clérigo) ============ -->
    @if (store.esClerigo()) {
      <div class="dominios">
        <p class="nivel-tit">Dominios</p>
        @if (store.misDominios().length === 0) {
          <p class="estado">Sin dominios elegidos. Edita la ficha para escoger los dos
            que te otorga tu deidad.</p>
        } @else {
          @for (d of store.misDominios(); track d.code) {
            <div class="dominio">
              <p class="dom-nombre">{{ d.nombre }}</p>
              <p class="dom-poder"><span class="dom-etiq">Poder otorgado</span> {{ d.poder }}</p>
              <ul class="dom-conjuros">
                @for (s of d.spells; track s.level) {
                  <li [class.fuera]="!s.inGrimoire">
                    <span class="dom-niv">{{ s.level }}</span>
                    <span class="dom-conj">{{ s.name }}</span>
                    @if (!s.inGrimoire) { <span class="dom-nota" title="No está en el grimorio">solo referencia</span> }
                  </li>
                }
              </ul>
            </div>
          }
        }
      </div>
    }
  `,
  styles: `
    .preparar { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
    .preparar .buscar { flex: 1 1 auto; min-width: 0; }
    .buscando { font-family: var(--dato); font-size: 10px; letter-spacing: .08em; color: var(--sepia); }

    .resultados { list-style: none; margin: 0 0 14px; padding: 0; display: grid; gap: 4px; }
    .res { display: flex; align-items: baseline; gap: 10px; width: 100%; text-align: left;
           padding: 8px 10px; border: 1px solid var(--linea); border-radius: var(--radio);
           background: transparent; color: inherit; font: inherit; cursor: pointer; }
    .res:hover { border-color: var(--oro); }
    .res-nombre { flex: 1 1 auto; }
    .res-meta { display: flex; gap: 6px; flex-wrap: wrap; }
    .res-clase { font-family: var(--dato); font-size: 9px; letter-spacing: .08em; text-transform: uppercase; color: var(--sepia); }
    .res-mas { font-family: var(--dato); font-size: 9px; letter-spacing: .08em; text-transform: uppercase; color: var(--oro); }

    .nivel { margin-top: 16px; }
    .nivel-tit { display: flex; align-items: baseline; gap: 8px; margin: 0 0 8px;
                 font-family: var(--dato); font-size: 10px; letter-spacing: .14em;
                 text-transform: uppercase; color: var(--sepia); }
    .nivel-cuenta { border: 1px solid var(--linea); border-radius: var(--radio); padding: 0 5px; }

    .conjuros { list-style: none; margin: 0; padding: 0; display: grid; gap: 4px; }
    .conj { border-top: 1px dashed var(--linea); padding: 6px 0; }
    .conj-fila { display: flex; align-items: center; gap: 10px; }
    .conj-nombre { flex: 1 1 auto; min-width: 0; text-align: left; background: transparent;
                   border: 0; padding: 0; font: inherit; color: inherit; cursor: pointer; }
    .conj-nombre:hover { color: var(--oro); }
    .conj-escuela { margin-left: 8px; font-family: var(--dato); font-size: 9px;
                    letter-spacing: .08em; text-transform: uppercase; color: var(--sepia); }
    .stepper { display: flex; align-items: center; gap: 4px; flex: 0 0 auto; }
    .stepper button { width: 26px; height: 26px; border: 1px solid var(--linea-fuerte);
                      background: transparent; color: inherit; border-radius: var(--radio); cursor: pointer; }
    .cant { min-width: 30px; text-align: center; font-family: var(--dato); font-size: 11px; }
    .conj-quitar { flex: 0 0 auto; width: 26px; height: 26px; border: 1px solid rgba(143,46,34,.4);
                   background: transparent; color: var(--vino); border-radius: var(--radio); cursor: pointer; }

    .stat { display: grid; grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 4px 14px; margin: 8px 0 0; padding: 8px 0 0; border-top: 1px dotted var(--linea); }
    .stat div { display: flex; gap: 6px; }
    .stat dt { flex: 0 0 auto; font-family: var(--dato); font-size: 9px; letter-spacing: .08em;
               text-transform: uppercase; color: var(--sepia); }
    .stat dd { margin: 0; font-size: 13px; }
    .conj-desc { margin: 8px 0 0; font-size: 13px; line-height: 1.5; color: var(--tinta); }

    .dominios { margin-top: 24px; padding-top: 12px; border-top: 2px solid var(--oro); }
    .dominio { margin-bottom: 16px; }
    .dom-nombre { margin: 0 0 4px; font-family: var(--titular, var(--display)); font-size: 17px; }
    .dom-poder { margin: 0 0 8px; font-size: 13px; line-height: 1.5; }
    .dom-etiq { display: inline-block; margin-right: 6px; font-family: var(--dato); font-size: 9px;
                letter-spacing: .1em; text-transform: uppercase; color: var(--oro); }
    .dom-conjuros { list-style: none; margin: 0; padding: 0; display: grid; gap: 2px; }
    .dom-conjuros li { display: flex; align-items: baseline; gap: 8px; font-size: 13px; }
    .dom-conjuros li.fuera { color: var(--sepia); }
    .dom-niv { flex: 0 0 auto; width: 18px; text-align: right; font-family: var(--dato);
               font-size: 10px; color: var(--sepia); }
    .dom-nota { font-family: var(--dato); font-size: 9px; letter-spacing: .06em;
                text-transform: uppercase; color: var(--sepia); }

    .estado { font-style: italic; color: var(--sepia); margin: 10px 0; }
    .error-conj { font-size: 14px; border-left: 2px solid var(--vino); padding: 6px 10px;
                  margin: 10px 0; color: var(--vino); }
  `,
})
export class ConjurosPanel {
  readonly store = inject(FichaStore);
}
