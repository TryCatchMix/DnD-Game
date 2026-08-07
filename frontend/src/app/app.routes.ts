import { Routes } from '@angular/router';

/**
 * Las rutas salen de a dónde navegan los componentes:
 *  - login  → '/personajes'
 *  - characters → '/personajes/:id/tablon'
 *  - board/scene → '/personajes/:id/tablon' y '/personajes/:id/escena'
 *
 * El nombre del parámetro es `personajeId` porque board.page y scene.page lo
 * reciben con `input.required<string>('personajeId')` implícito (el input se
 * llama `personajeId`). Para que ese enlace funcione hay que activar
 * withComponentInputBinding() en app.config.ts.
 */
export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'entrar' },

  {
    path: 'entrar',
    loadComponent: () =>
      import('./features/login/login.page').then(m => m.LoginPage),
  },
  {
    path: 'registro',
    loadComponent: () =>
      import('./features/registro/registro.page').then(m => m.RegistroPage),
  },
  {
    path: 'personajes',
    loadComponent: () =>
      import('./features/characters/characters.page').then(m => m.CharactersPage),
  },
  {
    path: 'personajes/nuevo',
    loadComponent: () =>
      import('./features/creador/creador.page').then(m => m.CreadorPage),
  },
  {
    path: 'personajes/:personajeId/ficha',
    loadComponent: () =>
      import('./features/ficha/ficha.page').then(m => m.FichaPage),
  },
  {
    path: 'personajes/:personajeId/tienda',
    loadComponent: () =>
      import('./features/shop/shop.page').then(m => m.ShopPage),
  },
  {
    path: 'personajes/:personajeId/admin',
    loadComponent: () =>
      import('./features/admin/admin.page').then(m => m.AdminPage),
  },
  {
    path: 'personajes/:personajeId/habilidades',
    loadComponent: () =>
      import('./features/habilidades/habilidades.page').then(m => m.HabilidadesPage),
  },
  {
    path: 'personajes/:personajeId/notas',
    loadComponent: () =>
      import('./features/notas/notas.page').then(m => m.NotasPage),
  },
  {
    path: 'personajes/:personajeId/propiedades',
    loadComponent: () =>
      import('./features/propiedades/propiedades.page').then(m => m.PropiedadesPage),
  },
  {
    path: 'personajes/:personajeId/cronica',
    loadComponent: () =>
      import('./features/cronica/cronica.page').then(m => m.CronicaPage),
  },
  {
    path: 'personajes/:personajeId/tablon',
    loadComponent: () =>
      import('./features/board/board.page').then(m => m.BoardPage),
  },
  {
    path: 'personajes/:personajeId/escena',
    loadComponent: () =>
      import('./features/scene/scene.page').then(m => m.ScenePage),
  },

  { path: '**', redirectTo: 'entrar' },
];
