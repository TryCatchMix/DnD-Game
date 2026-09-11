import { Component, computed, inject, input, output, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { ElencoService } from '../../core/cast.service';
import {
  CampoPnj, Descubierto, Elenco, Pnj, RelacionPnj, Trato,
} from '../../core/cast.types';
import { RetratoPanel } from './portrait-panel';

/** Todo sellado: como nace una ficha nueva. Lo que sabe el máster no lo sabe
 *  la mesa hasta que él lo diga, y ese es el valor por defecto correcto. */
const NADA_SABIDO: Descubierto = {
  listed: false, name: false, portrait: false, title: false, location: false,
  race: false, description: false, trivia: false, alignment: false,
};

/** El formulario mientras se escribe. */
interface Borrador {
  id: string | null;            // null = ficha nueva
  name: string;
  alias: string;
  title: string;
  location: string;
  race: string;
  description: string;
  trivia: string;
  alignment: string;
  reveal: Descubierto;
}

/** Lo que se está escribiendo en la fila de un trato nuevo. */
interface TratoNuevo {
  kind: Trato;
  /** 'pnj:<id>' | 'pj:<id>' | 'libre' — quién es el otro extremo. */
  destino: string;
  nombre: string;
  note: string;
  revealed: boolean;
}

const TRATO_EN_BLANCO: TratoNuevo = {
  kind: 'neutral', destino: 'libre', nombre: '', note: '', revealed: false,
};

const NOMBRES: Record<Trato, string> = {
  amistoso: 'Amistoso', neutral: 'Neutral', enemigo: 'Enemigo', familiar: 'Familia',
};

/**
 * El creador de personajes del elenco: la ficha entera de una vez.
 *
 * Cada campo lleva al lado su casilla de «ya lo saben». Escribir y decidir qué
 * se cuenta son la misma tarea —al inventarte a alguien ya sabes qué es su
 * secreto—, así que van juntas y no en dos pantallas.
 *
 * Lo que no está aquí es lo que solo tiene sentido con la ficha ya creada: el
 * retrato y los tratos necesitan un id al que colgarse, así que aparecen en
 * cuanto se guarda. La página se encarga de dejar el editor abierto sobre la
 * ficha recién creada para que se pueda seguir sin volver atrás.
 */
@Component({
  selector: 'arc-pnj-editor',
  imports: [FormsModule, RetratoPanel],
  template: `
    <div class="volver">
      <button class="boton" (click)="cerrar.emit()">← Volver al elenco</button>
    </div>

    <article class="hoja editor">
      <div class="columnas">

        <!-- ------------------------------------------------- la cara ---- -->
        <div class="cara">
          @if (pnj(); as p) {
            <arc-retrato-panel [pnj]="p" [dm]="true" (cambiado)="cambiado.emit($event)" />
          } @else {
            <div class="cara-vacia">
              <p class="rotulo">Retrato</p>
              <p>La foto se sube en cuanto la ficha existe. Guarda primero.</p>
            </div>
          }
        </div>

        <!-- ------------------------------------------------ el formulario -->
        <form class="formulario" (ngSubmit)="guardar()">
          <p class="rotulo">{{ b().id ? 'Editar ficha' : 'Personaje nuevo' }}</p>

          <!-- nombre y alias van juntos: son las dos caras del mismo dato -->
          <div class="fila">
            <label class="campo">
              <span class="etiqueta">Nombre</span>
              <input [ngModel]="b().name" (ngModelChange)="poner('name', $event)"
                     name="name" placeholder="Gorash Pico de Hierro" />
            </label>
            <label class="campo">
              <span class="etiqueta">Mientras no lo sepan</span>
              <input [ngModel]="b().alias" (ngModelChange)="poner('alias', $event)"
                     name="alias" placeholder="El encapuchado" />
            </label>
          </div>
          <div class="sellos">
            <label class="casilla">
              <input type="checkbox" [ngModel]="b().reveal.name" name="rev-name"
                     (ngModelChange)="sellar('name', $event)" />
              <span>Saben su nombre</span>
            </label>
            <label class="casilla casilla--fuerte">
              <input type="checkbox" [ngModel]="b().reveal.listed" name="rev-listed"
                     (ngModelChange)="sellar('listed', $event)" />
              <span>Ya ha salido (si no, no lo ven en el elenco)</span>
            </label>
          </div>

          @for (c of textos(); track c.campo) {
            <div class="campo">
              <label>
                <span class="etiqueta">{{ c.etiqueta }}</span>
                @if (c.campo === 'alignment') {
                  <input [ngModel]="b().alignment" (ngModelChange)="poner('alignment', $event)"
                         name="alignment" list="alineamientos" placeholder="Legal neutral" />
                } @else if (c.largo) {
                  <textarea [rows]="c.campo === 'description' ? 4 : 3"
                            [ngModel]="valor(c.campo)" [name]="c.campo"
                            (ngModelChange)="poner(c.campo, $event)"
                            [placeholder]="c.pista"></textarea>
                } @else {
                  <input [ngModel]="valor(c.campo)" [name]="c.campo"
                         (ngModelChange)="poner(c.campo, $event)" [placeholder]="c.pista" />
                }
              </label>
              <label class="casilla">
                <input type="checkbox" [ngModel]="sabido(c.campo)" [name]="'rev-' + c.campo"
                       (ngModelChange)="sellar(c.campo, $event)" />
                <span>Ya lo saben</span>
              </label>
            </div>
          }

          <datalist id="alineamientos">
            @for (a of alineamientos(); track a) { <option [value]="a"></option> }
          </datalist>

          @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

          <div class="acciones">
            <button type="submit" class="boton boton--lacre"
                    [disabled]="!b().name.trim() || ocupado()">
              {{ b().id ? 'Guardar cambios' : 'Crear personaje' }}
            </button>
            <button type="button" class="boton" (click)="cerrar.emit()">Cancelar</button>
            @if (b().id) {
              <button type="button" class="boton boton--peligro"
                      (click)="confirmando.set(true)">Eliminar</button>
            }
          </div>

          @if (confirmando()) {
            <div class="confirmar">
              <p>¿Borrar a «{{ b().name }}»? Se va con su retrato y sus tratos.</p>
              <div class="acciones">
                <button type="button" class="boton boton--lacre" [disabled]="ocupado()"
                        (click)="eliminar()">Sí, borrar</button>
                <button type="button" class="boton" (click)="confirmando.set(false)">No</button>
              </div>
            </div>
          }
        </form>
      </div>

      <!-- --------------------------------------------------- los tratos -->
      @if (pnj(); as p) {
        <section class="tratos-panel">
          <h2>Con quién se trata</h2>
          <p class="ayuda">Amistoso, neutral, enemigo o familia. Cada trato se
             descubre por su cuenta: saber que odia al Gremio no cuenta que sea
             hermano de la capitana.</p>

          @if (p.relations.length) {
            <ul class="lista">
              @for (t of p.relations; track t.id) {
                <li [class]="'trato trato--' + t.kind">
                  <span class="trato-tipo">{{ nombre(t.kind) }}</span>
                  <span class="trato-quien">{{ t.who }}</span>
                  @if (t.note) { <span class="trato-nota">{{ t.note }}</span> }
                  <span class="trato-acc">
                    <button type="button" class="sello" [class.sello--visto]="t.revealed"
                            [disabled]="ocupado()" (click)="alternarTrato(t)">
                      {{ t.revealed ? 'Sabido' : 'Sellado' }}
                    </button>
                    <button type="button" class="sello sello--mal" [disabled]="ocupado()"
                            (click)="quitarTrato(t)">Quitar</button>
                  </span>
                </li>
              }
            </ul>
          }

          <div class="alta">
            <div class="fila">
              <label class="campo">
                <span class="etiqueta">Trato</span>
                <select [ngModel]="nuevo().kind" name="t-kind"
                        (ngModelChange)="ponerTrato('kind', $event)">
                  @for (k of tratos(); track k) { <option [value]="k">{{ nombre(k) }}</option> }
                </select>
              </label>
              <label class="campo">
                <span class="etiqueta">Con quién</span>
                <select [ngModel]="nuevo().destino" name="t-destino"
                        (ngModelChange)="ponerTrato('destino', $event)">
                  <option value="libre">Escribir un nombre…</option>
                  @if (otros().length) {
                    <optgroup label="Del elenco">
                      @for (o of otros(); track o.id) {
                        <option [value]="'pnj:' + o.id">{{ o.name }}</option>
                      }
                    </optgroup>
                  }
                  @if (personajes().length) {
                    <optgroup label="Del grupo">
                      @for (c of personajes(); track c.id) {
                        <option [value]="'pj:' + c.id">{{ c.name }}</option>
                      }
                    </optgroup>
                  }
                </select>
              </label>
              @if (nuevo().destino === 'libre') {
                <label class="campo">
                  <span class="etiqueta">Nombre</span>
                  <input [ngModel]="nuevo().nombre" name="t-nombre"
                         (ngModelChange)="ponerTrato('nombre', $event)"
                         placeholder="El Gremio de Mineros" />
                </label>
              }
            </div>
            <div class="fila">
              <label class="campo campo--ancho">
                <span class="etiqueta">Detalle (opcional)</span>
                <input [ngModel]="nuevo().note" name="t-note"
                       (ngModelChange)="ponerTrato('note', $event)"
                       placeholder="Le debe 200 po desde la crecida" />
              </label>
              <label class="casilla casilla--alta">
                <input type="checkbox" [ngModel]="nuevo().revealed" name="t-rev"
                       (ngModelChange)="ponerTrato('revealed', $event)" />
                <span>Ya lo saben</span>
              </label>
            </div>
            <div class="acciones">
              <button type="button" class="boton" [disabled]="!tratoListo() || ocupado()"
                      (click)="anadirTrato()">Añadir trato</button>
            </div>
          </div>
        </section>
      }
    </article>
  `,
  styles: `
    .volver { margin-bottom: 14px; }
    .volver .boton { color: var(--pergamino); border-color: var(--linea-noche); }
    .volver .boton:hover:not(:disabled) { background: rgba(239,228,205,.08); }

    .editor { overflow: hidden; }
    .columnas { display: grid; grid-template-columns: minmax(200px, 280px) 1fr; }
    @media (max-width: 720px) { .columnas { grid-template-columns: 1fr; } }

    .cara { border-right: 1px solid var(--linea); background: rgba(43,33,23,.04); }
    @media (max-width: 720px) { .cara { border-right: none; border-bottom: 1px solid var(--linea); } }
    .cara-vacia { padding: 20px 14px; text-align: center; color: var(--sepia); }
    .cara-vacia p:last-child { font-size: 14px; font-style: italic; margin: 8px 0 0; }

    .formulario { padding: 20px 22px 24px; display: grid; gap: 12px; min-width: 0; }
    .formulario .rotulo { margin: 0; }

    .fila { display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); gap: 12px; }
    .campo { display: block; min-width: 0; }
    .campo--ancho { grid-column: 1 / -1; }
    .etiqueta {
      display: block; font-family: var(--dato); font-size: 10px; letter-spacing: .14em;
      text-transform: uppercase; color: var(--sepia); margin-bottom: 5px;
    }
    input, textarea, select {
      font: inherit; width: 100%; padding: 10px 12px;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-claro); color: var(--tinta);
    }
    textarea { resize: vertical; line-height: 1.5; }

    /* La casilla de «ya lo saben» va pegada a su campo, no en una columna
       aparte: así se decide mientras se escribe y no al final, de memoria. */
    .casilla {
      display: inline-flex; align-items: center; gap: 6px; margin-top: 5px;
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); cursor: pointer;
    }
    .casilla input { width: auto; padding: 0; accent-color: var(--musgo); }
    .casilla--fuerte { color: var(--vino); }
    .casilla--alta { align-self: end; margin-bottom: 11px; }
    .sellos { display: flex; flex-wrap: wrap; gap: 14px; margin-top: -4px; }

    .acciones { display: flex; gap: 8px; flex-wrap: wrap; }
    .boton--peligro { color: var(--vino); border-color: rgba(143,46,34,.4); }
    .boton--peligro:hover:not(:disabled) { background: rgba(143,46,34,.08); }

    .confirmar {
      border: 1px solid rgba(143,46,34,.4); border-radius: var(--radio);
      padding: 12px 14px; display: grid; gap: 10px; background: rgba(143,46,34,.05);
    }
    .confirmar p { margin: 0; color: var(--tinta); }

    /* ------------------------------------------------------------- tratos */
    .tratos-panel { border-top: 1px solid var(--linea); padding: 18px 22px 22px; }
    h2 { font-size: 18px; color: var(--tinta); }
    .ayuda { color: var(--sepia); font-size: 14px; font-style: italic; margin: 4px 0 12px; max-width: 62ch; }

    .lista { list-style: none; margin: 0 0 16px; padding: 0; display: grid; gap: 6px; }
    .trato {
      display: flex; align-items: baseline; flex-wrap: wrap; gap: 8px;
      padding: 7px 10px; border-radius: var(--radio);
      border-left: 2px solid var(--sepia); background: rgba(43,33,23,.04);
    }
    .trato-tipo {
      font-family: var(--dato); font-size: 9px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia);
    }
    .trato-quien { color: var(--tinta); font-weight: 600; }
    .trato-nota { color: var(--sepia-hondo); font-style: italic; font-size: 15px; }
    .trato-acc { margin-left: auto; display: flex; gap: 6px; }
    .trato--amistoso { border-left-color: var(--musgo); }
    .trato--amistoso .trato-tipo { color: var(--musgo); }
    .trato--enemigo { border-left-color: var(--vino); }
    .trato--enemigo .trato-tipo { color: var(--vino); }
    .trato--familiar { border-left-color: var(--oro); }
    .trato--familiar .trato-tipo { color: var(--oro); }

    .alta { display: grid; gap: 10px; border-top: 1px dashed var(--linea); padding-top: 14px; }

    .sello {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; padding: 4px 8px;
      border: 1px solid rgba(143,46,34,.4); border-radius: var(--radio);
      background: transparent; color: var(--vino); white-space: nowrap;
    }
    .sello:hover:not(:disabled) { background: rgba(143,46,34,.08); }
    .sello--visto { border-color: rgba(76,106,55,.5); color: var(--musgo); }
    .sello--visto:hover:not(:disabled) { background: rgba(76,106,55,.08); }
    .sello--mal { color: var(--sepia); border-color: var(--linea); }

    .mal { color: var(--vino); border-left: 2px solid var(--vino); padding: 6px 10px; margin: 0; }
  `,
})
export class PnjEditor {

  /** La ficha que se edita, o null para una nueva. */
  readonly pnj = input<Pnj | null>(null);
  readonly alineamientos = input<string[]>([]);
  readonly tratos = input<Trato[]>([]);
  /** Los personajes jugadores de la mesa. */
  readonly personajes = input<{ id: string; name: string }[]>([]);
  /** El resto del elenco, para apuntar tratos entre ellos. */
  readonly elencoOtros = input<Pnj[]>([]);

  readonly cambiado = output<Elenco>();
  /** Como `cambiado`, pero además dice cuál es la ficha recién creada. */
  readonly creado = output<Elenco>();
  readonly cerrar = output<void>();

  private readonly api = inject(ElencoService);

  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);
  readonly confirmando = signal(false);
  readonly nuevo = signal<TratoNuevo>({ ...TRATO_EN_BLANCO });

  /** Lo escrito a mano. Vacío hasta que el usuario toca algo: así la ficha que
   *  llega por input manda mientras no se edite y no hay dos verdades. */
  private readonly tocado = signal<Partial<Borrador>>({});

  /** El estado del formulario: la ficha de entrada con lo tecleado encima. */
  readonly b = computed<Borrador>(() => {
    const p = this.pnj();
    const base: Borrador = p
      ? {
          id: p.id,
          name: p.name,
          alias: p.alias ?? '',
          title: p.title ?? '',
          location: p.location ?? '',
          race: p.race ?? '',
          description: p.description ?? '',
          trivia: (p.trivia ?? []).join('\n'),
          alignment: p.alignment ?? '',
          reveal: p.reveal ?? { ...NADA_SABIDO },
        }
      : {
          id: null, name: '', alias: '', title: '', location: '', race: '',
          description: '', trivia: '', alignment: '', reveal: { ...NADA_SABIDO },
        };
    return { ...base, ...this.tocado() };
  });

  /** Los campos de texto, con su etiqueta y su pista. El nombre y el alias van
   *  aparte arriba porque son un par, no dos campos sueltos. */
  readonly textos = computed(() => [
    { campo: 'title'       as CampoPnj, etiqueta: 'Título (opcional)', largo: false, pista: 'Capataz del pozo tercero' },
    { campo: 'location'    as CampoPnj, etiqueta: 'Ubicación',         largo: false, pista: 'Dorakan' },
    { campo: 'race'        as CampoPnj, etiqueta: 'Raza',              largo: false, pista: 'Enano' },
    { campo: 'alignment'   as CampoPnj, etiqueta: 'Alineamiento',      largo: false, pista: 'Legal neutral' },
    { campo: 'description' as CampoPnj, etiqueta: 'Descripción',       largo: true,  pista: 'Quién es y qué pinta tiene.' },
    { campo: 'trivia'      as CampoPnj, etiqueta: 'Curiosidades',      largo: true,  pista: 'Una por línea.' },
  ]);

  /** El resto del elenco, sin él mismo: nadie se relaciona consigo. */
  readonly otros = computed(() => {
    const yo = this.pnj()?.id;
    return this.elencoOtros().filter(p => p.id !== yo);
  });

  readonly tratoListo = computed(() => {
    const n = this.nuevo();
    return n.destino !== 'libre' || n.nombre.trim().length > 0;
  });

  nombre(k: Trato): string { return NOMBRES[k] ?? k; }

  valor(campo: CampoPnj): string {
    const b = this.b();
    return (b as unknown as Record<string, string>)[campo] ?? '';
  }

  sabido(campo: CampoPnj): boolean {
    return this.b().reveal[campo] ?? false;
  }

  poner(campo: string, valor: string): void {
    this.tocado.update(t => ({ ...t, [campo]: valor }));
  }

  sellar(campo: CampoPnj, valor: boolean): void {
    const reveal = { ...this.b().reveal, [campo]: valor };
    this.tocado.update(t => ({ ...t, reveal }));
  }

  ponerTrato(campo: keyof TratoNuevo, valor: string | boolean): void {
    this.nuevo.update(n => ({ ...n, [campo]: valor }));
  }

  // ------------------------------------------------------------------ envío

  guardar(): void {
    const b = this.b();
    if (!b.name.trim() || this.ocupado()) return;

    const req = {
      name: b.name.trim(),
      alias: b.alias.trim(),
      title: b.title.trim(),
      location: b.location.trim(),
      race: b.race.trim(),
      description: b.description.trim(),
      trivia: b.trivia.trim(),
      alignment: b.alignment.trim(),
      reveal: b.reveal,
    };

    this.ocupado.set(true);
    this.error.set(null);
    const nueva = b.id === null;
    const peticion = nueva ? this.api.crear(req) : this.api.editar(b.id!, req);
    peticion.subscribe({
      next: r => {
        this.ocupado.set(false);
        this.tocado.set({});
        if (nueva) this.creado.emit(r); else this.cambiado.emit(r);
      },
      error: err => {
        this.ocupado.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido guardar la ficha.');
      },
    });
  }

  eliminar(): void {
    const id = this.b().id;
    if (!id || this.ocupado()) return;
    this.ocupado.set(true);
    this.api.eliminar(id).subscribe({
      next: r => { this.ocupado.set(false); this.confirmando.set(false); this.cambiado.emit(r); this.cerrar.emit(); },
      error: err => {
        this.ocupado.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido borrar la ficha.');
      },
    });
  }

  // ----------------------------------------------------------------- tratos

  anadirTrato(): void {
    const id = this.pnj()?.id;
    const n = this.nuevo();
    if (!id || !this.tratoListo() || this.ocupado()) return;

    const req = {
      kind: n.kind,
      note: n.note.trim(),
      revealed: n.revealed,
      ...(n.destino.startsWith('pnj:') ? { otherNpcId: n.destino.slice(4) }
        : n.destino.startsWith('pj:')  ? { characterId: n.destino.slice(3) }
        : { otherName: n.nombre.trim() }),
    };

    this.ocupado.set(true);
    this.error.set(null);
    this.api.anadirTrato(id, req).subscribe({
      next: r => {
        this.ocupado.set(false);
        this.nuevo.set({ ...TRATO_EN_BLANCO });
        this.cambiado.emit(r);
      },
      error: err => {
        this.ocupado.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido apuntar el trato.');
      },
    });
  }

  alternarTrato(t: RelacionPnj): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.api.editarTrato(t.id, { revealed: !t.revealed }).subscribe({
      next: r => { this.ocupado.set(false); this.cambiado.emit(r); },
      error: () => { this.ocupado.set(false); this.error.set('No se ha podido cambiar el sello.'); },
    });
  }

  quitarTrato(t: RelacionPnj): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.api.quitarTrato(t.id).subscribe({
      next: r => { this.ocupado.set(false); this.cambiado.emit(r); },
      error: () => { this.ocupado.set(false); this.error.set('No se ha podido quitar el trato.'); },
    });
  }
}
