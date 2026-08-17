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
