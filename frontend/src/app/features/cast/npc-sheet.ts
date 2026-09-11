import { Component, computed, inject, input, output, signal } from '@angular/core';
import { Observable } from 'rxjs';

import { ElencoService } from '../../core/cast.service';
import { CampoPnj, Elenco, Pnj, RelacionPnj, Trato } from '../../core/cast.types';
import { RetratoPanel } from './portrait-panel';

/** El nombre de cada trato, para no repetirlo en cuatro sitios. */
const TRATOS: Record<Trato, string> = {
  amistoso: 'Amistoso',
  neutral: 'Neutral',
  enemigo: 'Enemigo',
  familiar: 'Familia',
};

/**
 * El expediente de un PNJ: el retrato grande a la izquierda y lo que se sabe
 * de él a la derecha.
 *
 * La pieza que define esta pantalla es el SELLO que el máster ve junto a cada
 * campo. Revelar es la operación que de verdad se usa jugando —alguien
 * pregunta el nombre y hay que decidirlo en ese momento—, así que es un botón
 * al lado del dato y no una casilla enterrada en un formulario.
 *
 * El jugador no ve sellos: lo que aún no sabe sencillamente no ha llegado a su
 * navegador. Lo único que se le cuenta es CUÁNTAS cosas quedan, y eso es a
 * propósito: un expediente a medias con "quedan tres cosas por saber" es un
 * gancho; uno a medias sin decirlo parece una ficha mal rellenada.
 */
