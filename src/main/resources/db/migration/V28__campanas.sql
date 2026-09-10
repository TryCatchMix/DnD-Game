-- =====================================================================
-- LAS CAMPAÑAS — la mesa deja de ser una sola.
--
-- Hasta aquí todo colgaba del USUARIO: las misiones eran del DM, la tienda
-- era única para todo el mundo y el bloc de notas era del jugador a secas.
-- Eso vale mientras solo se juega una partida. En cuanto hay dos, el trasgo
-- de una campaña aparece en el combate de la otra.
--
-- A partir de ahora la unidad es la CAMPAÑA:
--
--   campaigns          la partida: quién la dirige y con qué código se entra
--   campaign_members   quién está dentro y con qué papel (DM o jugador)
--
-- El papel de máster pasa a ser DE CAMPAÑA, no de cuenta: cualquiera puede
-- crear la suya y dirigirla, y ser jugador en la de al lado. La columna
-- users.role se queda como estaba y significa otra cosa (administrador de la
-- instalación); ya no es lo que decide quién puede preparar una partida.
--
-- Todo lo que era del máster o de la mesa gana una columna campaign_id:
-- misiones, material, enemigos, combates, ofertas de la tienda, notas y
-- encargos. Los personajes ganan la suya para decir a qué partida se han
-- unido.
-- =====================================================================

create table campaigns (
    id          uuid primary key default gen_random_uuid(),
    -- quien la creó. Es su DM y el único que puede borrarla.
    owner_id    uuid not null references users(id) on delete cascade,
    name        text not null,
    description text not null default '',
    -- el código que se reparte para entrar: corto, en mayúsculas y sin
    -- caracteres que se confundan al dictarlo (ni O ni 0, ni I ni 1).
    join_code   text not null unique,
    -- con la puerta cerrada el código deja de valer, sin perderlo
    open        boolean not null default true,
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now()
);

create index idx_campaigns_owner on campaigns(owner_id);

create table campaign_members (
    id          uuid primary key default gen_random_uuid(),
    campaign_id uuid not null references campaigns(id) on delete cascade,
    user_id     uuid not null references users(id) on delete cascade,
    -- DM | PLAYER, dentro de ESTA campaña
    role        text not null default 'PLAYER',
    joined_at   timestamptz not null default now(),
    unique (campaign_id, user_id)
);

create index idx_campaign_members_user on campaign_members(user_id);

-- ---------------------------------------------------------------------
-- A qué partida pertenece cada cosa.
--
-- Todas las columnas son NULL-ables a propósito:
--   · un personaje sin campaña es uno recién creado, todavía sin mesa;
--   · una oferta sin campaña es SURTIDO BASE, la plantilla con la que nace
--     la tienda de cada campaña nueva (ver abajo);
--   · un encargo sin campaña es contenido COMÚN, visible desde cualquier
--     tablón, que ninguna campaña puede reescribir.
-- ---------------------------------------------------------------------
alter table characters      add column campaign_id uuid references campaigns(id) on delete set null;
alter table notes           add column campaign_id uuid references campaigns(id) on delete cascade;
alter table shop_offers     add column campaign_id uuid references campaigns(id) on delete cascade;
alter table mesa_misiones   add column campaign_id uuid references campaigns(id) on delete cascade;
alter table mesa_archivos   add column campaign_id uuid references campaigns(id) on delete cascade;
alter table mesa_enemigos   add column campaign_id uuid references campaigns(id) on delete cascade;
alter table mesa_combates   add column campaign_id uuid references campaigns(id) on delete cascade;
alter table quests          add column campaign_id uuid references campaigns(id) on delete cascade;

create index idx_characters_campaign    on characters(campaign_id);
create index idx_notes_campaign         on notes(campaign_id, user_id);
create index idx_shop_offers_campaign   on shop_offers(campaign_id);
create index idx_mesa_misiones_campaign on mesa_misiones(campaign_id);
create index idx_mesa_archivos_campaign on mesa_archivos(campaign_id);
create index idx_mesa_enemigos_campaign on mesa_enemigos(campaign_id);
create index idx_mesa_combates_campaign on mesa_combates(campaign_id);
create index idx_quests_campaign        on quests(campaign_id);

