"""Escribe V23__feats.sql: el catálogo de dotes y las dotes de cada personaje.

Dos tablas:
  · `feats`           — las 110 dotes del SRD, el compendio que se consulta.
  · `character_feats` — las que tiene un personaje concreto, con su detalle
                        ("Arma focalizada" + "espada larga"), al estilo de
                        character_skills.
"""
import json, os
from dotes_es_a import DOTES_A
from dotes_es_b import DOTES_B

TIPOS = {
    'General': 'General',
    'Metamagic': 'Metamágica',
    'Item Creation': 'Creación de objetos',
    'Special': 'Especial',
}

ESQUEMA = """-- =====================================================================
-- Las dotes del SRD 3.5 (contenido abierto OGL), de d20srd.org y traducidas
-- ENTERAS: a diferencia de los monstruos, una dote son dos o tres frases y en
-- inglés no sirve de nada en la mesa.
--
-- `feats` es el compendio (se consulta en la pestaña Habilidades) y
-- `character_feats` son las que tiene puestas un personaje en su ficha. La
-- segunda guarda un `detail` porque muchas dotes se eligen "para algo":
-- Arma focalizada (espada larga), Conjuro focalizado (Evocación)…
-- =====================================================================
create table if not exists feats (
    id           uuid primary key default gen_random_uuid(),
    name         varchar(120) not null unique,
    name_en      varchar(120) not null default '',
    -- General, Metamágica, Creación de objetos, Especial
    kind         varchar(40)  not null default 'General',
    prerequisite text         not null default '',
    benefit      text         not null default '',
    normal       text         not null default '',
    special      text         not null default '',
    source       varchar(60)  not null default 'SRD 3.5'
);

create index if not exists idx_feats_kind on feats(kind);

create table if not exists character_feats (
    id           uuid primary key default gen_random_uuid(),
    character_id uuid not null references characters(id) on delete cascade,
    -- el nombre visible; se copia para que la ficha siga entendiéndose
    -- aunque la dote se borre del compendio
    name         text not null,
    -- "espada larga", "Evocación"… vacío en las que no se especifican
    detail       text not null default '',
    -- enlace al compendio; null si es una dote de la casa
    feat_id      uuid references feats(id) on delete set null,
    sort_ordinal int  not null default 0
);

create index if not exists idx_character_feats_char on character_feats(character_id);
"""

COLS = ['name', 'name_en', 'kind', 'prerequisite', 'benefit', 'normal', 'special']


def q(s):
    return "'" + str(s or '').replace("'", "''") + "'"


def main():
    crudo = json.load(open('dotes_raw.json'))
    es = {**DOTES_A, **DOTES_B}

    partes = [ESQUEMA, '\n-- ---- el compendio de dotes ------------------------------------------\n']
    filas = []
    for d in crudo:
        nombre, pre, ben, nor, esp = es[d['nameEn']]
        filas.append('(%s)' % ', '.join([
            q(nombre), q(d['nameEn']), q(TIPOS.get(d['typeEn'], 'General')),
            q(pre), q(ben), q(nor), q(esp)]))

    for i in range(0, len(filas), 25):
        partes.append('insert into feats (%s) values\n%s\non conflict (name) do nothing;\n'
                      % (', '.join(COLS), ',\n'.join(filas[i:i + 25])))

    sql = ''.join(partes)
    destino = os.environ.get('DESTINO', 'V23__feats.sql')
    open(destino, 'w', encoding='utf-8').write(sql)
    print('escrito %s — %d KB, %d dotes' % (destino, len(sql.encode()) / 1024, len(filas)))
    from collections import Counter
    print(Counter(TIPOS.get(d['typeEn'], 'General') for d in crudo))


if __name__ == '__main__':
    main()
