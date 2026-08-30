import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { Enemigo, EnemigoRequest } from '../../core/table.types';
import { JuegoService } from '../../core/game.service';
import { MesaService } from '../../core/table.service';
import { MonsterRow } from '../../core/api.types';

/**
 * Los enemigos del máster.
 *
 * El bestiario es el manual: intocable e igual para todos. Aquí se hacen las
 * COPIAS con las que se juega — "el trasgo de la mina, que se llama Cara-rota y
 * tiene 5 PG porque ya le arreó Gorash"—, y una vez copiadas son del DM: las
 * retoca a su gusto sin que el manual se entere.
 *
 * Se puede empezar de dos sitios: buscando una criatura del bestiario (y
 * entonces los PG, la CA y la iniciativa vienen ya puestos, sacados de su
 * bloque) o de cero, con un enemigo en blanco.
 */
@Component({
  selector: 'arc-enemigos-panel',
  imports: [FormsModule],
  template: `
    <!-- ============ SACAR UNO DEL BESTIARIO ============ -->
    <section class="caza">
      <label class="ctrl">
        <span class="rotulo">Copiar del bestiario</span>
        <input [ngModel]="busca()" (ngModelChange)="buscar($event)"
               placeholder="Busca una criatura: trasgo, dragón, osgo…" autocomplete="off" />
      </label>

      @if (buscando()) { <p class="estado">Buscando…</p> }

      @if (resultados().length) {
        <ul class="hallazgos">
          @for (m of resultados(); track m.id) {
            <li>
              <button type="button" class="hallazgo" [disabled]="copiando() === m.id"
                      (click)="copiar(m)">
                <span class="h-nombre">{{ m.name }}</span>
                <span class="h-meta">{{ m.sizeType }} · VD {{ m.cr }}</span>
                <span class="h-mas">{{ copiando() === m.id ? 'copiando…' : '+ copiar' }}</span>
              </button>
            </li>
          }
        </ul>
      }

      <button type="button" class="boton boton--fantasma" (click)="nuevoEnBlanco()">
        ＋ O inventarme uno de cero
      </button>
    </section>

    @if (error(); as e) { <p class="estado estado--mal" role="alert">{{ e }}</p> }

    <!-- ============ LOS QUE YA TENGO ============ -->
    @if (cargando()) {
      <p class="estado">Abriendo el cajón…</p>
    } @else if (!enemigos().length) {
      <p class="estado">
        Todavía no tienes enemigos. Copia uno del bestiario ahí arriba o invéntate uno.
      </p>
    } @else {
      <p class="recuento">{{ enemigos().length }} enemigo(s)</p>
      <ul class="lista">
        @for (e of enemigos(); track e.id) {
          <li class="hoja bicho">
            @if (editando() === e.id) {
              <!-- --- retocarlo --- -->
              <form class="editor" (ngSubmit)="guardar(e)">
                <div class="rejilla">
                  <label class="campo campo--ancho"><span class="rotulo">Nombre</span>
                    <input name="n" [(ngModel)]="borrador.name" /></label>
                  <label class="campo"><span class="rotulo">PG</span>
                    <input name="pg" type="number" [(ngModel)]="borrador.hpMax" /></label>
                  <label class="campo"><span class="rotulo">CA</span>
                    <input name="ca" type="number" [(ngModel)]="borrador.ac" /></label>
                  <label class="campo"><span class="rotulo">Contacto</span>
                    <input name="ct" type="number" [(ngModel)]="borrador.acTouch" /></label>
                  <label class="campo"><span class="rotulo">Desprev.</span>
                    <input name="df" type="number" [(ngModel)]="borrador.acFlatFooted" /></label>
                  <label class="campo"><span class="rotulo">Iniciativa</span>
                    <input name="in" type="number" [(ngModel)]="borrador.initMod" /></label>
                  <label class="campo"><span class="rotulo">VD</span>
                    <input name="vd" [(ngModel)]="borrador.cr" /></label>
                  <label class="campo campo--ancho"><span class="rotulo">Ataque</span>
                    <input name="at" [(ngModel)]="borrador.attack" /></label>
                  <label class="campo campo--ancho"><span class="rotulo">Notas del máster</span>
                    <textarea name="no" rows="2" [(ngModel)]="borrador.notes"
                              placeholder="Cojea. Sabe dónde está la llave."></textarea></label>
                </div>
                <div class="acciones">
                  <button class="boton boton--lacre" type="submit" [disabled]="guardando()">
                    {{ guardando() ? 'Guardando…' : 'Guardar' }}
                  </button>
                  <button class="boton boton--fantasma" type="button" (click)="cancelar()">Cancelar</button>
                </div>
              </form>
            } @else {
              <!-- --- verlo --- -->
              <div class="fila">
                <h3>{{ e.name }}</h3>
                <span class="cifras">
                  <span class="pg">{{ e.hpMax }} PG</span>
                  <span class="ca">CA {{ e.ac }}</span>
                  @if (e.initMod) { <span class="ini">init {{ signo(e.initMod) }}</span> }
                </span>
              </div>
              <p class="linea">
                @if (e.sizeType) { {{ e.sizeType }} }
                @if (e.cr) { <span class="sep">·</span> VD {{ e.cr }} }
                @if (e.monsterName) {
                  <span class="sep">·</span>
                  <span class="origen">copiado de {{ e.monsterName }}</span>
                }
              </p>
              @if (e.attack) { <p class="ataque">{{ e.attack }}</p> }
              @if (e.notes) { <p class="notas">{{ e.notes }}</p> }
              <div class="acciones">
                <button class="boton boton--fantasma" type="button" (click)="retocar(e)">Retocar</button>
                <button class="boton-quitar" type="button" title="Borrar" (click)="borrar(e)">✕</button>
              </div>
            }
          </li>
        }
      </ul>
    }
  `,
  styles: `
    .caza { margin: 0 0 20px; display: grid; gap: 10px; }
    .ctrl { display: grid; gap: 4px; }
    .ctrl .rotulo { color: var(--sepia-claro); }
    .caza input {
      font: inherit; padding: 10px 12px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
      width: 100%; box-sizing: border-box;
    }

    .hallazgos { list-style: none; margin: 0; padding: 0; display: grid; gap: 4px; }
    .hallazgo {
      display: flex; width: 100%; align-items: baseline; gap: 10px; text-align: left;
      background: none; border: 1px solid var(--linea-clara); border-radius: var(--radio);
      padding: 8px 10px; font: inherit; color: inherit; cursor: pointer;
    }
    .hallazgo:hover { border-color: var(--vino); }
    .hallazgo:disabled { opacity: .5; cursor: default; }
    .h-nombre { color: var(--tinta); flex: 1; }
    .h-meta { font-family: var(--dato); font-size: 10px; color: var(--sepia); }
    .h-mas { font-family: var(--dato); font-size: 10px; color: var(--vino); }

    .recuento {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia); margin: 0 0 10px;
    }
    .lista { list-style: none; margin: 0; padding: 0; display: grid; gap: 10px; }
    .bicho { padding: 14px 16px; }

    .fila { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; }
    h3 { font-size: 18px; color: var(--tinta); margin: 0; }
    .cifras { display: flex; gap: 10px; align-items: baseline; white-space: nowrap; }
    .pg { font-family: var(--dato); font-size: 13px; color: var(--vino); }
    .ca, .ini { font-family: var(--dato); font-size: 12px; color: var(--sepia); }

    .linea {
      font-family: var(--dato); font-size: 10px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); margin: 4px 0 0;
    }
    .linea .sep { color: var(--linea-fuerte); margin: 0 4px; }
    .origen { text-transform: none; letter-spacing: 0; font-style: italic; }
    .ataque { margin: 8px 0 0; font-family: var(--dato); font-size: 13px; color: var(--vino); }
    .notas { margin: 6px 0 0; font-size: 14px; color: var(--sepia-hondo); line-height: 1.5; }

    .acciones { display: flex; gap: 8px; align-items: center; margin-top: 10px; }
    .boton--fantasma {
      background: transparent; border: 1px solid var(--linea-fuerte); color: var(--sepia-hondo);
    }
    .boton--fantasma:hover { color: var(--tinta); border-color: var(--oro); }
    .boton-quitar {
      margin-left: auto; background: none; border: 0; color: var(--sepia);
      cursor: pointer; font-size: 15px; padding: 4px 8px;
    }
    .boton-quitar:hover { color: var(--vino); }

    .editor { display: grid; gap: 12px; }
    .rejilla { display: grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 10px; }
    .campo { display: grid; gap: 4px; }
    .campo--ancho { grid-column: 1 / -1; }
    .campo .rotulo { color: var(--sepia-claro); }
    .editor input, .editor textarea {
      font: inherit; padding: 8px 10px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
      width: 100%; box-sizing: border-box;
    }
    .editor textarea { resize: vertical; line-height: 1.5; }

    .estado { color: var(--sepia-claro); margin: 10px 0; }
    .estado--mal { color: var(--vino); }
  `,
})
export class EnemigosPanel implements OnInit {

