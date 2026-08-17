import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/game.service';
import { Holdings, Property, PropertyCatalogItem } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

/**
 * El juego de propiedades: compra un negocio, recauda su renta, súbelo de
 * nivel y véndelo si quieres. Todo el dinero pasa por el monedero del
 * personaje. La renta se acumula sola con el tiempo (el backend la calcula);
 * aquí solo se recauda.
 */
@Component({
  selector: 'arc-propiedades',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />
    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Posesiones</p>
        <div class="titulo">
          <h1>Propiedades</h1>
          @if (datos(); as d) {
            <span class="monedero" title="Tu monedero">{{ d.purse }}</span>
          }
        </div>
      </header>

      @if (cargando()) {
        <p class="estado">Revisando las escrituras…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (datos(); as d) {

        <!-- Tus propiedades -->
        <p class="rotulo separador">Tus propiedades</p>
        @if (d.properties.length === 0) {
          <p class="vacio">Todavía no tienes ninguna. Compra la primera abajo.</p>
        } @else {
          <ul class="lista">
            @for (p of d.properties; track p.id) {
              <li class="hoja negocio">
                <div class="neg-cabe">
                  <span class="emoji" aria-hidden="true">{{ p.emoji }}</span>
                  <div class="neg-id">
                    <h2>{{ p.name }}</h2>
                    <p class="neg-sub">{{ p.tipo }} · {{ p.city }}</p>
                  </div>
                  <div class="nivel" [title]="'Nivel ' + p.level + ' de ' + p.maxLevel">
                    @for (n of niveles(p.maxLevel); track n) {
                      <span class="punto" [class.lleno]="n <= p.level"></span>
                    }
                  </div>
                </div>

                <dl class="neg-datos">
                  <div><dt>Renta</dt><dd>{{ p.incomePerDay }}</dd></div>
                  <div class="acumulado">
                    <dt>Acumulado</dt>
                    <dd [class.hay]="p.pendingCp > 0">{{ p.pending }}</dd>
                  </div>
                </dl>

                <div class="neg-acc">
                  <button class="boton boton--lacre"
                          [disabled]="p.pendingCp <= 0 || !!ocupado()"
                          (click)="recaudar(p)">
                    {{ ocupado() === p.id ? '…' : 'Recaudar' }}
                  </button>

                  @if (p.upgradeCost) {
                    <button class="boton"
                            [disabled]="d.purseCp < (p.upgradeCostCp ?? 0) || !!ocupado()"
                            [title]="d.purseCp < (p.upgradeCostCp ?? 0) ? 'No te llega para la mejora' : ''"
                            (click)="mejorar(p)">
                      Mejorar · {{ p.upgradeCost }}
                    </button>
                  } @else {
                    <span class="tope">Nivel máximo</span>
                  }

                  <button class="boton-quitar" title="Vender la propiedad"
                          [disabled]="!!ocupado()"
                          (click)="vender(p)">
                    Vender · {{ p.saleValue }}
                  </button>
                </div>
              </li>
            }
          </ul>
        }

        <!-- Catálogo -->
        <p class="rotulo separador">Comprar una propiedad</p>
        <ul class="catalogo">
          @for (c of d.catalog; track c.kind) {
            <li class="hoja tipo">
              <div class="tipo-cabe">
                <span class="emoji" aria-hidden="true">{{ c.emoji }}</span>
                <h3>{{ c.nombre }}</h3>
              </div>
              <p class="tipo-blurb">{{ c.blurb }}</p>
              <p class="tipo-datos">
                <span class="precio">{{ c.buyPrice }}</span>
                <span class="renta">{{ c.incomePerDay }}</span>
              </p>

              @if (eligiendo() === c.kind) {
                <div class="compra">
                  <input class="nombre" type="text" maxlength="80"
                         placeholder="Ponle un nombre…"
                         [(ngModel)]="nombre" (keyup.enter)="confirmar(c)" />
                  <div class="compra-acc">
                    <button class="boton boton--lacre" [disabled]="!!ocupado()"
                            (click)="confirmar(c)">Confirmar</button>
                    <button class="boton" [disabled]="!!ocupado()"
                            (click)="cancelar()">Cancelar</button>
                  </div>
                </div>
              } @else {
                <button class="boton boton--lacre ancho"
                        [disabled]="d.purseCp < c.buyPriceCp || !!ocupado()"
                        [title]="d.purseCp < c.buyPriceCp ? 'No te llega el dinero' : ''"
                        (click)="elegir(c)">
                  Comprar
                </button>
              }
            </li>
          }
        </ul>
      }
    </div>
  `,
  styles: `
    .separador { margin-top: 26px; }
    .vacio {
      font-family: var(--cuerpo);
      font-style: italic;
      color: var(--sepia);
      margin: 8px 0 0;
    }
    .lista { list-style: none; margin: 10px 0 0; padding: 0; display: grid; gap: 12px; }

    .negocio { padding: 16px 18px; }
    .neg-cabe { display: flex; align-items: center; gap: 12px; }
    .emoji { font-size: 26px; line-height: 1; }
    .neg-id { flex: 1; min-width: 0; }
    .neg-id h2 { margin: 0; font-size: 19px; color: var(--tinta); }
    .neg-sub {
      margin: 2px 0 0;
      font-family: var(--dato);
      font-size: 10px;
      letter-spacing: .1em;
      text-transform: uppercase;
      color: var(--sepia);
    }
    .nivel { display: flex; gap: 4px; }
    .punto {
      width: 9px; height: 9px; border-radius: 50%;
      border: 1px solid var(--oro);
      background: transparent;
    }
    .punto.lleno { background: var(--oro); }

    .neg-datos {
      display: flex; gap: 28px;
      margin: 14px 0;
      padding: 10px 0;
      border-top: 1px solid var(--linea);
      border-bottom: 1px solid var(--linea);
    }
    .neg-datos dt {
      font-family: var(--dato);
      font-size: 10px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia);
    }
    .neg-datos dd { margin: 3px 0 0; font-family: var(--dato); font-size: 15px; color: var(--tinta); }
    .acumulado dd { color: var(--sepia); }
    .acumulado dd.hay { color: var(--oro); font-weight: 600; }

    .neg-acc { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
    .tope {
      font-family: var(--dato);
      font-size: 10px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--musgo);
    }

    .catalogo {
      list-style: none; margin: 10px 0 0; padding: 0;
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 12px;
    }
    .tipo { padding: 14px 16px; display: flex; flex-direction: column; }
    .tipo-cabe { display: flex; align-items: center; gap: 10px; }
    .tipo-cabe h3 { margin: 0; font-size: 17px; color: var(--tinta); }
    .tipo-blurb {
      font-family: var(--cuerpo);
      font-size: 14px; color: var(--sepia-hondo);
      margin: 8px 0 10px; flex: 1;
    }
    .tipo-datos { display: flex; justify-content: space-between; align-items: baseline; margin: 0 0 12px; }
    .precio { font-family: var(--dato); font-size: 15px; color: var(--oro); }
    .renta { font-family: var(--dato); font-size: 11px; color: var(--sepia); }
    .ancho { width: 100%; }

    .compra { display: grid; gap: 8px; }
    .nombre {
      width: 100%;
      font-family: var(--cuerpo);
      padding: 7px 9px;
    }
    .compra-acc { display: flex; gap: 8px; }
    .compra-acc .boton { flex: 1; }

    .boton-quitar {
      font-family: var(--dato);
      font-size: 11px;
      letter-spacing: .06em;
      color: var(--vino);
      background: transparent;
      border: 1px solid rgba(143,46,34,.4);
      border-radius: var(--radio);
      padding: 7px 12px;
      cursor: pointer;
    }
    .boton-quitar:hover:not(:disabled) { background: rgba(143,46,34,.08); }
    .boton-quitar:disabled { opacity: .5; cursor: default; }

    .estado--mal { color: var(--vino); }
  `,
})
export class PropiedadesPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);

  readonly datos = signal<Holdings | null>(null);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  /** id de la propiedad (o 'comprar') en curso, para bloquear botones. */
  readonly ocupado = signal<string | null>(null);
  /** código del tipo cuyo formulario de compra está abierto. */
  readonly eligiendo = signal<string | null>(null);
  readonly nombre = signal('');

  /** [1..max] para pintar los puntos de nivel. */
  niveles = (max: number) => Array.from({ length: max }, (_, i) => i + 1);

  ngOnInit(): void {
    this.juego.propiedades(this.personajeId()).subscribe({
      next: d => { this.datos.set(d); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se han podido cargar las propiedades.');
      },
    });
  }

  recaudar(p: Property): void {
    if (this.ocupado()) return;
    this.ocupado.set(p.id);
    this.error.set(null);
    this.juego.recaudarPropiedad(this.personajeId(), p.id).subscribe({
      next: d => { this.datos.set(d); this.ocupado.set(null); },
      error: err => this.fallo(err, 'No se ha podido recaudar.'),
    });
  }

  mejorar(p: Property): void {
    if (this.ocupado()) return;
    this.ocupado.set(p.id);
    this.error.set(null);
    this.juego.mejorarPropiedad(this.personajeId(), p.id).subscribe({
      next: d => { this.datos.set(d); this.ocupado.set(null); },
      error: err => this.fallo(err, 'No se ha podido mejorar.'),
    });
  }

  vender(p: Property): void {
    if (this.ocupado()) return;
    // Confirmación simple: vender es destructivo.
    if (!confirm(`¿Vender "${p.name}" por ${p.saleValue}? (más la renta acumulada)`)) return;
    this.ocupado.set(p.id);
    this.error.set(null);
    this.juego.venderPropiedad(this.personajeId(), p.id).subscribe({
      next: d => { this.datos.set(d); this.ocupado.set(null); },
      error: err => this.fallo(err, 'No se ha podido vender.'),
    });
  }

  // --- compra ---

  elegir(c: PropertyCatalogItem): void {
    this.eligiendo.set(c.kind);
    this.nombre.set('');
  }

  cancelar(): void {
    this.eligiendo.set(null);
    this.nombre.set('');
  }

  confirmar(c: PropertyCatalogItem): void {
    if (this.ocupado()) return;
    this.ocupado.set('comprar');
    this.error.set(null);
    this.juego.comprarPropiedad(this.personajeId(), {
      kind: c.kind,
      name: this.nombre().trim() || c.nombre,
    }).subscribe({
      next: d => {
        this.datos.set(d);
        this.ocupado.set(null);
        this.eligiendo.set(null);
        this.nombre.set('');
      },
      error: err => this.fallo(err, 'No se ha podido comprar.'),
    });
  }

  private fallo(err: unknown, porDefecto: string): void {
    this.ocupado.set(null);
    const e = err as { error?: { message?: string } };
    this.error.set(e?.error?.message ?? porDefecto);
  }
}
