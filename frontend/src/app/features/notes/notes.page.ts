import { Component, ElementRef, computed, inject, input, signal, viewChild, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/game.service';
import { Note } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

const norm = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');

/** Lo que se está editando, o null si no hay nada abierto. */
interface Edicion { id: string; category: string; title: string; body: string; }

/**
 * El bloc de notas: nombres de PNJ, ciudades, facciones y lo que convenga no
 * olvidar. Las notas son del jugador (no de un personaje), así que siguen ahí
 * aunque cambies de personaje.
 */
@Component({
  selector: 'arc-notas',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Cuaderno de campo · Los Archivos</p>
        <h1>Bloc de notas</h1>
        <p class="intro">Apunta nombres, lugares y lo que no quieras olvidar.
          Es tuyo: no cambia al cambiar de personaje.</p>
      </header>

      <!-- ---------- añadir ---------- -->
      <div class="hoja alta">
        <div class="alta-fila">
          <select class="a-cat" [(ngModel)]="nuevaCat" aria-label="Categoría">
            @for (c of categorias(); track c) { <option [value]="c">{{ c }}</option> }
          </select>
          <input #tituloInput class="a-titulo" placeholder="Nombre (PNJ, ciudad, facción…)"
                 [(ngModel)]="nuevoTitulo" (keydown.enter)="anadir()" />
        </div>
        <textarea class="a-cuerpo" rows="2" placeholder="Lo que sepas de él (opcional)"
                  [(ngModel)]="nuevoCuerpo"></textarea>
        <div class="alta-acc">
          <button class="boton boton--lacre" [disabled]="!nuevoTitulo().trim() || guardando()"
                  (click)="anadir()">
            {{ guardando() ? 'Anotando…' : 'Anotar' }}
          </button>
        </div>
      </div>
      @if (error(); as e) { <p class="estado estado--mal" role="alert">{{ e }}</p> }

      <!-- ---------- filtros ---------- -->
      <div class="controles">
        <label class="ctrl">
          <span class="rotulo">Categoría</span>
          <select [(ngModel)]="filtroCat">
            <option value="Todas">Todas</option>
            @for (c of categoriasUsadas(); track c) { <option [value]="c">{{ c }}</option> }
          </select>
        </label>
        <label class="ctrl ctrl--buscar">
          <span class="rotulo">Buscar</span>
          <input [(ngModel)]="busqueda" placeholder="Filtra por nombre o contenido…" autocomplete="off" />
        </label>
      </div>

      @if (cargando()) {
        <p class="estado">Abriendo el cuaderno…</p>
      } @else {
        <p class="recuento">{{ filtradas().length }} nota(s)</p>

        @if (filtradas().length === 0) {
          <p class="estado">
            {{ notas().length === 0 ? 'El cuaderno está en blanco. Anota algo arriba.'
                                    : 'Ninguna nota cuadra con la búsqueda.' }}
          </p>
        } @else {
          <ul class="lista">
            @for (n of filtradas(); track n.id) {
              <li class="hoja nota" [class.nota--fijada]="n.pinned">

                <!-- modo edición -->
                @if (edicion()?.id === n.id) {
                  <div class="ed">
                    <div class="alta-fila">
                      <select class="a-cat" [ngModel]="edicion()!.category"
                              (ngModelChange)="cambiar('category', $event)">
                        @for (c of categorias(); track c) { <option [value]="c">{{ c }}</option> }
                      </select>
                      <input class="a-titulo" [ngModel]="edicion()!.title"
                             (ngModelChange)="cambiar('title', $event)" />
                    </div>
                    <textarea class="a-cuerpo" rows="4" [ngModel]="edicion()!.body"
                              (ngModelChange)="cambiar('body', $event)"></textarea>
                    <div class="alta-acc">
                      <button class="boton boton--lacre" (click)="guardar()">Guardar</button>
                      <button class="boton" (click)="cancelar()">Cancelar</button>
                    </div>
                  </div>
                }

                <!-- modo lectura -->
                @else {
                  <div class="fila">
                    <h2>{{ n.title }}</h2>
                    <span class="cat">{{ n.category }}</span>
                  </div>
                  @if (n.body) { <p class="cuerpo">{{ n.body }}</p> }
                  <div class="pie">
                    <span class="fecha">{{ fecha(n.updatedAt) }}</span>
                    <span class="acc">
                      <button type="button" class="mini" [class.mini--on]="n.pinned"
                              [title]="n.pinned ? 'Soltar' : 'Fijar arriba'"
                              (click)="fijar(n)">{{ n.pinned ? '★' : '☆' }}</button>
                      <button type="button" class="mini" (click)="editar(n)">Editar</button>
                      <button type="button" class="mini mini--mal" (click)="eliminar(n)">Borrar</button>
                    </span>
                  </div>
                }
              </li>
            }
          </ul>
        }
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 16px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 8px 0 0; max-width: 54ch; }

    /* alta */
    .alta { padding: 14px 16px; display: grid; gap: 8px; margin-bottom: 6px; }
    .alta-fila { display: flex; gap: 8px; flex-wrap: wrap; }
    .a-cat { flex: 0 0 130px; }
    .a-titulo { flex: 1 1 200px; min-width: 0; }
    .alta select, .alta input, .alta textarea, .ed select, .ed input, .ed textarea {
      font: inherit; padding: 9px 11px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
    }
    .a-cuerpo { width: 100%; resize: vertical; line-height: 1.5; }
    .alta-acc { display: flex; gap: 10px; }

    /* filtros */
    .controles { display: flex; gap: 12px; flex-wrap: wrap; margin: 16px 0 0; }
    .ctrl { display: grid; gap: 4px; }
    .ctrl .rotulo { color: var(--sepia-claro); }
    .ctrl--buscar { flex: 1 1 220px; }
    .controles select, .controles input {
      font: inherit; padding: 10px 12px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
    }
    .controles input { width: 100%; }

    .recuento { font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase; color: var(--sepia); margin: 12px 0 10px; }

    /* notas */
    .lista { list-style: none; margin: 0 0 24px; padding: 0; display: grid; gap: 10px; }
    .nota { padding: 14px 16px; }
    .nota--fijada { border-left: 2px solid var(--oro); }
    .fila { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; }
    h2 { font-size: 19px; color: var(--tinta); }
    .cat {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--musgo); border: 1px solid rgba(76,106,55,.4); border-radius: var(--radio);
      padding: 2px 6px; white-space: nowrap; flex: 0 0 auto;
    }
    .cuerpo { color: var(--sepia-hondo); font-size: 15px; line-height: 1.55; margin: 8px 0 0; white-space: pre-wrap; }

    .pie {
      display: flex; align-items: center; justify-content: space-between; gap: 10px;
      margin-top: 10px; padding-top: 8px; border-top: 1px solid var(--linea-clara);
    }
    .fecha { font-family: var(--dato); font-size: 9px; letter-spacing: .08em; text-transform: uppercase; color: var(--sepia); }
    .acc { display: flex; gap: 6px; }
    .mini {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia); background: transparent; border: 1px solid var(--linea);
      border-radius: var(--radio); padding: 4px 8px;
    }
    .mini:hover { color: var(--tinta); background: rgba(43,33,23,.06); }
    .mini--on { color: var(--oro); border-color: rgba(157,122,47,.5); }
    .mini--mal { color: var(--vino); border-color: rgba(143,46,34,.35); }
    .mini--mal:hover { background: rgba(143,46,34,.08); }

    .ed { display: grid; gap: 8px; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 16px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class NotasPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);

  readonly notas = signal<Note[]>([]);
  readonly categorias = signal<string[]>([]);
  readonly cargando = signal(true);
  readonly guardando = signal(false);
  readonly error = signal<string | null>(null);

  // alta
  readonly nuevaCat = signal('Persona');
  readonly nuevoTitulo = signal('');
  readonly nuevoCuerpo = signal('');
  private readonly tituloInput = viewChild<ElementRef<HTMLInputElement>>('tituloInput');

  // filtros
  readonly filtroCat = signal('Todas');
  readonly busqueda = signal('');

  // edición en sitio
  readonly edicion = signal<Edicion | null>(null);

  /** Solo las categorías que de verdad se usan, para no llenar el filtro. */
  readonly categoriasUsadas = computed(() => {
    const set = new Set(this.notas().map(n => n.category));
    return [...set].sort((a, b) => a.localeCompare(b));
  });

  readonly filtradas = computed(() => {
    const cat = this.filtroCat();
    const q = norm(this.busqueda().trim());
    return this.notas()
      .filter(n => cat === 'Todas' || n.category === cat)
      .filter(n => q === '' || norm(n.title).includes(q) || norm(n.body).includes(q));
  });

  ngOnInit(): void { this.cargar(); }

  private cargar(): void {
    this.juego.notas().subscribe({
      next: r => {
        this.notas.set(r.notes);
        this.categorias.set(r.categories);
        this.cargando.set(false);
      },
      error: () => { this.cargando.set(false); this.error.set('No se ha podido abrir el cuaderno.'); },
    });
  }

  /** Todas las operaciones devuelven el bloc entero: solo hay que repintar. */
  private aplicar(r: { notes: Note[]; categories: string[] }): void {
    this.notas.set(r.notes);
    this.categorias.set(r.categories);
  }

  anadir(): void {
    const title = this.nuevoTitulo().trim();
    if (!title || this.guardando()) return;
    this.guardando.set(true);
    this.error.set(null);
    this.juego.crearNota({ title, category: this.nuevaCat(), body: this.nuevoCuerpo().trim() })
      .subscribe({
        next: r => {
          this.aplicar(r);
          this.guardando.set(false);
          this.nuevoTitulo.set('');
          this.nuevoCuerpo.set('');
          this.tituloInput()?.nativeElement.focus();   // encadenar anotaciones
        },
        error: err => {
          this.guardando.set(false);
          this.error.set(err?.error?.message ?? 'No se ha podido anotar.');
        },
      });
  }

  editar(n: Note): void {
    this.edicion.set({ id: n.id, category: n.category, title: n.title, body: n.body });
  }

  cambiar(campo: 'category' | 'title' | 'body', valor: string): void {
    const e = this.edicion();
    if (e) this.edicion.set({ ...e, [campo]: valor });
  }

  guardar(): void {
    const e = this.edicion();
    if (!e || !e.title.trim()) return;
    this.error.set(null);
    this.juego.editarNota(e.id, { title: e.title.trim(), category: e.category, body: e.body })
      .subscribe({
        next: r => { this.aplicar(r); this.edicion.set(null); },
        error: err => this.error.set(err?.error?.message ?? 'No se han podido guardar los cambios.'),
      });
  }

  cancelar(): void { this.edicion.set(null); }

  fijar(n: Note): void {
    this.juego.fijarNota(n.id).subscribe({
      next: r => this.aplicar(r),
      error: () => this.error.set('No se ha podido fijar la nota.'),
    });
  }

  eliminar(n: Note): void {
    this.juego.eliminarNota(n.id).subscribe({
      next: r => this.aplicar(r),
      error: () => this.error.set('No se ha podido borrar la nota.'),
    });
  }

  /** "6 ago 2026" a partir del ISO que manda el backend. */
  fecha(iso: string): string {
    if (!iso) return '';
    const d = new Date(iso);
    if (isNaN(d.getTime())) return '';
    return d.toLocaleDateString('es-ES', { day: 'numeric', month: 'short', year: 'numeric' });
  }
}