  private readonly mesa = inject(MesaService);
  private readonly juego = inject(JuegoService);

  readonly enemigos = signal<Enemigo[]>([]);
  readonly cargando = signal(true);
  readonly error = signal('');

  readonly busca = signal('');
  readonly resultados = signal<MonsterRow[]>([]);
  readonly buscando = signal(false);
  readonly copiando = signal<string | null>(null);

  readonly editando = signal<string | null>(null);
  readonly guardando = signal(false);
  /** Objeto plano porque ngModel lo muta en sitio, como en la ficha. Es un
   *  EnemigoRequest y no un Enemigo: la procedencia (de qué monstruo salió) no
   *  se edita, se hereda. */
  borrador: EnemigoRequest = {};

  private debounce: ReturnType<typeof setTimeout> | null = null;

  ngOnInit(): void { this.cargar(); }

  private cargar(): void {
    this.cargando.set(true);
    this.mesa.enemigos().subscribe({
      next: es => { this.enemigos.set(es); this.cargando.set(false); },
      error: () => { this.cargando.set(false); this.error.set('No se ha podido abrir el cajón.'); },
    });
  }

  // --- buscar en el bestiario ---

  buscar(q: string): void {
    this.busca.set(q);
    if (this.debounce) clearTimeout(this.debounce);
    if (!q.trim()) { this.resultados.set([]); return; }
    this.buscando.set(true);
    this.debounce = setTimeout(() => {
      this.juego.bestiario({ q: q.trim(), limite: 8 }).subscribe({
        next: p => { this.resultados.set(p.items); this.buscando.set(false); },
        error: () => { this.buscando.set(false); this.resultados.set([]); },
      });
    }, 300);
  }