-- El código de un encargo era único en toda la base. Con varias campañas eso
-- impide que dos mesas tengan cada una su 'minas_01'. Pasa a ser único DENTRO
-- de la campaña, y aparte único entre los comunes (los que no tienen campaña,
-- donde el UNIQUE normal no serviría porque en SQL dos NULL no chocan).
alter table quests drop constraint if exists quests_code_key;
create unique index uq_quests_campaign_code on quests(campaign_id, code)
    where campaign_id is not null;
create unique index uq_quests_common_code on quests(code)
    where campaign_id is null;

-- =====================================================================
-- LA MUDANZA. Lo que ya estaba jugándose no puede quedarse sin mesa.
--
-- Se crea UNA campaña que recoge la partida que había: se la queda el máster
-- sembrado (o, si no existe, el primer DM que haya, o el usuario más antiguo)
-- y entran en ella TODOS los usuarios, con el papel que ya tenían. Así el día
-- que se despliega esto nadie pierde de vista sus personajes, sus notas ni sus
-- misiones: siguen exactamente donde estaban, ahora con nombre de campaña.
-- =====================================================================
insert into campaigns (id, owner_id, name, description, join_code, open)
select '44444444-4444-4444-4444-444444440001',
       u.id,
       'La mesa de siempre',
       'La partida que ya se estaba jugando antes de que existieran las campañas. '
       || 'Aquí siguen los personajes, las notas, la tienda y las misiones de entonces.',
       'MESA',
       true
from users u
order by (u.email = 'admin@trycatchmix.com') desc,
         (u.role = 'DM') desc,
         u.email
limit 1;

insert into campaign_members (campaign_id, user_id, role)
select c.id, u.id,
       case when u.id = c.owner_id or u.role = 'DM' then 'DM' else 'PLAYER' end
from campaigns c
cross join users u
where c.id = '44444444-4444-4444-4444-444444440001'
on conflict (campaign_id, user_id) do nothing;

update characters    set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');
update notes         set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');
update mesa_misiones set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');
update mesa_archivos set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');
update mesa_enemigos set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');
update mesa_combates set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');

-- La tienda que había pasa entera a esa campaña...
update shop_offers   set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');

-- ...y en su lugar queda el SURTIDO BASE, sin campaña: es de donde se copia el
-- mostrador de cada campaña nueva, para que no nazca con la vitrina vacía. No
-- se ve desde ninguna tienda; solo se lee al crear una campaña.
-- El `not exists` es por el caso raro de una base sin usuarios: allí no se creó
-- campaña heredada, las ofertas de V3 siguen sin campaña y ya hacen de
-- plantilla ellas mismas. Sin esta guarda quedarían dos surtidos base y toda
-- campaña nueva nacería con el género duplicado en la vitrina.
insert into shop_offers (id, location, item_code, price_cp, stock, campaign_id)
select gen_random_uuid(), 'base', i.code, i.price_cp, -1, null
from items i
where i.code in ('antorcha','aceite','racion','cuerda_canamo','piqueta','daga',
                 'farol','pocion_curacion')
  and not exists (select 1 from shop_offers where campaign_id is null);

-- Los encargos se reparten en dos montones.
--
-- Los DOS SEMBRADOS en V2 se quedan sin campaña, o sea COMUNES: aparecen en el
-- tablón de cualquier mesa, también en las que se creen mañana, para que una
-- campaña recién abierta tenga algo que jugar desde el primer día. Nadie los
-- reescribe: hacerlo cambiaría el tablón de todas a la vez.
--
-- Todo lo demás lo escribió un máster, así que se va con él a su campaña, donde
-- lo sigue editando y publicando como siempre. Sin esto, sus propios encargos
-- se le habrían quedado en solo lectura de la noche a la mañana.
update quests set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null
      and id not in ('33333333-3333-3333-3333-333333330001',
                     '33333333-3333-3333-3333-333333330002')
      and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');
