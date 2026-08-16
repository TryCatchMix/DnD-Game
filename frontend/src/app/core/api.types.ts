/**
 * Tipos que viajan entre el frontend y el backend.
 *
 * Están deducidos de cómo los usan los componentes (login, tablón, escena).
 * Cuando el backend real exista, estos son el contrato que debe cumplir:
 * mismos nombres de campo, misma forma.
 */

/** Respuesta de /api/auth/login y /api/auth/refresh. */
export interface TokenResponse {
  accessToken: string;
  /** Solo en la app nativa. En web el refresh token viaja en una cookie
   *  httpOnly y el backend lo deja a null aquí. */
  refreshToken?: string;
  /** Segundos de vida del access token. Útil para refrescar por adelantado. */
  expiresIn?: number;
  displayName?: string;
  role?: string;        // DM | PLAYER
}

/** Alta de una cuenta nueva. Siempre nace como PLAYER en el backend. */
export interface RegisterRequest {
  email: string;
  displayName: string;
  password: string;
}

// --- Propiedades (comprar y mejorar negocios) ---

/** Un tipo de propiedad comprable, del catálogo. */
export interface PropertyCatalogItem {
  kind: string;
  emoji: string;
  nombre: string;
  blurb: string;
  buyPriceCp: number;
  buyPrice: string;
  incomePerDayCp: number;
  incomePerDay: string;
}

/** Una propiedad ya comprada. */
export interface Property {
  id: string;
  kind: string;
  emoji: string;
  tipo: string;
  name: string;
  level: number;
  maxLevel: number;
  city: string;
  incomePerDayCp: number;
  incomePerDay: string;
  pendingCp: number;
  pending: string;
  upgradeCostCp: number | null;
  upgradeCost: string | null;
  canUpgrade: boolean;
  saleValueCp: number;
  saleValue: string;
}

/** Todo lo que pinta la pantalla de propiedades. */
export interface Holdings {
  purseCp: number;
  purse: string;
  properties: Property[];
  catalog: PropertyCatalogItem[];
}

export interface PropertyBuyRequest {
  kind: string;
  name: string;
}

/** Un personaje del jugador. Lo lista la pantalla /personajes. */
export interface Character {
  id: string;
  name: string;
  ancestry?: string;
  role?: string;
  level?: number;
  vigor?: number;
  maxVigor?: number;
  location?: string;
}

export interface Ability {
  key: string;      // FUE, DES, CON, INT, SAB, CAR
  name: string;
  score: number;
  modifier: number; // calculado por el backend
}

/** Lo que manda el creador de personaje. Solo `name` es obligatorio; el resto
 *  tiene valores por defecto en el backend. */
export interface CharacterCreate {
  name: string;
  clazz?: string; race?: string; alignment?: string; player?: string;
  city?: string; level?: number;
  strScore?: number; dexScore?: number; conScore?: number;
  intScore?: number; wisScore?: number; chaScore?: number;
  hpMax?: number; acTotal?: number; maxVigor?: number;
}

export interface SkillDetail {
  name: string;
  code: string;
  keyAbility: string;
  ranks: number;
  miscMod: number;
  total: number;    // calculado por el backend
}

/** La hoja de personaje D&D 3.5 completa. */
export interface Ficha {
  id: string;
  name: string; player: string; clazz: string; level: number; race: string;
  alignment: string; deity: string; size: string; age: string; sex: string;
  height: string; weight: string; campaign: string; location: string;
  /** Los dos dominios del clérigo, por código (ver /api/dominios). '' si no aplica. */
  domain1: string; domain2: string;
  abilities: Ability[];
  hpCurrent: number; hpMax: number;
  acTotal: number; acTouch: number; acFlatFooted: number;
  initiative: number; initiativeMisc: number;
  speed: number;
  bab: number; grapple: number; grappleMisc: number;
  spellResistance: number;
  saveFort: number; saveRef: number; saveWill: number;
  damageReduction: string;
  vigor: number; maxVigor: number; purseCp: number; bolsa: string; carga: string;
  skills: SkillDetail[];
}

/** Lo que se manda al editar la ficha. Todo opcional; el backend recalcula
 *  modificadores y totales. */
