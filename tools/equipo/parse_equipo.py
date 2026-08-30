"""Saca el catálogo de equipo del SRD 3.5 de las tres páginas de d20srd.org.

Las tablas del SRD llevan el <tfoot> ANTES del <tbody> (estilo HTML4), así que
la primera fila que se encuentra son las notas al pie, no la cabecera. Y dentro
de la tabla hay filas de SECCIÓN de una sola celda ("Light Melee Weapons") que
no son objetos: son las que dicen de qué tipo es lo que viene debajo.
"""
import re, json, html

SUP = re.compile(r'<sup>.*?</sup>', re.S | re.I)


def clean(c):
    c = SUP.sub('', c)                      # los superíndices son notas al pie
    return re.sub(r'\s+', ' ', html.unescape(re.sub('<[^>]+>', '', c))).strip()


def tabla(h, titulo):
    """Devuelve las filas del <tbody> de la tabla cuyo <caption> contiene `titulo`."""
    for m in re.finditer(r'<table[^>]*>.*?</table>', h, re.S):
        t = m.group(0)
        cap = re.search(r'<caption[^>]*>(.*?)</caption>', t, re.S)
        if not cap or titulo.lower() not in clean(cap.group(1)).lower():
            continue
        cuerpo = re.search(r'<tbody[^>]*>(.*?)</tbody>', t, re.S)
        cuerpo = cuerpo.group(1) if cuerpo else t
        filas = re.findall(r'<tr[^>]*>(.*?)</tr>', cuerpo, re.S)
        return [[clean(c) for c in re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', f, re.S)]
                for f in filas]
    return []


# --------------------------------------------------------------------------
# armas
# --------------------------------------------------------------------------

COMPETENCIA = {'Simple Weapons': 'Sencilla', 'Martial Weapons': 'Marcial',
               'Exotic Weapons': 'Exótica'}
MANEJO = {
    'Unarmed Attacks': 'Sin armas',
    'Light Melee Weapons': 'Ligera',
    'One-Handed Melee Weapons': 'Una mano',
    'Two-Handed Melee Weapons': 'Dos manos',
    'Ranged Weapons': 'A distancia',
}


def armas(h):
    filas = tabla(h, 'Table: Weapons')
    out, comp, manejo = [], '', ''
    for f in filas:
        if len(f) == 1:
            etiqueta = f[0]
            if etiqueta in MANEJO:
                manejo = MANEJO[etiqueta]
            continue
        if len(f) >= 2 and f[1] == 'Cost':      # fila de cabecera de bloque
            comp = COMPETENCIA.get(f[0], comp)
            continue
        if len(f) < 8:
            continue
        nombre, coste, dmgS, dmgM, crit, alcance, peso, tipo = f[:8]
        if not nombre or nombre == 'Cost':
            continue
        out.append({'kind': 'arma', 'nameEn': nombre, 'costEn': coste,
                    'dmgS': dmgS, 'dmgM': dmgM, 'crit': crit,
                    'range': alcance, 'weightEn': peso, 'typeEn': tipo,
                    'proficiency': comp, 'handling': manejo})
    return out


# --------------------------------------------------------------------------
# armaduras y escudos
# --------------------------------------------------------------------------

CLASE_ARMADURA = {
    'Light armor': 'Ligera', 'Medium armor': 'Media', 'Heavy armor': 'Pesada',
    'Shields': 'Escudo', 'Extras': 'Complemento',
}


def armaduras(h):
    filas = tabla(h, 'Armor and Shields')
    out, clase = [], ''
    for f in filas:
        if len(f) == 1:
            clase = CLASE_ARMADURA.get(f[0], clase)
            continue
        if len(f) < 8 or f[1] == 'Cost':
            continue
        nombre, coste, ca, maxDex, penal, fallo = f[:6]
        # la velocidad ocupa dos columnas (30 pies y 20 pies) y luego el peso
        vel30, vel20, peso = (f[6], f[7], f[8]) if len(f) >= 9 else (f[6], '', f[7])
        if not nombre:
            continue
        out.append({'kind': 'armadura', 'nameEn': nombre, 'costEn': coste,
                    'acBonus': ca, 'maxDex': maxDex, 'armorCheck': penal,
                    'spellFailure': fallo, 'speed30': vel30, 'speed20': vel20,
                    'weightEn': peso, 'armorKind': clase})
    return out


# --------------------------------------------------------------------------
# bienes y servicios
# --------------------------------------------------------------------------

BIENES = [
    ('Adventuring Gear', 'Equipo de aventurero'),
    ('Special Substances and Items', 'Sustancias y objetos especiales'),
    ('Tools and Skill Kits', 'Herramientas y estuches'),
    ('Clothing', 'Ropa'),
    ('Food, Drink, and Lodging', 'Comida, bebida y alojamiento'),
    ('Mounts and Related Gear', 'Monturas y arreos'),
    ('Transport', 'Transporte'),
    ('Spellcasting and Services', 'Conjuros y servicios'),
]


# El SRD no marca dónde termina un grupo: tras "Ale" vienen Gallon y Mug, y
# luego "Banquet", que ya NO es cerveza. Como son ocho grupos y la tabla es fija,
# se declaran sus miembros a mano en vez de adivinarlos.
MIEMBROS = {
    'Ale': {'Gallon', 'Mug'},
    'Inn stay (per day)': {'Good', 'Common', 'Poor'},
    'Meals (per day)': {'Good', 'Common', 'Poor'},
    'Wine': {'Common (pitcher)', 'Fine (bottle)'},
    'Barding': {'Medium creature', 'Large creature'},
    'Saddle': {'Military', 'Pack', 'Riding'},
    'Saddle, Exotic': {'Military', 'Pack', 'Riding'},
    'Horse': set(),          # esas filas ya traen su nombre completo
}


def bienes(h):
    out = []
    for titulo, categoria in BIENES:
        filas = tabla(h, titulo)
        grupo = ''
        for f in filas:
            # una fila de una sola celda encabeza un grupo ("Ale", "Saddle") y
            # las de debajo son sus variantes ("Gallon", "Military")
            if len(f) == 1:
                grupo = f[0]
                continue
            if len(f) < 2:
                continue
            if f[1] in ('Cost', 'Cost/Day', 'Price'):
                continue
            nombre, coste = f[0], f[1]
            peso = f[2] if len(f) > 2 else ''
            if not nombre or not coste:
                continue
            if nombre in MIEMBROS.get(grupo, ()):
                nombre = '%s, %s' % (grupo, nombre[0].lower() + nombre[1:])
            out.append({'kind': 'servicio' if titulo == 'Spellcasting and Services'
                        else 'objeto',
                        'nameEn': nombre, 'costEn': coste, 'weightEn': peso,
                        'category': categoria})
    return out


if __name__ == '__main__':
    w = open('weapons.htm', encoding='utf-8', errors='replace').read()
    a = open('armor.htm', encoding='utf-8', errors='replace').read()
    g = open('goodsAndServices.htm', encoding='utf-8', errors='replace').read()
    todo = armas(w) + armaduras(a) + bienes(g)
    json.dump(todo, open('equipo_raw.json', 'w'), ensure_ascii=False, indent=1)
    from collections import Counter
    print('total:', len(todo), Counter(x['kind'] for x in todo))
    for x in todo[:4] + todo[-4:]:
        print('  ', x)
