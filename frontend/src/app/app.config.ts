import {
  ApplicationConfig, inject, isDevMode, provideAppInitializer, provideZonelessChangeDetection,
} from '@angular/core';
import { provideRouter, withComponentInputBinding } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { provideServiceWorker } from '@angular/service-worker';

import { routes } from './app.routes';
import { authInterceptor } from './core/auth.interceptor';
import { AuthService } from './core/auth.service';
import { DisenoService } from './core/design/design.service';

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

    // Y el diseño elegido para cada pantalla, antes de la primera pintada: así
    // no se ve un instante el diseño de fábrica antes de cambiar al elegido.
    provideAppInitializer(() => inject(DisenoService).restaurar()),

    // PWA: registra el service worker (solo en build de producción). Con esto
    // la app es instalable ("Añadir a pantalla de inicio") y cachea el shell
    // para arrancar sin conexión. Se registra cuando la app está estable para
    // no competir con la carga inicial.
    provideServiceWorker('ngsw-worker.js', {
      enabled: !isDevMode(),
      registrationStrategy: 'registerWhenStable:30000',
    }),
  ],
};
