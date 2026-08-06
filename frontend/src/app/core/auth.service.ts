import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, throwError } from 'rxjs';
import { catchError, finalize, map, shareReplay, tap } from 'rxjs/operators';

import { TokenStore } from './token-store';
import { TokenResponse } from './api.types';

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
      .post<TokenResponse>('/api/auth/login', { email, password })
      .pipe(tap(t => {
        this.store.save(t);
        this.avisoDeSesion.set(null);
        this.rol.set(t.role ?? null);
        this.programarRefresco(t.expiresIn);
      }));
  }

  /**
   * Devuelve un access token nuevo. Llamadas simultáneas comparten el mismo
   * viaje al servidor.
   */
  refrescar(): Observable<string> {
    if (this.refrescoEnVuelo) return this.refrescoEnVuelo;

    const refreshToken = this.store.refreshToken();
    if (!refreshToken) return throwError(() => new Error('Sin sesión'));

    this.refrescoEnVuelo = this.http
      .post<TokenResponse>('/api/auth/refresh', { refreshToken })
      .pipe(
        tap(t => {
          this.store.save(t);
          this.rol.set(t.role ?? null);
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
    const refreshToken = this.store.refreshToken();
    if (refreshToken) {
      // No esperamos la respuesta: el cierre local es lo que le importa al
      // jugador, y si la petición falla el token caduca solo en 30 días.
      this.http.post('/api/auth/logout', { refreshToken }).subscribe({
        error: () => { /* da igual */ },
      });
    }
    this.cerrarSesionLocal(null);
  }

  private cerrarSesionLocal(aviso: string | null): void {
    this.cancelarRefrescoProgramado();
    this.store.clear();
    this.rol.set(null);
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
      if (this.store.refreshToken()) this.refrescar().subscribe({ error: () => {} });
    }, margen * 1000);
  }

  private cancelarRefrescoProgramado(): void {
    if (this.refrescoProgramado) {
      clearTimeout(this.refrescoProgramado);
      this.refrescoProgramado = null;
    }
  }
}
