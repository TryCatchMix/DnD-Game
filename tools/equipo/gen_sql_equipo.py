"""Escribe V22__equipment.sql a partir de equipo_es.json.

Amplía la tabla `items` que ya existe en vez de crear una nueva, porque la
tienda y el inventario apuntan a `items(code)` y así siguen funcionando sin
tocar nada. Las columnas de arma quedan vacías en una antorcha, y al revés.

Los 7 objetos que ya estaban en el catálogo de Dorakan conservan su nombre,
su descripción escrita a mano y su precio: solo se les rellenan las columnas
nuevas.
"""
import json, os

ESQUEMA = """-- =====================================================================
-- Equipo del SRD 3.5 (contenido abierto OGL), de d20srd.org y traducido:
-- 78 armas, 21 armaduras y escudos, 154 objetos y 16 servicios.
--
-- Se amplía `items` en vez de crear tablas nuevas: la tienda (shop_offers) y
-- la bolsa (inventory) ya apuntan a items(code), así que todo sigue igual y
-- los objetos nuevos se pueden comprar y vender desde el primer momento.
--
-- Precios en piezas de COBRE, como el resto de la app (1 po = 100 pc).
-- =====================================================================

-- ---- columnas nuevas -------------------------------------------------
-- El grupo del SRD ("Arma marcial (una mano)", "Armadura pesada"), para
-- poder ordenar el catálogo por familias en la tienda.
alter table items add column if not exists equipment_group text not null default '';
alter table items add column if not exists name_en         text not null default '';
alter table items add column if not exists source          text not null default '';

-- armas
alter table items add column if not exists damage_small    text not null default '';
alter table items add column if not exists damage_medium   text not null default '';
alter table items add column if not exists critical        text not null default '';
alter table items add column if not exists range_increment text not null default '';
alter table items add column if not exists damage_type     text not null default '';
alter table items add column if not exists proficiency     text not null default '';
alter table items add column if not exists handling        text not null default '';

-- armaduras y escudos
alter table items add column if not exists ac_bonus        text not null default '';
alter table items add column if not exists max_dex         text not null default '';
alter table items add column if not exists armor_check     text not null default '';
alter table items add column if not exists spell_failure   text not null default '';
alter table items add column if not exists speed_30        text not null default '';
alter table items add column if not exists speed_20        text not null default '';

create index if not exists idx_items_group    on items(equipment_group);
create index if not exists idx_items_category on items(category);
"""

COLS = ['code', 'name', 'name_en', 'description', 'price_cp', 'weight_lb',
        'category', 'equipment_group', 'damage_small', 'damage_medium',
        'critical', 'range_increment', 'damage_type', 'proficiency', 'handling',
        'ac_bonus', 'max_dex', 'armor_check', 'spell_failure', 'speed_30',
        'speed_20', 'source']


def q(s):
    return "'" + str(s or '').replace("'", "''") + "'"


def fila(x):
    v = {
        'code': q(x['code']), 'name': q(x['name']), 'name_en': q(x['nameEn']),
        'description': q(x.get('note', '')),
        'price_cp': str(x['priceCp']), 'weight_lb': repr(float(x['weightLb'])),
        'category': q(x['category']), 'equipment_group': q(x['group']),
        'damage_small': q(x.get('damageSmall', '')),
        'damage_medium': q(x.get('damageMedium', '')),
        'critical': q(x.get('critical', '')),
        'range_increment': q(x.get('rangeIncrement', '')),
        'damage_type': q(x.get('damageType', '')),
        'proficiency': q(x.get('proficiency', '')),
        'handling': q(x.get('handling', '')),
        'ac_bonus': q(x.get('acBonus', '')), 'max_dex': q(x.get('maxDex', '')),
        'armor_check': q(x.get('armorCheck', '')),
        'spell_failure': q(x.get('spellFailure', '')),
        'speed_30': q(x.get('speed30', '')), 'speed_20': q(x.get('speed20', '')),
        'source': q('SRD 3.5'),
    }
    return '(' + ', '.join(v[c] for c in COLS) + ')'


def main():
    d = json.load(open('equipo_es.json'))
    nuevos = [x for x in d if not x['existing']]
    viejos = [x for x in d if x['existing']]

    partes = [ESQUEMA, '\n-- ---- catálogo del SRD ------------------------------------------------\n']

    # los objetos nuevos: si por lo que sea el código ya existiera, se
    # actualizan las columnas nuevas y se respeta lo que hubiera escrito
    actualiza = ', '.join(
        '%s = excluded.%s' % (c, c) for c in COLS
        if c not in ('code', 'name', 'description', 'price_cp'))
    for i in range(0, len(nuevos), 40):
        lote = nuevos[i:i + 40]
        partes.append('insert into items (%s) values\n%s\non conflict (code) do update set %s;\n'
                      % (', '.join(COLS), ',\n'.join(fila(x) for x in lote), actualiza))

    # los 7 de Dorakan: SOLO las columnas nuevas; su nombre, su descripción
    # escrita a mano y su precio se quedan como estaban
    partes.append('\n-- ---- los que ya estaban en Dorakan: solo se completan --------------\n'
                  '-- Conservan nombre, descripción y precio; se les añaden las\n'
                  '-- estadísticas del SRD que les faltaban.\n')
    for x in viejos:
        sets = [
            "name_en = %s" % q(x['nameEn']),
            "equipment_group = %s" % q(x['group']),
            "category = %s" % q(x['category']),
            "source = %s" % q('SRD 3.5'),
        ]
        for col, clave in (('damage_small', 'damageSmall'), ('damage_medium', 'damageMedium'),
                           ('critical', 'critical'), ('range_increment', 'rangeIncrement'),
                           ('damage_type', 'damageType'), ('proficiency', 'proficiency'),
                           ('handling', 'handling')):
            if x.get(clave):
                sets.append('%s = %s' % (col, q(x[clave])))
        partes.append('update items set %s where code = %s;\n' % (', '.join(sets), q(x['code'])))

    # ---- ponerlo todo a la venta -------------------------------------
    # Se hace con un INSERT ... SELECT sobre el propio catálogo en vez de 242
    # filas literales: así es corto, se relee bien y es idempotente.
    partes.append("""
-- ---- al mostrador ----------------------------------------------------
-- Todo lo que sea un objeto que se pueda llevar encima entra en la vitrina.
-- Quedan fuera los servicios y el transporte (un barco no se compra en un
-- mostrador) y lo que no tiene precio fijo (el ataque sin armas, la barda,
-- las púas), que se cobran según de qué formen parte.
insert into shop_offers (id, location, item_code, price_cp, stock)
select gen_random_uuid(), 'Dorakan', i.code, i.price_cp, -1
  from items i
 where i.source = 'SRD 3.5'
   and i.category not in ('servicio', 'transporte')
   and i.price_cp > 0
   and not exists (select 1 from shop_offers o where o.item_code = i.code);
""")

    sql = ''.join(partes)
    destino = os.environ.get('DESTINO', 'V22__equipment.sql')
    open(destino, 'w', encoding='utf-8').write(sql)
    print('escrito %s — %d KB, %d objetos nuevos, %d completados'
          % (destino, len(sql.encode()) / 1024, len(nuevos), len(viejos)))


if __name__ == '__main__':
    main()
