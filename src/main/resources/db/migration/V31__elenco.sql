-- =====================================================================
-- EL ELENCO — quién ha ido saliendo en la campaña.
--
-- Una campaña se recuerda por su gente: el tabernero que sabía demasiado, la
-- capitana que os debe un favor, el encapuchado del callejón. Hasta ahora eso
-- vivía en el bloc de notas de cada jugador, y allí cada uno apuntaba una cosa
-- distinta (y el máster no podía enseñar el retrato).
--
-- Dos tablas:
--   npcs            la ficha del personaje: foto, nombre, título, ubicación,
--                   raza, descripción, curiosidades y alineamiento
--   npc_relations   con quién es amistoso, neutral, enemigo o familiar
--
-- LO QUE DE VERDAD IMPORTA AQUÍ SON LAS COLUMNAS `reveal_*`.
--
-- Un PNJ no se conoce de golpe: primero es "el encapuchado", luego tiene cara,
-- mucho después tiene nombre y un hermano en la guardia. Así que CADA CAMPO se
-- revela por separado. El máster lo ve todo siempre; al jugador el backend le
-- manda null en lo que aún no se ha descubierto —no oculto con CSS: no viajado,
-- porque lo que llega al navegador se puede leer.
--
-- Mientras el nombre está sellado, la ficha se enseña con su `alias` ("El
-- encapuchado"). Por eso el nombre puede ocultarse sin dejar la tarjeta muda.
-- =====================================================================

create table npcs (
    id           uuid primary key default gen_random_uuid(),
    -- de qué mesa es. Cada campaña tiene su elenco y no ve el de la de al lado.
    campaign_id  uuid not null references campaigns(id) on delete cascade,
    -- quién lo creó (el máster de turno); el permiso lo da la campaña
    user_id      uuid not null references users(id) on delete cascade,

    -- ---- la ficha ----
    name         text not null,
    -- cómo se le llama mientras el nombre siga sellado
    alias        text not null default 'Desconocido',
    title        text not null default '',
    location     text not null default '',
    race         text not null default '',
    description  text not null default '',
    -- las curiosidades, una por línea
    trivia       text not null default '',
    alignment    text not null default '',
    -- el retrato vive en la biblioteca de La Mesa, como el resto del material
    portrait_id  uuid references mesa_archivos(id) on delete set null,

    -- ---- qué se ha descubierto ----
    -- La ficha entera: en false el PNJ ni siquiera sale en el elenco del
    -- jugador. Es el borrador del máster, el que aún no ha aparecido en mesa.
    listed             boolean not null default false,
    reveal_name        boolean not null default false,
    reveal_portrait    boolean not null default false,
    reveal_title       boolean not null default false,
    reveal_location    boolean not null default false,
    reveal_race        boolean not null default false,
    reveal_description boolean not null default false,
    reveal_trivia      boolean not null default false,
    reveal_alignment   boolean not null default false,

    ordinal      int not null default 0,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now()
);

create index idx_npcs_campaign on npcs(campaign_id);

-- ---------------------------------------------------------------------
-- Con quién se lleva bien y con quién no.
--
-- El otro extremo puede ser tres cosas, y solo una a la vez: otro PNJ del
-- elenco, un personaje jugador de la mesa, o un nombre suelto (una facción, un
-- muerto, alguien que no tiene ficha). Se guardan las tres columnas y se usa la
-- que venga rellena; resolver el nombre para enseñar es cosa del servicio.
--
-- `revealed` es por relación: que sepas que es enemigo del gremio no te dice
-- que sea hermano de la capitana.
-- ---------------------------------------------------------------------
create table npc_relations (
    id           uuid primary key default gen_random_uuid(),
    npc_id       uuid not null references npcs(id) on delete cascade,
    -- amistoso | neutral | enemigo | familiar
    kind         text not null default 'neutral',
    other_npc_id uuid references npcs(id) on delete cascade,
    character_id uuid references characters(id) on delete cascade,
    other_name   text not null default '',
    -- "le debe 200 po", "hermanos de madre"
    note         text not null default '',
    revealed     boolean not null default false,
    ordinal      int not null default 0,
    created_at   timestamptz not null default now()
);

create index idx_npc_relations_npc on npc_relations(npc_id);

-- ---------------------------------------------------------------------
-- Un par de caras para que el elenco no arranque en blanco en la mesa
-- heredada de V28. Si esa campaña no existe (base recién creada), no se
-- siembra nada y el máster empieza de cero, que es lo correcto.
-- ---------------------------------------------------------------------
insert into npcs (campaign_id, user_id, name, alias, title, location, race,
                  description, trivia, alignment, listed, ordinal,
                  reveal_name, reveal_title, reveal_location, reveal_race,
                  reveal_description, reveal_trivia, reveal_alignment)
select c.id, c.owner_id,
       'Gorash Pico de Hierro', 'El capataz', 'Capataz del pozo tercero', 'Dorakan', 'Enano',
       'Lleva treinta años bajando a las minas y no ha perdido a nadie. Habla poco y mira mucho.',
       'Le falta el meñique izquierdo y no cuenta por qué.' || chr(10) ||
       'Guarda una botella de aguardiente para los que suben del pozo.',
       'Legal neutral', true, 1,
       true, true, true, true, true, false, false
from campaigns c
where c.id = '44444444-4444-4444-4444-444444440001';

-- La segunda todavía no tiene nombre para nadie: es la cara que se enseña
-- cuando el elenco hace lo que tiene que hacer.
insert into npcs (campaign_id, user_id, name, alias, title, location, race,
                  description, trivia, alignment, listed, ordinal,
                  reveal_name, reveal_title, reveal_location, reveal_race,
                  reveal_description, reveal_trivia, reveal_alignment)
select c.id, c.owner_id,
       'Vela Sarn', 'El encapuchado', 'Contacto del Gremio', 'Dorakan', 'Humana',
       'Aparece en el callejón detrás de El Farol cuando hay encargo. Nunca de día.',
       'Siempre paga por adelantado y en plata vieja.',
       'Neutral malvado', true, 2,
       false, false, true, false, true, false, false
from campaigns c
where c.id = '44444444-4444-4444-4444-444444440001';
