import { InjectionToken } from '@angular/core';

import { CatalogoDisenos } from './diseno.types';

/**
 * El catálogo: el único sitio donde se declara qué diseños existen.
 *
 * Para AÑADIR UN DISEÑO NUEVO (tres pasos, ninguno toca la lógica):
 *   1. Crea el componente en `features/<pantalla>/disenos/<nombre>.ts`.
 *      Solo plantilla y estilos: el estado lo saca con `inject(FichaStore)`.
 *   2. Añade aquí su entrada con un `id` estable y un `import()` dinámico.
 *   3. Ya está. Aparece solo en Ajustes → Diseño.
 *
 * Para añadir una PANTALLA nueva (tienda, notas…):
 *   1. Parte la página en contenedor (store con la lógica) + diseños.
 *   2. Registra la pantalla aquí con sus opciones.
 *   3. En la página, pinta `<arc-diseno pagina="tienda" />`.
 *
 * El orden importa: la primera opción de cada pantalla es la de por defecto,
 * la que ve quien no ha elegido nada.
 */
export const CATALOGO_POR_DEFECTO: CatalogoDisenos = [
  {
    id: 'ficha',
    nombre: 'Ficha',
    resumen: 'La hoja de personaje D&D 3.5.',
    opciones: [
      {
        id: 'pergamino',
        nombre: 'Pergamino',
        resumen: 'La hoja impresa de siempre: dos columnas, pestañas y casillas sobre papel.',
        cargar: () => import('../../features/ficha/disenos/pergamino')
          .then(m => m.FichaPergamino),
      },
      {
        id: 'mesa',
        nombre: 'Mesa de noche',
        resumen: 'Una sola columna sobre fondo oscuro, cifras grandes y todo a la vista sin pestañas.',
        cargar: () => import('../../features/ficha/disenos/mesa')
          .then(m => m.FichaMesa),
      },
    ],
  },
];

/**
 * El catálogo se inyecta (en vez de importarse a pelo) para que un test pueda
 * sustituirlo por dos diseños de mentira sin arrastrar la app entera.
 */
export const CATALOGO_DISENOS = new InjectionToken<CatalogoDisenos>('CATALOGO_DISENOS', {
  providedIn: 'root',
  factory: () => CATALOGO_POR_DEFECTO,
});
