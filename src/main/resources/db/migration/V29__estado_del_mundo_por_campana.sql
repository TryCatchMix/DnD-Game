-- =====================================================================
-- EL ESTADO DEL MUNDO también es de cada partida.
--
-- «puente_norte_en_pie» decide si un encargo sale bloqueado en el tablón. Si
-- fuera una sola fila para toda la instalación, lo que hicieran los jugadores
-- de una mesa cambiaría el tablón de la de al lado. Hoy nadie escribe estas
-- filas todavía, pero el día que un desenlace las toque el fallo sería mudo y
-- carísimo de encontrar, así que se separa ahora.
--
-- La clave textual deja de ser la primaria: ahora hay una fila por campaña y
-- bandera, más una PLANTILLA sin campaña de la que copian las mesas nuevas
-- (ver CampaignService), para que un encargo común no salga bloqueado en una
-- campaña recién creada solo porque allí no existiera ninguna bandera.
-- =====================================================================

alter table world_flags add column id uuid not null default gen_random_uuid();
alter table world_flags drop constraint world_flags_pkey;
alter table world_flags add primary key (id);
alter table world_flags add column campaign_id uuid references campaigns(id) on delete cascade;

update world_flags set campaign_id = '44444444-4444-4444-4444-444444440001'
    where campaign_id is null
      and exists (select 1 from campaigns where id = '44444444-4444-4444-4444-444444440001');

-- La plantilla: una copia sin campaña de lo que había. Si no llegó a haber
-- campaña heredada (base sin usuarios), las filas originales se quedaron sin
-- campaña y ya hacen de plantilla ellas mismas.
insert into world_flags (id, flag_key, state, campaign_id)
select gen_random_uuid(), w.flag_key, w.state, null
from world_flags w
where w.campaign_id = '44444444-4444-4444-4444-444444440001';

create unique index uq_world_flags_campaign on world_flags(campaign_id, flag_key)
    where campaign_id is not null;
create unique index uq_world_flags_base on world_flags(flag_key)
    where campaign_id is null;
