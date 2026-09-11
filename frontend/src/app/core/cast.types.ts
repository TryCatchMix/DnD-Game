/**
 * El elenco: la gente que va saliendo en la campaña.
 *
 * Lo que hay que entender de estos tipos es por qué casi todo es `| null`.
 * Un PNJ se descubre a trozos, y lo que la mesa aún no sabe NO viaja: el
 * backend manda null en cada campo sellado en vez de mandarlo con una marca de
 * "oculto". Así que null aquí no significa "vacío", significa "o no lo hay o
 * todavía no lo sabéis", y son lo mismo desde este lado de la línea.
 */

/** Cómo se lleva con alguien. Cerrado: cada uno pinta de un color. */
export type Trato = 'amistoso' | 'neutral' | 'enemigo' | 'familiar';

/** Los campos que se pueden sellar uno a uno. */
export type CampoPnj =
  | 'listed' | 'name' | 'portrait' | 'title' | 'location'
  | 'race' | 'description' | 'trivia' | 'alignment';

export interface RelacionPnj {
  id: string;
  kind: Trato;
  /** El nombre del otro extremo, con la misma discreción: si es un PNJ cuyo
   *  nombre sigue sellado, aquí llega su alias. */
  who: string;
  note: string;
  /** Solo para el máster. Al jugador solo le llegan las descubiertas. */
  revealed: boolean | null;
}

/** Qué está descubierto. Solo lo recibe el máster: es su panel de mando. */
export interface Descubierto {
  /** En false el PNJ ni sale en el elenco del jugador. */
  listed: boolean;
  name: boolean;
  portrait: boolean;
  title: boolean;
  location: boolean;
  race: boolean;
  description: boolean;
  trivia: boolean;
  alignment: boolean;
}

export interface Pnj {
  id: string;
  /** El de verdad, o el alias mientras el nombre siga sellado. */
  name: string;
  /** Solo para el máster; el jugador ya lo recibe en `name` si toca. */
  alias: string | null;
  title: string | null;
  location: string | null;
  race: string | null;
  description: string | null;
  /** Una por línea, ya troceadas. */
  trivia: string[] | null;
  alignment: string | null;
  /** Hay retrato y se puede ver. Los bytes se piden aparte. */
  portrait: boolean;
  relations: RelacionPnj[];
  /** Cuántas cosas quedan por descubrir. Es el gancho de la tarjeta. */
  porDescubrir: number;
  reveal: Descubierto | null;
}

/** Alguien a quien apuntar en una relación. */
export interface Quien {
  id: string;
  name: string;
}

export interface Elenco {
  npcs: Pnj[];
  /** Si quien mira dirige esta mesa. Manda en toda la interfaz. */
  dm: boolean;
  /** La lista sugerida del desplegable; se puede escribir otra cosa. */
  alignments: string[];
  kinds: Trato[];
  /** Los personajes jugadores de la mesa, para las relaciones. */
  personajes: Quien[];
}

/** Alta y edición: lo que vaya a undefined se deja como estaba. */
export interface PnjRequest {
  name?: string;
  alias?: string;
  title?: string;
  location?: string;
  race?: string;
  description?: string;
  /** Texto plano, una curiosidad por línea. */
  trivia?: string;
  alignment?: string;
  reveal?: Descubierto;
}

/** Alta y edición de una relación. Solo uno de los tres destinos manda. */
export interface RelacionRequest {
  kind?: Trato;
  otherNpcId?: string;
  characterId?: string;
  otherName?: string;
  note?: string;
  revealed?: boolean;
}
