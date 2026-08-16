import { Component, computed, effect, inject, input, output, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Observable } from 'rxjs';

import { MesaService } from '../../core/mesa.service';
import {
  Archivo, DetalleMision, ESTADOS, EstadoMision, NotaMesa, TIPOS_NOTA, TipoNota,
} from '../../core/mesa.types';
import { Lamina } from './lamina';
import { ModoMesa } from './modo-mesa';
import { Visor } from './visor';
import { ZonaSubida } from './zona-subida';

/** Lo que se está escribiendo en un paso del guion. */
interface EdicionNota { id: string | null; kind: TipoNota; title: string; body: string; }

const NOTA_EN_BLANCO: EdicionNota = { id: null, kind: 'nota', title: '', body: '' };

/**
 * Una misión abierta: a la izquierda el guion (los pasos, en orden), a la
 * derecha el material (láminas y PDF).
 *
 * Las dos columnas están juntas a propósito: preparar es ir escribiendo el
 * guion mientras miras el mapa, y tener que cambiar de pestaña para ver la
 * imagen que estás describiendo rompe el hilo.
 */
@Component({
  selector: 'arc-mision-detalle',
  imports: [FormsModule, Lamina, ZonaSubida, Visor, ModoMesa],
  template: `
    @if (mision(); as m) {
      <button class="volver" (click)="volver.emit()">‹ Todas las misiones</button>

      <!-- ---------------------------------------------------------- cabecera -->
      <header class="cabeza hoja">
        <div class="portada">
          <arc-lamina [assetId]="m.coverId" [alt]="m.title" />
        </div>

        <div class="quien">
          @if (editandoFicha()) {
            <div class="ficha">
              <input [ngModel]="ficha().title" (ngModelChange)="cambiarFicha('title', $event)"
                     aria-label="Título" />
              <textarea rows="2" [ngModel]="ficha().summary"
                        (ngModelChange)="cambiarFicha('summary', $event)"
                        aria-label="De qué va" placeholder="De qué va"></textarea>
              <div class="fila">
                <input type="date" [ngModel]="ficha().sessionDate"
                       (ngModelChange)="cambiarFicha('sessionDate', $event)" aria-label="Fecha" />
                <input [ngModel]="ficha().tags" (ngModelChange)="cambiarFicha('tags', $event)"
                       placeholder="etiquetas, separadas, por comas" aria-label="Etiquetas" />
              </div>
              <div class="acciones">
                <button class="boton boton--lacre" [disabled]="ocupado()" (click)="guardarFicha()">Guardar</button>
                <button class="boton" (click)="editandoFicha.set(false)">Cancelar</button>
              </div>
            </div>
          } @else {
            <p class="rotulo">
              Misión @if (m.sessionDate) { · se juega el {{ fecha(m.sessionDate) }} }
            </p>
            <h1>{{ m.title }}</h1>
            @if (m.summary) { <p class="resumen">{{ m.summary }}</p> }
            @if (m.tags.length) {
              <ul class="etiquetas">@for (t of m.tags; track t) { <li>{{ t }}</li> }</ul>
            }
          }

          <div class="mandos">
            <label class="estado">
              <span class="rotulo">Estado</span>
              <select [ngModel]="m.status" (ngModelChange)="cambiarEstado($event)">
                @for (e of estados; track e) { <option [value]="e">{{ nombreEstado(e) }}</option> }
              </select>
            </label>
            <button class="boton" (click)="abrirFicha(m)">Editar ficha</button>
            <button class="boton boton--lacre" (click)="enMesa.set(true)">▶ Modo mesa</button>
          </div>
        </div>
      </header>

      @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

      <div class="columnas">
        <!-- ------------------------------------------------------- guion ---- -->
        <section>
          <div class="titulillo">
            <p class="rotulo">Guion · {{ m.notes.length }} pasos</p>
          </div>

          @if (m.notes.length === 0) {
            <p class="vacio">Aún no hay guion. Empieza por lo que leerás en voz alta al abrir la escena.</p>
          }

          <ol class="pasos">
            @for (n of m.notes; track n.id) {
              <li class="paso hoja" [class]="'paso hoja paso--' + n.kind">
                @if (nota()?.id === n.id) {
                  <div class="ficha">
                    <div class="fila">
                      <select [ngModel]="nota()!.kind" (ngModelChange)="cambiarNota('kind', $event)"
                              aria-label="Tipo de paso">
                        @for (t of tipos; track t) { <option [value]="t">{{ nombreTipo(t) }}</option> }
                      </select>
                      <input [ngModel]="nota()!.title" (ngModelChange)="cambiarNota('title', $event)"
                             placeholder="Título del paso" aria-label="Título del paso" />
                    </div>
                    <textarea rows="5" [ngModel]="nota()!.body"
                              (ngModelChange)="cambiarNota('body', $event)"
                              placeholder="El texto" aria-label="Texto del paso"></textarea>
                    <div class="acciones">
                      <button class="boton boton--lacre" [disabled]="ocupado()" (click)="guardarNota()">Guardar</button>
                      <button class="boton" (click)="nota.set(null)">Cancelar</button>
                    </div>
                  </div>
                } @else {
                  <div class="paso-cabeza">
                    <p class="tipo">{{ nombreTipo(n.kind) }}</p>
                    <div class="paso-acc">
                      <button class="icono" [disabled]="$first || ocupado()" (click)="mover(n, true)"
                              aria-label="Subir paso">↑</button>
                      <button class="icono" [disabled]="$last || ocupado()" (click)="mover(n, false)"
                              aria-label="Bajar paso">↓</button>
                      <button class="icono" (click)="editarNota(n)" aria-label="Editar paso">✎</button>
                      <button class="icono icono--peligro" [disabled]="ocupado()"
                              (click)="confirmando.set(n.id)" aria-label="Quitar paso">✕</button>
                    </div>
                  </div>
                  @if (confirmando() === n.id) {
                    <p class="aviso">¿Quitar este paso del guion?
                      <button class="enlace" (click)="quitarNota(n)">Sí, quitarlo</button> ·
                      <button class="enlace" (click)="confirmando.set(null)">No</button>
                    </p>
                  }
                  @if (n.title) { <h3>{{ n.title }}</h3> }
                  @if (n.body) { <p class="cuerpo">{{ n.body }}</p> }
                }
              </li>
            }
          </ol>

          @if (nota()?.id === null) {
            <div class="hoja ficha nueva">
              <div class="fila">
                <select [ngModel]="nota()!.kind" (ngModelChange)="cambiarNota('kind', $event)"
                        aria-label="Tipo de paso">
                  @for (t of tipos; track t) { <option [value]="t">{{ nombreTipo(t) }}</option> }
                </select>
                <input [ngModel]="nota()!.title" (ngModelChange)="cambiarNota('title', $event)"
                       placeholder="Título del paso (opcional)" aria-label="Título del paso" />
              </div>
              <textarea rows="4" [ngModel]="nota()!.body" (ngModelChange)="cambiarNota('body', $event)"
                        placeholder="Lo que pasa, lo que dice, lo que hay"
                        aria-label="Texto del paso"></textarea>
              <div class="acciones">
                <button class="boton boton--lacre" [disabled]="ocupado()" (click)="guardarNota()">Añadir paso</button>
                <button class="boton" (click)="nota.set(null)">Cancelar</button>
              </div>
            </div>
          } @else {
            <button class="boton anadir" (click)="nota.set({ ...NOTA_EN_BLANCO })">+ Añadir paso al guion</button>
          }
        </section>

        <!-- ---------------------------------------------------- material ---- -->
        <section>
          <div class="titulillo">
            <p class="rotulo">Material · {{ m.assets.length }} archivos</p>
          </div>

          <arc-zona-subida [misionId]="m.id" titulo="Suelta aquí mapas, retratos o el PDF"
                           (subido)="trasSubir()" />

          @if (laminas().length) {
            <ul class="galeria">
              @for (a of laminas(); track a.id) {
                <li class="pieza hoja" [class.pieza--portada]="a.id === m.coverId">
                  <button class="ver" (click)="ver(a)" [attr.aria-label]="'Ver ' + a.title">
                    <arc-lamina [assetId]="a.id" [alt]="a.title" />
                  </button>
                  <p class="nombre" [title]="a.filename">{{ a.title }}</p>
                  <div class="pieza-acc">
                    @if (a.id === m.coverId) {
                      <span class="marca-portada">Portada</span>
                    } @else {
                      <button class="icono" (click)="hacerPortada(a)" aria-label="Usar como portada">☆</button>
                    }
                    <button class="icono" (click)="aBiblioteca(a)"
                            aria-label="Devolver a la biblioteca">⇱</button>
                    @if (confirmando() === a.id) {
                      <button class="enlace" (click)="borrarArchivo(a)">Borrar</button>
                      <button class="enlace" (click)="confirmando.set(null)">No</button>
                    } @else {
                      <button class="icono icono--peligro" (click)="confirmando.set(a.id)"
                              aria-label="Borrar archivo">✕</button>
                    }
                  </div>
                </li>
              }
            </ul>
          }

          @if (documentos().length) {
            <ul class="docs">
              @for (a of documentos(); track a.id) {
                <li class="doc hoja">
                  <button class="ver-doc" (click)="ver(a)">
                    <span class="marca">PDF</span>
                    <span class="doc-nombre">{{ a.title }}</span>
                    <span class="doc-peso">{{ peso(a.sizeBytes) }}</span>
                  </button>
                  <div class="pieza-acc">
                    <button class="icono" (click)="aBiblioteca(a)"
                            aria-label="Devolver a la biblioteca">⇱</button>
                    @if (confirmando() === a.id) {
                      <button class="enlace" (click)="borrarArchivo(a)">Borrar</button>
                      <button class="enlace" (click)="confirmando.set(null)">No</button>
                    } @else {
                      <button class="icono icono--peligro" (click)="confirmando.set(a.id)"
                              aria-label="Borrar archivo">✕</button>
                    }
                  </div>
                </li>
              }
            </ul>
          }

          <!-- Traer algo que ya está subido, sin volver a subirlo -->
          <div class="traer">
            <button class="boton" (click)="alternarBiblioteca()">
              {{ mostrarBiblioteca() ? 'Cerrar la biblioteca' : 'Traer de la biblioteca' }}
            </button>

            @if (mostrarBiblioteca()) {
              @if (sueltos().length === 0) {
                <p class="vacio">No hay nada suelto en la biblioteca: todo está ya en alguna misión.</p>
              } @else {
                <ul class="galeria">
                  @for (a of sueltos(); track a.id) {
                    <li class="pieza hoja">
                      <button class="ver" (click)="traer(a)" [attr.aria-label]="'Traer ' + a.title">
                        <arc-lamina [assetId]="a.id" [alt]="a.title" [kind]="a.kind" />
                      </button>
                      <p class="nombre">{{ a.title }}</p>
                    </li>
                  }
                </ul>
              }
            }
          </div>
        </section>
      </div>

      @if (viendo(); as v) {
        <arc-visor [archivos]="v.lista" [indice]="v.i" (cerrar)="viendo.set(null)" />
      }

      @if (enMesa()) {
        <arc-modo-mesa [mision]="m" (cerrar)="enMesa.set(false)" (ensenar)="ver($event)" />
      }
    } @else {
      <p class="vacio">Abriendo la misión…</p>
    }
  `,
  styles: `
    .volver {
      font-family: var(--dato); font-size: 10px; letter-spacing: .14em; text-transform: uppercase;
      color: var(--sepia-claro); background: none; border: 0; padding: 6px 0; margin-bottom: 10px;
    }
    .volver:hover { color: var(--pergamino); }

    /* ------------------------------------------------------------ cabecera - */
    .cabeza { display: grid; grid-template-columns: 260px 1fr; overflow: hidden; }
    .portada arc-lamina { height: 100%; min-height: 190px; }
    .quien { padding: 18px 20px; }
    .quien .rotulo { color: var(--sepia); margin: 0; }
    .quien h1 { font-size: 30px; color: var(--tinta); margin: 4px 0 0; }
    .resumen { color: var(--sepia-hondo); margin: 8px 0 0; }
    .etiquetas { list-style: none; display: flex; gap: 5px; flex-wrap: wrap; margin: 10px 0 0; padding: 0; }
    .etiquetas li {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio); padding: 2px 6px;
    }
    .mandos { display: flex; gap: 8px; align-items: flex-end; flex-wrap: wrap; margin-top: 16px; }
    .estado .rotulo { display: block; margin-bottom: 4px; }
    .estado select { width: auto; }

    @media (max-width: 720px) {
      .cabeza { grid-template-columns: 1fr; }
      .portada arc-lamina { height: 150px; min-height: 0; }
    }

    /* ------------------------------------------------------------ columnas - */
    .columnas {
      display: grid; gap: 26px; margin-top: 24px;
      grid-template-columns: minmax(0, 1.15fr) minmax(0, 1fr);
      align-items: start;
    }
    @media (max-width: 900px) { .columnas { grid-template-columns: 1fr; } }

    .titulillo { border-bottom: 1px solid var(--linea-noche); padding-bottom: 6px; margin-bottom: 14px; }
    .titulillo .rotulo { color: var(--sepia-claro); margin: 0; }

    /* --------------------------------------------------------------- guion - */
    .pasos { list-style: none; margin: 0 0 12px; padding: 0; display: grid; gap: 12px; counter-reset: paso; }
    .paso { padding: 14px 16px; }
    .paso--lectura { border-left: 3px solid var(--oro); }
    .paso--pnj     { border-left: 3px solid var(--vino); }
    .paso--botin   { border-left: 3px solid var(--musgo); }
    .paso--escena  { border-left: 3px solid var(--sepia); }

    .paso-cabeza { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
    .tipo {
      font-family: var(--dato); font-size: 9px; letter-spacing: .16em; text-transform: uppercase;
      color: var(--sepia); margin: 0;
    }
    .paso h3 { font-size: 19px; color: var(--tinta); margin: 6px 0 0; }
    .cuerpo { color: var(--sepia-hondo); margin: 6px 0 0; white-space: pre-wrap; }
    .paso--lectura .cuerpo { font-style: italic; color: var(--tinta); }

    .paso-acc { display: flex; gap: 2px; }
    .icono {
      width: 28px; height: 28px; line-height: 1;
      font-family: var(--dato); font-size: 13px;
      color: var(--sepia); background: none;
      border: 1px solid transparent; border-radius: var(--radio);
    }
    .icono:hover:not(:disabled) { color: var(--tinta); border-color: var(--linea); background: rgba(43,33,23,.06); }
    .icono:disabled { opacity: .25; }
    .icono--peligro:hover:not(:disabled) { color: var(--vino); border-color: rgba(143,46,34,.4); }

    .anadir { width: 100%; }

    /* ------------------------------------------------------------ material - */
    arc-zona-subida { display: block; margin-bottom: 16px; }

    .galeria {
      list-style: none; margin: 0 0 14px; padding: 0;
      display: grid; gap: 12px; grid-template-columns: repeat(auto-fill, minmax(132px, 1fr));
    }
    .pieza { overflow: hidden; display: flex; flex-direction: column; }
    .pieza--portada { outline: 2px solid var(--oro); outline-offset: -2px; }
    .ver { display: block; width: 100%; padding: 0; border: 0; background: none; }
    .ver arc-lamina { height: 92px; }
    .nombre {
      font-size: 13px; color: var(--sepia-hondo); margin: 6px 8px 0;
      overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    }
    .pieza-acc { display: flex; gap: 2px; align-items: center; padding: 4px 6px 6px; margin-top: auto; }
    .marca-portada {
      font-family: var(--dato); font-size: 9px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--oro);
    }

    .docs { list-style: none; margin: 0 0 14px; padding: 0; display: grid; gap: 8px; }
    .doc { display: flex; align-items: center; gap: 8px; padding: 6px 8px 6px 0; }
    .ver-doc {
      flex: 1; display: flex; align-items: center; gap: 10px;
      background: none; border: 0; text-align: left; padding: 6px 8px; color: var(--tinta);
    }
    .ver-doc:hover .doc-nombre { color: var(--vino); }
    .marca {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      color: var(--pergamino); background: var(--sepia-hondo);
      padding: 4px 6px; border-radius: var(--radio);
    }
    .doc-nombre { flex: 1; font-size: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .doc-peso { font-family: var(--dato); font-size: 10px; color: var(--sepia); }

    .traer { margin-top: 8px; }
    .traer .boton { width: 100%; color: var(--pergamino); border-color: var(--linea-noche); }
    .traer .boton:hover { background: rgba(239,228,205,.07); }
    .traer .galeria { margin-top: 12px; }

    /* --------------------------------------------------------------- común - */
    .ficha { display: grid; gap: 10px; }
    .ficha.nueva { padding: 14px 16px; }
    .fila { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 10px; }
    textarea, select {
      font: inherit; width: 100%; padding: 10px 12px;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-claro); color: var(--tinta);
    }
    textarea { resize: vertical; }
    .acciones { display: flex; gap: 8px; flex-wrap: wrap; }

    /* La confirmación de borrado: pregunta corta, en el sitio, sin ventanita. */
    .aviso { color: var(--sepia-hondo); font-size: 13px; margin: 8px 0 0; }
    .enlace {
      font-family: var(--dato); font-size: 11px; letter-spacing: .08em; text-transform: uppercase;
      color: var(--vino); background: none; border: 0; padding: 2px 4px;
    }
    .enlace:hover { text-decoration: underline; }

    .vacio { color: var(--sepia-claro); font-style: italic; padding: 8px 0 14px; }
    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 14px 0 0; }
  `,
})
export class MisionDetalle {

