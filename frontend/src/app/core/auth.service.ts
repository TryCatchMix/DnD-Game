import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { firstValueFrom, Observable, throwError } from 'rxjs';
import { catchError, finalize, map, shareReplay, tap, timeout } from 'rxjs/operators';

import { TokenStore } from './token-store';
import { RegisterRequest, TokenResponse } from './api.types';

@Injectable({ providedIn: 'root' })
export class AuthService {

  private readonly http = inject(HttpClient);
  private readonly router = inject(Router);
  private readonly store = inject(TokenStore);

  /** Se muestra si la sesión se cerró sola, para no dejar al jugador a ciegas. */
  readonly avisoDeSesion = signal<string | null>(null);

  /** El rol de quien ha entrado (DM | PLAYER). Para mostrar lo que solo puede
   *  hacer el DM, como revelar verdades en la crónica. */
  readonly rol = signal<string | null>(null);

  /**
   * Hay una sesión abierta en esta pestaña. En web el refresh token vive en
   * una cookie httpOnly invisible para el JS, así que no podemos preguntar
   * «¿tengo token?»; en su lugar recordamos si abrimos sesión (login o un
   * refresco con éxito). El interceptor lo usa para decidir si merece la pena
   * intentar un refresco ante un 401.
   */
  readonly sesionActiva = signal(false);

  /**
   * EL REFRESCO EN VUELO. Esta única variable es la razón de ser de esta clase.
   *
   * El backend rota los refresh tokens: cada refresco quema el anterior, y si
   * llega uno ya quemado asume robo y cierra la sesión ENTERA. Eso significa
   * que si el tablón y la ficha piden datos a la vez y ambas reciben un 401,
   * dos refrescos en paralelo con el mismo token echarían al jugador de la
   * partida sin que nadie haya hecho nada malo.
   *
   * Guardando aquí el observable en vuelo y compartiéndolo, la segunda petición
   * no lanza un refresco nuevo: se engancha al que ya está corriendo y espera
   * el mismo token. Un solo refresco por ráfaga, siempre.
   */
  private refrescoEnVuelo: Observable<string> | null = null;

  /** Temporizador del refresco por adelantado. Se reprograma con cada token
   *  nuevo y se cancela al cerrar sesión. */
  private refrescoProgramado: ReturnType<typeof setTimeout> | null = null;

  login(email: string, password: string): Observable<TokenResponse> {
    return this.http
      .post<TokenResponse>('/api/auth/login', { email, password }, this.opcionesAuth())
      .pipe(tap(t => this.abrirSesion(t)));
  }

  /** Alta de cuenta nueva. Deja la sesión iniciada, igual que login. */
  register(datos: RegisterRequest): Observable<TokenResponse> {
    return this.http
      .post<TokenResponse>('/api/auth/register', datos, this.opcionesAuth())
      .pipe(tap(t => this.abrirSesion(t)));
  }

  /**
   * Opciones comunes de las llamadas de autenticación:
   *  - X-Client-Platform le dice al backend si somos web (cookie httpOnly para
   *    el refresh token) o nativo (token en el cuerpo, como siempre).
   *  - withCredentials para que la cookie viaje en las peticiones a /api/auth.
   */
  private opcionesAuth() {
    return {
      headers: { 'X-Client-Platform': this.store.esNativo ? 'native' : 'web' },
      withCredentials: true,
    };
  }

  /** ¿Merece la pena intentar un refresco? Nativo: si hay token guardado.
   *  Web: si teníamos sesión abierta (la cookie httpOnly no se puede consultar). */
  puedeRefrescar(): boolean {
    return this.store.esNativo ? !!this.store.refreshToken() : this.sesionActiva();
  }

  /**
   * ARRANQUE EN MÓVIL. Si hay un refresh token guardado (solo lo hay en la app
   * nativa), lo canjea por una sesión nueva y devuelve true. En web no hay nada
   * guardado, así que devuelve false al instante y no molesta.
   *
   * Lo llama un app-initializer, así que la app espera a esto antes de pintar:
   * cuando resuelve, o hay sesión (access token en memoria) o no la hay.
   */
  async restaurarSesion(): Promise<boolean> {
    if (this.store.esNativo) {
      const guardado = await this.store.restaurar();
      if (!guardado) return false;
      try {
        // timeout para no colgar el arranque si el móvil está sin cobertura.
        await firstValueFrom(this.refrescar().pipe(timeout(6000)));
        return true;
      } catch {
        // Si el token estaba caducado o quemado, refrescar() ya limpió la sesión
        // (y el almacenamiento). Un timeout deja el token para el próximo intento.
        return false;
      }
    }

    // WEB: la sesión, si la hay, vive en la cookie httpOnly. Intentamos
    // canjearla por un access token. Si no hay cookie (visitante nuevo o
    // sesión caducada), el backend responde 401 y arrancamos sin sesión, en
    // silencio: nada de «tu sesión ha caducado» a quien nunca entró.
    try {
      await firstValueFrom(this.refrescar().pipe(timeout(6000)));
      return true;
    } catch {
      this.avisoDeSesion.set(null);
      return false;
    }
  }