@Component({
  selector: 'arc-pnj-ficha',
  imports: [RetratoPanel],
  template: `
    <div class="volver">
      <button class="boton" (click)="cerrar.emit()">← Volver al elenco</button>
      @if (dm()) {
        <span class="acc-dm">
          <button class="boton" (click)="editar.emit()">Editar ficha</button>
          @if (pnj().porDescubrir > 0) {
            <button class="boton" [disabled]="ocupado()" (click)="revelarTodo()">
              Revelarlo todo
            </button>
          }
        </span>
      }
    </div>

    <article class="hoja expediente">

      <!-- ---------------------------------------------------- el retrato -->
      <div class="cara">
        <arc-retrato-panel [pnj]="pnj()" [dm]="dm()" (cambiado)="cambiado.emit($event)" />
      </div>

      <!-- ------------------------------------------------------ los datos -->
      <div class="datos">

        <header class="titular">
          @if (pnj().title) { <p class="rotulo">{{ pnj().title }}</p> }
          <h1 [class.anonimo]="anonimo()">{{ pnj().name }}</h1>
          @if (dm()) {
            <div class="sellos">
              @if (r(); as rev) {
                <button class="sello" [class.sello--visto]="rev.name"
                        [disabled]="ocupado()" (click)="revelar('name')">
                  {{ rev.name ? 'Nombre dicho' : 'Se le conoce como «' + (pnj().alias ?? '') + '»' }}
                </button>
                <button class="sello" [class.sello--visto]="rev.listed"
                        [disabled]="ocupado()" (click)="revelar('listed')">
                  {{ rev.listed ? 'En el elenco' : 'Aún no ha salido' }}
                </button>
                @if (pnj().title || rev.title) {
                  <button class="sello" [class.sello--visto]="rev.title"
                          [disabled]="ocupado()" (click)="revelar('title')">Título</button>
                }
              }
            </div>
          }
        </header>

        <!-- los tres datos de cabecera -->
        <dl class="datos-rapidos">
          @for (d of rapidos(); track d.campo) {
            @if (d.valor || dm()) {
              <div class="dato-fila">
                <dt>{{ d.etiqueta }}</dt>
                <dd>{{ d.valor || '—' }}</dd>
                @if (dm() && d.valor) {
                  <button class="sello" [class.sello--visto]="d.visto"
                          [disabled]="ocupado()" (click)="revelar(d.campo)">
                    {{ d.visto ? 'Sabido' : 'Sellado' }}
                  </button>
                }
              </div>
            }
          }
        </dl>

        <!-- descripción -->
        @if (pnj().description || dm()) {
          <section class="bloque">
            <div class="bloque-cab">
              <h2>Descripción</h2>
              @if (dm() && pnj().description) {
                <button class="sello" [class.sello--visto]="r()!.description"
                        [disabled]="ocupado()" (click)="revelar('description')">
                  {{ r()!.description ? 'Sabido' : 'Sellado' }}
                </button>
              }
            </div>
            @if (pnj().description) {
              <p class="prosa">{{ pnj().description }}</p>
            } @else {
              <p class="hueco">Sin escribir.</p>
            }
          </section>
        }

        <!-- curiosidades -->
        @if (curiosidades().length || dm()) {
          <section class="bloque">
            <div class="bloque-cab">
              <h2>Curiosidades</h2>
              @if (dm() && curiosidades().length) {
                <button class="sello" [class.sello--visto]="r()!.trivia"
                        [disabled]="ocupado()" (click)="revelar('trivia')">
                  {{ r()!.trivia ? 'Sabido' : 'Sellado' }}
                </button>
              }
            </div>
            @if (curiosidades().length) {
              <ul class="curiosidades">
                @for (c of curiosidades(); track c) { <li>{{ c }}</li> }
              </ul>
            } @else {
              <p class="hueco">Sin apuntar nada.</p>
            }
          </section>
        }

        <!-- tratos -->
        @if (pnj().relations.length || dm()) {
          <section class="bloque">
            <div class="bloque-cab"><h2>Con quién se trata</h2></div>
            @if (pnj().relations.length) {
              <ul class="tratos">
                @for (t of pnj().relations; track t.id) {
                  <li [class]="'trato trato--' + t.kind">
                    <span class="trato-tipo">{{ nombreTrato(t) }}</span>
                    <span class="trato-quien">{{ t.who }}</span>
                    @if (t.note) { <span class="trato-nota">{{ t.note }}</span> }
                    @if (dm()) {
                      <button class="sello" [class.sello--visto]="t.revealed"
                              [disabled]="ocupado()" (click)="revelarTrato(t)">
                        {{ t.revealed ? 'Sabido' : 'Sellado' }}
                      </button>
                    }
                  </li>
                }
              </ul>
            } @else {
              <p class="hueco">No se le conoce trato con nadie.</p>
            }
          </section>
        }

        @if (pnj().porDescubrir > 0) {
          <p class="pendiente">
            {{ dm()
                ? 'Te quedan ' + pnj().porDescubrir + ' cosa(s) por contarles.'
                : 'Quedan ' + pnj().porDescubrir + ' cosa(s) por descubrir.' }}
          </p>
        }

        @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }
      </div>
    </article>
  `,
  styles: `
    .volver { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 14px; }
    .acc-dm { display: flex; gap: 8px; margin-left: auto; }
    .volver .boton { color: var(--pergamino); border-color: var(--linea-noche); }
    .volver .boton:hover:not(:disabled) { background: rgba(239,228,205,.08); }

    .expediente {
      display: grid;
      grid-template-columns: minmax(200px, 300px) 1fr;
      gap: 0;
      overflow: hidden;
    }
    @media (max-width: 720px) {
      .expediente { grid-template-columns: 1fr; }
    }

    /* ------------------------------------------------------------- la cara */
    .cara { border-right: 1px solid var(--linea); background: rgba(43,33,23,.04); }
    @media (max-width: 720px) { .cara { border-right: none; } }

    /* ------------------------------------------------------------ el texto */
    .datos { padding: 20px 22px 24px; min-width: 0; }
    .titular { margin-bottom: 16px; }
    .titular .rotulo { margin: 0 0 4px; }
    h1 { font-size: 30px; color: var(--tinta); line-height: 1.15; }
    /* Un nombre que todavía no es un nombre se lee distinto: es un apodo. */
    h1.anonimo { font-style: italic; color: var(--sepia-hondo); }
    .sellos { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px; }

    .datos-rapidos {
      display: grid; gap: 0; margin: 0 0 18px;
      border-top: 1px solid var(--linea-clara);
    }
    .dato-fila {
      display: flex; align-items: baseline; gap: 10px;
      padding: 8px 0; border-bottom: 1px solid var(--linea-clara);
    }
    dt {
      font-family: var(--dato); font-size: 10px; letter-spacing: .14em;
      text-transform: uppercase; color: var(--sepia);
      flex: 0 0 96px;
    }
    dd { margin: 0; color: var(--tinta); flex: 1; min-width: 0; }

    .bloque { margin-bottom: 18px; }
    .bloque-cab { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
    h2 { font-size: 17px; color: var(--tinta); }
    .prosa { color: var(--sepia-hondo); line-height: 1.6; margin: 0; white-space: pre-wrap; }
    .hueco { color: var(--sepia-claro); font-style: italic; margin: 0; font-size: 15px; }

    .curiosidades { margin: 0; padding-left: 18px; color: var(--sepia-hondo); }
    .curiosidades li { margin: 3px 0; line-height: 1.5; }

    /* -------------------------------------------------------------- tratos */
    .tratos { list-style: none; margin: 0; padding: 0; display: grid; gap: 6px; }
    .trato {
      display: flex; align-items: baseline; flex-wrap: wrap; gap: 8px;
      padding: 7px 10px; border-radius: var(--radio);
      border-left: 2px solid var(--sepia);
      background: rgba(43,33,23,.04);
    }
    .trato-tipo {
      font-family: var(--dato); font-size: 9px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia);
    }
    .trato-quien { color: var(--tinta); font-weight: 600; }
    .trato-nota { color: var(--sepia-hondo); font-style: italic; font-size: 15px; }
    /* El color dice el trato antes de leer el nombre: es el mismo idioma que
       el lacre de una tirada. */
    .trato--amistoso { border-left-color: var(--musgo); }
    .trato--amistoso .trato-tipo { color: var(--musgo); }
    .trato--enemigo { border-left-color: var(--vino); }
    .trato--enemigo .trato-tipo { color: var(--vino); }
    .trato--familiar { border-left-color: var(--oro); }
    .trato--familiar .trato-tipo { color: var(--oro); }

    .pendiente {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia);
      border-top: 1px solid var(--linea-clara); padding-top: 10px; margin: 18px 0 0;
    }

    /* ------------------------------------------------------------- botones */
    .sello {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; padding: 4px 8px;
      border: 1px solid var(--linea); border-radius: var(--radio);
      background: transparent; color: var(--sepia);
      white-space: nowrap;
    }
    .sello { border-color: rgba(143,46,34,.4); color: var(--vino); }
    .sello:hover:not(:disabled) { background: rgba(143,46,34,.08); }
    .sello--visto { border-color: rgba(76,106,55,.5); color: var(--musgo); }
    .sello--visto:hover:not(:disabled) { background: rgba(76,106,55,.08); }

    .mal { color: var(--vino); border-left: 2px solid var(--vino); padding: 6px 10px; margin: 12px 0 0; }
  `,
})
export class PnjFicha {

