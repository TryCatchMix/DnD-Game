import { Component, computed, inject, input, output, signal } from '@angular/core';

import { ElencoService } from '../../core/cast.service';
import { Elenco, PnjSuelto } from '../../core/cast.types';
import { Retrato } from './portrait';

/**
 * EL CAJÓN DE LOS QUE SE QUEDARON SIN MESA.
 *
 * Borrar una campaña no borra su elenco: las fichas se quedan sueltas y
 * esperan aquí a que su autor las traiga a otra partida. Es lo más caro de
 * escribir de una campaña —la ficha entera de cada cara, sus tratos, el
 * retrato— y lo que más se reutiliza: el tabernero que sabía demasiado vale
 * igual en la partida siguiente.
 *
 * DOS COSAS QUE CONVIENE SABER MIRANDO ESTA PANTALLA:
 *
 * 1. AQUÍ NO HAY SELLOS. Quien mira es quien escribió las fichas, así que se
 *    enseña todo en claro: el nombre de verdad, la cara, el alineamiento. Los
 *    secretos son de una mesa, y estas fichas no tienen ninguna.
 *
 * 2. AL TRAERLAS SE RESELLAN. Entran a la mesa nueva con todos los campos
 *    tapados y sin salir al elenco, aunque en su campaña anterior estuvieran
 *    destapadas de arriba abajo. Los jugadores de esta partida no han conocido
 *    a nadie todavía. Se avisa en el diálogo porque es lo único que sorprende
 *    de la operación: el texto está intacto, lo que se reinicia es lo que se
 *    sabe.
 */
@Component({
  selector: 'arc-elenco-suelto',
  imports: [Retrato],
  template: `
    <div class="velo" (click)="salir()">
      <div class="hoja panel" role="dialog" aria-modal="true" aria-labelledby="elenco-suelto-h"
           (click)="$event.stopPropagation()">

        <header class="cabeza">
          <p class="rotulo">Fichas sin mesa</p>
          <h2 id="elenco-suelto-h">El elenco suelto</h2>
          <p class="letra-pequena">
            Se quedaron aquí al borrarse su campaña. Tráete a quien vaya a salir
            en esta partida: la ficha entra entera pero <strong>sellada de
            nuevo</strong>, y la vas destapando como a cualquier otra.
          </p>
        </header>

        @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

        @if (sueltos().length === 0) {
          <p class="estado">
            No tienes fichas sueltas. Aquí caen las del elenco de una campaña
            cuando la borras.
          </p>
        } @else {
          <ul class="fichas">
            @for (p of sueltos(); track p.id) {
              <li>
                <article class="carta" [class.carta--puesta]="elegido(p.id)">
                  <label class="tapa">
                    <input type="checkbox" class="marca"
                           [checked]="elegido(p.id)" [disabled]="ocupado()"
                           (change)="alternar(p.id)"
                           [attr.aria-label]="'Traer a ' + p.name" />
                    <arc-retrato [npcId]="p.id" [hay]="p.portrait" [nombre]="p.name"
                                 fuente="suelto" />
                  </label>

                  <div class="cuerpo">
                    <h3>{{ p.name }}</h3>
                    @if (p.title) { <p class="cargo">{{ p.title }}</p> }
                    <p class="pie">{{ resumen(p) }}</p>
                    @if (p.campanaPerdida) {
                      <p class="procede">de «{{ p.campanaPerdida }}»</p>
                    }
                    @if (descartando() === p.id) {
                      <p class="ojo">
                        Esta sí se borra para siempre, con sus tratos y su retrato.
                      </p>
                      <span class="acc">
                        <button class="mini mini--mal" [disabled]="ocupado()"
                                (click)="descartar(p)">Sí, tirarla</button>
                        <button class="mini" [disabled]="ocupado()"
                                (click)="descartando.set(null)">No</button>
                      </span>
                    } @else {
                      <button class="mini mini--mal" [disabled]="ocupado()"
                              (click)="descartando.set(p.id)">Descartar</button>
                    }
                  </div>
                </article>
              </li>
            }
          </ul>
        }

        <div class="acciones">
          @if (sueltos().length > 0) {
            <button class="boton boton--lacre" [disabled]="ocupado() || elegidos().length === 0"
                    (click)="traer()">
              {{ ocupado() && !descartando()
                  ? 'Trayéndolas…'
                  : elegidos().length === 0
                    ? 'Elige a quién traer'
                    : 'Traer ' + elegidos().length + ' al elenco' }}
            </button>
          }
          <button class="boton" [disabled]="ocupado()" (click)="salir()">Cerrar</button>
        </div>
      </div>
    </div>
  `,
  host: { '(document:keydown.escape)': 'salir()' },
  styles: `
    .velo {
      position: fixed; inset: 0; z-index: 60;
      background: rgba(15, 11, 5, .82); backdrop-filter: blur(3px);
      display: grid; place-items: center; padding: 18px;
    }
    /* Alto acotado y la lista con su propio scroll: el cajón puede tener
       treinta caras y las acciones no se pueden ir al fondo de la página. */
    .panel {
      width: min(760px, 100%); max-height: min(86vh, 720px);
      padding: 22px 24px 20px;
      display: flex; flex-direction: column; gap: 14px;
    }

    .cabeza { display: grid; gap: 2px; }
    .cabeza .rotulo { color: var(--sepia); }
    .cabeza h2 { font-size: 23px; color: var(--tinta); margin: 4px 0 0; }
    .letra-pequena { color: var(--sepia-hondo); font-size: 15px; margin: 6px 0 0; max-width: 62ch; }
    .letra-pequena strong { color: var(--vino); font-weight: 400; }

    .fichas {
      list-style: none; margin: 0; padding: 2px;
      overflow-y: auto; flex: 1;
      display: grid; gap: 14px;
      grid-template-columns: repeat(auto-fill, minmax(152px, 1fr));
    }

    .carta {
      display: flex; flex-direction: column; overflow: hidden;
      border: 1px solid var(--linea); border-radius: var(--radio);
      background: rgba(239,228,205,.04);
      transition: border-color .12s, box-shadow .12s;
    }
    /* Elegida para venir: se marca con el lacre de la casa, no con un check
       azul de formulario. */
    .carta--puesta {
      border-color: rgba(143,46,34,.55);
      box-shadow: 0 0 0 1px rgba(143,46,34,.35);
    }

    .tapa { display: block; position: relative; cursor: pointer; }
    .marca {
      position: absolute; top: 8px; left: 8px; z-index: 2;
      width: 20px; height: 20px; cursor: pointer;
      accent-color: var(--vino);
    }

    .cuerpo { padding: 9px 11px 11px; display: grid; gap: 3px; justify-items: start; }
    h3 {
      font-family: var(--display); font-size: 17px; color: var(--tinta);
      margin: 0; line-height: 1.2;
    }
    .cargo { font-size: 13px; color: var(--sepia-hondo); font-style: italic; margin: 0; }
    .pie, .procede {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); margin: 4px 0 0;
    }
    .procede { color: var(--sepia-claro); font-style: italic; text-transform: none; letter-spacing: .04em; }
    .ojo { font-size: 13px; color: var(--vino); margin: 6px 0 0; }
    .acc { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 4px; }

    .mini {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; padding: 4px 8px; cursor: pointer; margin-top: 5px;
      background: transparent; color: var(--sepia);
      border: 1px solid var(--linea); border-radius: var(--radio);
    }
    .mini:hover:not(:disabled) { background: rgba(143,46,34,.08); }
    .mini:disabled { opacity: .45; cursor: default; }
    .mini--mal:hover:not(:disabled) { color: var(--vino); border-color: rgba(143,46,34,.45); }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; }
    .estado { font-style: italic; color: var(--sepia-hondo); margin: 0; max-width: 58ch; }
    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 0; }
  `,
})
export class ElencoSueltoPanel {

