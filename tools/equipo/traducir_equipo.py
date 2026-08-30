"""Pasa el equipo raspado a español y a las unidades que usa la app.

El precio se guarda en piezas de COBRE, que es como lleva el dinero la app
(Money.java: 1 po = 100 pc). Lo que no tiene un precio fijo (la barda, que vale
"×2", o un conjuro, que vale "nivel de lanzador × 60 po") se queda con precio 0
y la fórmula pasa a la descripción.
"""
import json, re, unicodedata
from nombres_equipo import ARMAS, ARMADURAS, OBJETOS, TIPO_DANO, YA_EXISTEN

MONEDA = {'pp': 1000, 'gp': 100, 'sp': 10, 'cp': 1}
PERIODO = {'per day': 'por día', 'per mile': 'por milla', 'per week': 'por semana'}


def precio_cp(txt):
    """'2 gp' -> 200. Devuelve (cobre, nota) — la nota explica lo que no cuadra."""
    t = (txt or '').strip().replace(',', '')
    if not t or t == '—':
        return 0, ''
    m = re.match(r'^\+?([\d.]+)\s*(pp|gp|sp|cp)\b(.*)$', t)
    if m:
        cantidad = float(m.group(1)) * MONEDA[m.group(2)]
        resto = m.group(3).strip()
        nota = ''
        for en, es in PERIODO.items():
            if en in resto:
                nota = es
        if t.startswith('+'):
            nota = ('%s, se suma al precio del objeto' % nota).strip(', ')
        return int(round(cantidad)), nota
    if t.startswith('×'):
        return 0, 'Cuesta %s el precio de la armadura equivalente' % t
    m = re.match(r'^Caster level\s*×\s*([\d]+)\s*gp', t, re.I)
    if m:
        return 0, 'Nivel de lanzador × %s po' % m.group(1)
    if t.lower() == 'special':
        return 0, 'Cuesta lo mismo que el escudo o la armadura de los que forma parte'
    return 0, txt


def peso_lb(txt):
    """'1½ lb.' -> 1.5 ; '1/10 lb.' -> 0.1 ; '—' -> 0."""
    t = (txt or '').strip().replace('+', '')
    if not t or t in ('—', '*'):
        return 0.0
    t = t.replace('½', '.5')
    m = re.match(r'^(\d+)\s*/\s*(\d+)\s*lb', t)
    if m:
        return round(int(m.group(1)) / int(m.group(2)), 3)
    m = re.match(r'^(\d*)\.?(\d*)?\s*lb', t)
    if m:
        try:
            return float(re.match(r'^[\d.]+', t).group(0))
        except (AttributeError, ValueError):
            return 0.0
    return 0.0


def pies(txt):
    """'10 ft.' -> '10 pies'."""
    t = (txt or '').strip()
    if not t or t == '—':
        return ''
    return t.replace('ft.', 'pies').replace('ft', 'pies')


def codigo(nombre, usados):
    base = unicodedata.normalize('NFD', nombre.lower())
    base = ''.join(c for c in base if unicodedata.category(c) != 'Mn')
    base = re.sub(r'[^a-z0-9]+', '_', base).strip('_')[:44]
    c, n = base, 2
    while c in usados:
        c = '%s_%d' % (base[:40], n)
        n += 1
    usados.add(c)
    return c


GRUPO_ARMA = 'Arma %s (%s)'

# La categoría es el filtro de un toque del mostrador, así que tiene que ser
# corta y poca: una palabra por gremio de mercancía.
CATEGORIA = {
    'Equipo de aventurero': 'equipo',
    'Sustancias y objetos especiales': 'sustancia',
    'Herramientas y estuches': 'herramienta',
    'Ropa': 'ropa',
    'Comida, bebida y alojamiento': 'comida',
    'Monturas y arreos': 'montura',
    'Transporte': 'transporte',
    'Conjuros y servicios': 'servicio',
}


def convertir(items):
    usados, vistos, fuera = set(), set(), []
    for it in items:
        en = it['nameEn']
        if it['kind'] == 'arma':
            es = ARMAS.get(en)
        elif it['kind'] == 'armadura':
            es = ARMADURAS.get(en)
        else:
            es = OBJETOS.get(en)
        if es is None:
            print('  SIN TRADUCIR:', it['kind'], '|', en)
            continue
        if es in vistos:          # las flechas y virotes salen varias veces
            continue
        vistos.add(es)

        cp, nota = precio_cp(it['costEn'])
        fila = {
            'name': es, 'nameEn': en, 'kind': it['kind'],
            'priceCp': cp, 'weightLb': peso_lb(it['weightEn']),
            'note': nota,
        }
        if it['kind'] == 'arma':
            fila.update({
                'category': 'arma',
                'group': GRUPO_ARMA % (it['proficiency'].lower(), it['handling'].lower()),
                'damageSmall': it['dmgS'] if it['dmgS'] != '—' else '',
                'damageMedium': it['dmgM'] if it['dmgM'] != '—' else '',
                'critical': it['crit'] if it['crit'] != '—' else '',
                'rangeIncrement': pies(it['range']),
                'damageType': TIPO_DANO.get(it['typeEn'], it['typeEn']),
                'proficiency': it['proficiency'],
                'handling': it['handling'],
            })
        elif it['kind'] == 'armadura':
            clase = it['armorKind']
            fila.update({
                'category': 'armadura',
                'group': 'Escudo' if clase == 'Escudo'
                         else ('Complemento' if clase == 'Complemento' else 'Armadura ' + clase.lower()),
                'acBonus': it['acBonus'] if it['acBonus'] != '—' else '',
                'maxDex': it['maxDex'] if it['maxDex'] != '—' else '',
                'armorCheck': it['armorCheck'] if it['armorCheck'] != '—' else '',
                'spellFailure': it['spellFailure'] if it['spellFailure'] != '—' else '',
                'speed30': pies(it['speed30']),
                'speed20': pies(it['speed20']),
                'armorKind': clase,
            })
        else:
            fila.update({'category': CATEGORIA.get(it['category'], 'equipo'),
                         'group': it['category']})
        # los que ya estaban en el catálogo de Dorakan conservan su código
        fila['code'] = YA_EXISTEN.get(es) or codigo(es, usados)
        fila['existing'] = es in YA_EXISTEN
        fuera.append(fila)
    return fuera


if __name__ == '__main__':
    crudo = json.load(open('equipo_raw.json'))
    fuera = convertir(crudo)
    json.dump(fuera, open('equipo_es.json', 'w'), ensure_ascii=False, indent=1)
    from collections import Counter
    print('convertidos:', len(fuera), Counter(x['category'] for x in fuera))
    print('reutilizan código existente:', [x['code'] for x in fuera if x['existing']])
    print('precio 0 con nota:', sum(1 for x in fuera if x['priceCp'] == 0 and x['note']))
    for x in fuera[:3]:
        print('  ', x)
    for x in fuera:
        if x['category'] == 'armadura':
            print('  ', x); break
