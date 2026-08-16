import { Component, computed, inject, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { MesaService } from '../../core/mesa.service';
import { Archivo, TarjetaMision } from '../../core/mesa.types';
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
      <input class="buscar" type="search" placeholder="Buscar por nombre…"
             [(ngModel)]="busqueda" aria-label="Buscar archivo" />
    </div>

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
