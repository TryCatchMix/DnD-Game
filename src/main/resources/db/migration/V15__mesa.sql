-- =====================================================================
-- LA MESA — el escritorio de preparación del DM.
--
-- Tres piezas y nada más, porque preparar una partida es exactamente eso:
--   mesa_misiones  la carpeta: una sesión/misión que se está cocinando
--   mesa_notas     el guion: escenas, PNJ, botín y textos para leer en voz alta
--   mesa_archivos  el material: imágenes y PDF subidos al servidor
--
-- Todo cuelga del USUARIO (el DM), no de un personaje: la preparación es del
-- máster y sigue valiendo aunque cambie de personaje o de mesa.
-- =====================================================================

create table mesa_misiones (
    id           uuid primary key default gen_random_uuid(),
    user_id      uuid not null references users(id) on delete cascade,
    title        text not null,
    summary      text not null default '',
    -- idea | preparando | lista | jugada
    status       text not null default 'idea',
    -- etiquetas libres separadas por coma: "dorakan,minas,nivel 3"
    tags         text not null default '',
    -- cuándo se piensa jugar (opcional): ordena la vista de "próximas"
    session_date date,
    -- portada de la tarjeta; se rellena luego, por eso la FK va al final
    cover_id     uuid,
    ordinal      int  not null default 0,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now()
);

create index idx_mesa_misiones_user on mesa_misiones(user_id);

create table mesa_archivos (
    id           uuid primary key default gen_random_uuid(),
    user_id      uuid not null references users(id) on delete cascade,
    -- null = está en la biblioteca general, sin misión asignada
    mision_id    uuid references mesa_misiones(id) on delete set null,
    -- imagen | pdf | otro
    kind         text not null,
    title        text not null,
    -- el nombre con el que lo subió el DM (solo para mostrar y descargar)
    filename     text not null,
    mime         text not null,
    size_bytes   bigint not null default 0,
    -- el nombre real en disco: uuid + extensión, nunca lo que mandó el cliente
    storage_name text not null,
    created_at   timestamptz not null default now()
);

create index idx_mesa_archivos_user   on mesa_archivos(user_id);
create index idx_mesa_archivos_mision on mesa_archivos(mision_id);

-- La portada apunta a un archivo. Si se borra el archivo, la misión se queda
-- sin portada (no desaparece la misión).
alter table mesa_misiones
    add constraint fk_mesa_misiones_cover
    foreign key (cover_id) references mesa_archivos(id) on delete set null;

create table mesa_notas (
    id         uuid primary key default gen_random_uuid(),
    mision_id  uuid not null references mesa_misiones(id) on delete cascade,
    -- lectura | escena | pnj | botin | nota
    kind       text not null default 'nota',
    title      text not null default '',
    body       text not null default '',
    ordinal    int  not null default 0,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index idx_mesa_notas_mision on mesa_notas(mision_id);

-- ---------------------------------------------------------------------
-- Una misión de ejemplo para el DM sembrado (V10__admin_user.sql), para que
-- La Mesa no arranque vacía del todo y se vea de qué va.
-- ---------------------------------------------------------------------
insert into mesa_misiones (id, user_id, title, summary, status, tags, ordinal)
select '33333333-3333-3333-3333-333333330001', u.id,
       'El silencio de las minas',
       'Los mineros no vuelven del pozo tercero. Lo que hay abajo no es un derrumbe.',
       'preparando', 'dorakan,minas,nivel 3', 0
from users u where u.email = 'admin@trycatchmix.com'
on conflict do nothing;

insert into mesa_notas (mision_id, kind, title, body, ordinal)
select '33333333-3333-3333-3333-333333330001', 'lectura', 'Entrada al pozo',
       'El aire sube caliente y huele a moneda vieja. La cuerda del cabestrante está cortada, no rota: alguien la cortó desde abajo.',
       0
where exists (select 1 from mesa_misiones where id = '33333333-3333-3333-3333-333333330001')
on conflict do nothing;

insert into mesa_notas (mision_id, kind, title, body, ordinal)
select '33333333-3333-3333-3333-333333330001', 'pnj', 'Bruna, capataz',
       'Sabe más de lo que dice. Si la presionan delante de otros mineros, miente; a solas, cuenta lo del tercer turno.',
       1
where exists (select 1 from mesa_misiones where id = '33333333-3333-3333-3333-333333330001')
on conflict do nothing;
