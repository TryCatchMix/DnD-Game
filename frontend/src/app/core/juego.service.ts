import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import {
  Character, CharacterCreate, ChronicleCreate, ChronicleEntry, Ficha, FichaEdit,
  Holdings, ImportResult, Inventory, Invocation, Note, NoteRequest, Notes,
  PropertyBuyRequest, QuestCard, QuestSummary, ResolutionView, SceneView, Shop,
  ShopOfferCreate, Spell, ValidationReport,
} from './api.types';

/**
 * Todo lo que el jugador le pide al backend durante la partida.
 *
 * Las rutas están en español y coinciden EXACTAMENTE con las del backend
 * (GameController) y con las que prueba `probar.sh`. Si cambias una, cámbiala
 * en los dos sitios.
 */
@Injectable({ providedIn: 'root' })
export class JuegoService {

  private readonly http = inject(HttpClient);

  /** Los personajes del jugador que ha entrado. */
  personajes(): Observable<Character[]> {
    return this.http.get<Character[]>('/api/personajes');
  }

  /** Crear un personaje nuevo. Devuelve su ficha ya montada. */
  crearPersonaje(datos: CharacterCreate): Observable<Ficha> {
    return this.http.post<Ficha>('/api/personajes', datos);
  }

  /** La hoja de personaje D&D 3.5 completa. */
  ficha(personajeId: string): Observable<Ficha> {
    return this.http.get<Ficha>(`/api/personajes/${personajeId}`);
  }

  /** Guardar los cambios de la ficha. Devuelve la ficha recalculada. */
  editarFicha(personajeId: string, cambios: FichaEdit): Observable<Ficha> {
    return this.http.put<Ficha>(`/api/personajes/${personajeId}`, cambios);
  }

  /** El tablón de encargos visto por un personaje concreto. */
  tablon(personajeId: string): Observable<QuestCard[]> {
    return this.http.get<QuestCard[]>(`/api/personajes/${personajeId}/tablon`);
  }

  // --- Tienda ---

  /** La tienda de la ciudad del personaje, con su monedero e inventario. */
  tienda(personajeId: string): Observable<Shop> {
    return this.http.get<Shop>(`/api/personajes/${personajeId}/tienda`);
  }

  /** Comprar un objeto. Devuelve la tienda ya actualizada. */
  comprar(personajeId: string, itemCode: string): Observable<Shop> {
    return this.http.post<Shop>(`/api/personajes/${personajeId}/tienda/comprar/${itemCode}`, {});
  }

  /** Vender un objeto (la tienda paga la mitad). Devuelve la tienda actualizada. */
  vender(personajeId: string, itemCode: string): Observable<Shop> {
    return this.http.post<Shop>(`/api/personajes/${personajeId}/tienda/vender/${itemCode}`, {});
  }

  /** El DM pone algo a la venta en la ciudad del personaje (solo DM). */
  crearOferta(personajeId: string, oferta: ShopOfferCreate): Observable<Shop> {
    return this.http.post<Shop>(`/api/personajes/${personajeId}/tienda/ofertas`, oferta);
  }

  /** El DM retira una oferta del mostrador (solo DM). */
  quitarOferta(personajeId: string, itemCode: string): Observable<Shop> {
    return this.http.delete<Shop>(`/api/personajes/${personajeId}/tienda/ofertas/${itemCode}`);
  }

  /** Firmar un encargo: el backend devuelve directamente la primera escena. */
  firmar(personajeId: string, questId: string): Observable<SceneView> {
    return this.http.post<SceneView>(`/api/personajes/${personajeId}/encargos/${questId}`, {});
  }

  /** La escena en la que está ahora mismo el personaje. */
  escenaActual(personajeId: string): Observable<SceneView> {
    return this.http.get<SceneView>(`/api/personajes/${personajeId}/escena`);
  }

  /** Elegir una opción de la escena: devuelve el expediente con la tirada. */
  elegir(personajeId: string, optionId: string): Observable<ResolutionView> {
    return this.http.post<ResolutionView>(
      `/api/personajes/${personajeId}/escena/opciones/${optionId}`, {});
  }

  // --- Crónica del clan ---

  /** La crónica del clan (memoria compartida del mundo). */
  cronica(): Observable<ChronicleEntry[]> {
    return this.http.get<ChronicleEntry[]>('/api/cronica');
  }

  /** Destapar una verdad sellada (solo DM). Devuelve la crónica actualizada. */
  revelar(entryId: string): Observable<ChronicleEntry[]> {
    return this.http.post<ChronicleEntry[]>(`/api/cronica/${entryId}/revelar`, {});
  }

