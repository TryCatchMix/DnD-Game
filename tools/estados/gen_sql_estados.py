"""Escribe V26__conditions_poisons.sql: condiciones, enfermedades y venenos."""
import json, os, re
from estados_es import CONDICIONES, ENFERMEDADES, VENENOS, NOTAS_ENFERMEDAD

ESQUEMA = """-- =====================================================================
-- Condiciones, enfermedades y venenos del SRD 3.5 (contenido abierto OGL).
--
-- Las tres cosas se consultan a media pelea y hasta ahora no estaban en
-- ningún sitio: el bestiario dice "veneno" y "enfermedad" sin decir la CD, y
-- "aturdido" o "derribado" se discutían de memoria.
--
-- Como las dotes, están traducidas ENTERAS: son textos de dos o tres frases.
-- =====================================================================
create table if not exists conditions (
    id          uuid primary key default gen_random_uuid(),
    name        varchar(80)  not null unique,
    name_en     varchar(80)  not null default '',
    description text         not null default '',
    source      varchar(60)  not null default 'SRD 3.5'
);

create table if not exists diseases (
    id          uuid primary key default gen_random_uuid(),
    name        varchar(80)  not null unique,
    name_en     varchar(80)  not null default '',
    -- Ingerida | Inhalada | Herida | Contacto
    infection   varchar(40)  not null default '',
    dc          int          not null default 0,
    incubation  varchar(60)  not null default '',
    damage      varchar(120) not null default '',
    -- las aclaraciones que el SRD pone al pie de la tabla
    notes       text         not null default '',
    source      varchar(60)  not null default 'SRD 3.5'
);

create table if not exists poisons (
    id               uuid primary key default gen_random_uuid(),
    name             varchar(80)  not null unique,
    name_en          varchar(80)  not null default '',
    -- Contacto | Ingerido | Inhalado | Herida
    kind             varchar(40)  not null default '',
    dc               int          not null default 0,
    initial_damage   varchar(120) not null default '',
    secondary_damage varchar(120) not null default '',
    -- en piezas de cobre, como el resto de la app
    price_cp         bigint       not null default 0,
    source           varchar(60)  not null default 'SRD 3.5'
);
"""

def q(s):
    return "'" + str(s or '').replace("'", "''") + "'"

def cp(precio):
    t = (precio or '').replace(',', '')
    m = re.match(r'^([\d.]+)\s*gp', t)
    return int(float(m.group(1)) * 100) if m else 0

def main():
    d = json.load(open('estados_raw.json'))
    partes = [ESQUEMA]

    partes.append('\n-- ------------------------- condiciones ------------------------\n')
    filas = []
    for x in d['condiciones']:
        nombre, texto = CONDICIONES[x['nameEn']]
        filas.append('(%s, %s, %s)' % (q(nombre), q(x['nameEn']), q(texto)))
    partes.append('insert into conditions (name, name_en, description) values\n%s\n'
                  'on conflict (name) do nothing;\n' % ',\n'.join(filas))

    partes.append('\n-- ------------------------ enfermedades ------------------------\n')
    filas = []
    for x in d['enfermedades']:
        nombre, contagio, incub, dano = ENFERMEDADES[x['nameEn']]
        nota = NOTAS_ENFERMEDAD.get(x['nameEn'], '')
        filas.append('(%s, %s, %s, %s, %s, %s, %s)' % (
            q(nombre), q(x['nameEn']), q(contagio), x['dc'], q(incub), q(dano), q(nota)))
    partes.append('insert into diseases (name, name_en, infection, dc, incubation, damage, notes)'
                  ' values\n%s\non conflict (name) do nothing;\n' % ',\n'.join(filas))

    partes.append('\n-- -------------------------- venenos ---------------------------\n')
    filas = []
    for x in d['venenos']:
        nombre, tipo, inicial, secundario = VENENOS[x['nameEn']]
        clase = tipo.split(' CD')[0]
        cd = re.search(r'CD\s*(\d+)', tipo).group(1)
        filas.append('(%s, %s, %s, %s, %s, %s, %s)' % (
            q(nombre), q(x['nameEn']), q(clase), cd, q(inicial), q(secundario),
            cp(x['priceEn'])))
    partes.append('insert into poisons (name, name_en, kind, dc, initial_damage,'
                  ' secondary_damage, price_cp) values\n%s\n'
                  'on conflict (name) do nothing;\n' % ',\n'.join(filas))

    sql = ''.join(partes)
    destino = os.environ.get('DESTINO', 'V26__conditions_poisons.sql')
    open(destino, 'w', encoding='utf-8').write(sql)
    print('escrito %s — %d KB · %d condiciones, %d enfermedades, %d venenos'
          % (destino, len(sql.encode()) / 1024, len(d['condiciones']),
             len(d['enfermedades']), len(d['venenos'])))

if __name__ == '__main__':
    main()
