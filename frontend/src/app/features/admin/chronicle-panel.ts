import { Component, inject, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/juego.service';
import { ChronicleEntry } from '../../core/api.types';

const CATEGORIAS = ['MUNDO', 'CATACLISMO', 'VERDAD', 'CLAN', 'RUMOR'];

interface Formulario {
  id: string | null;
  title: string;
  year: number;
  era: string;
  category: string;
  faction: string;
  body: string;
  sealed: boolean;
  revealed: boolean;
}

/**
 * Gestión de la crónica del clan: añadir, editar y eliminar entradas, y marcar
 * lo sellado/destapado. A diferencia de la pantalla de crónica «de mundo», aquí
 * el DM ve el cuerpo verdadero de todo, hasta lo que la Orden del Velo sella.
 */
@Component({
  selector: 'arc-cronica-panel',
  imports: [FormsModule],
  template: `
    <header class="cabecera">
      <p class="rotulo">Crónica del clan · Los Archivos</p>
      <p class="intro">Añade, corrige o borra entradas de la crónica. Lo sellado se muestra aquí sin censura.</p>
    </header>

    <!-- Formulario (nueva / edición) -->
    <form class="hoja formulario" (ngSubmit)="guardar()">
      <p class="rotulo">{{ form.id ? 'Editar entrada' : 'Nueva entrada' }}</p>
      <label>Título<input name="c_title" [(ngModel)]="form.title" required /></label>
      <div class="fila-form">
        <label>Año<input name="c_year" type="number" [(ngModel)]="form.year" /></label>
        <label>Época<input name="c_era" [(ngModel)]="form.era" placeholder="Año 1127 · Dorakan" /></label>
        <label>Categoría
          <select name="c_cat" [(ngModel)]="form.category">
            @for (c of categorias; track c) { <option [value]="c">{{ c }}</option> }
          </select>
        </label>
      </div>
      <label>Facción<input name="c_fac" [(ngModel)]="form.faction" placeholder="Los Archivos, La Orden del Velo…" /></label>
      <label>Texto<textarea name="c_body" rows="4" [(ngModel)]="form.body"></textarea></label>
      <div class="checks">
        <label class="check">
          <input name="c_sealed" type="checkbox" [(ngModel)]="form.sealed" />
          Sellar (verdad oculta por la Orden del Velo)
        </label>
        @if (form.sealed) {
          <label class="check">
            <input name="c_revealed" type="checkbox" [(ngModel)]="form.revealed" />
            Ya destapada
          </label>
        }
      </div>
      @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }
      @if (mensaje(); as m) { <p class="ok" role="status">{{ m }}</p> }
      <div class="acciones">
        <button class="boton boton--lacre" type="submit" [disabled]="ocupado()">
          {{ ocupado() ? 'Guardando…' : (form.id ? 'Guardar cambios' : 'Añadir entrada') }}
        </button>
        @if (form.id) {
          <button class="boton" type="button" (click)="cancelarEdicion()">Cancelar</button>
        }
      </div>
    </form>

    <!-- Lista -->
    <p class="rotulo separador">Entradas ({{ entradas().length }})</p>
    @if (cargando()) {
      <p class="estado">Abriendo la crónica…</p>
    } @else if (entradas().length === 0) {
      <p class="estado">Aún no hay entradas.</p>
    } @else {
      <ul class="lista">
        @for (e of entradas(); track e.id) {
          <li class="hoja entrada" [class.editando]="e.id === form.id">
            <div class="franja">
              <span class="rotulo era">{{ e.era || ('Año ' + e.year) }}</span>
              <span class="cat" [class]="'cat--' + e.category.toLowerCase()">{{ e.category }}</span>
              @if (e.sealed) {
                <span class="marca" [class.marca--rev]="e.revealed">{{ e.revealed ? 'destapada' : 'sellada' }}</span>
              }
            </div>
            <h2>{{ e.title }}</h2>
            @if (e.faction) { <p class="faccion">{{ e.faction }}</p> }
            <p class="cuerpo">{{ e.body }}</p>
            <div class="acc">
              <button class="boton" [disabled]="ocupado()" (click)="editar(e)">Editar</button>
              @if (confirmar() === e.id) {
                <button class="boton boton--peligro" [disabled]="ocupado()" (click)="eliminar(e)">Confirmar borrado</button>
                <button class="boton" [disabled]="ocupado()" (click)="confirmar.set(null)">No</button>
              } @else {
                <button class="boton boton--peligro" [disabled]="ocupado()" (click)="confirmar.set(e.id)">Eliminar</button>
              }
            </div>
          </li>
        }
      </ul>
    }
  `,
  styles: `
    .cabecera { margin: 0 0 14px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 8px 0 0; }

    .separador { margin: 24px 0 10px; color: var(--sepia); }

    .formulario { padding: 16px 18px; display: grid; gap: 10px; }
    .formulario label { display: grid; gap: 4px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }
    .formulario input, .formulario textarea, .formulario select {
      font: inherit; width: 100%; padding: 10px 12px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
    }
    .formulario textarea { resize: vertical; }
    .fila-form { display: grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 10px; }
    .checks { display: flex; gap: 18px; flex-wrap: wrap; }
    .check { flex-direction: row; align-items: center; gap: 8px; display: flex !important; text-transform: none; letter-spacing: normal; font-size: 12px; color: var(--sepia-hondo); }
    .check input { width: auto; }
    .acciones { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 4px; }

    .lista { list-style: none; margin: 0; padding: 0; display: grid; gap: 12px; }
    .entrada { padding: 16px 18px; }
    .entrada.editando { border-left: 3px solid var(--oro); }
    .franja { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap; }
    .era { color: var(--sepia); }
    .cat { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; border: 1px solid var(--linea); border-radius: var(--radio); padding: 3px 6px; }
    .cat--cataclismo { color: var(--vino); border-color: rgba(143,46,34,.4); }
    .cat--verdad { color: var(--oro); border-color: rgba(157,122,47,.5); }
    .cat--clan { color: var(--musgo); border-color: rgba(76,106,55,.5); }
    .cat--mundo { color: var(--sepia); }
    .cat--rumor { color: var(--sepia-claro); }
    .marca { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; color: var(--vino); border: 1px solid rgba(143,46,34,.4); border-radius: var(--radio); padding: 3px 6px; }
    .marca--rev { color: var(--oro); border-color: rgba(157,122,47,.5); }

    h2 { font-size: 20px; color: var(--tinta); line-height: 1.25; }
    .faccion { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); margin: 4px 0 8px; }
    .cuerpo { color: var(--sepia-hondo); font-size: 15px; line-height: 1.5; margin: 6px 0 12px; white-space: pre-wrap; }
    .acc { display: flex; gap: 8px; flex-wrap: wrap; }

    .boton--peligro { color: #d98a7c; border-color: rgba(143,46,34,.45); }
    .ok { color: var(--musgo); border-left: 2px solid var(--musgo); padding: 6px 10px; margin: 0; }
    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 0; }
    .estado { font-style: italic; color: var(--sepia-claro); padding: 12px 0; }
  `,
})
export class CronicaPanel implements OnInit {

  private readonly juego = inject(JuegoService);

  readonly categorias = CATEGORIAS;

  readonly entradas = signal<ChronicleEntry[]>([]);
  readonly cargando = signal(true);
  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);
  readonly mensaje = signal<string | null>(null);
  /** Id de la entrada con el borrado pendiente de confirmar. */
  readonly confirmar = signal<string | null>(null);

  form: Formulario = this.formularioVacio();

  ngOnInit(): void { this.cargar(); }

  private cargar(): void {
    this.juego.cronicaAdmin().subscribe({
      next: cs => { this.entradas.set(cs); this.cargando.set(false); },
      error: () => { this.cargando.set(false); this.error.set('No se ha podido abrir la crónica.'); },
    });
  }

  guardar(): void {
    if (this.ocupado()) return;
    if (!this.form.title.trim()) { this.error.set('La entrada necesita un título.'); return; }

    this.ocupado.set(true);
    this.error.set(null);
    this.mensaje.set(null);

    const datos = {
      title: this.form.title.trim(),
      year: this.form.year,
      era: this.form.era,
      category: this.form.category,
      faction: this.form.faction,
      body: this.form.body,
      sealed: this.form.sealed,
      revealed: this.form.revealed,
    };

    const id = this.form.id;
    const peticion = id
      ? this.juego.editarCronica(id, datos)
      : this.juego.crearCronica(datos);

    peticion.subscribe({
      next: cs => {
        this.entradas.set(cs);
        this.ocupado.set(false);
        this.mensaje.set(id ? 'Entrada actualizada.' : 'Entrada añadida.');
        this.form = this.formularioVacio();
      },
      error: err => {
        this.ocupado.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido guardar.');
      },
    });
  }

  editar(e: ChronicleEntry): void {
    this.confirmar.set(null);
    this.error.set(null);
    this.mensaje.set(null);
    this.form = {
      id: e.id,
      title: e.title,
      year: e.year,
      era: e.era,
      category: e.category,
      faction: e.faction ?? '',
      body: e.body,
      sealed: e.sealed,
      revealed: e.revealed,
    };
    // Sube al formulario para que se vea que está en edición.
    if (typeof window !== 'undefined') window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  cancelarEdicion(): void {
    this.form = this.formularioVacio();
    this.error.set(null);
    this.mensaje.set(null);
  }

  eliminar(e: ChronicleEntry): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.juego.eliminarCronica(e.id).subscribe({
      next: cs => {
        this.entradas.set(cs);
        this.ocupado.set(false);
        this.confirmar.set(null);
        this.mensaje.set('Entrada eliminada.');
        if (this.form.id === e.id) this.form = this.formularioVacio();
      },
      error: err => {
        this.ocupado.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido eliminar.');
      },
    });
  }

  private formularioVacio(): Formulario {
    return {
      id: null, title: '', year: 1127, era: 'Año 1127 · Dorakan',
      category: 'MUNDO', faction: '', body: '', sealed: false, revealed: false,
    };
  }
}
