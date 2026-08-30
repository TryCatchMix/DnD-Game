/**
 * Los tipos de La Mesa (el escritorio de preparación del DM).
 *
 * Van aparte de api.types.ts a propósito: aquello es lo que consume el JUGADOR
 * durante la partida; esto solo lo ve el máster mientras prepara.
 */

/** idea → preparando → lista → jugada. */
export type EstadoMision = 'idea' | 'preparando' | 'lista' | 'jugada';

/** Los tipos de paso del guion. */
export type TipoNota = 'lectura' | 'escena' | 'pnj' | 'botin' | 'nota';

export interface Archivo {
  id: string;
  misionId: string | null;
  kind: 'imagen' | 'pdf' | 'otro';
  title: string;
  filename: string;
  mime: string;
  sizeBytes: number;
  createdAt: string;
}

/** Un PDF donde aparece lo que se ha buscado por contenido. */
export interface Coincidencia {
  id: string;
  misionId: string | null;
  title: string;
  filename: string;
  /** Cuántas veces sale la frase en el documento. */
  matchCount: number;
  /** Un trozo del texto con la frase, para enseñar dónde. */
  snippet: string;
}

export interface NotaMesa {
  id: string;
  kind: TipoNota;
  title: string;
  body: string;
  ordinal: number;
}

/** La tarjeta de la rejilla. */
export interface TarjetaMision {
  id: string;
  title: string;
  summary: string;
  status: EstadoMision;
  tags: string[];
  sessionDate: string | null;
  coverId: string | null;
  imageCount: number;
  pdfCount: number;
  noteCount: number;
  updatedAt: string;
}

/** Lo que se abre al pulsar una tarjeta. */
export interface DetalleMision {
  id: string;
  title: string;
  summary: string;
  status: EstadoMision;
  tags: string[];
  sessionDate: string | null;
  coverId: string | null;
  updatedAt: string;
  notes: NotaMesa[];
  assets: Archivo[];
}

export interface VistaMesa {
  misiones: TarjetaMision[];
  estados: EstadoMision[];
}

/** Alta y edición comparten forma: lo que no se manda, no se toca. */
export interface MisionRequest {
  title?: string;
  summary?: string;
  status?: EstadoMision;
  tags?: string;
  /** 'AAAA-MM-DD', o '' para quitarla. */
  sessionDate?: string;
  /** id del archivo, o '' para quitar la portada. */
  coverId?: string;
}

export interface NotaRequest {
  kind?: TipoNota;
  title?: string;
  body?: string;
}

/** Cómo se llama cada estado y de qué color va el sello. */
export const ESTADOS: Record<EstadoMision, string> = {
  idea:       'Idea',
  preparando: 'Preparando',
  lista:      'Lista',
  jugada:     'Jugada',
};

/** Cómo se llama cada tipo de paso del guion. */
export const TIPOS_NOTA: Record<TipoNota, string> = {
  lectura: 'Leer en voz alta',
  escena:  'Escena',
  pnj:     'PNJ',
  botin:   'Botín',
  nota:    'Nota',
};

// --- Enemigos del máster y combate ---

/** Un enemigo de la lista del DM: copiado del bestiario o inventado. */
export interface Enemigo {
  id: string;
  name: string;
  sizeType: string;
  cr: string;
  hpMax: number;
  ac: number;
  acTouch: number;
  acFlatFooted: number;
  initMod: number;
  speed: string;
  saves: string;
  abilities: string;
  attack: string;
  fullAttack: string;
  specialAttacks: string;
  specialQualities: string;
  skills: string;
  feats: string;
  notes: string;
  /** De qué criatura salió, si salió de alguna. */
  monsterId: string | null;
  monsterName: string | null;
  misionId: string | null;
}

/** Lo que se manda al crear o editar un enemigo a mano. Todo opcional
 *  salvo el nombre al crearlo. */
export interface EnemigoRequest {
  name?: string; sizeType?: string; cr?: string;
  hpMax?: number; ac?: number; acTouch?: number; acFlatFooted?: number; initMod?: number;
  speed?: string; saves?: string; abilities?: string;
  attack?: string; fullAttack?: string; specialAttacks?: string; specialQualities?: string;
  skills?: string; feats?: string; notes?: string; misionId?: string;
}

export interface Combatiente {
  id: string;
  /** enemigo | personaje | suelto. */
  kind: string;
  name: string;
  initiative: number;
  hpMax: number;
  hpCurrent: number;
  ac: number;
  conditions: string;
  notes: string;
  defeated: boolean;
  sortOrdinal: number;
  /** true si le toca ahora mismo. */
  active: boolean;
  enemigoId: string | null;
  characterId: string | null;
}

export interface Combate {
  id: string;
  title: string;
  /** 0 = aún no ha empezado. */
  round: number;
  turnOrdinal: number;
  misionId: string | null;
  combatants: Combatiente[];
}

export interface ResumenCombate {
  id: string;
  title: string;
  round: number;
  combatants: number;
}