export interface FichaEdit {
  name?: string; player?: string; clazz?: string; level?: number; race?: string;
  alignment?: string; deity?: string; size?: string; age?: string; sex?: string;
  height?: string; weight?: string; campaign?: string; location?: string;
  domain1?: string; domain2?: string;
  strScore?: number; dexScore?: number; conScore?: number;
  intScore?: number; wisScore?: number; chaScore?: number;
  hpCurrent?: number; hpMax?: number;
  acTotal?: number; acTouch?: number; acFlatFooted?: number;
  initiativeMisc?: number; speed?: number;
  bab?: number; grappleMisc?: number; spellResistance?: number;
  saveFort?: number; saveRef?: number; saveWill?: number;
  damageReduction?: string;
  vigor?: number; maxVigor?: number; purseCp?: number; carga?: string;
  skills?: { name: string; keyAbility: string; ranks: number; miscMod: number }[];
}

// --- Tienda (pantalla 06) ---

export interface ShopOffer {
  itemCode: string;
  name: string;
  description: string;
  category: string;
  priceCp: number;
  price: string;        // ya formateado: "1 po · 2 pp"
  affordable: boolean;
  stock: number;        // -1 = sin límite
}

export interface InventoryItem {
  itemCode: string;
  name: string;
  quantity: number;
  sellPriceCp: number;
  sellPrice: string;
}

export interface Shop {
  purseCp: number;
  purse: string;        // ya formateado
  /** La ciudad del personaje. Es la que decide qué mostrador se ve: las ofertas
   *  van por ciudad y el nombre tiene que coincidir exactamente. */
  location: string;
  offers: ShopOffer[];
  inventory: InventoryItem[];
}

/** Lo que manda el DM para poner algo a la venta. priceCp en piezas de cobre;
 *  stock -1 = sin límite. */
export interface ShopOfferCreate {
  name: string;
  priceCp: number;
  stock: number;
  description?: string;
  category?: string;
}

// --- Inventario (bolsa) ---

export interface InventoryLine {
  id: string;
  name: string;
  quantity: number;
  weightLb: number;
  lineWeight: number;
  sellable: boolean;
}

export interface Inventory {
  items: InventoryLine[];
  totalWeight: number;
}

// --- Bloc de notas ---

/** Una nota del bloc: un nombre que conviene recordar y lo que sepas de él.
 *  Las notas son del jugador, no de un personaje. */
export interface Note {
  id: string;
  category: string;
  title: string;
  body: string;
  pinned: boolean;
  updatedAt: string;
}

export interface Notes {
  notes: Note[];
  /** Las categorías sugeridas, que manda el backend. */
  categories: string[];
}

export interface NoteRequest {
  category?: string;
  title?: string;
  body?: string;
  pinned?: boolean;
}

// --- Hechizos (grimorio) ---

export interface SpellClassLevel {
  clazz: string;
  level: number;
  /** El atributo con el que esa clase lanza (Sabiduría, Inteligencia, Carisma). */
  keyAbility: string;
  /** "CD 13 + mod. de Inteligencia", ya montada por el backend. */
  saveDcFormula: string;
}

export interface Spell {
  name: string;
  nameEn: string;
  school: string;
  subschool: string;
  descriptors: string;
  description: string;
  minLevel: number;
  // bloque de estadísticas
  components: string;
  castingTime: string;
  range: string;
  target: string;
  targetKind: string;
  duration: string;
  savingThrow: string;
  spellResistance: string;
  // daño y escalado
  dice: string;
  scaling: string;
  cap: string;
  /** "1d6 por nivel de lanzador (máx. 10d6)". */
  damageSummary: string;
  source: string;
  classes: SpellClassLevel[];
}

/** Una página de conjuros: los que caben en el límite + cuántos hay en total. */
export interface SpellPage {
  total: number;
  items: Spell[];
}

// --- Conjuros preparados (la lista que se arma antes de jugar) ---

/** Un conjuro preparado: cuántas veces se lleva y el conjuro completo. `level`
 *  es el nivel al que lo lanza ESTE personaje (según su clase). */
export interface PreparedSpell {
  id: string;
  prepared: number;
  level: number;
  spell: Spell;
}

export interface PreparedList {
  items: PreparedSpell[];
}

// --- Dominios divinos (clérigo) ---

/** Un dominio en el selector. */
export interface DomainSummary {
  code: string;
  nombre: string;
}

/** Un conjuro de dominio. Si `inGrimoire`, `name` es el nombre español del
 *  grimorio; si no, el inglés del SRD (no lo tenemos fichado). */
