import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/juego.service';
import { ClassFeature, Invocation, Spell, SpellPage } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

const norm = (s: string) =>
  (s ?? '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');

/** Clases con conjuros en el SRD. Fijas: no hace falta traerlas del servidor. */
const CLASES_CONJURO = ['Mago', 'Hechicero', 'Clérigo', 'Bardo', 'Druida', 'Paladín', 'Explorador'];
/** Clases marciales con aptitudes (no lanzan conjuros). */
const CLASES_APTITUD = ['Bárbaro', 'Guerrero', 'Monje'];

/**
 * Habilidades: reúne en una sola pantalla las tres formas de "cosas que un
 * personaje puede hacer":
 *   · Conjuros (las 7 clases lanzadoras) — paginados en el servidor.
 *   · Invocaciones de warlock — a voluntad, por grado.
 *   · Aptitudes de clase (Bárbaro, Guerrero, Monje) — que no lanzan conjuros.
 *
 * Al entrar muestra 25; con "Mostrar" se sube a 100 o a todas. Los conjuros no
 * se traen enteros (son ~500): el servidor filtra y pagina.
 */
@Component({
  selector: 'arc-habilidades',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Compendio · Los Archivos</p>
        <h1>Habilidades</h1>
      </header>

      <!-- Controles: categoría + búsqueda + cuántas mostrar -->
      <div class="controles">
        <label class="ctrl">
          <span class="rotulo">Categoría</span>
          <select [ngModel]="vista()" (ngModelChange)="onVista($event)">
            <optgroup label="Conjuros">
              <option value="hechizo:Todas">Todas las clases</option>
              @for (c of clasesConjuro; track c) {
                <option [value]="'hechizo:' + c">{{ c }}</option>
              }
            </optgroup>
            <optgroup label="Invocaciones">
              <option value="invocacion:Warlock">Warlock</option>
            </optgroup>
            <optgroup label="Aptitudes de clase">
              @for (c of clasesAptitud; track c) {
                <option [value]="'aptitud:' + c">{{ c }}</option>
              }
            </optgroup>
          </select>
        </label>

        <label class="ctrl ctrl--buscar">
          <span class="rotulo">Buscar por nombre</span>
          <input [ngModel]="busqueda()" (ngModelChange)="onBuscar($event)"
                 placeholder="Escribe para filtrar…" autocomplete="off" />
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
        <p class="estado">Abriendo el compendio…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal">{{ e }}</p>
      }

      <!-- ==================== INVOCACIONES (warlock) ==================== -->
      @else if (kind() === 'invocacion') {
        <p class="aviso aviso--inv">
          El warlock no lanza conjuros: usa <strong>invocaciones</strong>, aptitudes
          sobrenaturales que emplea <strong>a voluntad</strong>, sin espacios diarios.
          Se ordenan por grado y la CD sale del Carisma.
        </p>
        <p class="recuento">{{ invocacionesMostradas().length }} de {{ invocacionesFiltradas().length }} invocación(es)</p>
        <ul class="lista">
          @for (i of invocacionesMostradas(); track i.name) {
            <li class="hoja hechizo hechizo--inv">
              <div class="fila">
                <h2>{{ i.name }}</h2>
                <span class="nivel">{{ i.grade }} · warlock {{ i.minClassLevel }}</span>
              </div>
              <p class="escuela">
                {{ i.nameEn }}
                @if (i.kind) { <span class="sep">·</span> {{ i.kind }} }
                @if (i.atWill) { <span class="sep">·</span> <span class="avol">a voluntad</span> }
              </p>
              <p class="desc">{{ i.description }}</p>
              <dl class="stats">
                <div><dt>CD</dt><dd>{{ i.saveDcFormula }}</dd></div>
                <div><dt>Equivale a</dt><dd>conjuro de nivel {{ i.spellLevel }}</dd></div>
                @if (i.savingThrow) { <div><dt>Salvación</dt><dd>{{ i.savingThrow }}</dd></div> }
                @if (i.spellResistance) { <div><dt>Resist. conjuros</dt><dd>{{ i.spellResistance }}</dd></div> }
                @if (i.dice) { <div><dt>Dados</dt><dd class="dano">{{ i.dice }}</dd></div> }
                @if (i.scaling) { <div class="ancho"><dt>Escalado</dt><dd>{{ i.scaling }}</dd></div> }
              </dl>
              <p class="fuente">{{ i.source }}</p>
            </li>
          }
        </ul>
      }

      <!-- ==================== APTITUDES (marciales) ==================== -->
      @else if (kind() === 'aptitud') {
        <p class="aviso aviso--apt">
          {{ clase() }} <strong>no lanza conjuros</strong> en D&amp;D 3.5. Estas son sus
          <strong>aptitudes de clase</strong>: no gastan espacios ni tienen CD de conjuro;
          son acciones y capacidades que gana al subir de nivel.
        </p>
        <p class="recuento">{{ aptitudesMostradas().length }} de {{ aptitudesFiltradas().length }} aptitud(es)</p>
        <ul class="lista">
          @for (a of aptitudesMostradas(); track a.name) {
            <li class="hoja hechizo hechizo--apt">
              <div class="fila">
                <h2>{{ a.name }}</h2>
                <span class="nivel">{{ a.clazz }} · nivel {{ a.level }}</span>
              </div>
              <p class="escuela">{{ a.kind }}</p>
              <p class="desc">{{ a.description }}</p>
              <p class="fuente">{{ a.source }}</p>
            </li>
          }
        </ul>
      }

      <!-- ======================= CONJUROS ======================= -->
      @else {
        <p class="recuento">
          {{ pagina().items.length }} de {{ pagina().total }} hechizo(s)
          @if (limite() > 0 && pagina().total > pagina().items.length) {
            <span class="sep">·</span> sube «Mostrar» para ver más
          }
        </p>
        @if (pagina().items.length === 0) {
          <p class="estado">Ningún hechizo cuadra con la búsqueda.</p>
        } @else {
          <ul class="lista">
            @for (h of pagina().items; track h.name) {
              <li class="hoja hechizo">
                <div class="fila">
                  <h2>{{ h.name }}</h2>
                  <span class="nivel">{{ nivel(h) }}</span>
                </div>
                <p class="escuela">
                  {{ h.school }}
                  @if (h.subschool) { ({{ h.subschool }}) }
                  @if (h.descriptors) { <span class="sep">·</span> {{ h.descriptors }} }
                  @if (h.nameEn) { <span class="sep">·</span> <span class="en">{{ h.nameEn }}</span> }
                </p>

                @if (h.damageSummary) {
                  <p class="dano-destacado">{{ h.damageSummary }}</p>
                }

                <dl class="stats">
                  @if (h.castingTime) { <div><dt>Lanzamiento</dt><dd>{{ h.castingTime }}</dd></div> }
                  @if (h.components) { <div><dt>Componentes</dt><dd>{{ h.components }}</dd></div> }
                  @if (h.range) { <div><dt>Alcance</dt><dd>{{ h.range }}</dd></div> }
                  @if (h.target) { <div><dt>{{ h.targetKind || 'Objetivo' }}</dt><dd>{{ h.target }}</dd></div> }
                  @if (h.duration) { <div><dt>Duración</dt><dd>{{ h.duration }}</dd></div> }
                  @if (h.savingThrow) { <div><dt>Salvación</dt><dd>{{ h.savingThrow }}</dd></div> }
                  @if (h.spellResistance) { <div><dt>Resist. conjuros</dt><dd>{{ h.spellResistance }}</dd></div> }
                  @if (cd(h); as f) { <div><dt>CD</dt><dd>{{ f }}</dd></div> }
                </dl>

                <p class="desc">{{ h.description }}</p>

                <p class="clases">
                  @for (c of h.classes; track c.clazz) {
                    <span class="chip" [class.chip--sel]="c.clazz === clase()"
                          [title]="c.saveDcFormula">{{ c.clazz }} {{ c.level }}</span>
                  }
                </p>
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

    .controles { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 8px; align-items: end; }
    .ctrl { display: grid; gap: 4px; }
    .ctrl .rotulo { color: var(--sepia-claro); }
    .ctrl--buscar { flex: 1 1 220px; }
    .controles select, .controles input {
      font: inherit; padding: 10px 12px; border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio); background: var(--pergamino-claro); color: var(--tinta);
    }
    .controles input { width: 100%; }

    .aviso {
      border-left: 2px solid #8a7bb0; background: rgba(138,123,176,.08);
      padding: 10px 12px; margin: 14px 0 4px; color: var(--sepia-hondo);
      font-size: 15px; line-height: 1.5;
    }
    .aviso strong { color: var(--tinta); }
    .aviso--apt { border-left-color: var(--musgo); background: rgba(76,106,55,.08); }

    .recuento { font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase; color: var(--sepia); margin: 10px 0; }
    .recuento .sep { color: var(--linea-fuerte); margin: 0 6px; }

    .lista { list-style: none; margin: 0; padding: 0; display: grid; gap: 12px; }
    .hechizo { padding: 16px 18px; }
    .hechizo--inv { border-left: 2px solid rgba(138,123,176,.45); }
    .hechizo--apt { border-left: 2px solid rgba(76,106,55,.5); }
    .fila { display: flex; align-items: baseline; justify-content: space-between; gap: 10px; }
    h2 { font-size: 20px; color: var(--tinta); }
    .nivel { font-family: var(--dato); font-size: 11px; letter-spacing: .06em; color: var(--oro); white-space: nowrap; }
    .escuela { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); margin: 4px 0 8px; }
    .escuela .sep { color: var(--linea-fuerte); margin: 0 4px; }
    .escuela .en { color: var(--sepia-claro); text-transform: none; letter-spacing: 0; font-style: italic; }
    .avol { color: var(--musgo); }

    .dano-destacado {
      font-family: var(--dato); font-size: 13px; color: var(--vino);
      border: 1px solid rgba(143,46,34,.3); border-radius: var(--radio);
      padding: 5px 9px; display: inline-block; margin: 0 0 10px;
    }

    .stats {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
      gap: 4px 16px; margin: 0 0 10px; padding: 10px 0;
      border-top: 1px solid var(--linea-clara); border-bottom: 1px solid var(--linea-clara);
    }
    .stats > div { display: flex; gap: 6px; align-items: baseline; min-width: 0; }
    .stats > div.ancho { grid-column: 1 / -1; }
    .stats dt {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); white-space: nowrap; flex: 0 0 auto;
    }
    .stats dd { margin: 0; color: var(--tinta); font-size: 14px; min-width: 0; }
    .stats dd.dano { color: var(--vino); font-family: var(--dato); }

    .desc { color: var(--sepia-hondo); font-size: 15px; line-height: 1.55; margin: 0 0 10px; white-space: pre-line; }
    .fuente { font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia-claro); margin: 0; }

    .clases { display: flex; flex-wrap: wrap; gap: 6px; margin: 0; }
    .chip { font-family: var(--dato); font-size: 9px; letter-spacing: .08em; text-transform: uppercase; color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio); padding: 2px 6px; }
    .chip--sel { color: #a294c9; border-color: rgba(138, 123, 176, .5); }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 20px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class HabilidadesPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);

  readonly clasesConjuro = CLASES_CONJURO;
  readonly clasesAptitud = CLASES_APTITUD;

  /** "kind:clase" — p. ej. "hechizo:Mago", "invocacion:Warlock", "aptitud:Monje". */
  readonly vista = signal('hechizo:Todas');
  readonly busqueda = signal('');
  readonly mostrar = signal<'25' | '100' | 'todas'>('25');

  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  readonly pagina = signal<SpellPage>({ total: 0, items: [] });
  readonly invocaciones = signal<Invocation[]>([]);
  readonly aptitudes = signal<ClassFeature[]>([]);

  readonly kind = computed(() => this.vista().split(':')[0]);
  readonly clase = computed(() => this.vista().split(':')[1] ?? '');
  /** Límite numérico para el servidor: 0 = todas. */
  readonly limite = computed(() => this.mostrar() === 'todas' ? 0 : Number(this.mostrar()));
  private tope(): number { return this.mostrar() === 'todas' ? Infinity : Number(this.mostrar()); }

  // Invocaciones y aptitudes son pocas: se filtran y recortan en el cliente.
  readonly invocacionesFiltradas = computed(() => {
    const q = norm(this.busqueda().trim());
    return this.invocaciones()
      .filter(i => q === '' || norm(i.name).includes(q) || norm(i.nameEn).includes(q))
      .sort((a, b) => a.gradeOrder - b.gradeOrder || a.name.localeCompare(b.name));
  });
  readonly invocacionesMostradas = computed(() => this.invocacionesFiltradas().slice(0, this.tope()));

  readonly aptitudesFiltradas = computed(() => {
    const q = norm(this.busqueda().trim());
    return this.aptitudes()
      .filter(a => q === '' || norm(a.name).includes(q))
      .sort((a, b) => a.level - b.level || a.name.localeCompare(b.name));
  });
  readonly aptitudesMostradas = computed(() => this.aptitudesFiltradas().slice(0, this.tope()));

  private debounce: ReturnType<typeof setTimeout> | null = null;

  ngOnInit(): void {
    // Arranca en la categoría que le pega al personaje; si no, en conjuros/Todas.
    this.juego.personajes().subscribe({
      next: ps => {
        const clase = ps.find(p => p.id === this.personajeId())?.role ?? '';
        const n = norm(clase);
        if (n.includes('warlock') || n.includes('brujo')) this.vista.set('invocacion:Warlock');
        else if (CLASES_APTITUD.some(c => norm(c) === n)) this.vista.set('aptitud:' + clase);
        else if (CLASES_CONJURO.some(c => norm(c) === n)) this.vista.set('hechizo:' + clase);
        this.recargar();
      },
      error: () => this.recargar(),   // da igual: se queda en conjuros/Todas
    });
  }

  onVista(v: string): void { this.vista.set(v); this.recargar(); }

  onMostrar(v: string): void {
    this.mostrar.set(v as '25' | '100' | 'todas');
    // Solo los conjuros necesitan pedir más al servidor; el resto recorta solo.
    if (this.kind() === 'hechizo') this.recargarHechizos();
  }

  onBuscar(v: string): void {
    this.busqueda.set(v);
    if (this.kind() !== 'hechizo') return;   // invos/aptitudes filtran en cliente
    if (this.debounce) clearTimeout(this.debounce);
    this.debounce = setTimeout(() => this.recargarHechizos(), 300);
  }

  private recargar(): void {
    const k = this.kind();
    if (k === 'invocacion') this.cargarInvocaciones();
    else if (k === 'aptitud') this.cargarAptitudes();
    else this.recargarHechizos();
  }

  private recargarHechizos(): void {
    this.cargando.set(true);
    this.juego.hechizos(this.clase(), this.busqueda().trim(), this.limite()).subscribe({
      next: p => { this.pagina.set(p); this.cargando.set(false); this.error.set(null); },
      error: () => { this.cargando.set(false); this.error.set('No se ha podido abrir el grimorio.'); },
    });
  }

  private cargarInvocaciones(): void {
    this.cargando.set(true);
    this.juego.invocaciones().subscribe({
      next: is => { this.invocaciones.set(is); this.cargando.set(false); this.error.set(null); },
      error: () => { this.cargando.set(false); this.error.set('No se han podido cargar las invocaciones.'); },
    });
  }

  private cargarAptitudes(): void {
    this.cargando.set(true);
    this.juego.aptitudes(this.clase()).subscribe({
      next: as => { this.aptitudes.set(as); this.cargando.set(false); this.error.set(null); },
      error: () => { this.cargando.set(false); this.error.set('No se han podido cargar las aptitudes.'); },
    });
  }

  nivel(h: Spell): string {
    if (this.clase() === '' || this.vista() === 'hechizo:Todas') return 'Nivel ' + h.minLevel;
    const c = h.classes.find(x => x.clazz === this.clase());
    return c ? 'Nivel ' + c.level : 'Nivel ' + h.minLevel;
  }

  cd(h: Spell): string {
    const clase = this.clase();
    if (clase && this.vista() !== 'hechizo:Todas') {
      return h.classes.find(c => c.clazz === clase)?.saveDcFormula ?? '';
    }
    return h.classes.find(c => c.saveDcFormula)?.saveDcFormula ?? '';
  }
}