  /** Guardado común de login y registro. */
  private abrirSesion(t: TokenResponse): void {
    this.store.save(t);
    this.avisoDeSesion.set(null);
    this.rol.set(t.role ?? null);
    this.sesionActiva.set(true);
    this.programarRefresco(t.expiresIn);
  }

  /**
   * Devuelve un access token nuevo. Llamadas simultáneas comparten el mismo
   * viaje al servidor.
   */
  refrescar(): Observable<string> {
    if (this.refrescoEnVuelo) return this.refrescoEnVuelo;

    // Nativo: el token va en el cuerpo y debe existir. Web: el token viaja en
    // la cookie httpOnly, así que mandamos el cuerpo vacío y deja que el
    // backend lo lea (o responda 401 si no hay cookie).
    const refreshToken = this.store.refreshToken();
    if (this.store.esNativo && !refreshToken) return throwError(() => new Error('Sin sesión'));
    const cuerpo = this.store.esNativo ? { refreshToken } : {};

    this.refrescoEnVuelo = this.http
      .post<TokenResponse>('/api/auth/refresh', cuerpo, this.opcionesAuth())
      .pipe(
        tap(t => {
          this.store.save(t);
          this.rol.set(t.role ?? null);
          this.sesionActiva.set(true);
          this.programarRefresco(t.expiresIn);
        }),
        map(t => t.accessToken),
        catchError(err => {
          // 401 con código TOKEN_REUSE_DETECTED significa que el backend vio un
          // token quemado. Si esto pasa con el refresco serializado, es de
          // verdad: merece un mensaje distinto al de "se te caducó la sesión".
          const codigo = err?.error?.error;
          this.cerrarSesionLocal(
            codigo === 'TOKEN_REUSE_DETECTED'
              ? 'Se ha detectado un uso anómalo de tu sesión. Entra de nuevo.'
              : 'Tu sesión ha caducado. Entra de nuevo.');
          return throwError(() => err);
        }),
        // Se limpia SIEMPRE, también al fallar: si no, un fallo dejaría el
        // observable muerto cacheado y ningún refresco volvería a funcionar.
        finalize(() => { this.refrescoEnVuelo = null; }),
        shareReplay({ bufferSize: 1, refCount: false }),
      );

    return this.refrescoEnVuelo;
  }

  logout(): void {
    // No esperamos la respuesta: el cierre local es lo que le importa al
    // jugador. En nativo mandamos el token del cuerpo; en web el backend lee
    // (y borra) la cookie httpOnly. Si la petición falla, el token caduca solo.
    const refreshToken = this.store.refreshToken();
    const cuerpo = this.store.esNativo ? { refreshToken } : {};
    this.http.post('/api/auth/logout', cuerpo, this.opcionesAuth()).subscribe({
      error: () => { /* da igual */ },
    });
    this.cerrarSesionLocal(null);
  }

  private cerrarSesionLocal(aviso: string | null): void {
    this.cancelarRefrescoProgramado();
    this.store.clear();
    this.rol.set(null);
    this.sesionActiva.set(false);
    this.avisoDeSesion.set(aviso);
    void this.router.navigate(['/entrar']);
  }

  /**
   * Refresco POR ADELANTADO. En vez de esperar a comerse un 401, renovamos el
   * access token un minuto antes de que caduque. Así una petición nunca llega
   * con el token justo vencido.
   *
   * Reutiliza refrescar(), que ya está serializado: si por lo que sea coincide
   * con un refresco disparado por el interceptor, se enganchan al mismo.
   */
  private programarRefresco(expiresIn: number | undefined): void {
    this.cancelarRefrescoProgramado();
    if (!expiresIn) return;

    // Un minuto antes, con un suelo de 5 s para no entrar en bucle si el token
    // viene con una vida ridículamente corta.
    const margen = Math.max(expiresIn - 60, 5);
    this.refrescoProgramado = setTimeout(() => {
      this.refrescoProgramado = null;
      // Sin sesión no hay nada que renovar; si falla, refrescar() ya cierra.
      if (this.puedeRefrescar()) this.refrescar().subscribe({ error: () => {} });
    }, margen * 1000);
  }

  private cancelarRefrescoProgramado(): void {
    if (this.refrescoProgramado) {
      clearTimeout(this.refrescoProgramado);
      this.refrescoProgramado = null;
    }
  }
}
