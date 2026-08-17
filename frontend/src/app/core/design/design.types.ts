import { Type } from '@angular/core';

/**
 * Sistema de diseños intercambiables.
 *
 * La idea: una pantalla se parte en dos. Por un lado el *contenedor*, que tiene
 * el estado y habla con el backend (p. ej. `FichaStore`); por otro los
 * *diseños*, que son componentes con SOLO plantilla y estilos y que leen ese
 * estado. Cambiar de diseño es cambiar qué componente se pinta: la lógica no se
 * toca, ni se duplica.
 *
 * Aquí solo viven los tipos. El catálogo (qué diseños hay) está en
 * `diseno.catalogo.ts`, y la elección del jugador en `diseno.service.ts`.
 */

/**
 * Las pantallas que pueden llevar diseño propio.
 *
 * Están todas listadas aunque hoy solo `ficha` tenga alternativas: el día que
 * la tienda o las notas tengan la suya, basta con registrarlas en el catálogo.
 * El servicio y la pantalla de ajustes ya saben tratarlas.
 */
export type PaginaId =
  | 'ficha' | 'tienda' | 'notas' | 'cronica' | 'propiedades' | 'habilidades' | 'tablon';

/** Un diseño concreto de una pantalla. */
export interface OpcionDiseno {
  /** Se guarda en las preferencias: no lo cambies a la ligera. */
  readonly id: string;
  /** Como se lee en los ajustes. */
  readonly nombre: string;
  /** Una línea contando en qué se diferencia. */
  readonly resumen: string;
  /**
   * Carga perezosa del componente. Es un `import()` dinámico a propósito: el
   * diseño que no se usa no viaja en el bundle inicial.
   */
  readonly cargar: () => Promise<Type<unknown>>;
}

/** Una pantalla y los diseños entre los que se puede elegir. */
export interface PaginaDiseno {
  readonly id: PaginaId;
  readonly nombre: string;
  readonly resumen: string;
  /** La PRIMERA opción es la de por defecto. */
  readonly opciones: readonly OpcionDiseno[];
}

export type CatalogoDisenos = readonly PaginaDiseno[];
