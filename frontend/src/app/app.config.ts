import {
  ApplicationConfig, inject, provideAppInitializer, provideZonelessChangeDetection,
} from '@angular/core';
import { provideRouter, withComponentInputBinding } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';

import { routes } from './app.routes';
import { authInterceptor } from './core/auth.interceptor';
import { AuthService } from './core/auth.service';

export const appConfig: ApplicationConfig = {
  providers: [
    // Zoneless: sin zone.js. La detección de cambios la disparan las signals.
    provideZonelessChangeDetection(),

    // withComponentInputBinding: pasa :personajeId de la URL al input del
    // componente. Sin esto, board.page y scene.page recibirían undefined.
    provideRouter(routes, withComponentInputBinding()),

    // El interceptor pone el token y refresca ante un 401.
    provideHttpClient(withInterceptors([authInterceptor])),

    // Al arrancar, intenta restaurar la sesión guardada (solo hace algo en la
    // app nativa; en web resuelve al instante sin sesión).
    provideAppInitializer(() => inject(AuthService).restaurarSesion()),
  ],
};
