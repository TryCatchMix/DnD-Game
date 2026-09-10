import { Injectable, Signal, WritableSignal, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';

import {
  Campana, CampanaRequest, ContextoCampana, DetalleCampana, VistaCampanas,
} from './campaign.types';

/** Lo que devuelve el backend cuando el personaje no está en ninguna campaña. */
const SIN_CAMPANA: ContextoCampana = { campaignId: null, name: null, role: null, dm: false };

/**
 * Las campañas: crearlas, entrar con un código y llevar personajes.
 *
 * LO ÚNICO QUE MERECE EXPLICACIÓN ES LA CACHÉ DE CONTEXTOS.
 *
 * Casi todas las pantallas viven en /personajes/:id/algo, pero lo que pintan
 * —el bloc, la tienda, el tablón, La Mesa— es de la campaña. Así que antes de
 * pedir nada hay que traducir personaje → campaña, y eso lo pregunta también la
 * barra de pestañas para saber si enseña las del máster.
 *
 * Sin caché serían dos o tres viajes idénticos en cada navegación. Con ella, el
 * primero que pregunta trae el contexto y los demás leen la misma señal. Se
 * vacía en cuanto algo lo puede haber cambiado (unirse, salir, borrar).
 */
@Injectable({ providedIn: 'root' })
export class CampanasService {

  private readonly http = inject(HttpClient);

  /** personajeId → señal con su contexto (null mientras se pregunta). */
  private readonly contextos = new Map<string, WritableSignal<ContextoCampana | null>>();

  // ------------------------------------------------------------------- lista

  mias(): Observable<VistaCampanas> {
    return this.http.get<VistaCampanas>('/api/campanas');
  }

  abrir(campanaId: string): Observable<DetalleCampana> {
    return this.http.get<DetalleCampana>(`/api/campanas/${campanaId}`);
  }

  crear(req: CampanaRequest): Observable<DetalleCampana> {
    return this.http.post<DetalleCampana>('/api/campanas', req).pipe(tap(() => this.olvidar()));
  }

  editar(campanaId: string, req: CampanaRequest): Observable<DetalleCampana> {
    return this.http.put<DetalleCampana>(`/api/campanas/${campanaId}`, req)
      .pipe(tap(() => this.olvidar()));
  }

  borrar(campanaId: string): Observable<VistaCampanas> {
    return this.http.delete<VistaCampanas>(`/api/campanas/${campanaId}`)
      .pipe(tap(() => this.olvidar()));
  }

  /** Un código nuevo: el viejo deja de valer al instante. */
  renovarCodigo(campanaId: string): Observable<DetalleCampana> {
    return this.http.post<DetalleCampana>(`/api/campanas/${campanaId}/codigo`, {});
  }

  // ------------------------------------------------------------------ entrar

  /** Entrar con el código. Si va un personaje, entra con él. */
  unirse(code: string, personajeId?: string | null): Observable<DetalleCampana> {
    return this.http.post<DetalleCampana>('/api/campanas/unirse', { code, personajeId })
      .pipe(tap(() => this.olvidar()));
  }

  apuntar(campanaId: string, personajeId: string): Observable<DetalleCampana> {
    return this.http.post<DetalleCampana>(`/api/campanas/${campanaId}/personajes/${personajeId}`, {})
      .pipe(tap(() => this.olvidar()));
  }

  sacar(campanaId: string, personajeId: string): Observable<DetalleCampana> {
    return this.http.delete<DetalleCampana>(`/api/campanas/${campanaId}/personajes/${personajeId}`)
      .pipe(tap(() => this.olvidar()));
  }

  salir(campanaId: string): Observable<VistaCampanas> {
    return this.http.post<VistaCampanas>(`/api/campanas/${campanaId}/salir`, {})
      .pipe(tap(() => this.olvidar()));
  }

  expulsar(campanaId: string, userId: string): Observable<DetalleCampana> {
    return this.http.delete<DetalleCampana>(`/api/campanas/${campanaId}/miembros/${userId}`)
      .pipe(tap(() => this.olvidar()));
  }

  cambiarPapel(campanaId: string, userId: string, role: 'DM' | 'PLAYER'): Observable<DetalleCampana> {
    return this.http.put<DetalleCampana>(`/api/campanas/${campanaId}/miembros/${userId}`, { role })
      .pipe(tap(() => this.olvidar()));
  }

  // ---------------------------------------------------------------- contexto

  /**
   * El contexto de un personaje como señal: null mientras se pregunta, y luego
   * el contexto (con campaignId a null si no está en ninguna campaña). Varias
   * pantallas pueden pedir el mismo sin que se repita la petición.
   */
  contexto(personajeId: string): Signal<ContextoCampana | null> {
    const guardado = this.contextos.get(personajeId);
    if (guardado) return guardado.asReadonly();

    const s = signal<ContextoCampana | null>(null);
    this.contextos.set(personajeId, s);
    this.http.get<ContextoCampana>(`/api/personajes/${personajeId}/campana`).subscribe({
      next: c => s.set(c),
      // Si falla (sesión caída, personaje ajeno), se responde «sin campaña»: la
      // pantalla enseña su aviso en vez de quedarse cargando para siempre.
      error: () => s.set(SIN_CAMPANA),
    });
    return s.asReadonly();
  }

  /** Igual, pero de una sola vez, para quien no quiere señales. */
  contextoDe(personajeId: string): Observable<ContextoCampana> {
    return this.http.get<ContextoCampana>(`/api/personajes/${personajeId}/campana`);
  }

  /** Tira la caché: algo ha cambiado a qué campaña pertenece qué. */
  olvidar(): void {
    this.contextos.clear();
  }

  /** El nombre para enseñar, sin repetir el «(sin campaña)» por ahí. */
  static nombre(c: Campana | null | undefined): string {
    return c?.name ?? 'Sin campaña';
  }
}