  /** El cajón, que lo carga y lo guarda la pantalla del elenco. */
  readonly sueltos = input.required<PnjSuelto[]>();

  /** Las que ya están en la mesa: el elenco recién actualizado. */
  readonly traidos = output<Elenco>();

  /** El cajón después de tirar una ficha. */
  readonly cambiados = output<PnjSuelto[]>();

  readonly cerrar = output<void>();

  private readonly api = inject(ElencoService);

  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);
  /** El id de la que está preguntando si de verdad se tira. */
  readonly descartando = signal<string | null>(null);

  private readonly marcados = signal<ReadonlySet<string>>(new Set());

  readonly elegidos = computed(() => [...this.marcados()]);

  elegido(id: string): boolean {
    return this.marcados().has(id);
  }

  /** El velo, el Escape y el botón de cerrar, todos por aquí: irse a media
   *  operación deja el cajón diciendo una cosa y la mesa otra. */
  salir(): void {
    if (!this.ocupado()) this.cerrar.emit();
  }

  alternar(id: string): void {
    const s = new Set(this.marcados());
    if (!s.delete(id)) s.add(id);
    this.marcados.set(s);
  }

  traer(): void {
    const ids = this.elegidos();
    if (this.ocupado() || ids.length === 0) return;
    this.ocupado.set(true);
    this.error.set(null);
    this.api.traer(ids).subscribe({
      next: r => {
        this.ocupado.set(false);
        this.marcados.set(new Set());
        // Lo que ya está en la mesa sale del cajón sin volver a preguntarlo.
        this.cambiados.emit(this.sueltos().filter(p => !ids.includes(p.id)));
        this.traidos.emit(r);
      },
      error: () => {
        this.ocupado.set(false);
        this.error.set('No se han podido traer esas fichas al elenco.');
      },
    });
  }

  descartar(p: PnjSuelto): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.error.set(null);
    this.api.descartar(p.id).subscribe({
      next: r => {
        this.ocupado.set(false);
        this.descartando.set(null);
        const s = new Set(this.marcados());
        s.delete(p.id);
        this.marcados.set(s);
        this.cambiados.emit(r.npcs);
      },
      error: () => {
        this.ocupado.set(false);
        this.error.set(`No se ha podido descartar a ${p.name}.`);
      },
    });
  }

  /** La línea de abajo de la tarjeta: lo poco que haya, en orden. */
  resumen(p: PnjSuelto): string {
    const trozos = [p.race, p.location].filter(Boolean) as string[];
    if (p.relaciones > 0) trozos.push(`${p.relaciones} trato(s)`);
    return trozos.length ? trozos.join(' · ') : 'Sin más datos';
  }
}