  readonly pnj = input.required<Pnj>();
  readonly dm = input(false);

  /** Cualquier cambio devuelve el elenco entero: la página solo repinta. */
  readonly cambiado = output<Elenco>();
  readonly cerrar = output<void>();
  readonly editar = output<void>();

  private readonly elenco = inject(ElencoService);

  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);

  /** Los sellos del máster; null cuando mira un jugador. */
  readonly r = computed(() => this.pnj().reveal);

  /** El nombre que se enseña no es el suyo todavía. */
  readonly anonimo = computed(() => {
    const rev = this.r();
    return rev ? !rev.name : false;
  });

  readonly curiosidades = computed(() => this.pnj().trivia ?? []);

  /** Los tres datos de cabecera, con su sello y su etiqueta. */
  readonly rapidos = computed(() => {
    const p = this.pnj();
    const rev = p.reveal;
    return [
      { campo: 'location'  as CampoPnj, etiqueta: 'Ubicación',   valor: p.location,  visto: rev?.location ?? true },
      { campo: 'race'      as CampoPnj, etiqueta: 'Raza',        valor: p.race,      visto: rev?.race ?? true },
      { campo: 'alignment' as CampoPnj, etiqueta: 'Alineamiento', valor: p.alignment, visto: rev?.alignment ?? true },
    ];
  });

  nombreTrato(t: RelacionPnj): string {
    return TRATOS[t.kind] ?? t.kind;
  }

  // ------------------------------------------------------------------------

  revelar(campo: CampoPnj): void {
    this.pedir(this.elenco.revelar(this.pnj().id, campo));
  }

  revelarTodo(): void {
    this.pedir(this.elenco.revelarTodo(this.pnj().id));
  }

  revelarTrato(t: RelacionPnj): void {
    this.pedir(this.elenco.editarTrato(t.id, { revealed: !t.revealed }));
  }

  /** Todas las llamadas de esta ficha se parecen: bloquear, pedir, repintar. */
  private pedir(obs: Observable<Elenco>): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.error.set(null);
    obs.subscribe({
      next: r => { this.ocupado.set(false); this.cambiado.emit(r); },
      error: (err: { error?: { message?: string } }) => {
        this.ocupado.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido guardar el cambio.');
      },
    });
  }
}
