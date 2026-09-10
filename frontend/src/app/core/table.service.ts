import { Injectable, Signal, WritableSignal, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import {
  Archivo, Coincidencia, Combate, Combatiente, DetalleMision, Enemigo, EnemigoRequest,
  MisionRequest, NotaRequest, ResumenCombate, VistaMesa,
} from './table.types';

/**
 * Todo lo que La Mesa le pide al backend. Las rutas cuelgan de la campaña
 * (/api/campanas/{id}/mesa/**) porque el guion, los mapas y los enemigos son de
 * una partida concreta; entra quien la dirija.
 *
 * De ahí `usar()`: la pantalla resuelve en qué campaña juega el personaje de la
 * URL y se lo dice a este servicio antes de pedir nada. Guardarlo aquí evita
 * arrastrar el id por los siete métodos de cada panel, y no se queda viejo
 * porque La Mesa solo se entra por table.page, que lo fija al abrirse.
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

  /** La campaña cuya mesa se está preparando. */
  private readonly campana = signal<string | null>(null);

  /**
   * Fija la campaña y suelta los blobs de la anterior: los mapas de una partida
   * no tienen por qué seguir en memoria mientras se prepara otra, y así una
   * misma id de archivo nunca puede devolver la imagen de la mesa de al lado.
   */
  usar(campanaId: string): void {
    if (this.campana() === campanaId) return;
    for (const id of [...this.cache.keys()]) this.olvidar(id);
    this.campana.set(campanaId);
  }

  /** El prefijo de todas las rutas. Sin campaña no hay mesa que preparar. */
  private base(): string {
    const id = this.campana();
    if (!id) throw new Error('La Mesa necesita saber en qué campaña está.');
    return `/api/campanas/${id}/mesa`;
  }

  // ------------------------------------------------------------------ misiones

  misiones(): Observable<VistaMesa> {
    return this.http.get<VistaMesa>(`${this.base()}/misiones`);
  }

  crearMision(req: MisionRequest): Observable<DetalleMision> {
    return this.http.post<DetalleMision>(`${this.base()}/misiones`, req);
  }

  mision(id: string): Observable<DetalleMision> {
    return this.http.get<DetalleMision>(`${this.base()}/misiones/${id}`);
  }

  editarMision(id: string, req: MisionRequest): Observable<DetalleMision> {
    return this.http.put<DetalleMision>(`${this.base()}/misiones/${id}`, req);
  }

  /** Devuelve la rejilla ya sin ella. */
  borrarMision(id: string): Observable<VistaMesa> {
    return this.http.delete<VistaMesa>(`${this.base()}/misiones/${id}`);
  }

  // --------------------------------------------------------------------- guion

  anadirNota(misionId: string, req: NotaRequest): Observable<DetalleMision> {
    return this.http.post<DetalleMision>(`${this.base()}/misiones/${misionId}/notas`, req);
  }

  editarNota(notaId: string, req: NotaRequest): Observable<DetalleMision> {
    return this.http.put<DetalleMision>(`${this.base()}/notas/${notaId}`, req);
  }

  moverNota(notaId: string, arriba: boolean): Observable<DetalleMision> {
    return this.http.post<DetalleMision>(`${this.base()}/notas/${notaId}/mover?arriba=${arriba}`, {});
  }

  quitarNota(notaId: string): Observable<DetalleMision> {
    return this.http.delete<DetalleMision>(`${this.base()}/notas/${notaId}`);
  }

  // ------------------------------------------------------------------ material

  biblioteca(): Observable<Archivo[]> {
    return this.http.get<Archivo[]>(`${this.base()}/archivos`);
  }

  /** Busca la frase DENTRO del texto de los PDF, no solo en los títulos. */
  buscarEnPdf(q: string): Observable<Coincidencia[]> {
    return this.http.get<Coincidencia[]>(`${this.base()}/buscar`, { params: { q } });
  }

  /** Indexa los PDF viejos (subidos antes de la búsqueda). Devuelve cuántos. */
  reindexar(): Observable<number> {
    return this.http.post<number>(`${this.base()}/archivos/reindexar`, {});
  }

  /** Sube un fichero. Sin misión, se queda en la biblioteca general. */
  subir(file: File, misionId?: string | null): Observable<Archivo> {
    const cuerpo = new FormData();
    cuerpo.append('archivo', file, file.name);
    const query = misionId ? `?misionId=${misionId}` : '';
    return this.http.post<Archivo>(`${this.base()}/archivos${query}`, cuerpo);
  }

  /** Renombrar o mover de misión. misionId '' lo devuelve a la biblioteca. */
  editarArchivo(id: string, cambios: { title?: string; misionId?: string }): Observable<Archivo> {
    return this.http.put<Archivo>(`${this.base()}/archivos/${id}`, cambios);
  }

  borrarArchivo(id: string): Observable<void> {
    this.olvidar(id);
    return this.http.delete<void>(`${this.base()}/archivos/${id}`);
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
    this.http.get(`${this.base()}/archivos/${assetId}/contenido`, { responseType: 'blob' })
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
    return this.http.get<Enemigo[]>(`${this.base()}/enemigos`);
  }

  /** Copiar una criatura del bestiario a la lista del máster. Es una copia:
   *  el bestiario no se toca. */
  copiarDelBestiario(monsterId: string, name?: string, misionId?: string): Observable<Enemigo> {
    return this.http.post<Enemigo>(`${this.base()}/enemigos/del-bestiario`,
      { monsterId, name, misionId });
  }

  crearEnemigo(req: EnemigoRequest): Observable<Enemigo> {
    return this.http.post<Enemigo>(`${this.base()}/enemigos`, req);
  }

  editarEnemigo(id: string, req: EnemigoRequest): Observable<Enemigo> {
    return this.http.put<Enemigo>(`${this.base()}/enemigos/${id}`, req);
  }

  borrarEnemigo(id: string): Observable<void> {
    return this.http.delete<void>(`${this.base()}/enemigos/${id}`);
  }

  combates(): Observable<ResumenCombate[]> {
    return this.http.get<ResumenCombate[]>(`${this.base()}/combates`);
  }

  abrirCombate(title: string, misionId?: string): Observable<Combate> {
    return this.http.post<Combate>(`${this.base()}/combates`, { title, misionId });
  }

  combate(id: string): Observable<Combate> {
    return this.http.get<Combate>(`${this.base()}/combates/${id}`);
  }

  cerrarCombate(id: string): Observable<void> {
    return this.http.delete<void>(`${this.base()}/combates/${id}`);
  }

  meterEnemigos(combateId: string, enemigoId: string, count: number): Observable<Combate> {
    return this.http.post<Combate>(`${this.base()}/combates/${combateId}/enemigos`,
      { enemigoId, count });
  }

  meterPersonaje(combateId: string, characterId: string): Observable<Combate> {
    return this.http.post<Combate>(`${this.base()}/combates/${combateId}/personajes`,
      { characterId });
  }

  meterSuelto(combateId: string, name: string, hpMax: number, ac: number): Observable<Combate> {
    return this.http.post<Combate>(`${this.base()}/combates/${combateId}/sueltos`,
      { name, hpMax, ac });
  }

  /** Tira 1d20 + modificador por quien no tenga iniciativa puesta. */
  tirarIniciativa(combateId: string, personajes: boolean): Observable<Combate> {
    return this.http.post<Combate>(`${this.base()}/combates/${combateId}/iniciativa`, null,
      { params: { personajes: String(personajes) } });
  }

  siguienteTurno(combateId: string): Observable<Combate> {
    return this.http.post<Combate>(`${this.base()}/combates/${combateId}/siguiente`, null);
  }

  /** Daño (negativo) o curación (positivo). */
  cambiarPg(combateId: string, combatantId: string, delta: number): Observable<Combate> {
    return this.http.post<Combate>(
      `${this.base()}/combates/${combateId}/combatientes/${combatantId}/pg`, { delta });
  }

  editarCombatiente(combateId: string, combatantId: string,
                    cambios: Partial<Combatiente>): Observable<Combate> {
    return this.http.put<Combate>(
      `${this.base()}/combates/${combateId}/combatientes/${combatantId}`, cambios);
  }

  quitarCombatiente(combateId: string, combatantId: string): Observable<Combate> {
    return this.http.delete<Combate>(
      `${this.base()}/combates/${combateId}/combatientes/${combatantId}`);
  }

}
