import { HttpErrorResponse, HttpInterceptorFn, HttpRequest } from '@angular/common/http';
import { inject } from '@angular/core';
import { catchError, switchMap, throwError } from 'rxjs';

import { AuthService } from './auth.service';
import { TokenStore } from './token-store';

/** Endpoints que NO llevan token y que nunca deben disparar un refresco. */
const PUBLICOS = ['/api/auth/login', '/api/auth/refresh', '/api/auth/logout'];

function conToken(req: HttpRequest<unknown>, token: string): HttpRequest<unknown> {
  return req.clone({ setHeaders: { Authorization: `Bearer ${token}` } });
}

/**
 * Pone el token en cada petición y, ante un 401, refresca y reintenta UNA vez.
 *
 * El reintento único es deliberado: si la petición vuelve a dar 401 con un
 * token recién emitido, el problema no es la caducidad, y reintentar en bucle
 * solo aplazaría el error real.
 */
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthService);
  const store = inject(TokenStore);

  if (PUBLICOS.some(p => req.url.startsWith(p))) return next(req);

  const token = store.accessToken();
  const peticion = token ? conToken(req, token) : req;

  return next(peticion).pipe(
    catchError((err: HttpErrorResponse) => {
      if (err.status !== 401 || !store.refreshToken()) return throwError(() => err);

      // auth.refrescar() serializa: si ya hay uno en vuelo, se engancha a él.
      return auth.refrescar().pipe(
        switchMap(nuevo => next(conToken(req, nuevo))),
      );
    }),
  );
};
