"""Escribe V21__monsters.sql a partir de monsters_es.json.

La migración crea la tabla e inserta las criaturas con `on conflict (name) do
nothing`, así que se puede volver a aplicar sin duplicar nada.
"""
import json, re, os
import parse as P

# plantillas del SRD: no traen bloque de estadísticas, son reglas para modificar
# a otra criatura. Se guardan igual porque el máster las usa constantemente.
PLANTILLAS = {
    'ghost': ('Fantasma', 'Ghost'),
    'lich': ('Liche', 'Lich'),
    'halfDragon': ('Semidragón', 'Half-Dragon'),
    'halfCelestial': ('Semicelestial', 'Half-Celestial'),
    'halfFiend': ('Semidemonio', 'Half-Fiend'),
    'celestialCreature': ('Criatura celestial', 'Celestial Creature'),
    'fiendishCreature': ('Criatura infernal', 'Fiendish Creature'),
}

COLUMNAS = [
    ('name', 'name'), ('name_en', 'nameEn'), ('family', 'family'),
    ('creature_type', 'creatureType'), ('size_type', 'sizeType'),
    ('challenge_rating', 'challengeRating'), ('hit_dice', 'hitDice'),
    ('initiative', 'initiative'), ('speed', 'speed'), ('armor_class', 'armorClass'),
    ('base_attack', 'baseAttack'), ('attack', 'attack'), ('full_attack', 'fullAttack'),
    ('space_reach', 'spaceReach'), ('special_attacks', 'specialAttacks'),
    ('special_qualities', 'specialQualities'), ('saves', 'saves'),
    ('abilities', 'abilities'), ('skills', 'skills'), ('feats', 'feats'),
    ('environment', 'environment'), ('organization', 'organization'),
    ('treasure', 'treasure'), ('alignment', 'alignment'),
    ('advancement', 'advancement'), ('level_adjustment', 'levelAdjustment'),
    ('description', 'descriptionEn'),
]

ESQUEMA = """-- =====================================================================
-- Bestiario: las criaturas del SRD 3.5 (contenido abierto OGL), raspadas de
-- d20srd.org y traducidas. El bloque de estadísticas está en español; la prosa
-- descriptiva sigue en el inglés del SRD, igual que en los conjuros (V8).
--
-- Los dragones verdaderos van desglosados por categoría de edad, porque sus
-- estadísticas no viven en un bloque sino en tablas por edad.
--
-- `kind` distingue las criaturas de las PLANTILLAS (fantasma, liche,
-- semidragón…), que no tienen bloque: son reglas para modificar a otra.
-- =====================================================================
create table if not exists monsters (
    id                uuid primary key default gen_random_uuid(),
    name              varchar(140)  not null unique,
    name_en           varchar(140)  not null default '',
    family            varchar(140)  not null default '',
    creature_type     varchar(40)   not null default '',
    size_type         varchar(200)  not null default '',
    cr                numeric(7,3),
    challenge_rating  varchar(500)  not null default '',
    hit_dice          varchar(200)  not null default '',
    initiative        varchar(80)   not null default '',
    speed             varchar(400)  not null default '',
    armor_class       varchar(400)  not null default '',
    base_attack       varchar(160)  not null default '',
    attack            text          not null default '',
    full_attack       text          not null default '',
    space_reach       varchar(160)  not null default '',
    special_attacks   text          not null default '',
    special_qualities text          not null default '',
    saves             varchar(300)  not null default '',
    abilities         varchar(300)  not null default '',
    skills            text          not null default '',
    feats             text          not null default '',
    environment       varchar(300)  not null default '',
    organization      text          not null default '',
    treasure          varchar(400)  not null default '',
    alignment         varchar(200)  not null default '',
    advancement       text          not null default '',
    level_adjustment  varchar(300)  not null default '',
    description       text          not null default '',
    kind              varchar(20)   not null default 'criatura',
    source            varchar(60)   not null default 'SRD 3.5'
);

create index if not exists idx_monsters_cr   on monsters(cr);
create index if not exists idx_monsters_type on monsters(creature_type);
create index if not exists idx_monsters_kind on monsters(kind);
"""


def q(s):
    """Literal SQL: comillas simples dobladas."""
    return "'" + (s or '').replace("'", "''") + "'"


def main():
    ms = json.load(open('monsters_es.json'))

    cols = ['name', 'name_en', 'family', 'creature_type', 'size_type', 'cr',
            'challenge_rating', 'hit_dice', 'initiative', 'speed', 'armor_class',
            'base_attack', 'attack', 'full_attack', 'space_reach',
            'special_attacks', 'special_qualities', 'saves', 'abilities',
            'skills', 'feats', 'environment', 'organization', 'treasure',
            'alignment', 'advancement', 'level_adjustment', 'description', 'kind']
    campos = ['name', 'nameEn', 'family', 'creatureType', 'sizeType', None,
              'challengeRating', 'hitDice', 'initiative', 'speed', 'armorClass',
              'baseAttack', 'attack', 'fullAttack', 'spaceReach',
              'specialAttacks', 'specialQualities', 'saves', 'abilities',
              'skills', 'feats', 'environment', 'organization', 'treasure',
              'alignment', 'advancement', 'levelAdjustment', 'descriptionEn', None]

    partes = [ESQUEMA]
    lote = []

    def emitir():
        if not lote:
            return
        partes.append('insert into monsters (%s) values\n%s\non conflict (name) do nothing;\n'
                      % (', '.join(cols), ',\n'.join(lote)))
        lote.clear()

    partes.append('\n-- ------------------------- criaturas -------------------------\n')
    for i, m in enumerate(ms):
        vals = []
        for col, campo in zip(cols, campos):
            if col == 'cr':
                vals.append('null' if m['cr'] is None else repr(m['cr']))
            elif col == 'kind':
                vals.append(q('criatura'))
            else:
                vals.append(q(m.get(campo, '')))
        lote.append('(' + ', '.join(vals) + ')')
        if len(lote) >= 40:          # lotes cortos: un INSERT gigante es ilegible
            emitir()
    emitir()

    # --- plantillas: solo nombre y prosa, sin bloque ---
    partes.append('\n-- ------------------------- plantillas ------------------------\n')
    for pagina, (es, en) in sorted(PLANTILLAS.items()):
        ruta = 'pages/%s.htm' % pagina
        if not os.path.exists(ruta):
            print('falta la página', ruta)
            continue
        h = open(ruta, encoding='utf-8', errors='replace').read()
        i = h.find('<h1')
        fin = h.find('<div class="footer"', i)
        cuerpo = h[i:fin if fin > 0 else len(h)]
        prosa = P.txt(cuerpo)
        vals = []
        for col, campo in zip(cols, campos):
            if col == 'name':      vals.append(q(es))
            elif col == 'name_en': vals.append(q(en))
            elif col == 'family':  vals.append(q('Plantillas'))
            elif col == 'creature_type': vals.append(q('Plantilla'))
            elif col == 'description':   vals.append(q(prosa))
            elif col == 'kind':    vals.append(q('plantilla'))
            elif col == 'cr':      vals.append('null')
            else:                  vals.append(q(''))
        lote.append('(' + ', '.join(vals) + ')')
    emitir()

    sql = ''.join(partes)
    destino = os.environ.get('DESTINO', 'V21__monsters.sql')
    open(destino, 'w', encoding='utf-8').write(sql)
    print('escrito %s — %.1f MB, %d criaturas + %d plantillas'
          % (destino, len(sql.encode()) / 1e6, len(ms), len(PLANTILLAS)))


if __name__ == '__main__':
    main()
