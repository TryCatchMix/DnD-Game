/**
 * Las campañas: la mesa a la que se une la gente con sus personajes.
 *
 * Espejo de CampaignDtos.java. Mismos nombres de campo, misma forma.
 */

/** Un personaje visto desde la campaña. */
export interface PersonajeDeCampana {
  id: string;
  name: string;
  clazz: string;
  level: number;
  city: string;
  /** El nombre visible de su jugador. */
  owner: string;
  /** true si es de quien está mirando. */
  mine: boolean;
}

/** Quién está en la mesa, con lo que haya traído. */
export interface MiembroDeCampana {
  userId: string;
  displayName: string;
  role: 'DM' | 'PLAYER';
  owner: boolean;
  me: boolean;
  characters: PersonajeDeCampana[];
}

/**
 * Una campaña en la lista. `joinCode` solo viene relleno si eres su máster: el
 * código es la llave de la puerta y no tiene por qué verlo un jugador.
 */
export interface Campana {
  id: string;
  name: string;
  description: string;
  role: 'DM' | 'PLAYER';
  owner: boolean;
  open: boolean;
  joinCode: string | null;
  memberCount: number;
  characterCount: number;
  myCharacters: PersonajeDeCampana[];
  createdAt: string;
}

/** La campaña abierta: la tarjeta más el grupo entero. */
export interface DetalleCampana {
  campaign: Campana;
  members: MiembroDeCampana[];
}

/** La pantalla entera: mis campañas y los personajes que no están en ninguna. */
export interface VistaCampanas {
  campaigns: Campana[];
  free: PersonajeDeCampana[];
}

export interface CampanaRequest {
  name?: string;
  description?: string;
  open?: boolean;
}

/**
 * En qué campaña juega un personaje y qué soy yo en ella.
 *
 * Lo pregunta cada pantalla que cuelga de un personaje antes de pedir nada más:
 * la URL del navegador lleva el personaje, pero el bloc, la tienda y La Mesa
 * son de la campaña. Todo a null = el personaje aún no se ha unido a ninguna.
 */
export interface ContextoCampana {
  campaignId: string | null;
  name: string | null;
  role: 'DM' | 'PLAYER' | null;
  dm: boolean;
}