  copiar(m: MonsterRow): void {
    this.copiando.set(m.id);
    this.mesa.copiarDelBestiario(m.id).subscribe({
      next: e => {
        this.enemigos.update(es => [...es, e].sort((a, b) => a.name.localeCompare(b.name, 'es')));
        this.copiando.set(null);
        this.busca.set('');
        this.resultados.set([]);
        this.retocar(e);        // recién copiado, lo normal es querer cambiarle el nombre
      },
      error: () => { this.copiando.set(null); this.error.set('No se ha podido copiar.'); },
    });
  }

  nuevoEnBlanco(): void {
    this.mesa.crearEnemigo({ name: 'Enemigo sin nombre', hpMax: 10, ac: 12 }).subscribe({
      next: e => {
        this.enemigos.update(es => [...es, e]);
        this.retocar(e);
      },
      error: () => this.error.set('No se ha podido crear.'),
    });
  }

  // --- retocar ---

  retocar(e: Enemigo): void {
    this.borrador = {
      name: e.name, sizeType: e.sizeType, cr: e.cr,
      hpMax: e.hpMax, ac: e.ac, acTouch: e.acTouch, acFlatFooted: e.acFlatFooted,
      initMod: e.initMod, speed: e.speed, saves: e.saves, abilities: e.abilities,
      attack: e.attack, fullAttack: e.fullAttack, specialAttacks: e.specialAttacks,
      specialQualities: e.specialQualities, skills: e.skills, feats: e.feats,
      notes: e.notes,
    };
    this.editando.set(e.id);
  }

  cancelar(): void { this.editando.set(null); this.borrador = {}; }

  guardar(e: Enemigo): void {
    if (this.guardando()) return;
    this.guardando.set(true);
    this.mesa.editarEnemigo(e.id, this.borrador).subscribe({
      next: act => {
        this.enemigos.update(es => es.map(x => x.id === act.id ? act : x)
          .sort((a, b) => a.name.localeCompare(b.name, 'es')));
        this.guardando.set(false);
        this.cancelar();
      },
      error: () => { this.guardando.set(false); this.error.set('No se ha podido guardar.'); },
    });
  }

  borrar(e: Enemigo): void {
    if (!confirm(`¿Borrar «${e.name}»? Los combates donde ya esté metido no se tocan.`)) return;
    this.mesa.borrarEnemigo(e.id).subscribe({
      next: () => this.enemigos.update(es => es.filter(x => x.id !== e.id)),
      error: () => this.error.set('No se ha podido borrar.'),
    });
  }

  signo(n: number): string { return (n >= 0 ? '+' : '−') + Math.abs(n); }
}
