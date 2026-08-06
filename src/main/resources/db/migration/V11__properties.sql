-- =====================================================================
-- Propiedades: el mini-juego de comprar un negocio y mejorarlo.
-- Cada propiedad es de un personaje; la renta se acumula con el tiempo y se
-- recauda a mano (no hay proceso en segundo plano). La economía de cada tipo
-- vive en el código (PropertyKind), aquí solo guardamos el tipo y el nivel.
-- =====================================================================
create table properties (
    id                uuid primary key default gen_random_uuid(),
    character_id      uuid not null references characters(id) on delete cascade,
    kind              varchar(32) not null,
    name              varchar(80) not null,
    level             int  not null default 1,
    city              varchar(80) not null default '',
    purchased_at      timestamptz not null default now(),
    last_collected_at timestamptz not null default now()
);

create index idx_properties_character on properties(character_id);

-- Una propiedad de ejemplo para Gorash, con 3 días de renta ya acumulada
-- (last_collected_at en el pasado) para que se pueda recaudar nada más entrar.
insert into properties (character_id, kind, name, level, city, purchased_at, last_collected_at)
values ('22222222-2222-2222-2222-222222220001', 'taberna', 'El Toro Ciego', 2, 'Dorakan',
        now() - interval '20 days', now() - interval '3 days');