  readonly misionId = input.required<string>();
  /** Volver a la rejilla. La página recarga las tarjetas al recibirlo. */
  readonly volver = output<void>();

  protected readonly NOTA_EN_BLANCO = NOTA_EN_BLANCO;
  protected readonly estados: EstadoMision[] = ['idea', 'preparando', 'lista', 'jugada'];
  protected readonly tipos: TipoNota[] = ['lectura', 'escena', 'pnj', 'botin', 'nota'];

  private readonly mesa = inject(MesaService);

  readonly mision = signal<DetalleMision | null>(null);
  readonly nota = signal<EdicionNota | null>(null);
  /** Id del paso o del archivo pendiente de confirmar el borrado. */
  readonly confirmando = signal<string | null>(null);
  readonly editandoFicha = signal(false);
  readonly ficha = signal({ title: '', summary: '', tags: '', sessionDate: '' });
  readonly viendo = signal<{ lista: Archivo[]; i: number } | null>(null);
  readonly enMesa = signal(false);
  readonly mostrarBiblioteca = signal(false);
  readonly sueltos = signal<Archivo[]>([]);
  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);

  readonly laminas = computed(() => this.mision()?.assets.filter(a => a.kind === 'imagen') ?? []);
  readonly documentos = computed(() => this.mision()?.assets.filter(a => a.kind !== 'imagen') ?? []);

  constructor() {
    // Al cambiar de misión (o al entrar) se baja su detalle entero.
    effect(() => {
      const id = this.misionId();
      this.mision.set(null);
      this.nota.set(null);
      this.editandoFicha.set(false);
      this.mesa.mision(id).subscribe({
        next: d => this.mision.set(d),
        error: err => this.fallo(err),
      });
    });
  }

  nombreEstado(e: EstadoMision): string { return ESTADOS[e]; }
  nombreTipo(t: TipoNota): string { return TIPOS_NOTA[t]; }

  fecha(iso: string): string {
    return new Date(iso + 'T00:00:00')
      .toLocaleDateString('es-ES', { day: 'numeric', month: 'long' });
  }

  peso(bytes: number): string {
    const mb = bytes / (1024 * 1024);
    return mb >= 1 ? mb.toFixed(1) + ' MB' : Math.max(Math.round(bytes / 1024), 1) + ' KB';
  }

  // ---------------------------------------------------------------- la ficha

  abrirFicha(m: DetalleMision): void {
    this.ficha.set({
      title: m.title, summary: m.summary,
      tags: m.tags.join(', '), sessionDate: m.sessionDate ?? '',
    });
    this.editandoFicha.set(true);
  }

  cambiarFicha(campo: 'title' | 'summary' | 'tags' | 'sessionDate', valor: string): void {
    this.ficha.update(f => ({ ...f, [campo]: valor }));
  }

  guardarFicha(): void {
    const f = this.ficha();
    if (!f.title.trim()) return;
    this.pedir(this.mesa.editarMision(this.misionId(), {
      title: f.title.trim(), summary: f.summary.trim(),
      tags: f.tags.trim(), sessionDate: f.sessionDate,
    }), () => this.editandoFicha.set(false));
  }

  cambiarEstado(estado: EstadoMision): void {
    this.pedir(this.mesa.editarMision(this.misionId(), { status: estado }));
  }

  // ----------------------------------------------------------------- guion

  editarNota(n: NotaMesa): void {
    this.nota.set({ id: n.id, kind: n.kind, title: n.title, body: n.body });
  }

  cambiarNota<K extends keyof EdicionNota>(campo: K, valor: EdicionNota[K]): void {
    this.nota.update(n => (n ? { ...n, [campo]: valor } : n));
  }

  guardarNota(): void {
    const n = this.nota();
    if (!n) return;
    if (!n.title.trim() && !n.body.trim()) {
      this.error.set('Un paso vacío no sirve de nada: ponle título o texto.');
      return;
    }
    const req = { kind: n.kind, title: n.title.trim(), body: n.body.trim() };
    const peticion = n.id
      ? this.mesa.editarNota(n.id, req)
      : this.mesa.anadirNota(this.misionId(), req);
    this.pedir(peticion, () => this.nota.set(null));
  }

  mover(n: NotaMesa, arriba: boolean): void {
    this.pedir(this.mesa.moverNota(n.id, arriba));
  }

  quitarNota(n: NotaMesa): void {
    this.confirmando.set(null);
    this.pedir(this.mesa.quitarNota(n.id));
  }

  // --------------------------------------------------------------- material

  /** Un archivo recién subido entra directo en la misión: se recarga y ya. */
  trasSubir(): void {
    this.recargar();
  }

  ver(a: Archivo): void {
    // Se abre con toda la lista de su tipo para poder pasar de una a otra.
    const lista = a.kind === 'imagen' ? this.laminas() : this.documentos();
    this.viendo.set({ lista, i: Math.max(lista.findIndex(x => x.id === a.id), 0) });
  }

  hacerPortada(a: Archivo): void {
    this.pedir(this.mesa.editarMision(this.misionId(), { coverId: a.id }));
  }

  aBiblioteca(a: Archivo): void {
    this.mesa.editarArchivo(a.id, { misionId: '' }).subscribe({
      next: () => this.recargar(),
      error: err => this.fallo(err),
    });
  }

  borrarArchivo(a: Archivo): void {
    this.confirmando.set(null);
    this.mesa.borrarArchivo(a.id).subscribe({
      next: () => { this.recargar(); this.cargarSueltos(); },
      error: err => this.fallo(err),
    });
  }

  alternarBiblioteca(): void {
    this.mostrarBiblioteca.update(v => !v);
    if (this.mostrarBiblioteca()) this.cargarSueltos();
  }

  /** Traer a esta misión algo que ya estaba subido. */
  traer(a: Archivo): void {
    this.mesa.editarArchivo(a.id, { misionId: this.misionId() }).subscribe({
      next: () => { this.recargar(); this.cargarSueltos(); },
      error: err => this.fallo(err),
    });
  }

  // ---------------------------------------------------------------- adentro

  private cargarSueltos(): void {
    this.mesa.biblioteca().subscribe({
      next: todos => this.sueltos.set(todos.filter(a => !a.misionId)),
      error: err => this.fallo(err),
    });
  }

  private recargar(): void {
    this.mesa.mision(this.misionId()).subscribe({
      next: d => this.mision.set(d),
      error: err => this.fallo(err),
    });
  }

  /** Todas las operaciones del detalle devuelven el detalle entero. */
  private pedir(peticion: Observable<DetalleMision>, luego?: () => void): void {
    this.ocupado.set(true);
    this.error.set(null);
    peticion.subscribe({
      next: d => { this.mision.set(d); this.ocupado.set(false); luego?.(); },
      error: err => { this.ocupado.set(false); this.fallo(err); },
    });
  }

  private fallo(err: any): void {
    this.error.set(err?.error?.message ?? 'Algo ha ido mal en la mesa.');
  }
}
