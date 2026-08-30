"""Escribe V27__class_tables.sql: las tablas de progresión y de qué clase es
cada criatura del bestiario."""
import json, os

ESQUEMA = """-- =====================================================================
-- Tablas de progresión de clase del SRD 3.5 (contenido abierto OGL).
--
-- Es lo que hace falta para responder "¿y este guerrero enano, de nivel 3?":
-- el dado de golpe, el ataque base y las tres salvaciones de cada clase en
-- cada uno de sus 20 niveles.
--
-- CUIDADO: "Guerrero (PNJ)" (Warrior) y "Guerrero" (Fighter) son clases
-- DISTINTAS aunque las dos se traduzcan igual — d8 con 2+Int puntos frente a
-- d10 con dote adicional cada dos niveles. Por eso las criaturas se emparejan
-- por su nombre en INGLÉS, no por el traducido.
-- =====================================================================
create table if not exists character_classes (
    id            uuid primary key default gen_random_uuid(),
    name          varchar(60) not null unique,
    name_en       varchar(60) not null unique,
    hit_die       int         not null default 8,
    -- puntos de habilidad por nivel, antes de sumar el modificador de Int
    skill_points  int         not null default 2,
    -- true = clase de PNJ (guerrero, experto, adepto, aristócrata, plebeyo)
    npc           boolean     not null default false,
    source        varchar(60) not null default 'SRD 3.5'
);

create table if not exists class_progression (
    id        uuid primary key default gen_random_uuid(),
    class_en  varchar(60) not null references character_classes(name_en) on delete cascade,
    level     int not null,
    bab       int not null default 0,
    fort      int not null default 0,
    ref       int not null default 0,
    will      int not null default 0,
    special   text not null default '',
    unique (class_en, level)
);

create index if not exists idx_class_progression on class_progression(class_en, level);

-- ---- de qué clase y nivel es cada criatura del bestiario ----
-- Se saca del nombre en inglés ("Dwarf, 1st-Level Warrior"), que es el único
-- sitio donde Warrior y Fighter se distinguen.
alter table monsters add column if not exists class_name_en varchar(60) not null default '';
alter table monsters add column if not exists class_level   int         not null default 0;

update monsters
   set class_level   = coalesce(nullif(substring(name_en from '(\\d+)(?:st|nd|rd|th)-Level'), '')::int, 0),
       class_name_en = coalesce(substring(name_en from '\\d+(?:st|nd|rd|th)-Level ([A-Za-z]+)'), '')
 where name_en ~ '\\d+(st|nd|rd|th)-Level';

create index if not exists idx_monsters_class on monsters(class_name_en);
"""


def q(s):
    return "'" + str(s or '').replace("'", "''") + "'"


def main():
    clases = json.load(open('clases_raw.json'))
    partes = [ESQUEMA, '\n-- ---------------------- las clases ----------------------\n']

    filas = ['(%s, %s, %d, %d, %s)' % (q(c['name']), q(c['nameEn']), c['hitDie'],
                                       c['skillPoints'], 'true' if c['npc'] else 'false')
             for c in clases]
    partes.append('insert into character_classes (name, name_en, hit_die, skill_points, npc)'
                  ' values\n%s\non conflict (name_en) do nothing;\n' % ',\n'.join(filas))

    partes.append('\n-- ------------------- la progresión nivel a nivel -------------------\n')
    filas = []
    for c in clases:
        for n in c['levels']:
            filas.append('(%s, %d, %d, %d, %d, %d, %s)' % (
                q(c['nameEn']), n['level'], n['bab'], n['fort'], n['ref'], n['will'],
                q(n['special'])))
    for i in range(0, len(filas), 40):
        partes.append('insert into class_progression (class_en, level, bab, fort, ref, will, special)'
                      ' values\n%s\non conflict (class_en, level) do nothing;\n'
                      % ',\n'.join(filas[i:i + 40]))

    sql = ''.join(partes)
    destino = os.environ.get('DESTINO', 'V27__class_tables.sql')
    open(destino, 'w', encoding='utf-8').write(sql)
    print('escrito %s — %d KB · %d clases, %d filas de progresión'
          % (destino, len(sql.encode()) / 1024, len(clases), len(filas)))


if __name__ == '__main__':
    main()
