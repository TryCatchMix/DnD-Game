import { Injectable, Signal, WritableSignal, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';

import { CampoPnj, Elenco, ElencoSuelto, PnjRequest, RelacionRequest } from './cast.types';

/**
 * Todo lo que el elenco le pide al backend.
 *
 * Las rutas cuelgan de la campaña (/api/campanas/{id}/elenco/**) porque la
 * gente de una partida no sale en la de al lado. De ahí `usar()`: la pantalla
 * traduce personaje → campaña una vez y se lo dice al servicio, en lugar de
 * arrastrar el id por los catorce métodos.
 *
 * Lo único que merece explicación es el RETRATO. Su ruta va con Bearer como
 * todo lo demás, así que no se puede meter en un <img src> a pelo: se baja el
 * blob y se convierte en object URL. La caché es un mapa pnjId → señal, para
 * que la misma cara no se baje una vez por la tarjeta y otra por la ficha.
 * Se suelta cuando la foto cambia, y entera al cambiar de campaña: una id de
 * PNJ nunca puede devolver la cara de otra mesa.
 */
@Injectable({ providedIn: 'root' })
export class ElencoService {

  private readonly http = inject(HttpClient);

  /** pnjId → señal con su object URL ('' si no se pudo, null mientras baja). */
  private readonly caras = new Map<string, WritableSignal<string | null>>();

  /** Lo mismo para los sueltos. Aparte porque su ruta no cuelga de la mesa y
   *  no hay que soltarlas al cambiar de campaña: no son de ninguna. */
  private readonly carasSueltas = new Map<string, WritableSignal<string | null>>();

  private readonly campana = signal<string | null>(null);

  usar(campanaId: string): void {
    if (this.campana() === campanaId) return;
    for (const id of [...this.caras.keys()]) this.olvidar(id);
    this.campana.set(campanaId);
  }

  private base(): string {
    const id = this.campana();
    if (!id) throw new Error('El elenco necesita saber de qué campaña es.');
    return `/api/campanas/${id}/elenco`;
  }

  // -------------------------------------------------------------- el elenco

  listar(): Observable<Elenco> {
    return this.http.get<Elenco>(this.base());
  }

  crear(req: PnjRequest): Observable<Elenco> {
    return this.http.post<Elenco>(this.base(), req);
  }

  editar(npcId: string, req: PnjRequest): Observable<Elenco> {
    return this.http.put<Elenco>(`${this.base()}/${npcId}`, req);
  }

  eliminar(npcId: string): Observable<Elenco> {
    return this.http.delete<Elenco>(`${this.base()}/${npcId}`)
      .pipe(tap(() => this.olvidar(npcId)));
  }

  mover(npcId: string, arriba: boolean): Observable<Elenco> {
    return this.http.post<Elenco>(`${this.base()}/${npcId}/mover?arriba=${arriba}`, {});
  }

  // ---------------------------------------------------------------- revelar

  /** Destapar o sellar un campo. Sin `valor`, alterna. */
  revelar(npcId: string, campo: CampoPnj, valor?: boolean): Observable<Elenco> {
    const q = valor === undefined ? '' : `&valor=${valor}`;
    return this.http.post<Elenco>(`${this.base()}/${npcId}/revelar?campo=${campo}${q}`, {});
  }

  /** La ficha entera de golpe: destapada, o sellada con `valor` a false. */
  revelarTodo(npcId: string, valor = true): Observable<Elenco> {
    return this.http.post<Elenco>(`${this.base()}/${npcId}/revelar-todo?valor=${valor}`, {});
  }

  /** Saca al elenco a los que el máster escribió pero nunca marcó como salidos. */
  sacarTodos(): Observable<Elenco> {
    return this.http.post<Elenco>(`${this.base()}/sacar-todos`, {});
  }

  // ---------------------------------------------------------------- retrato

  subirRetrato(npcId: string, file: File): Observable<Elenco> {
    const cuerpo = new FormData();
    cuerpo.append('archivo', file, file.name);
    return this.http.post<Elenco>(`${this.base()}/${npcId}/retrato`, cuerpo)
      .pipe(tap(() => this.olvidar(npcId)));
  }

  quitarRetrato(npcId: string): Observable<Elenco> {
    return this.http.delete<Elenco>(`${this.base()}/${npcId}/retrato`)
      .pipe(tap(() => this.olvidar(npcId)));
  }

  /**
   * Qué jugadores han visto la cara, cuando no la ha visto toda la mesa. Va
   * la lista entera; la cara deja de estar revelada «para todos».
   */
  vistos(npcId: string, userIds: string[]): Observable<Elenco> {
    return this.http.put<Elenco>(`${this.base()}/${npcId}/retrato/vistos`, { userIds });
  }

  /**
   * La URL local del retrato: null mientras baja, '' si no se pudo (o si esa
   * cara todavía no se ha descubierto, que el backend contesta 403).
   */
  retrato(npcId: string): Signal<string | null> {
    const guardada = this.caras.get(npcId);
    if (guardada) return guardada.asReadonly();

    const url = signal<string | null>(null);
    this.caras.set(npcId, url);
    this.http.get(`${this.base()}/${npcId}/retrato`, { responseType: 'blob' })
      .subscribe({
        next: b => url.set(URL.createObjectURL(b)),
        error: () => url.set(''),
      });
    return url.asReadonly();
  }

  /** Suelta la object URL de una cara (al cambiarla o al borrar el PNJ). */
  olvidar(npcId: string): void {
    const s = this.caras.get(npcId);
    const url = s?.();
    if (url) URL.revokeObjectURL(url);
    this.caras.delete(npcId);
  }

  // ---------------------------------------------------------- elenco suelto

  /**
   * Las fichas que se quedaron sin mesa al borrarse su campaña.
   *
   * Esta ruta NO cuelga de la campaña, y es a propósito: lo que define a estas
   * fichas es justamente no tener ninguna. Son de la cuenta hasta que se traen
   * a una partida.
   */
  sueltos(): Observable<ElencoSuelto> {
    return this.http.get<ElencoSuelto>('/api/elenco-suelto');
  }

  /** Traerlas a la mesa actual. Llegan reselladas: las destapa el máster. */
  traer(ids: string[]): Observable<Elenco> {
    return this.http.post<Elenco>(`${this.base()}/traer`, { ids })
      // Sus caras pasan a servirse por la ruta de la mesa: la copia que hay
      // cacheada es de la otra ruta y ya no manda.
      .pipe(tap(() => ids.forEach(id => this.olvidarSuelto(id))));
  }

  /** Tirar una suelta para siempre. Es la papelera del cajón. */
  descartar(npcId: string): Observable<ElencoSuelto> {
    return this.http.delete<ElencoSuelto>(`/api/elenco-suelto/${npcId}`)
      .pipe(tap(() => this.olvidarSuelto(npcId)));
  }

  /** La cara de una suelta. Igual que `retrato`, por su propia ruta. */
  retratoSuelto(npcId: string): Signal<string | null> {
    const guardada = this.carasSueltas.get(npcId);
    if (guardada) return guardada.asReadonly();

    const url = signal<string | null>(null);
    this.carasSueltas.set(npcId, url);
    this.http.get(`/api/elenco-suelto/${npcId}/retrato`, { responseType: 'blob' })
      .subscribe({
        next: b => url.set(URL.createObjectURL(b)),
        error: () => url.set(''),
      });
    return url.asReadonly();
  }

  private olvidarSuelto(npcId: string): void {
    const s = this.carasSueltas.get(npcId);
    const url = s?.();
    if (url) URL.revokeObjectURL(url);
    this.carasSueltas.delete(npcId);
  }

  // ------------------------------------------------------------- relaciones

  anadirTrato(npcId: string, req: RelacionRequest): Observable<Elenco> {
    return this.http.post<Elenco>(`${this.base()}/${npcId}/tratos`, req);
  }

  editarTrato(tratoId: string, req: RelacionRequest): Observable<Elenco> {
    return this.http.put<Elenco>(`${this.base()}/tratos/${tratoId}`, req);
  }

  quitarTrato(tratoId: string): Observable<Elenco> {
    return this.http.delete<Elenco>(`${this.base()}/tratos/${tratoId}`);
  }
}
