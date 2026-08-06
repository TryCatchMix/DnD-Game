-- =====================================================================
-- El bloc de notas: nombres de PNJ, ciudades, facciones y lo que sea que
-- convenga no olvidar durante la partida.
--
-- Las notas son DEL JUGADOR, no de un personaje concreto: los nombres que
-- salen en la historia siguen valiendo aunque cambies de personaje.
-- =====================================================================

create table notes (
    id         uuid primary key,
    user_id    uuid not null references users(id),
    -- Persona | Lugar | Facción | Objeto | Suceso | Otro
    category   text not null default 'Otro',
    title      text not null,
    body       text not null default '',
    -- las fijadas salen siempre arriba del todo
    pinned     boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index idx_notes_user on notes(user_id);

-- ---- un par de ejemplos para que el bloc no arranque vacío ----------
insert into notes (id, user_id, category, title, body, pinned) values
(gen_random_uuid(),'11111111-1111-1111-1111-111111111111','Lugar','Dorakan',
 'La ciudad donde empieza todo. Tiene tablón de encargos, mercado y el pozo tercero de las minas.', true),
(gen_random_uuid(),'11111111-1111-1111-1111-111111111111','Facción','Gremio de Mineros',
 'Encargan lo del silencio de las minas. Pagan 120 po y un favor.', false),
(gen_random_uuid(),'11111111-1111-1111-1111-111111111111','Lugar','Puente Norte',
 'Está caído. Mientras siga así, la procesión del Farolero no puede cruzar al arrabal.', false);