  /** Anotar una entrada nueva (solo DM). Devuelve la crónica actualizada. */
  anotar(entrada: ChronicleCreate): Observable<ChronicleEntry[]> {
    return this.http.post<ChronicleEntry[]>('/api/cronica', entrada);
  }

  // --- Inventario (bolsa) ---

  inventario(personajeId: string): Observable<Inventory> {
    return this.http.get<Inventory>(`/api/personajes/${personajeId}/inventario`);
  }

  anadirItem(personajeId: string, item: { name: string; quantity: number; weightLb: number }): Observable<Inventory> {
    return this.http.post<Inventory>(`/api/personajes/${personajeId}/inventario`, item);
  }

  fijarCantidad(personajeId: string, entryId: string, quantity: number): Observable<Inventory> {
    return this.http.patch<Inventory>(`/api/personajes/${personajeId}/inventario/${entryId}`, { quantity });
  }

  eliminarItem(personajeId: string, entryId: string): Observable<Inventory> {
    return this.http.delete<Inventory>(`/api/personajes/${personajeId}/inventario/${entryId}`);
  }

  // --- Bloc de notas ---
  // Cuelgan de /api/notas, no del personaje: son del jugador. Todas devuelven
  // el bloc entero ya actualizado.

  notas(): Observable<Notes> {
    return this.http.get<Notes>('/api/notas');
  }

  crearNota(nota: NoteRequest): Observable<Notes> {
    return this.http.post<Notes>('/api/notas', nota);
  }

  editarNota(noteId: string, nota: NoteRequest): Observable<Notes> {
    return this.http.put<Notes>(`/api/notas/${noteId}`, nota);
  }

  fijarNota(noteId: string): Observable<Notes> {
    return this.http.post<Notes>(`/api/notas/${noteId}/fijar`, {});
  }

  eliminarNota(noteId: string): Observable<Notes> {
    return this.http.delete<Notes>(`/api/notas/${noteId}`);
  }

  // --- Propiedades (comprar y mejorar negocios) ---
  // Todas devuelven el estado completo (monedero + propiedades + catálogo).

  propiedades(personajeId: string): Observable<Holdings> {
    return this.http.get<Holdings>(`/api/personajes/${personajeId}/propiedades`);
  }

  comprarPropiedad(personajeId: string, compra: PropertyBuyRequest): Observable<Holdings> {
    return this.http.post<Holdings>(`/api/personajes/${personajeId}/propiedades`, compra);
  }

  mejorarPropiedad(personajeId: string, propId: string): Observable<Holdings> {
    return this.http.post<Holdings>(`/api/personajes/${personajeId}/propiedades/${propId}/mejorar`, {});
  }

  recaudarPropiedad(personajeId: string, propId: string): Observable<Holdings> {
    return this.http.post<Holdings>(`/api/personajes/${personajeId}/propiedades/${propId}/recaudar`, {});
  }

  venderPropiedad(personajeId: string, propId: string): Observable<Holdings> {
    return this.http.delete<Holdings>(`/api/personajes/${personajeId}/propiedades/${propId}`);
  }

  // --- Hechizos ---

  /** Todos los hechizos, con las clases que los aprenden. El filtro y la
   *  búsqueda se hacen en el frontend (instantáneos). */
  hechizos(): Observable<Spell[]> {
    return this.http.get<Spell[]>('/api/hechizos');
  }

  /** Las invocaciones de warlock (van aparte: no son conjuros). */
  invocaciones(): Observable<Invocation[]> {
    return this.http.get<Invocation[]>('/api/hechizos/invocaciones');
  }

  // --- Editor de encargos del DM ---

  /** La lista de encargos (publicados y borradores). */
  encargos(): Observable<QuestSummary[]> {
    return this.http.get<QuestSummary[]>('/api/admin/encargos');
  }

  /** Validar un borrador sin guardar. */
  comprobarEncargo(draft: unknown): Observable<ValidationReport> {
    return this.http.post<ValidationReport>('/api/admin/encargos/check', draft);
  }

  /** Guardar (crear o reemplazar). No publica. */
  guardarEncargo(draft: unknown): Observable<ImportResult> {
    return this.http.post<ImportResult>('/api/admin/encargos', draft);
  }

  /** Bajar un encargo en formato borrador para editarlo. */
  exportarEncargo(code: string): Observable<unknown> {
    return this.http.get(`/api/admin/encargos/${code}`);
  }

  publicarEncargo(code: string): Observable<unknown> {
    return this.http.post(`/api/admin/encargos/${code}/publicar`, {});
  }

  despublicarEncargo(code: string): Observable<unknown> {
    return this.http.post(`/api/admin/encargos/${code}/despublicar`, {});
  }
}
