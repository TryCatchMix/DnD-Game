import { Component, computed, effect, inject, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { MesaService } from '../../core/mesa.service';
import { Archivo, Coincidencia, TarjetaMision } from '../../core/mesa.types';
import { Lamina } from './lamina';
import { Visor } from './visor';
import { ZonaSubida } from './zona-subida';

const norm = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');

type Filtro = 'todo' | 'imagen' | 'pdf' | 'sueltos';

/**
 * La biblioteca: todo el material subido, esté o no en una misión.
 *
 * Es el sitio al que se viene a buscar («el retrato del alcalde, ¿dónde lo
 * metí?») y a repartir: desde aquí un archivo se manda a la misión que sea sin
 * tener que abrirla.
 */
@Component({
  selector: 'arc-biblioteca-panel',
  imports: [FormsModule, Lamina, ZonaSubida, Visor],
  template: `
    <arc-zona-subida titulo="Suelta aquí lo que quieras guardar" (subido)="cargar()" />

    <div class="mando">
      <input class="buscar" type="search" placeholder="Buscar por nombre o por lo que dice dentro…"
             [(ngModel)]="busqueda" aria-label="Buscar archivo" />
    </div>

    <!-- Lo que se ha encontrado DENTRO de los PDF, no solo en el título -->
    @if (busqueda().trim().length >= 2) {
      <section class="dentro">
        <p class="rotulo-dentro">Dentro de los documentos
          @if (buscandoTexto()) { · buscando… }
          @else { · {{ coincidencias().length }} {{ coincidencias().length === 1 ? 'documento' : 'documentos' }} }
        </p>

        @if (coincidencias().length) {
          <ul class="hallazgos">
            @for (c of coincidencias(); track c.id) {
              <li class="hallazgo hoja">
                <button class="abrir-doc" (click)="abrirCoincidencia(c)"
                        [attr.aria-label]="'Abrir ' + c.title">
                  <span class="marca">PDF</span>
                  <span class="hallazgo-cuerpo">
                    <span class="hallazgo-nombre">{{ c.title }}</span>
                    <span class="fragmento">@for (s of segmentos(c.snippet); track $index) {
                      @if (s.hit) { <mark>{{ s.t }}</mark> } @else { {{ s.t }} }
                    }</span>
                  </span>
                  <span class="veces">{{ c.matchCount }}×</span>
                </button>
              </li>
            }
          </ul>
        } @else if (!buscandoTexto()) {
          <p class="nada-dentro">
            No sale en el texto de ningún PDF.
            <button class="enlace" [disabled]="reindexando()" (click)="reindexar()">
              {{ reindexando() ? 'Indexando…' : 'Indexar PDF antiguos' }}
            </button>
            @if (avisoIndex(); as a) { <span class="aviso-index">{{ a }}</span> }
          </p>
        }
      </section>
    }

    <div class="filtros" role="group" aria-label="Filtrar material">
      <button class="chip" [class.activo]="filtro() === 'todo'" (click)="filtro.set('todo')">
        Todo <span class="cuenta">{{ archivos().length }}</span>
      </button>
      <button class="chip" [class.activo]="filtro() === 'imagen'" (click)="filtro.set('imagen')">
        Láminas <span class="cuenta">{{ cuenta('imagen') }}</span>
      </button>
      <button class="chip" [class.activo]="filtro() === 'pdf'" (click)="filtro.set('pdf')">
        PDF <span class="cuenta">{{ cuenta('pdf') }}</span>
      </button>
      <button class="chip" [class.activo]="filtro() === 'sueltos'" (click)="filtro.set('sueltos')">
        Sin misión <span class="cuenta">{{ sueltos() }}</span>
      </button>
    </div>

    @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

    @if (cargando()) {
      <p class="vacio">Abriendo la biblioteca…</p>
    } @else if (visibles().length === 0) {
      <p class="vacio">
        {{ archivos().length === 0
            ? 'Aún no has subido nada. Los mapas, retratos y PDF que subas aquí valen para cualquier misión.'
            : 'Nada con ese filtro.' }}
      </p>
    } @else {
      <ul class="rejilla">
        @for (a of visibles(); track a.id) {
          <li class="pieza hoja">
            <button class="ver" (click)="ver(a)" [attr.aria-label]="'Ver ' + a.title">
              <arc-lamina [assetId]="a.id" [alt]="a.title" [kind]="a.kind" />
            </button>

            <div class="cuerpo">
              @if (renombrando() === a.id) {
                <input [ngModel]="nombre()" (ngModelChange)="nombre.set($event)"
                       (keydown.enter)="guardarNombre(a)" aria-label="Nombre del archivo" />
                <div class="acciones">
                  <button class="boton" (click)="guardarNombre(a)">Guardar</button>
                  <button class="boton" (click)="renombrando.set(null)">Cancelar</button>
                </div>
              } @else {
                <p class="nombre" [title]="a.filename">{{ a.title }}</p>
                <p class="dato">{{ a.kind === 'pdf' ? 'PDF' : 'Lámina' }} · {{ peso(a.sizeBytes) }}</p>

                <label class="destino">
                  <span class="rotulo">En la misión</span>
                  <select [ngModel]="a.misionId ?? ''" (ngModelChange)="asignar(a, $event)">
                    <option value="">— suelta en la biblioteca —</option>
                    @for (m of misiones(); track m.id) {
                      <option [value]="m.id">{{ m.title }}</option>
                    }
                  </select>
                </label>

                @if (confirmando() === a.id) {
                  <p class="aviso">¿Borrarlo de verdad? Desaparece también de la misión donde esté.</p>
                  <div class="acciones">
                    <button class="boton boton--lacre" (click)="borrar(a)">Sí, borrar</button>
                    <button class="boton" (click)="confirmando.set(null)">No</button>
                  </div>
                } @else {
                  <div class="acciones">
                    <button class="icono" (click)="renombrar(a)" aria-label="Renombrar">✎</button>
                    <button class="icono icono--peligro" (click)="confirmando.set(a.id)"
                            aria-label="Borrar">✕</button>
                  </div>
                }
              }
            </div>
          </li>
        }
      </ul>
    }

    @if (viendo(); as v) {
      <arc-visor [archivos]="v.lista" [indice]="v.i" (cerrar)="viendo.set(null)" />
    }
  `,
  styles: `
    arc-zona-subida { display: block; margin-bottom: 18px; }

    .mando { display: flex; gap: 10px; margin-bottom: 12px; }
    .buscar { flex: 1; }

    /* ------------------------------------------------ dentro de los PDF ---- */
    .dentro { margin: 0 0 18px; }
    .rotulo-dentro {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--sepia-claro); margin: 0 0 8px;
    }
    .hallazgos { list-style: none; margin: 0; padding: 0; display: grid; gap: 8px; }
    .hallazgo { overflow: hidden; }
    .abrir-doc {
      width: 100%; display: flex; align-items: center; gap: 12px;
      background: none; border: 0; text-align: left; padding: 10px 12px; color: var(--tinta);
    }
    .abrir-doc:hover { background: rgba(43,33,23,.05); }
    .abrir-doc:hover .hallazgo-nombre { color: var(--vino); }
    .abrir-doc .marca {
      flex: none;
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      color: var(--pergamino); background: var(--sepia-hondo);
      padding: 4px 6px; border-radius: var(--radio);
    }
    .hallazgo-cuerpo { flex: 1; min-width: 0; display: grid; gap: 3px; }
    .hallazgo-nombre { font-size: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .fragmento {
      font-size: 13px; color: var(--sepia-hondo); font-style: italic;
      overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    }
    .fragmento mark { background: rgba(191,155,74,.35); color: var(--tinta); font-style: normal; border-radius: 2px; }
    .veces { flex: none; font-family: var(--dato); font-size: 11px; color: var(--sepia); }

    .nada-dentro { color: var(--sepia-claro); font-style: italic; font-size: 14px; margin: 0; }
    .nada-dentro .enlace {
      font-family: var(--dato); font-size: 11px; letter-spacing: .08em; text-transform: uppercase;
      font-style: normal; color: var(--vino); background: none; border: 0; padding: 2px 4px; margin-left: 4px;
    }
    .nada-dentro .enlace:hover:not(:disabled) { text-decoration: underline; }
    .nada-dentro .enlace:disabled { opacity: .5; }
    .aviso-index { font-style: normal; color: var(--musgo); margin-left: 6px; font-size: 13px; }

    .filtros { display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 20px; }
    .chip {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--sepia-claro); background: transparent;
      border: 1px solid var(--linea-noche); border-radius: var(--radio); padding: 7px 11px;
    }
    .chip:hover { color: var(--pergamino); background: rgba(239,228,205,.06); }
    .chip.activo { color: var(--pergamino); background: rgba(239,228,205,.10); border-color: var(--sepia); }
    .chip .cuenta { opacity: .6; margin-left: 5px; }

    .rejilla {
      list-style: none; margin: 0; padding: 0;
      display: grid; gap: 16px; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
    }
    .pieza { overflow: hidden; display: flex; flex-direction: column; }
    .ver { display: block; width: 100%; padding: 0; border: 0; background: none; }
    .ver arc-lamina { height: 118px; }

    .cuerpo { padding: 10px 12px 12px; display: grid; gap: 8px; }
    .nombre { font-size: 16px; color: var(--tinta); margin: 0; overflow-wrap: anywhere; }
    .dato { color: var(--sepia); text-transform: uppercase; font-family: var(--dato); font-size: 10px; margin: 0; }

    .destino .rotulo { display: block; margin-bottom: 4px; color: var(--sepia); }
    select {
      font: inherit; width: 100%; padding: 8px 10px; font-size: 14px;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-claro); color: var(--tinta);
    }

    .acciones { display: flex; gap: 4px; }
    .icono {
      width: 30px; height: 30px; font-family: var(--dato); font-size: 13px;
      color: var(--sepia); background: none; border: 1px solid transparent; border-radius: var(--radio);
    }
    .icono:hover { color: var(--tinta); border-color: var(--linea); background: rgba(43,33,23,.06); }
    .icono--peligro:hover { color: var(--vino); border-color: rgba(143,46,34,.4); }

    .aviso { color: var(--sepia-hondo); font-size: 13px; margin: 0; }

    .vacio { color: var(--sepia-claro); font-style: italic; padding: 14px 0; max-width: 52ch; }
    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 0 0 14px; }
  `,
})
export class BibliotecaPanel implements OnInit {

  private readonly mesa = inject(MesaService);

  readonly archivos = signal<Archivo[]>([]);
  readonly misiones = signal<TarjetaMision[]>([]);
  readonly filtro = signal<Filtro>('todo');
  readonly busqueda = signal('');
  readonly renombrando = signal<string | null>(null);
  readonly confirmando = signal<string | null>(null);
  readonly nombre = signal('');
  readonly viendo = signal<{ lista: Archivo[]; i: number } | null>(null);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  /** Lo encontrado dentro del texto de los PDF (aparte del filtro por nombre). */
  readonly coincidencias = signal<Coincidencia[]>([]);
  readonly buscandoTexto = signal(false);
  readonly reindexando = signal(false);
  readonly avisoIndex = signal<string | null>(null);

  constructor() {
    // Buscar dentro de los PDF con un respiro (debounce): cada tecla reinicia
    // la cuenta y solo se pregunta al backend cuando el DM deja de escribir.
    effect(onCleanup => {
      const q = this.busqueda().trim();
      if (q.length < 2) { this.coincidencias.set([]); this.buscandoTexto.set(false); return; }
      this.buscandoTexto.set(true);
      const t = setTimeout(() => {
        this.mesa.buscarEnPdf(q).subscribe({
          next: cs => { this.coincidencias.set(cs); this.buscandoTexto.set(false); },
          error: () => { this.coincidencias.set([]); this.buscandoTexto.set(false); },
        });
      }, 300);
      onCleanup(() => clearTimeout(t));
    });
  }

  readonly visibles = computed(() => {
    const q = norm(this.busqueda().trim());
    const f = this.filtro();
    return this.archivos().filter(a => {
      if (f === 'sueltos' && a.misionId) return false;
      if ((f === 'imagen' || f === 'pdf') && a.kind !== f) return false;
      if (!q) return true;
      return norm(a.title + ' ' + a.filename).includes(q);
    });
  });

  readonly sueltos = computed(() => this.archivos().filter(a => !a.misionId).length);

  ngOnInit(): void {
    this.cargar();
    this.mesa.misiones().subscribe({
      next: v => this.misiones.set(v.misiones),
      error: () => {},   // sin la lista solo se pierde el desplegable de destino
    });
  }

  cuenta(kind: 'imagen' | 'pdf'): number {
    return this.archivos().filter(a => a.kind === kind).length;
  }

  peso(bytes: number): string {
    const mb = bytes / (1024 * 1024);
    return mb >= 1 ? mb.toFixed(1) + ' MB' : Math.max(Math.round(bytes / 1024), 1) + ' KB';
  }

  cargar(): void {
    this.mesa.biblioteca().subscribe({
      next: as => { this.archivos.set(as); this.cargando.set(false); },
      error: err => { this.cargando.set(false); this.fallo(err); },
    });
  }

  ver(a: Archivo): void {
    const lista = this.visibles();
    this.viendo.set({ lista, i: Math.max(lista.findIndex(x => x.id === a.id), 0) });
  }

  /** Abrir a pantalla completa el PDF donde se ha encontrado la frase. */
  abrirCoincidencia(c: Coincidencia): void {
    const a = this.archivos().find(x => x.id === c.id);
    if (a) this.viendo.set({ lista: [a], i: 0 });
  }

  /**
   * Parte el fragmento en trozos para poder resaltar la frase buscada sin usar
   * innerHTML. Compara sin tildes ni mayúsculas, igual que la búsqueda, mapeando
   * las posiciones del texto normalizado de vuelta al original.
   */
  segmentos(snippet: string): { t: string; hit: boolean }[] {
    const q = norm(this.busqueda().trim());
    if (!q) return [{ t: snippet, hit: false }];

    let plano = '';
    const mapa: number[] = [];
    for (let i = 0; i < snippet.length; i++) {
      const limpio = norm(snippet[i]);
      for (const ch of limpio) { mapa.push(i); plano += ch; }
    }
    mapa.push(snippet.length);

    const partes: { t: string; hit: boolean }[] = [];
    let ultimo = 0, desde = 0, p: number;
    while ((p = plano.indexOf(q, desde)) >= 0) {
      const ini = mapa[p], fin = mapa[p + q.length];
      if (ini > ultimo) partes.push({ t: snippet.slice(ultimo, ini), hit: false });
      partes.push({ t: snippet.slice(ini, fin), hit: true });
      ultimo = fin; desde = p + q.length;
    }
    if (ultimo < snippet.length) partes.push({ t: snippet.slice(ultimo), hit: false });
    return partes;
  }

  /** Indexar los PDF viejos y repetir la búsqueda con lo recién indexado. */
  reindexar(): void {
    this.reindexando.set(true);
    this.avisoIndex.set(null);
    this.mesa.reindexar().subscribe({
      next: n => {
        this.reindexando.set(false);
        this.avisoIndex.set(n > 0 ? `Indexados ${n}. Vuelve a buscar.` : 'No había ninguno pendiente.');
        if (n > 0) {
          const q = this.busqueda().trim();
          this.buscandoTexto.set(true);
          this.mesa.buscarEnPdf(q).subscribe({
            next: cs => { this.coincidencias.set(cs); this.buscandoTexto.set(false); },
            error: () => this.buscandoTexto.set(false),
          });
        }
      },
      error: err => { this.reindexando.set(false); this.fallo(err); },
    });
  }

  renombrar(a: Archivo): void {
    this.nombre.set(a.title);
    this.renombrando.set(a.id);
  }

  guardarNombre(a: Archivo): void {
    const t = this.nombre().trim();
    if (!t) { this.renombrando.set(null); return; }
    this.mesa.editarArchivo(a.id, { title: t }).subscribe({
      next: () => { this.renombrando.set(null); this.cargar(); },
      error: err => this.fallo(err),
    });
  }

  /** Mandar el archivo a una misión, o devolverlo a la biblioteca ('' ). */
  asignar(a: Archivo, misionId: string): void {
    if ((a.misionId ?? '') === misionId) return;
    this.mesa.editarArchivo(a.id, { misionId }).subscribe({
      next: () => this.cargar(),
      error: err => this.fallo(err),
    });
  }

  borrar(a: Archivo): void {
    this.confirmando.set(null);
    this.mesa.borrarArchivo(a.id).subscribe({
      next: () => this.cargar(),
      error: err => this.fallo(err),
    });
  }

  private fallo(err: any): void {
    this.error.set(err?.error?.message ?? 'Algo ha ido mal en la biblioteca.');
  }
}
