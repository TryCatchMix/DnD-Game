import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/juego.service';
import { AuthService } from '../../core/auth.service';
import { ChronicleEntry } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

const CATEGORIAS = ['MUNDO', 'CATACLISMO', 'VERDAD', 'CLAN', 'RUMOR'];

/**
 * Pantalla 07: la crónica del clan. La memoria compartida del mundo.
 * La Orden del Velo sella lo que pasó en el Cataclismo; Los Archivos (el DM)
 * lo van destapando.
 */
@Component({
  selector: 'arc-cronica',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Crónica del clan · Los Archivos</p>
        <h1>Lo que quede constancia</h1>
        <p class="intro">
          La Orden del Velo sella lo que de verdad pasó en el Cataclismo. El clan
          copia, coteja y destapa. Aquí queda escrito.
        </p>
      </header>

      @if (esDM()) {
        <div class="anotar">
          @if (!mostrarAnotar()) {
            <button class="boton" (click)="mostrarAnotar.set(true)">+ Anotar en la crónica</button>
          } @else {
            <form class="hoja formulario" (ngSubmit)="anotar()">
              <p class="rotulo">Nueva entrada</p>
              <label>Título<input name="c_title" [(ngModel)]="nueva.title" required /></label>
              <div class="fila-form">
                <label>Año<input name="c_year" type="number" [(ngModel)]="nueva.year" /></label>
                <label>Época<input name="c_era" [(ngModel)]="nueva.era" placeholder="Año 1127 · Dorakan" /></label>
                <label>Categoría
                  <select name="c_cat" [(ngModel)]="nueva.category">
                    @for (c of categorias; track c) { <option [value]="c">{{ c }}</option> }
                  </select>
                </label>
              </div>
              <label>Facción<input name="c_fac" [(ngModel)]="nueva.faction" placeholder="Los Archivos, La Orden del Velo…" /></label>
              <label>Texto<textarea name="c_body" rows="3" [(ngModel)]="nueva.body"></textarea></label>
              <label class="check">
                <input name="c_sealed" type="checkbox" [(ngModel)]="nueva.sealed" />
                Sellar (verdad oculta por la Orden del Velo)
              </label>
              @if (errorAnotar(); as e) { <p class="error">{{ e }}</p> }
              <div class="acciones">
                <button class="boton boton--lacre" type="submit" [disabled]="guardando()">
                  {{ guardando() ? 'Anotando…' : 'Anotar' }}
                </button>
                <button class="boton" type="button" (click)="cancelarAnotar()">Cancelar</button>
              </div>
            </form>
          }
        </div>
      }

      @if (cargando()) {
        <p class="estado">Abriendo la crónica…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else {
        <ol class="linea">
          @for (e of entradas(); track e.id) {
            <li class="hoja entrada"
                [class.sellada]="e.sealed && !e.revealed"
                [class.revelada]="e.sealed && e.revealed">
              <div class="franja">
                <span class="rotulo era">{{ e.era }}</span>
                <span class="cat" [class]="'cat--' + e.category.toLowerCase()">{{ etiqueta(e.category) }}</span>
              </div>

              <h2>{{ e.title }}</h2>

              @if (e.faction) {
                <p class="faccion" [class.velo]="e.faction === 'La Orden del Velo'">{{ e.faction }}</p>
              }

              @if (e.sealed && !e.revealed) {
                <div class="sello" aria-hidden="true"><span>SELLADO</span></div>
                <p class="cuerpo censurado">{{ e.body }}</p>
                @if (e.canReveal) {
                  <button class="boton boton--lacre revelar"
                          [disabled]="revelando() === e.id"
                          (click)="revelar(e)">
                    {{ revelando() === e.id ? 'Destapando…' : 'Destapar la verdad' }}
                  </button>
                }
              } @else {
                @if (e.sealed && e.revealed) {
                  <p class="destapada">✦ Verdad destapada por Los Archivos</p>
                }
                <p class="cuerpo">{{ e.body }}</p>
              }
            </li>
          }
        </ol>
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 18px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 10px 0 0; max-width: 52ch; }

    /* anotar */
    .anotar { margin-bottom: 20px; }
    .formulario { padding: 16px 18px; display: grid; gap: 10px; }
    .formulario label { display: grid; gap: 4px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }
    .formulario textarea { font: inherit; width: 100%; padding: 10px 12px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta); resize: vertical; }
    .formulario select { font: inherit; padding: 10px 8px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta); }
    .fila-form { display: grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 10px; }
    .check { flex-direction: row; align-items: center; gap: 8px; display: flex !important; text-transform: none; letter-spacing: normal; font-size: 12px; color: var(--sepia-hondo); }
    .check input { width: auto; }
    .acciones { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 4px; }

    /* línea de tiempo */
    .linea { list-style: none; margin: 0; padding: 0; display: grid; gap: 14px; }
    .entrada { padding: 18px 20px; position: relative; }

    .franja { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-bottom: 8px; }
    .era { color: var(--sepia); }
    .cat { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; border: 1px solid var(--linea); border-radius: var(--radio); padding: 3px 6px; white-space: nowrap; }
    .cat--cataclismo { color: var(--vino); border-color: rgba(143,46,34,.4); }
    .cat--verdad { color: var(--oro); border-color: rgba(157,122,47,.5); }
    .cat--clan { color: var(--musgo); border-color: rgba(76,106,55,.5); }
    .cat--mundo { color: var(--sepia); }
    .cat--rumor { color: var(--sepia-claro); }

    h2 { font-size: 21px; color: var(--tinta); line-height: 1.25; }
    .faccion { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); margin: 6px 0 10px; }
    .faccion.velo { color: var(--vino); }

    .cuerpo { color: var(--sepia-hondo); font-size: 16px; line-height: 1.55; margin: 8px 0 0; }
    .destapada { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--oro); margin: 4px 0 8px; }

    /* sellada */
    .entrada.sellada { background: var(--pergamino-hueso); }
    .censurado { color: var(--sepia); font-style: italic; filter: blur(.3px); }
    .sello { position: absolute; top: 14px; right: 18px; transform: rotate(-8deg); border: 2px solid var(--vino); border-radius: var(--radio); padding: 2px 8px; opacity: .8; }
    .sello span { font-family: var(--dato); font-size: 11px; letter-spacing: .18em; color: var(--vino); }
    .revelar { margin-top: 12px; }
    .entrada.revelada { border-left: 3px solid var(--oro); }

    .error { font-size: 13px; color: #d98a7c; border-left: 2px solid var(--vino); padding: 4px 10px; margin: 0; }
    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class CronicaPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly auth = inject(AuthService);

  readonly categorias = CATEGORIAS;
  readonly esDM = computed(() => this.auth.rol() === 'DM');

  readonly entradas = signal<ChronicleEntry[]>([]);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);
  readonly revelando = signal<string | null>(null);

  readonly mostrarAnotar = signal(false);
  readonly guardando = signal(false);
  readonly errorAnotar = signal<string | null>(null);
  nueva = this.entradaVacia();

  ngOnInit(): void {
    this.juego.cronica().subscribe({
      next: cs => { this.entradas.set(cs); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido abrir la crónica.');
      },
    });
  }

  revelar(e: ChronicleEntry): void {
    if (this.revelando()) return;
    this.revelando.set(e.id);
    this.juego.revelar(e.id).subscribe({
      next: cs => { this.entradas.set(cs); this.revelando.set(null); },
      error: () => { this.revelando.set(null); this.error.set('No se ha podido destapar la entrada.'); },
    });
  }

  anotar(): void {
    if (this.guardando()) return;
    if (!this.nueva.title || !this.nueva.title.trim()) {
      this.errorAnotar.set('La entrada necesita un título.');
      return;
    }
    this.guardando.set(true);
    this.errorAnotar.set(null);
    this.juego.anotar(this.nueva).subscribe({
      next: cs => {
        this.entradas.set(cs);
        this.guardando.set(false);
        this.mostrarAnotar.set(false);
        this.nueva = this.entradaVacia();
      },
      error: err => {
        this.guardando.set(false);
        this.errorAnotar.set(err?.error?.message ?? 'No se ha podido anotar.');
      },
    });
  }

  cancelarAnotar(): void {
    this.mostrarAnotar.set(false);
    this.errorAnotar.set(null);
    this.nueva = this.entradaVacia();
  }

  etiqueta(cat: string): string {
    switch (cat) {
      case 'CATACLISMO': return 'Cataclismo';
      case 'MUNDO': return 'Mundo';
      case 'VERDAD': return 'Verdad';
      case 'CLAN': return 'Clan';
      case 'RUMOR': return 'Rumor';
      default: return cat;
    }
  }

  private entradaVacia() {
    return { title: '', year: 1127, era: 'Año 1127 · Dorakan', category: 'MUNDO', faction: '', body: '', sealed: false };
  }
}
