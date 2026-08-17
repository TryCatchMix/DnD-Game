-- =====================================================================
-- Habilidades personalizadas ("de la casa").
--
-- Cualquier jugador (sea DM o no) puede añadir desde la pestaña Habilidades
-- cosas tipo "Crear agua" o "Descarga sobrenatural", sin depender del grimorio
-- del SRD. A propósito son ligeras: nombre, tipo libre y descripción.
--
-- Se guarda quién la creó solo para mostrar el autor, no para restringir.
-- =====================================================================

create table custom_abilities (
    id              uuid primary key,
    name            text not null,
    kind            text not null default '',
    description     text not null default '',
    created_by      uuid not null references users(id),
    created_by_name text not null default '',
    created_at      timestamptz not null default now()
);

create index idx_custom_abilities_created_at on custom_abilities(created_at desc);
