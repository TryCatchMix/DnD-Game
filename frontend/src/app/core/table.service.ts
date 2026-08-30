import { Injectable, Signal, WritableSignal, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import {
  Archivo, Coincidencia, Combate, Combatiente, DetalleMision, Enemigo, EnemigoRequest,
  MisionRequest, NotaRequest, ResumenCombate, VistaMesa,
} from './table.types';

/**
 * Todo lo que La Mesa le pide al backend. Rutas /api/mesa/**, solo DM.
 *
 * Lo único raro de este servicio es cómo se pintan los archivos: la ruta del
 * contenido va con Bearer como el resto de la API, así que NO se puede meter en
 * un <img src>. Se baja el blob con HttpClient y se convierte en object URL.
 * De ahí la caché: un mapa id → señal con la URL, para que la misma imagen no
 * se baje una vez por cada tarjeta que la enseñe.
 */
@Injectable({ providedIn: 'root' })
export class MesaService {

  private readonly http = inject(HttpClient);

  /** id de archivo → señal con su object URL ('' si falló, null mientras baja). */
  private readonly cache = new Map<string, WritableSignal<string | null>>();

  // ------------------------------------------------------------------ misiones

  misiones(): Observable<VistaMesa> {
    return this.http.get<VistaMesa>('/api/mesa/misiones');
  }

  crearMision(req: MisionRequest): Observable<DetalleMision> {
    return this.http.post<DetalleMision>('/api/mesa/misiones', req);
  }

  mision(id: string): Observable<DetalleMision> {
    return this.http.get<DetalleMision>(`/api/mesa/misiones/${id}`);
  }

  editarMision(id: string, req: MisionRequest): Observable<DetalleMision> {
    return this.http.put<DetalleMision>(`/api/mesa/misiones/${id}`, req);
  }

  /** Devuelve la rejilla ya sin ella. */
  borrarMision(id: string): Observable<VistaMesa> {
    return this.http.delete<VistaMesa>(`/api/mesa/misiones/${id}`);
  }

  // --------------------------------------------------------------------- guion

  anadirNota(misionId: string, req: NotaRequest): Observable<DetalleMision> {
    return this.http.post<DetalleMision>(`/api/mesa/misiones/${misionId}/notas`, req);
  }

  editarNota(notaId: string, req: NotaRequest): Observable<DetalleMision> {
    return this.http.put<DetalleMision>(`/api/mesa/notas/${notaId}`, req);
  }

  moverNota(notaId: string, arriba: boolean): Observable<DetalleMision> {
    return this.http.post<DetalleMision>(`/api/mesa/notas/${notaId}/mover?arriba=${arriba}`, {});
  }

  quitarNota(notaId: string): Observable<DetalleMision> {
    return this.http.delete<DetalleMision>(`/api/mesa/notas/${notaId}`);
  }

  // ------------------------------------------------------------------ material

  biblioteca(): Observable<Archivo[]> {
    return this.http.get<Archivo[]>('/api/mesa/archivos');
  }

  /** Busca la frase DENTRO del texto de los PDF, no solo en los títulos. */
  buscarEnPdf(q: string): Observable<Coincidencia[]> {
    return this.http.get<Coincidencia[]>('/api/mesa/buscar', { params: { q } });
  }

  /** Indexa los PDF viejos (subidos antes de la búsqueda). Devuelve cuántos. */
  reindexar(): Observable<number> {
    return this.http.post<number>('/api/mesa/archivos/reindexar', {});
  }

  /** Sube un fichero. Sin misión, se queda en la biblioteca general. */
  subir(file: File, misionId?: string | null): Observable<Archivo> {
    const cuerpo = new FormData();
    cuerpo.append('archivo', file, file.name);
    const query = misionId ? `?misionId=${misionId}` : '';
    return this.http.post<Archivo>(`/api/mesa/archivos${query}`, cuerpo);
  }

  /** Renombrar o mover de misión. misionId '' lo devuelve a la biblioteca. */
  editarArchivo(id: string, cambios: { title?: string; misionId?: string }): Observable<Archivo> {
    return this.http.put<Archivo>(`/api/mesa/archivos/${id}`, cambios);
  }

  borrarArchivo(id: string): Observable<void> {
    this.olvidar(id);
    return this.http.delete<void>(`/api/mesa/archivos/${id}`);
  }

  // ------------------------------------------------------- contenido (blobs)

  /**
   * La URL local del contenido de un archivo. Devuelve una señal porque el blob
   * tarda: null mientras baja, '' si no se pudo, y la object URL cuando está.
   */
  contenido(assetId: string): Signal<string | null> {
    const guardada = this.cache.get(assetId);
    if (guardada) return guardada.asReadonly();

    const url = signal<string | null>(null);
    this.cache.set(assetId, url);
    this.http.get(`/api/mesa/archivos/${assetId}/contenido`, { responseType: 'blob' })
      .subscribe({
        next: b => url.set(URL.createObjectURL(b)),
        error: () => url.set(''),
      });
    return url.asReadonly();
  }

  /** Suelta la object URL de un archivo (al borrarlo o al reemplazarlo). */
  olvidar(assetId: string): void {
    const s = this.cache.get(assetId);
    const url = s?.();
    if (url) URL.revokeObjectURL(url);
    this.cache.delete(assetId);
  }
  // ------------------------------------------------------- enemigos y combate

  enemigos(): Observable<Enemigo[]> {
    return this.http.get<Enemigo[]>('/api/mesa/enemigos');
  }

  /** Copiar una criatura del bestiario a la lista del máster. Es una copia:
   *  el bestiario no se toca. */
  copiarDelBestiario(monsterId: string, name?: string, misionId?: string): Observable<Enemigo> {
    return this.http.post<Enemigo>('/api/mesa/enemigos/del-bestiario',
      { monsterId, name, misionId });
  }

  crearEnemigo(req: EnemigoRequest): Observable<Enemigo> {
    return this.http.post<Enemigo>('/api/mesa/enemigos', req);
  }

  editarEnemigo(id: string, req: EnemigoRequest): Observable<Enemigo> {
    return this.http.put<Enemigo>(`/api/mesa/enemigos/${id}`, req);
  }

  borrarEnemigo(id: string): Observable<void> {
    return this.http.delete<void>(`/api/mesa/enemigos/${id}`);
  }

  combates(): Observable<ResumenCombate[]> {
    return this.http.get<ResumenCombate[]>('/api/mesa/combates');
  }

  abrirCombate(title: string, misionId?: string): Observable<Combate> {
    return this.http.post<Combate>('/api/mesa/combates', { title, misionId });
  }

  combate(id: string): Observable<Combate> {
    return this.http.get<Combate>(`/api/mesa/combates/${id}`);
  }

  cerrarCombate(id: string): Observable<void> {
    return this.http.delete<void>(`/api/mesa/combates/${id}`);
  }

  meterEnemigos(combateId: string, enemigoId: string, count: number): Observable<Combate> {
    return this.http.post<Combate>(`/api/mesa/combates/${combateId}/enemigos`,
      { enemigoId, count });
  }

  meterPersonaje(combateId: string, characterId: string): Observable<Combate> {
    return this.http.post<Combate>(`/api/mesa/combates/${combateId}/personajes`,
      { characterId });
  }

  meterSuelto(combateId: string, name: string, hpMax: number, ac: number): Observable<Combate> {
    return this.http.post<Combate>(`/api/mesa/combates/${combateId}/sueltos`,
      { name, hpMax, ac });
  }

  /** Tira 1d20 + modificador por quien no tenga iniciativa puesta. */
  tirarIniciativa(combateId: string, personajes: boolean): Observable<Combate> {
    return this.http.post<Combate>(`/api/mesa/combates/${combateId}/iniciativa`, null,
      { params: { personajes: String(personajes) } });
  }

  siguienteTurno(combateId: string): Observable<Combate> {
    return this.http.post<Combate>(`/api/mesa/combates/${combateId}/siguiente`, null);
  }

  /** Daño (negativo) o curación (positivo). */
  cambiarPg(combateId: string, combatantId: string, delta: number): Observable<Combate> {
    return this.http.post<Combate>(
      `/api/mesa/combates/${combateId}/combatientes/${combatantId}/pg`, { delta });
  }

  editarCombatiente(combateId: string, combatantId: string,
                    cambios: Partial<Combatiente>): Observable<Combate> {
    return this.http.put<Combate>(
      `/api/mesa/combates/${combateId}/combatientes/${combatantId}`, cambios);
  }

  quitarCombatiente(combateId: string, combatantId: string): Observable<Combate> {
    return this.http.delete<Combate>(
      `/api/mesa/combates/${combateId}/combatientes/${combatantId}`);
  }

}
