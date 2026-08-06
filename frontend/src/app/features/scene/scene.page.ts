import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { JuegoService } from '../../core/juego.service';
import { ResolutionView, SceneOption, SceneView } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

@Component({
  selector: 'arc-scene',
  imports: [NavBar],
  template: `
    <arc-nav [personajeId]="personajeId()" />
    <div class="contenedor">

      @if (cargando()) {
        <p class="estado">Abriendo el expediente…</p>
      }

      @if (escena(); as sc) {
        <header class="cabecera">
          <p class="rotulo">
            {{ sc.questTitle }} · escena {{ sc.sceneOrdinal }} de {{ sc.sceneCount }}
          </p>
          <h1>{{ sc.title }}</h1>
        </header>

        <div class="hoja relato">
          <p>{{ sc.body }}</p>
        </div>

        @if (sc.waitingFor; as espera) {
          <p class="camino">
            Sigues en camino. Vuelve en <strong>{{ espera }}</strong>.
          </p>
        }

        @if (!resolucion() && !sc.waitingFor) {
          <p class="rotulo separador">Qué haces</p>
          <ul class="opciones">
            @for (o of sc.options; track o.id) {
              <li>
                <button class="hoja opcion"
                        [disabled]="!o.affordable || eligiendo() !== null"
                        (click)="elegir(o)">
                  <span class="etiqueta">{{ o.label }}</span>

                  <span class="linea-datos">
                    @if (o.skill) {
                      <span class="dato">{{ o.skill }} · CD {{ o.dc }}</span>
                    } @else {
                      <span class="dato">Sin tirada</span>
                    }

                    @if (o.successChance !== null) {
                      <span class="sep">·</span>
                      <span class="dato">{{ o.successChance }} % éxito</span>
                    }

                    <span class="sep">·</span>
                    <span class="dato" [class.gratis]="o.vigorCost === 0">
                      {{ o.vigorCost === 0 ? 'No gasta Vigor' : 'Vigor ' + o.vigorCost }}
                    </span>

                    @if (o.risk) {
                      <span class="sep">·</span>
                      <span class="dato riesgo" [class]="'riesgo--' + o.risk.toLowerCase()">
                        {{ riesgoEnPalabras(o.risk) }}
                      </span>
                    }
                  </span>

                  @if (o.note) { <span class="nota">{{ o.note }}</span> }
                  @if (!o.affordable) { <span class="nota nota--mal">Te falta Vigor</span> }
                </button>
              </li>
            }
          </ul>
        }
      }

      <!-- ================= EXPEDIENTE SELLADO ================= -->
      @if (resolucion(); as r) {
        <article class="hoja expediente" [class]="'grado--' + (r.roll?.grade ?? 4)">

          @if (r.roll; as roll) {
            <div class="lacre-grado" aria-hidden="true">
              <span class="numero">{{ roll.grade }}</span>
              <span class="de">de 5</span>
            </div>

            <p class="rotulo">Resultado cotejado</p>
            <h2 class="veredicto">{{ roll.gradeLabel }}</h2>

            <!-- El desglose completo. Enseñarlo es lo que hace que un fallo se
                 sienta justo en vez de arbitrario. -->
            <dl class="cuentas">
              <div class="cuenta">
                <dt>d20</dt>
                <dd class="tirada">{{ roll.d20 }}</dd>
              </div>
              @for (m of roll.breakdown; track m.label) {
                <div class="cuenta">
                  <dt>{{ m.label }}</dt>
                  <dd [class.menos]="m.value < 0">
                    {{ m.value > 0 ? '+' : '' }}{{ m.value }}
                  </dd>
                </div>
              }
              <div class="cuenta cuenta--total">
                <dt>Total contra CD {{ roll.dc }}</dt>
                <dd>{{ roll.total }}</dd>
              </div>
            </dl>
          }

          <p class="narrativa">{{ r.narrative }}</p>

          @if (r.changes.length > 0) {
            <ul class="cambios">
              @for (c of r.changes; track c) { <li>{{ c }}</li> }
            </ul>
          }

          @if (r.finished) {
            <p class="cierre">El encargo queda cerrado.</p>
            <button class="boton boton--lacre" (click)="volverAlTablon()">
              Volver al tablón
            </button>
          } @else if (r.waitingFor) {
            <p class="cierre">
              Sigues en camino. Vuelve en <strong>{{ r.waitingFor }}</strong>.
            </p>
            <button class="boton" (click)="volverAlTablon()">Volver al tablón</button>
          } @else {
            <button class="boton boton--lacre" (click)="continuar()">Continuar</button>
          }
        </article>
      }

      @if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      }
    </div>
  `,
  styles: `
    .cabecera { margin-bottom: 16px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 27px; color: var(--pergamino); margin-top: 5px; line-height: 1.2; }

    .relato { padding: 22px 22px 20px; }
    .relato p { margin: 0; font-size: 18px; line-height: 1.6; color: var(--tinta); }

    .camino {
      font-family: var(--dato);
      font-size: 11px;
      letter-spacing: .06em;
      color: var(--oro);
      border-left: 2px solid var(--oro);
      padding: 8px 12px;
      margin: 16px 0 0;
      background: rgba(157,122,47,.08);
    }

    .separador { margin: 26px 0 12px; color: var(--sepia-claro); }

    .opciones { list-style: none; margin: 0; padding: 0; display: grid; gap: 12px; }

    .opcion {
      display: block;
      width: 100%;
      text-align: left;
      padding: 16px 18px;
      color: var(--tinta);
      transition: transform .12s ease, box-shadow .12s ease;
    }
    .opcion:hover:not(:disabled) {
      transform: translateY(-1px);
      box-shadow: 0 1px 0 rgba(255,255,255,.35) inset,
                  0 16px 32px rgba(0,0,0,.5);
    }
    .opcion:disabled { opacity: .45; }

    .etiqueta {
      display: block;
      font-family: var(--cuerpo);
      font-size: 18px;
      line-height: 1.35;
      margin-bottom: 8px;
    }

    .linea-datos {
      display: flex; flex-wrap: wrap; align-items: center; gap: 6px;
      color: var(--sepia);
    }
    .sep { color: var(--linea-fuerte); }
    .gratis { color: var(--musgo); }

    .riesgo--high { color: var(--vino); }
    .riesgo--medium { color: var(--oro); }
    .riesgo--low { color: var(--musgo); }

    .nota {
      display: block;
      margin-top: 7px;
      font-style: italic;
      font-size: 14px;
      color: var(--sepia);
    }
    .nota--mal { color: var(--vino); font-style: normal; }

    /* ----------------------------- expediente ----------------------------- */

    .expediente {
      margin-top: 22px;
      padding: 34px 24px 24px;
      position: relative;
      border-top: 3px solid var(--linea-fuerte);
    }

    /* El sello lacrado con el grado. Es la firma de toda la pantalla: el
       resultado no "aparece", queda ESTAMPADO en el expediente. */
    .lacre-grado {
      position: absolute;
      top: -20px; right: 22px;
      width: 58px; height: 58px;
      border-radius: 50%;
      display: grid; place-content: center; gap: 0;
      background: var(--tinta);
      border: 1px solid rgba(0,0,0,.4);
      box-shadow: 0 3px 9px rgba(0,0,0,.5),
                  0 2px 0 rgba(255,255,255,.12) inset;
      transform: rotate(-5deg);
    }
    .lacre-grado .numero {
      font-family: var(--display);
      font-size: 25px;
      line-height: 1;
      color: var(--pergamino);
      text-align: center;
    }
    .lacre-grado .de {
      font-family: var(--dato);
      font-size: 8px;
      letter-spacing: .14em;
      color: var(--sepia-claro);
      text-align: center;
    }

    /* El color del lacre cuenta el resultado antes de leer nada. */
    .grado--1 .lacre-grado, .grado--2 .lacre-grado { background: var(--vino); }
    .grado--3 .lacre-grado { background: var(--oro); }
    .grado--4 .lacre-grado, .grado--5 .lacre-grado { background: var(--musgo); }

    .veredicto {
      font-size: 26px;
      color: var(--tinta);
      margin: 4px 0 18px;
      padding-right: 70px;
    }

    .cuentas {
      margin: 0 0 20px;
      border-top: 1px solid var(--linea);
      border-bottom: 1px solid var(--linea);
      padding: 4px 0;
    }
    .cuenta {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      gap: 12px;
      padding: 5px 0;
      font-family: var(--dato);
      font-size: 11px;
      letter-spacing: .04em;
    }
    .cuenta dt { color: var(--sepia); }
    .cuenta dd { margin: 0; color: var(--tinta); font-variant-numeric: tabular-nums; }
    .cuenta .tirada { font-size: 15px; }
    .cuenta .menos { color: var(--vino); }
    .cuenta--total {
      border-top: 1px solid var(--linea-clara);
      margin-top: 4px;
      padding-top: 8px;
    }
    .cuenta--total dt, .cuenta--total dd { color: var(--tinta); font-size: 13px; }

    .narrativa {
      font-size: 18px;
      line-height: 1.6;
      color: var(--tinta);
      margin: 0 0 16px;
    }

    .cambios { list-style: none; margin: 0 0 18px; padding: 0; display: grid; gap: 6px; }
    .cambios li {
      font-family: var(--dato);
      font-size: 11px;
      letter-spacing: .04em;
      color: var(--sepia-hondo);
      border-left: 2px solid var(--oro);
      padding: 4px 10px;
      background: rgba(157,122,47,.07);
    }

    .cierre {
      font-style: italic;
      color: var(--sepia);
      margin: 0 0 14px;
    }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 24px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class ScenePage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly router = inject(Router);

  readonly escena = signal<SceneView | null>(null);
  readonly resolucion = signal<ResolutionView | null>(null);
  readonly cargando = signal(true);
  readonly eligiendo = signal<string | null>(null);
  readonly error = signal<string | null>(null);

  ngOnInit(): void { this.cargarEscena(); }

  elegir(o: SceneOption): void {
    if (this.eligiendo()) return;

    this.eligiendo.set(o.id);
    this.error.set(null);

    this.juego.elegir(this.personajeId(), o.id).subscribe({
      next: r => {
        this.eligiendo.set(null);
        this.resolucion.set(r);
      },
      error: err => {
        this.eligiendo.set(null);
        // 425 = sigue en camino, 409 = sin Vigor o encargo cerrado. En ambos
        // el backend manda el motivo con el tiempo exacto que falta.
        this.error.set(err?.error?.message ?? 'No se ha podido resolver la escena.');
      },
    });
  }

  continuar(): void {
    this.resolucion.set(null);
    this.cargando.set(true);
    this.cargarEscena();
  }

  volverAlTablon(): void {
    void this.router.navigate(['/personajes', this.personajeId(), 'tablon']);
  }

  riesgoEnPalabras(r: 'LOW' | 'MEDIUM' | 'HIGH'): string {
    return { LOW: 'Poco riesgo', MEDIUM: 'Riesgo', HIGH: 'Muy arriesgado' }[r];
  }

  private cargarEscena(): void {
    this.juego.escenaActual(this.personajeId()).subscribe({
      next: sc => { this.escena.set(sc); this.cargando.set(false); },
      error: err => {
        this.cargando.set(false);
        if (err?.status === 404) {
          void this.router.navigate(['/personajes', this.personajeId(), 'tablon']);
          return;
        }
        this.error.set('No se ha podido abrir el expediente.');
      },
    });
  }
}
