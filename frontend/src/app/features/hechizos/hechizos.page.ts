import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/juego.service';
import { Invocation, Spell } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

const norm = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');

/** Valor especial del selector: el warlock no tiene conjuros, tiene invocaciones. */
const WARLOCK = 'Warlock (invocaciones)';

/**
 * El grimorio: los conjuros que puede lanzar cada clase con su ficha completa
 * (nivel, escuela, componentes, tiempo, alcance, objetivo, duración, salvación,
 * resistencia, dados y escalado) y la CD ya calculada según el atributo de la
 * clase.
 *
 * El warlock va en su propia vista porque NO lanza conjuros: usa invocaciones
 * a voluntad, agrupadas por grado en vez de por nivel de conjuro.
 */
@Component({
  selector: 'arc-hechizos',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Grimorio · Los Archivos</p>
        <h1>{{ esWarlock() ? 'Invocaciones' : 'Hechizos' }}</h1>
      </header>

      <!-- Controles: clase + búsqueda -->
      <div class="controles">
        <label class="ctrl">
          <span class="rotulo">Clase</span>
          <select [(ngModel)]="claseSel">
            <option value="Todas">Todas las clases</option>
            @for (c of clases(); track c) { <option [value]="c">{{ c }}</option> }
            <option [value]="WARLOCK">{{ WARLOCK }}</option>
          </select>
        </label>
        <label class="ctrl ctrl--buscar">
          <span class="rotulo">Buscar por nombre</span>
          <input [(ngModel)]="busqueda" placeholder="Escribe para filtrar…" autocomplete="off" />
        </label>
      </div>

      @if (cargando()) {
        <p class="estado">Abriendo el grimorio…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal">{{ e }}</p>
      }

      <!-- ==================== INVOCACIONES (warlock) ==================== -->
      @else if (esWarlock()) {
        <p class="aviso">
          El warlock no lanza conjuros: usa <strong>invocaciones</strong>, aptitudes
          sobrenaturales que puede emplear <strong>a voluntad</strong>, sin espacios
          diarios. Se ordenan por grado y la CD sale del Carisma.
        </p>
        <p class="recuento">{{ invocacionesFiltradas().length }} invocación(es)</p>
        <ul class="lista">
          @for (i of invocacionesFiltradas(); track i.name) {
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

      <!-- ======================= CONJUROS ======================= -->
      @else {
        <p class="recuento">{{ filtrados().length }} hechizo(s)</p>
        @if (filtrados().length === 0) {
          <p class="estado">Ningún hechizo cuadra con la búsqueda.</p>
        } @else {
          <ul class="lista">
            @for (h of filtrados(); track h.name) {
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
                    <span class="chip" [class.chip--sel]="c.clazz === claseSel()"
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

    .controles { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 8px; }
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

    .recuento { font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase; color: var(--sepia); margin: 10px 0; }

    .lista { list-style: none; margin: 0; padding: 0; display: grid; gap: 12px; }
    .hechizo { padding: 16px 18px; }
    .hechizo--inv { border-left: 2px solid rgba(138,123,176,.45); }
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

    /* bloque de estadísticas en dos columnas */
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

    .desc { color: var(--sepia-hondo); font-size: 15px; line-height: 1.55; margin: 0 0 10px; }
    .fuente { font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia-claro); margin: 0; }

    .clases { display: flex; flex-wrap: wrap; gap: 6px; margin: 0; }
    .chip { font-family: var(--dato); font-size: 9px; letter-spacing: .08em; text-transform: uppercase; color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio); padding: 2px 6px; }
    .chip--sel { color: #a294c9; border-color: rgba(138, 123, 176, .5); }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 20px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class HechizosPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);

  readonly WARLOCK = WARLOCK;

  readonly hechizos = signal<Spell[]>([]);
  readonly invocaciones = signal<Invocation[]>([]);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  readonly claseSel = signal('Todas');
  readonly busqueda = signal('');

  readonly esWarlock = computed(() => this.claseSel() === WARLOCK);

  /** Todas las clases que aparecen en el grimorio, ordenadas. */
  readonly clases = computed(() => {
    const set = new Set<string>();
    for (const h of this.hechizos()) for (const c of h.classes) set.add(c.clazz);
    return [...set].sort((a, b) => a.localeCompare(b));
  });

  readonly filtrados = computed(() => {
    const clase = this.claseSel();
    const q = norm(this.busqueda().trim());
    const nivelDe = (h: Spell) =>
      clase === 'Todas' ? h.minLevel : (h.classes.find(c => c.clazz === clase)?.level ?? 99);

    return this.hechizos()
      .filter(h => clase === 'Todas' || h.classes.some(c => c.clazz === clase))
      .filter(h => q === '' || norm(h.name).includes(q) || norm(h.nameEn ?? '').includes(q))
      .sort((a, b) => nivelDe(a) - nivelDe(b) || a.name.localeCompare(b.name));
  });

  readonly invocacionesFiltradas = computed(() => {
    const q = norm(this.busqueda().trim());
    return this.invocaciones()
      .filter(i => q === '' || norm(i.name).includes(q) || norm(i.nameEn ?? '').includes(q))
      .sort((a, b) => a.gradeOrder - b.gradeOrder || a.name.localeCompare(b.name));
  });

  ngOnInit(): void {
    this.juego.hechizos().subscribe({
      next: hs => { this.hechizos.set(hs); this.cargando.set(false); this.defectoPorClase(); },
      error: () => { this.cargando.set(false); this.error.set('No se ha podido abrir el grimorio.'); },
    });
    this.juego.invocaciones().subscribe({
      next: is => this.invocaciones.set(is),
      error: () => { /* secundario: si falla, el grimorio de conjuros sigue */ },
    });
  }

  /** Por comodidad, arranca filtrado por la clase del personaje si tiene hechizos. */
  private defectoPorClase(): void {
    this.juego.personajes().subscribe({
      next: ps => {
        const mio = ps.find(p => p.id === this.personajeId());
        const clase = mio?.role;
        if (!clase) return;
        if (norm(clase).includes('warlock') || norm(clase).includes('brujo')) {
          this.claseSel.set(WARLOCK);
        } else if (this.clases().includes(clase)) {
          this.claseSel.set(clase);
        }
      },
      error: () => { /* da igual: se queda en «Todas» */ },
    });
  }

  nivel(h: Spell): string {
    const clase = this.claseSel();
    if (clase === 'Todas') return 'Nivel ' + h.minLevel;
    const c = h.classes.find(x => x.clazz === clase);
    return c ? 'Nivel ' + c.level : '';
  }

  /** La CD de la clase seleccionada; si es «Todas», la de la primera que la tenga. */
  cd(h: Spell): string {
    const clase = this.claseSel();
    if (clase !== 'Todas') {
      return h.classes.find(c => c.clazz === clase)?.saveDcFormula ?? '';
    }
    return h.classes.find(c => c.saveDcFormula)?.saveDcFormula ?? '';
  }
}
