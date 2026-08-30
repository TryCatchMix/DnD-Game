-- =====================================================================
-- LOS ENEMIGOS DEL MÁSTER Y EL COMBATE.
--
-- El bestiario (V21) es el MANUAL: no se toca, es igual para todos y lo
-- consulta cualquiera. Lo que hace falta para jugar es otra cosa: "el trasgo
-- de la mina, que tiene 5 PG porque ya le arreó Gorash y se llama Cara-rota".
--
--   mesa_enemigos      la plantilla de un enemigo del DM. Puede salir copiada
--                      de un monstruo del bestiario o inventada de cero, y
--                      desde ese momento es SUYA: la edita a su gusto sin
--                      tocar el manual.
--   mesa_combates      un encuentro concreto.
--   mesa_combatientes  quién está en él: enemigos, personajes del grupo o
--                      algo suelto escrito a mano, con su iniciativa y sus PG.
--
-- Todo cuelga del USUARIO (el DM), como el resto de La Mesa.
-- =====================================================================

create table mesa_enemigos (
    id           uuid primary key default gen_random_uuid(),
    user_id      uuid not null references users(id) on delete cascade,
    -- opcional: prepararlo dentro de una misión concreta
    mision_id    uuid references mesa_misiones(id) on delete set null,
    -- de qué monstruo se copió. Si el bestiario cambiara, el enemigo no:
    -- es solo la procedencia, para poder volver a mirar la ficha original.
    monster_id   uuid references monsters(id) on delete set null,

    name         text not null,
    size_type    text not null default '',
    -- el VD tal cual se lee ("7", "½"); es informativo
    cr           text not null default '',

    -- lo que de verdad se usa en combate, ya en números
    hp_max       int  not null default 0,
    ac           int  not null default 10,
    ac_touch     int  not null default 10,
    ac_flat_footed int not null default 10,
    init_mod     int  not null default 0,

    -- el resto del bloque, tal cual se lee (no hace falta partirlo)
    speed             text not null default '',
    saves             text not null default '',
    abilities         text not null default '',
    attack            text not null default '',
    full_attack       text not null default '',
    special_attacks   text not null default '',
    special_qualities text not null default '',
    skills            text not null default '',
    feats             text not null default '',
    -- las notas del máster: "cojea", "sabe dónde está la llave"
    notes             text not null default '',

    created_at   timestamptz not null default now()
);

create index idx_mesa_enemigos_user   on mesa_enemigos(user_id);
create index idx_mesa_enemigos_mision on mesa_enemigos(mision_id);

create table mesa_combates (
    id           uuid primary key default gen_random_uuid(),
    user_id      uuid not null references users(id) on delete cascade,
    mision_id    uuid references mesa_misiones(id) on delete set null,
    title        text not null default 'Combate',
    -- 0 = aún no ha empezado; 1 en adelante, el asalto en curso
    round        int  not null default 0,
    -- a quién le toca, por su sitio en el orden de iniciativa
    turn_ordinal int  not null default 0,
    created_at   timestamptz not null default now()
);

create index idx_mesa_combates_user on mesa_combates(user_id);

create table mesa_combatientes (
    id           uuid primary key default gen_random_uuid(),
    combate_id   uuid not null references mesa_combates(id) on delete cascade,

    -- 'enemigo' | 'personaje' | 'suelto'
    kind         text not null default 'enemigo',
    -- de dónde salió; se conserva el nombre y los números por si desaparece
    enemigo_id   uuid references mesa_enemigos(id) on delete set null,
    character_id uuid references characters(id) on delete set null,

    name         text not null,
    initiative   int  not null default 0,
    hp_max       int  not null default 0,
    hp_current   int  not null default 0,
    ac           int  not null default 10,
    -- estados, de momento texto libre: "derribado, cegado"
    conditions   text not null default '',
    notes        text not null default '',
    -- fuera de combate, pero sin borrarlo del orden
    defeated     boolean not null default false,
    sort_ordinal int  not null default 0
);

create index idx_mesa_combatientes_combate on mesa_combatientes(combate_id);
