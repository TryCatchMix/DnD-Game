import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import {
  Backstory, Character, CharacterCreate, ChronicleCreate, ChronicleEntry, ClassFeature, DomainDetail,
  DomainSummary, Ficha, FichaEdit, Holdings, ImportResult, Inventory, Invocation, Note,
  NoteRequest, Notes, PreparedList, PropertyBuyRequest, QuestCard, QuestSummary,
  BestiaryFilters, Condicion, Enfermedad, Feat, Monster, MonsterPage, Veneno,
  ResolutionView, SceneView, Shop, ShopOfferCreate, Spell, SpellCreate, SpellPage, ValidationReport,
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

  /** Borrar un personaje con todo lo suyo. Devuelve la lista ya sin él. */
  borrarPersonaje(personajeId: string): Observable<Character[]> {
    return this.http.delete<Character[]>(`/api/personajes/${personajeId}`);
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

  // --- Crónica: panel de administración (solo DM) ---
  // Devuelven la lista SIN censurar, para poder gestionar hasta lo sellado.

  /** Lista completa para gestionar (sin censura). */
  cronicaAdmin(): Observable<ChronicleEntry[]> {
    return this.http.get<ChronicleEntry[]>('/api/cronica/admin');
  }

  /** Crear una entrada desde el panel. */
  crearCronica(entrada: ChronicleCreate): Observable<ChronicleEntry[]> {
    return this.http.post<ChronicleEntry[]>('/api/cronica/admin', entrada);
  }

  /** Editar una entrada existente. */
  editarCronica(id: string, entrada: ChronicleCreate): Observable<ChronicleEntry[]> {
    return this.http.put<ChronicleEntry[]>(`/api/cronica/admin/${id}`, entrada);
  }

  /** Eliminar una entrada. */
  eliminarCronica(id: string): Observable<ChronicleEntry[]> {
    return this.http.delete<ChronicleEntry[]>(`/api/cronica/admin/${id}`);
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

  // --- Trasfondo (la historia del personaje) ---
  // Es de un personaje concreto. Ambas devuelven la vista entera (HTML + fecha).

  trasfondo(personajeId: string): Observable<Backstory> {
    return this.http.get<Backstory>(`/api/personajes/${personajeId}/trasfondo`);
  }

  guardarTrasfondo(personajeId: string, html: string): Observable<Backstory> {
    return this.http.put<Backstory>(`/api/personajes/${personajeId}/trasfondo`, { html });
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

  // --- Habilidades (conjuros + invocaciones + aptitudes) ---

  /** Conjuros filtrados y paginados EN EL SERVIDOR (por defecto 25), para no
   *  traer los ~500 de golpe. `limite <= 0` = todos. */
  hechizos(clase: string, q: string, limite: number, offset = 0): Observable<SpellPage> {
    const params: Record<string, string> = {
      clase, q, limite: String(limite), offset: String(offset),
    };
    return this.http.get<SpellPage>('/api/habilidades/hechizos', { params });
  }

  /** Las invocaciones de warlock (van aparte: no son conjuros). Son pocas. */
  invocaciones(): Observable<Invocation[]> {
    return this.http.get<Invocation[]>('/api/habilidades/invocaciones');
  }

  /** Aptitudes de clase de Bárbaro, Guerrero y Monje. Son pocas. */
  aptitudes(clase: string): Observable<ClassFeature[]> {
    return this.http.get<ClassFeature[]>('/api/habilidades/aptitudes', { params: { clase } });
  }

  /** Las dotes del manual (110). Filtra por tipo y por nombre; son pocas, así
   *  que vienen enteras y el resto del filtrado es instantáneo. */
  dotes(tipo = '', q = ''): Observable<Feat[]> {
    const params: Record<string, string> = {};
    if (tipo) params['tipo'] = tipo;
    if (q) params['q'] = q;
    return this.http.get<Feat[]>('/api/habilidades/dotes', { params });
  }

  /** Las condiciones del SRD (38). Se consultan a media pelea. */
  condiciones(): Observable<Condicion[]> {
    return this.http.get<Condicion[]>('/api/habilidades/condiciones');
  }

  /** Las enfermedades, con la CD que el bestiario no da. */
  enfermedades(): Observable<Enfermedad[]> {
    return this.http.get<Enfermedad[]>('/api/habilidades/enfermedades');
  }

  /** Los venenos, con su CD y sus dos daños. */
  venenos(): Observable<Veneno[]> {
    return this.http.get<Veneno[]>('/api/habilidades/venenos');
  }

  /** Crea un conjuro "de la casa": queda como uno más y sale en su categoría.
   *  Lo puede hacer cualquier jugador (DM o no). */
  crearHechizo(datos: SpellCreate): Observable<Spell> {
    return this.http.post<Spell>('/api/habilidades/hechizos', datos);
  }

  /** Borra un conjuro de la casa (los del SRD no se pueden borrar). */
  borrarHechizo(id: string): Observable<void> {
    return this.http.delete<void>(`/api/habilidades/hechizos/${id}`);
  }

  /** Ponerse o quitarse un objeto. Devuelve la bolsa repintada. */
  equipar(personajeId: string, entryId: string, puesto: boolean): Observable<Inventory> {
    return this.http.post<Inventory>(
      `/api/personajes/${personajeId}/inventario/${entryId}/equipar`, null,
      { params: { puesto: String(puesto) } });
  }

  // --- Bestiario ---

  /** Criaturas filtradas y paginadas EN EL SERVIDOR. `limite <= 0` = todas.
   *  Los filtros vacíos no se mandan, para no ensuciar la URL. */
  bestiario(filtros: {
    q?: string; tipo?: string; entorno?: string;
    vdMin?: number | null; vdMax?: number | null;
    orden?: string; limite: number; offset?: number;
  }): Observable<MonsterPage> {
    const params: Record<string, string> = {
      limite: String(filtros.limite), offset: String(filtros.offset ?? 0),
    };
    if (filtros.q) params['q'] = filtros.q;
    if (filtros.tipo) params['tipo'] = filtros.tipo;
    if (filtros.entorno) params['entorno'] = filtros.entorno;
    if (filtros.vdMin != null) params['vdMin'] = String(filtros.vdMin);
    if (filtros.vdMax != null) params['vdMax'] = String(filtros.vdMax);
    if (filtros.orden) params['orden'] = filtros.orden;
    return this.http.get<MonsterPage>('/api/bestiario', { params });
  }

  /** Los tipos y entornos que hay, para poblar los desplegables. */
  filtrosBestiario(): Observable<BestiaryFilters> {
    return this.http.get<BestiaryFilters>('/api/bestiario/filtros');
  }

  /** La ficha completa de una criatura (se pide al abrirla). */
  criatura(id: string): Observable<Monster> {
    return this.http.get<Monster>(`/api/bestiario/${id}`);
  }

  // --- Conjuros preparados ---
  // La lista que el personaje se prepara antes de jugar. Todas devuelven la
  // lista entera ya actualizada, para repintar de una.

  conjuros(personajeId: string): Observable<PreparedList> {
    return this.http.get<PreparedList>(`/api/personajes/${personajeId}/conjuros`);
  }

  /** Preparar un conjuro por su nombre del grimorio. Si ya estaba, suma. */
  prepararConjuro(personajeId: string, name: string, prepared = 1): Observable<PreparedList> {
    return this.http.post<PreparedList>(`/api/personajes/${personajeId}/conjuros`, { name, prepared });
  }

  /** Fijar cuántas veces se lleva preparado. 0 o menos lo quita. */
  fijarConjuro(personajeId: string, prepId: string, prepared: number): Observable<PreparedList> {
    return this.http.patch<PreparedList>(
      `/api/personajes/${personajeId}/conjuros/${prepId}`, { prepared });
  }

  quitarConjuro(personajeId: string, prepId: string): Observable<PreparedList> {
    return this.http.delete<PreparedList>(`/api/personajes/${personajeId}/conjuros/${prepId}`);
  }

  // --- Dominios divinos (clérigo) ---

  /** La lista de dominios para elegir (código + nombre). */
  dominios(): Observable<DomainSummary[]> {
    return this.http.get<DomainSummary[]>('/api/dominios');
  }

  /** El detalle de un dominio: poder otorgado + sus 9 conjuros. */
  dominio(code: string): Observable<DomainDetail> {
    return this.http.get<DomainDetail>(`/api/dominios/${code}`);
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
