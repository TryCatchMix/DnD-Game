import { Component, inject, input, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/game.service';
import { BestiaryFilters, Monster, MonsterRow } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

/** Tramos de peligro, que es como se elige un bicho de verdad: "algo para un
 *  grupo de nivel 5", no "algo de VD 5,000". */
const TRAMOS: { etiqueta: string; min: number | null; max: number | null }[] = [
  { etiqueta: 'Cualquier peligro', min: null, max: null },
  { etiqueta: 'Alimañas (VD < 1)', min: null, max: 0.9 },
  { etiqueta: 'Escaramuza (VD 1-3)', min: 1, max: 3 },
  { etiqueta: 'Amenaza seria (VD 4-7)', min: 4, max: 7 },
  { etiqueta: 'Jefe (VD 8-12)', min: 8, max: 12 },
  { etiqueta: 'Leyenda (VD 13+)', min: 13, max: null },
];

/**
 * El bestiario: las ~590 criaturas del SRD 3.5, con su bloque de estadísticas
 * en español.
 *
 * La lista se filtra y pagina en el SERVIDOR (por defecto 25) porque son
 * demasiadas para mandarlas de una. La ficha completa de cada criatura se pide
 * aparte al desplegarla y se queda cacheada, así que abrir y cerrar no vuelve a
 * llamar al servidor.
 */
@Component({
  selector: 'arc-bestiario',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Compendio · Los Archivos</p>
        <h1>Bestiario</h1>
      </header>

      <div class="controles">
        <label class="ctrl ctrl--buscar">
          <span class="rotulo">Buscar por nombre</span>
          <input [ngModel]="busqueda()" (ngModelChange)="onBuscar($event)"
                 placeholder="Escribe para filtrar…" autocomplete="off" />
        </label>

        <label class="ctrl">
          <span class="rotulo">Tipo</span>
          <select [ngModel]="tipo()" (ngModelChange)="onTipo($event)">
            <option value="">Todos los tipos</option>
            @for (t of filtros()?.types ?? []; track t) {
              <option [value]="t">{{ t }}</option>
            }
          </select>
        </label>

        <label class="ctrl">
          <span class="rotulo">Peligro</span>
          <select [ngModel]="tramo()" (ngModelChange)="onTramo($event)">
            @for (t of tramos; track t.etiqueta; let i = $index) {
              <option [value]="i">{{ t.etiqueta }}</option>
            }
          </select>
        </label>

        <label class="ctrl">
          <span class="rotulo">Entorno</span>
          <select [ngModel]="entorno()" (ngModelChange)="onEntorno($event)">
            <option value="">Cualquier entorno</option>
            @for (e of filtros()?.environments ?? []; track e) {
              <option [value]="e">{{ e }}</option>
            }
          </select>
        </label>

        <label class="ctrl">
          <span class="rotulo">Ordenar</span>
          <select [ngModel]="orden()" (ngModelChange)="onOrden($event)">
            <option value="nombre">Por nombre</option>
            <option value="vd">Por peligro</option>
          </select>
        </label>

        <label class="ctrl">
          <span class="rotulo">Mostrar</span>
          <select [ngModel]="mostrar()" (ngModelChange)="onMostrar($event)">
            <option value="25">25</option>
            <option value="100">100</option>
            <option value="todas">Todas</option>
          </select>
        </label>
      </div>

      @if (cargando()) {
        <p class="estado">Abriendo el bestiario…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal">{{ e }}</p>
      } @else {
        <p class="recuento">
          {{ criaturas().length }} de {{ total() }} criatura(s)
          @if (total() > criaturas().length) {
            <span class="sep">·</span> ajusta «Mostrar» para ver más
          }
        </p>

        @if (!criaturas().length) {
          <p class="estado">Nada acecha con esos filtros.</p>
        }

        <ul class="lista">
          @for (c of criaturas(); track c.id) {
            <li class="hoja bicho" [class.bicho--plantilla]="c.kind === 'plantilla'">
              <button class="titular" (click)="alternar(c)"
                      [attr.aria-expanded]="abierta() === c.id">
                <div class="fila">
                  <h2>{{ c.name }}</h2>
                  <span class="vd" [class.vd--plantilla]="c.kind === 'plantilla'"
                        [title]="c.kind === 'plantilla' ? 'Regla para modificar otra criatura'
                                 : 'Valor de desafío ' + c.cr + ': lo que cuesta enfrentarse a ella'">
                    @if (c.kind === 'plantilla') { plantilla } @else { VD {{ c.cr }} }
                  </span>
                </div>
                <p class="linea">
                  @if (c.sizeType) { {{ c.sizeType }} }
                  @if (c.environment) { <span class="sep">·</span> {{ c.environment }} }
                  <span class="sep">·</span> <span class="en">{{ c.nameEn }}</span>
                </p>
              </button>

              @if (abierta() === c.id) {
                @if (ficha(); as f) {
                  @if (f.scaling; as e) {
                    <div class="niveles">
                      <label class="nivel-ctrl">
                        <span class="rotulo">Nivel de {{ e.className }}</span>
                        <select [ngModel]="e.level" (ngModelChange)="cambiarNivel(c, $event)">
                          @for (n of rango(e.minLevel, e.maxLevel); track n) {
                            <option [value]="n">{{ n }}@if (n === e.baseLevel) { · el del manual }</option>
                          }
                        </select>
                      </label>

                      @if (e.original) {
                        <p class="nivel-nota">
                          Estás viendo el bloque tal cual viene en el manual.
                        </p>
                      } @else {
                        <p class="nivel-nota nivel-nota--calc">
                          Recalculado desde el nivel {{ e.baseLevel }}: dados de golpe, ataque base,
                          presa, ataques y salvaciones. VD estimado <strong>{{ e.estimatedCr }}</strong>
                          (es una estimación, no un dato del manual).
                        </p>
                        @if (e.notes.length) {
                          <ul class="nivel-avisos">
                            @for (n of e.notes; track n) { <li>{{ n }}</li> }
                          </ul>
                        }
                      }
                    </div>
                  }

                  @if (f.kind !== 'plantilla') {
                    <dl class="stats">
                      @if (f.hitDice) { <div><dt>Dados de golpe</dt><dd>{{ f.hitDice }}</dd></div> }
                      @if (f.initiative) { <div><dt>Iniciativa</dt><dd>{{ f.initiative }}</dd></div> }
                      @if (f.speed) { <div class="ancho"><dt>Velocidad</dt><dd>{{ f.speed }}</dd></div> }
                      @if (f.armorClass) { <div class="ancho"><dt>Clase de armadura</dt><dd>{{ f.armorClass }}</dd></div> }
                      @if (f.baseAttack) { <div><dt>Ataque base/presa</dt><dd>{{ f.baseAttack }}</dd></div> }
                      @if (f.spaceReach) { <div><dt>Espacio/alcance</dt><dd>{{ f.spaceReach }}</dd></div> }
                      @if (f.attack) { <div class="ancho"><dt>Ataque</dt><dd class="dano">{{ f.attack }}</dd></div> }
                      @if (f.fullAttack && f.fullAttack !== f.attack) {
                        <div class="ancho"><dt>Ataque completo</dt><dd class="dano">{{ f.fullAttack }}</dd></div>
                      }
                      @if (f.specialAttacks) { <div class="ancho"><dt>Ataques especiales</dt><dd>{{ f.specialAttacks }}</dd></div> }
                      @if (f.specialQualities) { <div class="ancho"><dt>Cualidades especiales</dt><dd>{{ f.specialQualities }}</dd></div> }
                      @if (f.saves) { <div class="ancho"><dt>Salvaciones</dt><dd>{{ f.saves }}</dd></div> }
                      @if (f.abilities) { <div class="ancho"><dt>Características</dt><dd>{{ f.abilities }}</dd></div> }
                      @if (f.skills) { <div class="ancho"><dt>Habilidades</dt><dd>{{ f.skills }}</dd></div> }
                      @if (f.feats) { <div class="ancho"><dt>Dotes</dt><dd>{{ f.feats }}</dd></div> }
                      @if (f.organization) { <div class="ancho"><dt>Organización</dt><dd>{{ f.organization }}</dd></div> }
                      @if (f.challengeRating) {
                        <div class="ancho">
                          <dt title="Lo que cuesta enfrentarse a ella: un grupo de cuatro personajes de ese nivel debería poder con ella">Valor de desafío (VD)</dt>
                          <dd>{{ f.challengeRating }}</dd>
                        </div>
                      }
                      @if (f.treasure) { <div><dt>Tesoro</dt><dd>{{ f.treasure }}</dd></div> }
                      @if (f.alignment) { <div><dt>Alineamiento</dt><dd>{{ f.alignment }}</dd></div> }
                      @if (f.advancement) { <div class="ancho"><dt>Avance</dt><dd>{{ f.advancement }}</dd></div> }
                      @if (f.levelAdjustment) { <div><dt>Ajuste de nivel</dt><dd>{{ f.levelAdjustment }}</dd></div> }
                    </dl>
                  }

                  @if (f.description) {
                    <p class="aviso-idioma">
                      La descripción sigue en el inglés del SRD, igual que la de los conjuros.
                    </p>
                    <p class="prosa">{{ f.description }}</p>
                  }
                  <p class="fuente">{{ f.source }}@if (f.family && f.family !== f.name) { · {{ f.family }} }</p>
                } @else if (errorFicha(); as ef) {
                  <p class="estado estado--mal">{{ ef }}</p>
                } @else {
                  <p class="estado">Consultando el bestiario…</p>
                }
              }
            </li>
          }
        </ul>
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 16px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }

    .controles { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 8px; align-items: end; }
    .ctrl { display: grid; gap: 4px; }
    .ctrl .rotulo { color: var(--sepia-claro); }
    .ctrl--buscar { flex: 1 1 220px; }
    .controles select, .controles input {
      font: inherit; padding: 10px 12px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
    }
    .controles input { width: 100%; }

    .recuento {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia); margin: 10px 0;
    }
    .recuento .sep { color: var(--linea-fuerte); margin: 0 6px; }

    .lista { list-style: none; margin: 0; padding: 0; display: grid; gap: 12px; }
    .bicho { padding: 0; overflow: hidden; }
    .bicho--plantilla { border-left: 2px solid rgba(138,123,176,.45); }

    /* la cabecera de la ficha es el botón que la despliega */
    .titular {
      display: block; width: 100%; text-align: left; background: none; border: 0;
      font: inherit; color: inherit; padding: 16px 18px 12px; cursor: pointer;
    }
    .titular:hover h2 { color: var(--vino); }

    .fila { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; }
    h2 { font-size: 20px; color: var(--tinta); margin: 0; }
    .vd {
      font-family: var(--dato); font-size: 11px; letter-spacing: .06em;
      color: var(--vino); white-space: nowrap;
    }
    .vd--plantilla { color: #8a7bb0; }
    .linea {
      font-family: var(--dato); font-size: 10px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); margin: 4px 0 0;
    }
    .linea .sep { color: var(--linea-fuerte); margin: 0 4px; }
    .linea .en { text-transform: none; letter-spacing: 0; font-style: italic; color: var(--sepia-claro); }

    .stats {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
      gap: 4px 16px; margin: 0; padding: 12px 18px;
      border-top: 1px solid var(--linea-clara);
    }
    .stats > div { display: flex; gap: 6px; align-items: baseline; min-width: 0; }
    .stats > div.ancho { grid-column: 1 / -1; }
    .stats dt {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); white-space: nowrap; flex: 0 0 auto;
    }
    .stats dd { margin: 0; color: var(--tinta); font-size: 14px; min-width: 0; }
    .stats dd.dano { color: var(--vino); font-family: var(--dato); font-size: 13px; }

    .niveles {
      margin: 0; padding: 12px 18px;
      border-top: 1px solid var(--linea-clara);
      background: rgba(157, 122, 47, .05);
    }
    .nivel-ctrl { display: grid; gap: 4px; max-width: 260px; }
    .nivel-ctrl .rotulo { color: var(--sepia-claro); }
    .nivel-ctrl select {
      font: inherit; padding: 8px 10px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
    }
    .nivel-nota { margin: 8px 0 0; font-size: 13px; color: var(--sepia); line-height: 1.5; }
    .nivel-nota--calc { color: var(--sepia-hondo); }
    .nivel-nota strong { color: var(--vino); }
    .nivel-avisos {
      margin: 8px 0 0; padding-left: 18px; font-size: 13px;
      color: var(--sepia-hondo); line-height: 1.6;
    }

    .aviso-idioma {
      margin: 0; padding: 10px 18px 0; font-size: 12px; color: var(--sepia);
      font-style: italic;
    }
    .prosa {
      margin: 6px 0 0; padding: 0 18px 4px; color: var(--sepia-hondo);
      line-height: 1.6; white-space: pre-line;
    }
    .fuente {
      margin: 0; padding: 10px 18px 16px;
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia-claro);
    }
    .estado { color: var(--sepia-claro); padding: 0 18px 12px; }
    .estado--mal { color: var(--vino); }
  `,
})
export class BestiarioPage implements OnInit {
  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);

  readonly tramos = TRAMOS;

  readonly criaturas = signal<MonsterRow[]>([]);
  readonly total = signal(0);
  readonly filtros = signal<BestiaryFilters | null>(null);
  readonly cargando = signal(true);
  readonly error = signal('');

  readonly busqueda = signal('');
  readonly tipo = signal('');
  readonly entorno = signal('');
  readonly orden = signal('nombre');
  readonly tramo = signal(0);
  readonly mostrar = signal('25');

  /** La criatura desplegada y su ficha completa, ya traída del servidor. */
  readonly abierta = signal<string | null>(null);
  readonly ficha = signal<Monster | null>(null);
  readonly errorFicha = signal('');

  /** Fichas ya pedidas: abrir y cerrar no vuelve a llamar al servidor. */
  private readonly cache = new Map<string, Monster>();
  private temporizador: ReturnType<typeof setTimeout> | null = null;

  ngOnInit(): void {
    this.juego.filtrosBestiario().subscribe({
      next: f => this.filtros.set(f),
      // sin los desplegables aún se puede buscar por nombre: no es un error fatal
      error: () => this.filtros.set(null),
    });
    this.recargar();
  }

  // --- controles ---

  onBuscar(v: string): void {
    this.busqueda.set(v);
    // se escribe letra a letra: espera a que pare antes de preguntar
    if (this.temporizador) clearTimeout(this.temporizador);
    this.temporizador = setTimeout(() => this.recargar(), 300);
  }

  onTipo(v: string): void { this.tipo.set(v); this.recargar(); }
  onEntorno(v: string): void { this.entorno.set(v); this.recargar(); }
  onOrden(v: string): void { this.orden.set(v); this.recargar(); }
  onMostrar(v: string): void { this.mostrar.set(v); this.recargar(); }
  onTramo(v: string): void { this.tramo.set(Number(v)); this.recargar(); }

  private recargar(): void {
    const tramo = this.tramos[this.tramo()] ?? this.tramos[0];
    this.cargando.set(true);
    this.error.set('');
    this.juego.bestiario({
      q: this.busqueda(),
      tipo: this.tipo(),
      entorno: this.entorno(),
      vdMin: tramo.min,
      vdMax: tramo.max,
      orden: this.orden(),
      limite: this.mostrar() === 'todas' ? 0 : Number(this.mostrar()),
    }).subscribe({
      next: p => {
        this.criaturas.set(p.items);
        this.total.set(p.total);
        this.cargando.set(false);
        // si la que estaba abierta ya no sale en la lista, se cierra
        if (this.abierta() && !p.items.some(i => i.id === this.abierta())) {
          this.cerrar();
        }
      },
      error: () => {
        this.error.set('No se ha podido abrir el bestiario.');
        this.cargando.set(false);
      },
    });
  }

  // --- desplegar una ficha ---

  alternar(c: MonsterRow): void {
    if (this.abierta() === c.id) { this.cerrar(); return; }
    this.abierta.set(c.id);
    this.errorFicha.set('');
    const guardada = this.cache.get(c.id);
    if (guardada) { this.ficha.set(guardada); return; }
    this.ficha.set(null);
    this.juego.criatura(c.id).subscribe({
      next: f => {
        this.cache.set(c.id, f);
        // puede haberse cerrado o abierto otra mientras llegaba
        if (this.abierta() === c.id) this.ficha.set(f);
      },
      error: () => this.errorFicha.set('No se ha podido leer esa ficha.'),
    });
  }

  /** Los niveles que ofrece el selector. */
  rango(desde: number, hasta: number): number[] {
    return Array.from({ length: hasta - desde + 1 }, (_, i) => desde + i);
  }

  /**
   * Pedir la ficha a otro nivel.
   *
   * NO se guarda en la caché de fichas: la caché es "la criatura tal cual la
   * trae el manual", y meter ahí una versión escalada haría que al reabrirla
   * saliera con el nivel de la última vez sin que nadie lo hubiera pedido.
   */
  cambiarNivel(c: MonsterRow, nivel: number | string): void {
    const n = Number(nivel);
    this.errorFicha.set('');
    this.juego.criatura(c.id, n).subscribe({
      next: f => { if (this.abierta() === c.id) this.ficha.set(f); },
      error: () => this.errorFicha.set('No se ha podido recalcular a ese nivel.'),
    });
  }

  private cerrar(): void {
    this.abierta.set(null);
    this.ficha.set(null);
    this.errorFicha.set('');
  }
}
