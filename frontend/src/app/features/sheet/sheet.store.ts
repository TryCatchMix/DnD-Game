import { Injectable, computed, inject, signal } from '@angular/core';
import { Router } from '@angular/router';

import {
  DomainDetail, DomainSummary, Ficha, Inventory, InventoryLine, PreparedSpell, SkillDetail, Spell,
} from '../../core/api.types';
import { JuegoService } from '../../core/juego.service';

export interface EditRow { name: string; keyAbility: string; ranks: number; miscMod: number; }

export interface EditModel {
  name: string; player: string; clazz: string; level: number; race: string;
  alignment: string; deity: string; size: string; age: string; sex: string;
  height: string; weight: string; campaign: string; location: string;
  domain1: string; domain2: string;
  strScore: number; dexScore: number; conScore: number;
  intScore: number; wisScore: number; chaScore: number;
  hpCurrent: number; hpMax: number; acTotal: number; acTouch: number; acFlatFooted: number;
  initiativeMisc: number; speed: number; bab: number; grappleMisc: number; spellResistance: number;
  saveFort: number; saveRef: number; saveWill: number; damageReduction: string;
  vigor: number; maxVigor: number; carga: string;
}

export const CARACTS = ['', 'FUE', 'DES', 'CON', 'INT', 'SAB', 'CAR'];

/** Pestaña visible. Es estado de interfaz, no del personaje. */
export type Vista = 'ficha' | 'bolsa' | 'habilidades' | 'conjuros';

/**
 * Toda la ficha, sin una sola línea de HTML: estado, cuentas y llamadas al
 * backend. Los diseños (`disenos/pergamino.ts`, `disenos/mesa.ts`) lo inyectan
 * y se limitan a pintarlo, así que cambiar de diseño no cambia el comportamiento.
 *
 * Lo provee `FichaPage` (no es `providedIn: 'root'`): una instancia por visita a
 * la hoja, que muere con ella.
 *
 * Los modificadores, la iniciativa, la presa y los totales de habilidad los
 * calcula el backend; al guardar, se recalcula todo y se repinta.
 */
@Injectable()
export class FichaStore {

  private readonly juego = inject(JuegoService);
  private readonly router = inject(Router);

  readonly caracts = CARACTS;

  readonly personajeId = signal('');