export interface DomainSpell {
  level: number;
  name: string;
  nameEn: string;
  inGrimoire: boolean;
}

/** El detalle de un dominio: el poder otorgado (la pasiva) y sus 9 conjuros. */
export interface DomainDetail {
  code: string;
  nombre: string;
  poder: string;
  spells: DomainSpell[];
}

/** Una aptitud de clase (Bárbaro, Guerrero, Monje). No es un conjuro. */
export interface ClassFeature {
  clazz: string;
  name: string;
  level: number;
  kind: string;
  description: string;
  source: string;
}

/** Una invocación de warlock: no es un conjuro (se usa a voluntad y va por
 *  grado, no por nivel de conjuro 0-9). */
export interface Invocation {
  name: string;
  nameEn: string;
  grade: string;
  gradeOrder: number;
  spellLevel: number;
  minClassLevel: number;
  kind: string;
  savingThrow: string;
  spellResistance: string;
  dice: string;
  scaling: string;
  description: string;
  keyAbility: string;
  saveDcFormula: string;
  atWill: boolean;
  source: string;
}

// --- Editor de encargos del DM ---

export interface QuestSummary {
  code: string;
  title: string;
  location: string;
  published: boolean;
  sceneCount: number;
}

export interface ValidationProblem { field: string; message: string; }
export interface ValidationReport {
  errors: ValidationProblem[];
  warnings: ValidationProblem[];
}
export interface ImportResult {
  code: string;
  title: string;
  created: boolean;
  report: ValidationReport;
}

// --- Crónica del clan (pantalla 07) ---

export interface ChronicleEntry {
  id: string;
  year: number;
  era: string;
  title: string;
  body: string;         // censurado si está sellada y sin revelar
  category: string;     // CATACLISMO | MUNDO | CLAN | VERDAD | RUMOR
  faction: string | null;
  sealed: boolean;
  revealed: boolean;
  canReveal: boolean;   // el que mira puede destaparla (es DM)
}

export interface ChronicleCreate {
  year?: number;
  era?: string;
  title: string;
  body?: string;
  category?: string;
  faction?: string;
  sealed?: boolean;
  /** Solo al editar desde el panel: marca la entrada sellada como destapada. */
  revealed?: boolean;
}

export type QuestAvailability =
  | 'AVAILABLE'        // se puede firmar
  | 'RECRUITING'       // admite más firmantes
  | 'JOINED'           // ya estás dentro
  | 'BLOCKED_BY_WORLD' // el estado del mundo lo bloquea (lleva `reason`)
  | 'FULL'             // sin plazas
  | 'LOCKED';          // requisito no cumplido

/** Una tarjeta del tablón de encargos. */
export interface QuestCard {
  id: string;
  title: string;
  faction?: string;
  hook: string;
  skills: string[];
  vigorCost: number;
  duration: string;
  sceneCount: number;
  rewardNote?: string;
  signatures?: string;
  closesIn?: string;
  availability: QuestAvailability;
  /** Motivo por el que está bloqueado. Solo en los no jugables. */
  reason?: string;
}

/** Una opción dentro de una escena. */
export interface SceneOption {
  id: string;
  label: string;
  skill?: string;
  dc: number;
  /** Probabilidad de éxito en %, o null si no aplica (opción sin tirada). */
  successChance: number | null;
  vigorCost: number;
  affordable: boolean;
  risk?: 'LOW' | 'MEDIUM' | 'HIGH';
  note?: string;
}

/** La escena actual del personaje. */
export interface SceneView {
  questTitle: string;
  sceneOrdinal: number;
  sceneCount: number;
  title: string;
  body: string;
  /** Si sigues "en camino", el tiempo que falta. */
  waitingFor?: string;
  options: SceneOption[];
}

/** Un modificador del desglose de la tirada. */
export interface RollModifier {
  label: string;
  value: number;
}

/** El desglose completo de una tirada de d20. */
export interface RollView {
  grade: number;        // 1..5
  gradeLabel: string;   // "Éxito con coste", etc.
  d20: number;
  breakdown: RollModifier[];
  dc: number;
  total: number;
}

/** El expediente lacrado: el resultado de elegir una opción. */
export interface ResolutionView {
  /** null cuando la opción no llevaba tirada. */
  roll?: RollView;
  narrative: string;
  changes: string[];
  finished: boolean;
  waitingFor?: string;
}
