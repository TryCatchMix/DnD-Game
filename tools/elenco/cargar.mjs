/**
 * CARGAR UN ELENCO EN UNA CAMPAÑA.
 *
 * Lee el dossier de `velmorra.mjs` y lo mete por la API, como lo haría el
 * máster a mano pero sin cuarenta y cuatro formularios.
 *
 *   node tools/elenco/cargar.mjs
 *
 * Variables de entorno (todas con valor por defecto de desarrollo):
 *   API       http://localhost:8080
 *   EMAIL     mix@trycatchmix.com
 *   PASSWORD  archivos
 *   CAMPANA   Velmorra          nombre de la campaña; se crea si no existe
 *
 * ES IDEMPOTENTE, y eso es lo único que tiene de listo: se puede volver a
 * lanzar después de tocar el dossier. Busca por nombre, actualiza lo que ya
 * está y solo crea lo que falta. Los tratos se rehacen enteros para cada ficha
 * que los tenga en el dossier, porque no hay forma de casarlos por nombre sin
 * inventarse una clave; si has apuntado tratos a mano en la interfaz, esos SÍ
 * se pierden al recargar. Todo lo demás (retratos, sellos que hayas movido
 * jugando) se respeta salvo que el dossier diga otra cosa.
 *
 * Por defecto NO pisa los sellos de una ficha que ya existe: si durante la
 * partida revelaste el alineamiento de alguien, recargar no vuelve a sellarlo.
 * Para forzar el reparto del dossier, lanza con RESELLAR=1.
 */

import { ELENCO, PJS } from './velmorra.mjs';

const API = process.env.API ?? 'http://localhost:8080';
const EMAIL = process.env.EMAIL ?? 'mix@trycatchmix.com';
const PASSWORD = process.env.PASSWORD ?? 'archivos';
const CAMPANA = process.env.CAMPANA ?? 'Velmorra';
const RESELLAR = process.env.RESELLAR === '1';

/** Lo que se ve de una ficha recién puesta: lo que ves al conocer a alguien. */
const POR_DEFECTO = {
  listed: true,
  name: true,
  portrait: false,
  title: true,
  location: true,
  race: true,
  description: true,
  trivia: false,
  alignment: false,
};

let token = null;

async function api(metodo, ruta, cuerpo) {
  const r = await fetch(API + ruta, {
    method: metodo,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: cuerpo === undefined ? undefined : JSON.stringify(cuerpo),
  });
  const texto = await r.text();
  if (!r.ok) {
    throw new Error(`${metodo} ${ruta} → ${r.status} ${texto.slice(0, 300)}`);
  }
  return texto ? JSON.parse(texto) : null;
}

const log = (...a) => console.log(...a);

// ---------------------------------------------------------------- entrar ---

async function entrar() {
  const r = await api('POST', '/api/auth/login', { email: EMAIL, password: PASSWORD });
  token = r.accessToken;
  log(`· dentro como ${EMAIL}`);
}

// -------------------------------------------------------------- campaña ---

async function campana() {
  const vista = await api('GET', '/api/campanas');
  const ya = vista.campaigns.find(c => c.name === CAMPANA);
  if (ya) {
    log(`· campaña «${CAMPANA}» ya existe (código ${ya.joinCode})`);
    return ya;
  }
  const detalle = await api('POST', '/api/campanas', {
    name: CAMPANA,
    description: 'La ciudad de la sangre reglada. Dossier de personajes.',
    open: true,
  });
  log(`· campaña «${CAMPANA}» creada (código ${detalle.campaign.joinCode})`);
  return detalle.campaign;
}

// ----------------------------------------------------------- personajes ---

/** Crea los tres PJs si faltan y los apunta a la campaña. */
async function personajes(campanaId) {
  let mios = await api('GET', '/api/personajes');
  const porNombre = new Map(mios.map(c => [c.name, c]));

  for (const pj of PJS) {
    if (porNombre.has(pj.name)) continue;
    await api('POST', '/api/personajes', {
      name: pj.name,
      clazz: pj.clazz,
      race: pj.race,
      alignment: pj.alignment || undefined,
      city: pj.city,
      level: pj.level,
    });
    log(`  + personaje ${pj.name}`);
  }

  mios = await api('GET', '/api/personajes');
  const mapa = new Map();
  for (const pj of PJS) {
    const c = mios.find(x => x.name === pj.name);
    if (!c) throw new Error(`No se ha podido crear el personaje ${pj.name}`);
    mapa.set(pj.name, c.id);
    if (c.campaignId !== campanaId) {
      await api('POST', `/api/campanas/${campanaId}/personajes/${c.id}`, {});
      log(`  → ${pj.name} apuntado a ${CAMPANA}`);
    }
  }
  return mapa;
}

