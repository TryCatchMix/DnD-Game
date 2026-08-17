import { Injectable, Signal, computed, inject, signal } from '@angular/core';
import { Preferences } from '@capacitor/preferences';

import { CATALOGO_DISENOS } from './design.catalog';
import { OpcionDiseno, PaginaDiseno, PaginaId } from './design.types';

const CLAVE = 'archivos.disenos';

/** Lo que se guarda: { ficha: 'mesa', tienda: 'gremio' }. */
type Eleccion = Partial<Record<PaginaId, string>>;

/**
 * Qué diseño ve el jugador en cada pantalla.
 *
 * La elección se guarda con @capacitor/preferences, que en la app nativa usa el
 * almacenamiento del sistema y en el navegador cae en localStorage. Aquí sí se
 * persiste en web (a diferencia de la sesión): esto es un gusto, no un secreto.
 *
 * Se restaura al arrancar (`provideAppInitializer` en app.config.ts) para que
 * la primera pintada ya sea la buena y no se vea el diseño por defecto un
 * instante antes de cambiar.
 */
@Injectable({ providedIn: 'root' })
export class DisenoService {

  private readonly catalogo = inject(CATALOGO_DISENOS);

  private readonly eleccion = signal<Eleccion>({});

  /** Computeds memorizados por pantalla: `opcion('ficha')` siempre devuelve el mismo. */
  private readonly cache = new Map<PaginaId, Signal<OpcionDiseno | null>>();

  /** Las pantallas registradas, para pintar los ajustes. */
  readonly paginas = this.catalogo;

  pagina(id: PaginaId): PaginaDiseno | undefined {
    return this.catalogo.find(p => p.id === id);
  }

  /** El diseño elegido para una pantalla (o el de por defecto), como señal. */
  opcion(pagina: PaginaId): Signal<OpcionDiseno | null> {
    let s = this.cache.get(pagina);
    if (!s) {
      s = computed(() => {
        const p = this.pagina(pagina);
        if (!p || p.opciones.length === 0) return null;
        const elegido = this.eleccion()[pagina];
        // Si el id guardado ya no existe (diseño retirado en una versión nueva),
        // se cae con elegancia al de por defecto en vez de dejar la pantalla en blanco.
        return p.opciones.find(o => o.id === elegido) ?? p.opciones[0];
      });
      this.cache.set(pagina, s);
    }
    return s;
  }

  /**
   * El id elegido para una pantalla, ya resuelto contra el catálogo.
   * Lee de la señal por dentro: dentro de una plantilla o un `computed` es
   * reactivo, como si devolviera la señal.
   */
  idElegido(pagina: PaginaId): string | null {
    return this.opcion(pagina)()?.id ?? null;
  }

  /** ¿Sigue esta pantalla con el diseño de fábrica? */
  esPorDefecto(pagina: PaginaId): boolean {
    const p = this.pagina(pagina);
    return !p || this.idElegido(pagina) === p.opciones[0]?.id;
  }

  elegir(pagina: PaginaId, opcionId: string): void {
    const p = this.pagina(pagina);
    if (!p || !p.opciones.some(o => o.id === opcionId)) return;   // id inventado: ni caso
    this.eleccion.update(e => ({ ...e, [pagina]: opcionId }));
    this.guardar();
  }

  /** Vuelve al diseño de fábrica de esa pantalla. */
  restablecer(pagina: PaginaId): void {
    this.eleccion.update(({ [pagina]: _, ...resto }) => resto);
    this.guardar();
  }

  /**
   * Arranque: lee lo guardado. Nunca rechaza — si el JSON está corrupto o la
   * plataforma no deja leer, se juega con los diseños de fábrica y punto.
   */
  async restaurar(): Promise<void> {
    try {
      const { value } = await Preferences.get({ key: CLAVE });
      if (!value) return;
      const crudo: unknown = JSON.parse(value);
      if (!crudo || typeof crudo !== 'object') return;
      this.eleccion.set(this.validar(crudo as Record<string, unknown>));
    } catch {
      /* preferencias ilegibles: se ignoran a propósito */
    }
  }

  /** Se queda solo con pantallas y diseños que existen HOY en el catálogo. */
  private validar(crudo: Record<string, unknown>): Eleccion {
    const limpio: Eleccion = {};
    for (const p of this.catalogo) {
      const id = crudo[p.id];
      if (typeof id === 'string' && p.opciones.some(o => o.id === id)) limpio[p.id] = id;
    }
    return limpio;
  }

  private guardar(): void {
    // Fire-and-forget: guardar un gusto no debe hacer esperar a nadie.
    void Preferences.set({ key: CLAVE, value: JSON.stringify(this.eleccion()) });
  }
}