  readonly ficha = signal<Ficha | null>(null);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);

  readonly vista = signal<Vista>('ficha');
  readonly busca = signal('');

  readonly editando = signal(false);
  readonly guardando = signal(false);
  readonly errorEdit = signal<string | null>(null);
  /** Modelo del formulario (objeto plano; ngModel lo muta en sitio). */
  edit: EditModel | null = null;
  readonly editSkills = signal<EditRow[]>([]);
  /** El monedero se edita en po/pp/pc; al guardar se recompone a piezas de cobre. */
  readonly purseOro = signal(0);
  readonly pursePlata = signal(0);
  readonly purseCobre = signal(0);

  // --- bolsa / inventario ---
  readonly inventario = signal<Inventory | null>(null);
  readonly errorBolsa = signal<string | null>(null);
  readonly nuevoNombre = signal('');
  readonly nuevaCantidad = signal(1);
  readonly nuevoPeso = signal(0);
  /**
   * Sube cada vez que se añade un objeto. El foco al siguiente nombre es cosa
   * del DOM, así que lo hace cada diseño con su propia referencia de plantilla.
   */
  readonly itemAnadido = signal(0);

  // --- conjuros preparados ---
  readonly conjuros = signal<PreparedSpell[]>([]);
  readonly errorConjuros = signal<string | null>(null);
  /** Lo que se escribe en el buscador para preparar un conjuro nuevo. */
  readonly buscaConjuro = signal('');
  readonly resultados = signal<Spell[]>([]);
  readonly buscandoConjuro = signal(false);
  /** El conjuro cuyo detalle está desplegado (por nombre), o ''. */
  readonly conjuroAbierto = signal('');

  // --- dominios (clérigo) ---
  readonly dominios = signal<DomainSummary[]>([]);
  /** Detalle de los dominios elegidos, en el orden domain1, domain2. */
  readonly misDominios = signal<DomainDetail[]>([]);

  // --- ajuste rápido de PG y vigor ---
  readonly ajustandoPg = signal(false);
  readonly ajustandoVigor = signal(false);
  readonly errorAjuste = signal<string | null>(null);

  // --- derivados de la vista ---

  /** Porcentaje de PG, para la barra. */
  readonly porcentajePg = computed(() => {
    const f = this.ficha();
    if (!f || !f.hpMax) return 0;
    return Math.max(0, Math.min(100, Math.round((f.hpCurrent / f.hpMax) * 100)));
  });

  /** El color cuenta el estado antes de leer la cifra: musgo, oro, vino. */
  readonly estadoPg = computed<'bien' | 'medio' | 'mal'>(() => {
    const p = this.porcentajePg();
    return p <= 25 ? 'mal' : (p <= 60 ? 'medio' : 'bien');
  });

  readonly etiquetaPg = computed(() => {
    const e = this.estadoPg();
    return e === 'mal' ? 'malherido' : (e === 'medio' ? 'herido' : 'entero');
  });

  readonly pipsVigor = computed(() => {
    const f = this.ficha();
    if (!f) return [] as boolean[];
    return Array.from({ length: Math.max(0, f.maxVigor) }, (_, i) => i < f.vigor);
  });

  /** El monedero se muestra en las tres monedas, igual que se edita. */
  readonly monedas = computed(() => {
    const cp = this.ficha()?.purseCp ?? 0;
    return { po: Math.floor(cp / 100), pp: Math.floor((cp % 100) / 10), pc: cp % 10 };
  });

  /** Las cinco mejores: lo que se consulta en mesa sin abrir la lista entera. */
  readonly habilidadesTop = computed(() =>
    [...(this.ficha()?.skills ?? [])].sort((a, b) => b.total - a.total).slice(0, 5));

  readonly habilidadesFiltradas = computed<SkillDetail[]>(() => {
    const q = this.busca().trim().toLowerCase();
    const todas = this.ficha()?.skills ?? [];
    return q ? todas.filter(s => s.name.toLowerCase().includes(q)) : todas;
  });

  /** Los conjuros preparados agrupados por nivel, que es como se leen en la
   *  mesa ("los de 1.º", "los de 2.º"). */
  readonly conjurosPorNivel = computed(() => {
    const grupos = new Map<number, PreparedSpell[]>();
    for (const c of this.conjuros()) {
      const lista = grupos.get(c.level) ?? [];
      lista.push(c);
      grupos.set(c.level, lista);
    }
    return [...grupos.entries()]
      .sort((a, b) => a[0] - b[0])
      .map(([nivel, items]) => ({ nivel, items }));
  });

  /** Cuántos conjuros lleva preparados en total (contando repeticiones). */
  readonly totalPreparados = computed(() =>
    this.conjuros().reduce((n, c) => n + c.prepared, 0));

  /** Solo el clérigo elige dominios; el resto no ve esa sección. */
  readonly esClerigo = computed(() =>
    (this.ficha()?.clazz ?? '').trim().toLowerCase().startsWith('cléri')
    || (this.ficha()?.clazz ?? '').trim().toLowerCase().startsWith('cleri'));

  /** Lo llama la página al entrar, con el id de la URL. */
  iniciar(personajeId: string): void {
    if (this.personajeId() === personajeId) return;
    this.personajeId.set(personajeId);
    this.cargar();
    this.cargarInventario();
    this.cargarConjuros();
  }

  private cargar(): void {
    this.cargando.set(true);
    this.juego.ficha(this.personajeId()).subscribe({
      next: f => {
        this.ficha.set(f);
        this.cargando.set(false);
        this.cargarDominios(f);
      },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido abrir la ficha.');
      },
    });
  }

  editar(): void {
    const f = this.ficha();
    if (!f) return;
    const s = (k: string) => f.abilities.find(a => a.key === k)?.score ?? 10;
    this.edit = {
      name: f.name, player: f.player, clazz: f.clazz, level: f.level, race: f.race,
      alignment: f.alignment, deity: f.deity, size: f.size, age: f.age, sex: f.sex,
      height: f.height, weight: f.weight, campaign: f.campaign, location: f.location,
      domain1: f.domain1 ?? '', domain2: f.domain2 ?? '',
      strScore: s('FUE'), dexScore: s('DES'), conScore: s('CON'),
      intScore: s('INT'), wisScore: s('SAB'), chaScore: s('CAR'),
      hpCurrent: f.hpCurrent, hpMax: f.hpMax, acTotal: f.acTotal, acTouch: f.acTouch, acFlatFooted: f.acFlatFooted,
      initiativeMisc: f.initiativeMisc, speed: f.speed, bab: f.bab, grappleMisc: f.grappleMisc, spellResistance: f.spellResistance,
      saveFort: f.saveFort, saveRef: f.saveRef, saveWill: f.saveWill, damageReduction: f.damageReduction,
      vigor: f.vigor, maxVigor: f.maxVigor, carga: f.carga,
    };
    this.editSkills.set(f.skills.map(k => ({ name: k.name, keyAbility: k.keyAbility, ranks: k.ranks, miscMod: k.miscMod })));
    // Descomponer el monedero (cp) en po/pp/pc para editarlo con comodidad.
    const cp = f.purseCp ?? 0;
    this.purseOro.set(Math.floor(cp / 100));
    this.pursePlata.set(Math.floor((cp % 100) / 10));
    this.purseCobre.set(cp % 10);
    this.errorEdit.set(null);
    this.editando.set(true);
    if (this.esClerigo()) this.cargarCatalogoDominios();
  }

  anadirHabilidad(): void {
    this.editSkills.update(rows => [...rows, { name: '', keyAbility: '', ranks: 0, miscMod: 0 }]);
  }

  quitarHabilidad(i: number): void {
    this.editSkills.update(rows => rows.filter((_, idx) => idx !== i));
  }

  guardar(): void {
    if (!this.edit || this.guardando()) return;
    this.guardando.set(true);
    this.errorEdit.set(null);

    const skills = this.editSkills()
      .filter(r => r.name.trim() !== '')
      .map(r => ({ name: r.name, keyAbility: r.keyAbility, ranks: Number(r.ranks) || 0, miscMod: Number(r.miscMod) || 0 }));

    const nn = (s: () => number) => Math.max(0, Math.floor(Number(s()) || 0));
    const purseCp = nn(this.purseOro) * 100 + nn(this.pursePlata) * 10 + nn(this.purseCobre);

    this.juego.editarFicha(this.personajeId(), { ...this.edit, purseCp, skills }).subscribe({
      next: f => {
        this.ficha.set(f);
        this.guardando.set(false);
        this.editando.set(false);
        this.edit = null;
        this.cargarDominios(f);   // puede haber cambiado de dominios
      },
      error: err => {
        this.guardando.set(false);
        this.errorEdit.set(err?.error?.message ?? 'No se han podido guardar los cambios.');
      },
    });
  }

  cancelar(): void {
    this.editando.set(false);
    this.edit = null;
    this.errorEdit.set(null);
  }

  // --- ajuste rápido (daño, curación, vigor) ---

  /**
   * Anota daño o curación sin abrir el editor. Se pinta al momento (la mesa no
   * espera) y, si el backend rechaza el cambio, se devuelve la ficha anterior.
   */
  ajustarPg(delta: number): void {
    const f = this.ficha();
    if (!f || this.ajustandoPg()) return;
    const nuevo = Math.max(0, Math.min(f.hpMax, f.hpCurrent + delta));
    if (nuevo === f.hpCurrent) return;

    this.ajustandoPg.set(true);
    this.errorAjuste.set(null);
    this.ficha.set({ ...f, hpCurrent: nuevo });

    this.juego.editarFicha(this.personajeId(), { hpCurrent: nuevo }).subscribe({
      next: actualizada => { this.ficha.set(actualizada); this.ajustandoPg.set(false); },
      error: () => {
        this.ficha.set(f);
        this.ajustandoPg.set(false);
        this.errorAjuste.set('No se han podido anotar los puntos de golpe.');
      },
    });
  }

  ajustarVigor(delta: number): void {
    const f = this.ficha();
    if (!f || this.ajustandoVigor()) return;
    const nuevo = Math.max(0, Math.min(f.maxVigor, f.vigor + delta));
    if (nuevo === f.vigor) return;

    this.ajustandoVigor.set(true);
    this.errorAjuste.set(null);
    this.ficha.set({ ...f, vigor: nuevo });

    this.juego.editarFicha(this.personajeId(), { vigor: nuevo }).subscribe({
      next: actualizada => { this.ficha.set(actualizada); this.ajustandoVigor.set(false); },
      error: () => {
        this.ficha.set(f);
        this.ajustandoVigor.set(false);
        this.errorAjuste.set('No se ha podido anotar el vigor.');
      },
    });
  }

  alTablon(id: string): void { void this.router.navigate(['/personajes', id, 'tablon']); }
  alaTienda(id: string): void { void this.router.navigate(['/personajes', id, 'tienda']); }

  // --- bolsa / inventario ---

  private cargarInventario(): void {
    this.juego.inventario(this.personajeId()).subscribe({
      next: inv => this.inventario.set(inv),
      error: () => { /* la bolsa es secundaria; no bloquea la ficha */ },
    });
  }

  anadirItem(): void {
    const nombre = this.nuevoNombre().trim();
    if (!nombre) return;
    const cantidad = Math.max(1, Math.floor(Number(this.nuevaCantidad()) || 1));
    const peso = Math.max(0, Number(this.nuevoPeso()) || 0);
    this.errorBolsa.set(null);

    this.juego.anadirItem(this.personajeId(), { name: nombre, quantity: cantidad, weightLb: peso }).subscribe({
      next: inv => {
        this.inventario.set(inv);
        // Vaciar para encadenar añadidos; del foco se encarga el diseño.
        this.nuevoNombre.set('');
        this.nuevaCantidad.set(1);
        this.nuevoPeso.set(0);
        this.itemAnadido.update(n => n + 1);
      },
      error: err => this.errorBolsa.set(err?.error?.message ?? 'No se ha podido añadir.'),
    });
  }

  ajustar(it: InventoryLine, delta: number): void {
    const nueva = it.quantity + delta;   // 0 o menos: el backend lo elimina
    this.juego.fijarCantidad(this.personajeId(), it.id, nueva).subscribe({
      next: inv => this.inventario.set(inv),
      error: () => this.errorBolsa.set('No se ha podido actualizar la cantidad.'),
    });
  }

  eliminar(it: InventoryLine): void {
    this.juego.eliminarItem(this.personajeId(), it.id).subscribe({
      next: inv => this.inventario.set(inv),
      error: () => this.errorBolsa.set('No se ha podido quitar el objeto.'),
    });
  }

  // --- conjuros preparados ---

  private cargarConjuros(): void {
    this.juego.conjuros(this.personajeId()).subscribe({
      next: l => this.conjuros.set(l.items),
      error: () => { /* secundario: no bloquea la ficha */ },
    });
  }

  /**
   * Busca en el grimorio para preparar. Pide al servidor los conjuros de la
   * clase del personaje que casen con el texto; si no hay texto, no busca (la
   * lista entera son ~500 y no aporta nada en un desplegable).
   */
  buscarConjuro(): void {
    const q = this.buscaConjuro().trim();
    if (q.length < 2) { this.resultados.set([]); return; }

    this.buscandoConjuro.set(true);
    const clase = this.ficha()?.clazz ?? '';
    this.juego.hechizos(clase, q, 15).subscribe({
      next: p => { this.resultados.set(p.items); this.buscandoConjuro.set(false); },
      error: () => {
        this.buscandoConjuro.set(false);
        this.errorConjuros.set('No se ha podido buscar en el grimorio.');
      },
    });
  }

  /** Añade el conjuro a la lista preparada. Si ya estaba, suma una preparación. */
  preparar(nombre: string): void {
    this.errorConjuros.set(null);
    this.juego.prepararConjuro(this.personajeId(), nombre).subscribe({
      next: l => {
        this.conjuros.set(l.items);
        this.buscaConjuro.set('');
        this.resultados.set([]);
      },
      error: err => this.errorConjuros.set(err?.error?.message ?? 'No se ha podido preparar.'),
    });
  }

  /** +1 / −1 preparaciones. Al llegar a 0 el backend lo quita de la lista. */
  ajustarConjuro(c: PreparedSpell, delta: number): void {
    this.juego.fijarConjuro(this.personajeId(), c.id, c.prepared + delta).subscribe({
      next: l => this.conjuros.set(l.items),
      error: () => this.errorConjuros.set('No se ha podido cambiar la cantidad.'),
    });
  }

  quitarConjuro(c: PreparedSpell): void {
    this.juego.quitarConjuro(this.personajeId(), c.id).subscribe({
      next: l => this.conjuros.set(l.items),
      error: () => this.errorConjuros.set('No se ha podido quitar el conjuro.'),
    });
  }

  /** Despliega o pliega el detalle de un conjuro preparado. */
  alternarConjuro(nombre: string): void {
    this.conjuroAbierto.update(a => (a === nombre ? '' : nombre));
  }

  // --- dominios (clérigo) ---

  /** Carga el detalle de los dominios elegidos (poder otorgado + conjuros).
   *  La lista para elegir solo hace falta al editar. */
  private cargarDominios(f: Ficha): void {
    const codigos = [f.domain1, f.domain2].filter(c => !!c && c.trim() !== '');
    if (codigos.length === 0) { this.misDominios.set([]); return; }

    const detalles: DomainDetail[] = [];
    for (const code of codigos) {
      this.juego.dominio(code).subscribe({
        next: d => {
          detalles.push(d);
          // Reordenar como los eligió: domain1 primero.
          this.misDominios.set(
            codigos.map(c => detalles.find(x => x.code === c)).filter((x): x is DomainDetail => !!x));
        },
        error: () => { /* un código inválido no rompe la ficha */ },
      });
    }
  }

  /** El selector de dominios del editor: se pide una sola vez. */
  cargarCatalogoDominios(): void {
    if (this.dominios().length > 0) return;
    this.juego.dominios().subscribe({
      next: d => this.dominios.set(d),
      error: () => { /* sin catálogo, los campos quedan vacíos */ },
    });
  }
}