// --------------------------------------------------------------- elenco ---

function sellos(ficha, existente) {
  // A una ficha que ya está no se le vuelven a bajar los sellos: lo que se
  // reveló jugando, revelado se queda.
  if (existente && !RESELLAR) return existente.reveal;
  return { ...POR_DEFECTO, ...(ficha.ve ?? {}) };
}

function peticion(ficha, existente) {
  return {
    name: ficha.name,
    alias: ficha.alias ?? '',
    title: ficha.title ?? '',
    location: ficha.location ?? '',
    race: ficha.race ?? '',
    description: ficha.description ?? '',
    trivia: (ficha.trivia ?? []).join('\n'),
    alignment: ficha.alignment ?? '',
    reveal: sellos(ficha, existente),
  };
}

async function fichas(campanaId) {
  let vista = await api('GET', `/api/campanas/${campanaId}/elenco`);
  let porNombre = new Map(vista.npcs.map(n => [n.name, n]));

  let nuevas = 0;
  let tocadas = 0;
  for (const ficha of ELENCO) {
    const ya = porNombre.get(ficha.name);
    if (ya) {
      vista = await api('PUT', `/api/campanas/${campanaId}/elenco/${ya.id}`, peticion(ficha, ya));
      tocadas++;
    } else {
      vista = await api('POST', `/api/campanas/${campanaId}/elenco`, peticion(ficha, null));
      nuevas++;
    }
    porNombre = new Map(vista.npcs.map(n => [n.name, n]));
  }
  log(`· fichas: ${nuevas} nuevas, ${tocadas} actualizadas`);
  return porNombre;
}

// --------------------------------------------------------------- tratos ---

/**
 * Rehace los tratos de cada ficha que los declare. Se borran los que hubiera y
 * se vuelven a poner: el dossier manda.
 *
 * Los tratos van después de TODAS las fichas porque la mitad apuntan a otra
 * ficha del elenco, y hasta que no existen todas no hay a qué apuntar. Es la
 * única razón por la que esto no va en el mismo bucle de arriba.
 */
async function tratos(campanaId, porNombre, pjs) {
  let puestos = 0;
  let vista = null;

  for (const ficha of ELENCO) {
    const lista = ficha.tratos ?? [];
    if (!lista.length) continue;

    const npc = porNombre.get(ficha.name);
    if (!npc) throw new Error(`Falta la ficha ${ficha.name}`);

    for (const viejo of npc.relations) {
      vista = await api('DELETE', `/api/campanas/${campanaId}/elenco/tratos/${viejo.id}`);
    }

    for (const t of lista) {
      const req = { kind: t.kind, note: t.note ?? '', revealed: !!t.visto };
      if (t.a.startsWith('npc:')) {
        const otro = porNombre.get(t.a.slice(4));
        if (!otro) throw new Error(`${ficha.name}: no existe la ficha «${t.a.slice(4)}»`);
        req.otherNpcId = otro.id;
      } else if (t.a.startsWith('pj:')) {
        const id = pjs.get(t.a.slice(3));
        if (!id) throw new Error(`${ficha.name}: no existe el personaje «${t.a.slice(3)}»`);
        req.characterId = id;
      } else {
        req.otherName = t.a;
      }
      vista = await api('POST', `/api/campanas/${campanaId}/elenco/${npc.id}/tratos`, req);
      puestos++;
    }

    if (vista) porNombre = new Map(vista.npcs.map(n => [n.name, n]));
  }

  log(`· tratos: ${puestos} puestos`);
  return vista;
}

// ----------------------------------------------------------------- main ---

async function main() {
  await entrar();
  const c = await campana();
  const pjs = await personajes(c.id);
  const porNombre = await fichas(c.id);
  const vista = await tratos(c.id, porNombre, pjs);

  const final = vista ?? (await api('GET', `/api/campanas/${c.id}/elenco`));
  const sinSalir = final.npcs.filter(n => n.reveal && !n.reveal.listed);
  const secretos = final.npcs.reduce((s, n) => s + n.porDescubrir, 0);

  log('');
  log(`Elenco de «${CAMPANA}»: ${final.npcs.length} fichas.`);
  log(`  · ${final.npcs.length - sinSalir.length} en el elenco de los jugadores.`);
  log(`  · ${sinSalir.length} sin salir aún: ${sinSalir.map(n => n.name).join(', ')}.`);
  log(`  · ${secretos} cosas por descubrir en total.`);
  log(`  · código de la mesa: ${c.joinCode}`);
}

main().catch(e => {
  console.error('\nSe ha roto:', e.message);
  process.exit(1);
});
