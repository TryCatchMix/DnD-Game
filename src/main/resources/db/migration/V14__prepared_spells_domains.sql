-- =====================================================================
-- Conjuros preparados y dominios del clérigo.
--
-- En D&D 3.5 un lanzador prepara sus conjuros ANTES de aventurarse: aquí cada
-- personaje arma su propia lista (tabla prepared_spells), un enlace al conjuro
-- del grimorio con cuántas veces lo lleva preparado.
--
-- Los dominios (que elige el clérigo, dos) se guardan como dos códigos en el
-- propio personaje; el poder otorgado y los conjuros de dominio viven en el
-- código (DomainCatalog), no en la BD.
-- =====================================================================

alter table characters add column if not exists domain1 varchar(40) not null default '';
alter table characters add column if not exists domain2 varchar(40) not null default '';

create table prepared_spells (
    id           uuid primary key default gen_random_uuid(),
    character_id uuid not null references characters(id) on delete cascade,
    spell_id     uuid not null references spells(id)     on delete cascade,
    prepared     int  not null default 1,
    created_at   timestamptz not null default now(),
    unique (character_id, spell_id)
);

create index idx_prepared_spells_character on prepared_spells(character_id);

-- Alisander es clérigo de Pelor (ver ficha.jpeg): le pegan los dominios de Sol
-- y Curación. Códigos según DomainCatalog.
update characters set domain1 = 'sun', domain2 = 'healing'
where id = '22222222-2222-2222-2222-222222220005';

-- Una lista preparada de ejemplo para Alisander, referenciada por el nombre
-- inglés del SRD para no depender de la traducción exacta. Si algún conjuro no
-- estuviera, el insert simplemente no añade nada.
insert into prepared_spells (character_id, spell_id, prepared)
select '22222222-2222-2222-2222-222222220005', s.id, v.prepared
from (values
        ('Cure Light Wounds', 3),
        ('Bless', 1),
        ('Shield of Faith', 1),
        ('Magic Weapon', 1),
        ('Cure Moderate Wounds', 2),
        ('Searing Light', 1)
     ) as v(name_en, prepared)
join spells s on s.name_en = v.name_en
on conflict (character_id, spell_id) do nothing;
