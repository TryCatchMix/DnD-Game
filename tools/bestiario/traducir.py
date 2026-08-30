"""Traduce el bloque de estadísticas de cada monstruo al español.

Cada campo se traduce con el diccionario que le toca (las habilidades con el de
habilidades, las dotes con el de dotes, el resto con el general), porque aplicar
el general a todo destrozaría los nombres propios de habilidades y dotes.
"""
import json, re, sys
import tr_nombres
from vocabulario import (TAMANOS, TIPOS, SUBTIPOS, HABILIDADES, DOTES,
                         TERMINOS, TERRENOS, CLIMAS)


def _rx(d):
    """Un regex con todas las claves, de la más larga a la más corta, para que
    'low-light vision' gane a 'vision'. Sin distinguir mayúsculas: el SRD escribe
    'Darkvision' al empezar el campo y 'darkvision' en medio."""
    claves = sorted(d, key=len, reverse=True)
    return re.compile(r'(?<![\w-])(' + '|'.join(re.escape(k) for k in claves) + r')(?![\w-])',
                      re.IGNORECASE)


RX_TERM = _rx(TERMINOS)
RX_HAB = _rx(HABILIDADES)
RX_DOTE = _rx(DOTES)
RX_TAM = _rx(TAMANOS)
RX_TIPO = _rx(TIPOS)
RX_SUB = _rx(SUBTIPOS)

MANIOBRA = {'perfect': 'perfecta', 'good': 'buena', 'average': 'media',
            'poor': 'mala', 'clumsy': 'torpe'}


def _busca(d, clave):
    if clave in d:
        return d[clave]
    baja = clave.lower()
    for k, v in d.items():
        if k.lower() == baja:
            return v
    return clave


def _sub(rx, d, texto):
    """Sustituye respetando la mayúscula inicial del original."""
    def rep(m):
        orig = m.group(1)
        nuevo = _busca(d, orig)
        if orig[:1].isupper() and nuevo[:1].islower():
            nuevo = nuevo[0].upper() + nuevo[1:]
        return nuevo
    return rx.sub(rep, texto)


def entorno(v):
    """'Warm deserts' -> 'Desiertos cálidos'; 'A lawful evil-aligned plane' ->
       'Un plano de alineamiento legal maligno'."""
    m = re.match(r'^\s*(Temperate|Warm|Cold)\s+(\w+)\s*$', v, re.I)
    if m:
        clima = m.group(1).capitalize()
        terreno = m.group(2).lower()
        if terreno in TERRENOS:
            nombre, gen, plural = TERRENOS[terreno]
            adj = CLIMAS[clima][0 if gen == 'm' else 1]
            if plural:
                adj += 's'
            return '%s %s' % (nombre[0].upper() + nombre[1:], adj)
    m = re.match(r'^\s*An?\s+(.+?)-aligned plane\s*$', v, re.I)
    if m:
        return 'Un plano de alineamiento ' + _sub(RX_TERM, TERMINOS, m.group(1)).lower()
    return _sub(RX_TERM, TERMINOS, v)


def tam_tipo(v):
    """'Huge Aberration (Aquatic)' -> 'Aberración enorme (acuático)'."""
    m = re.match(r'^\s*(\w[\w-]*)\s+(.*?)\s*(\((.*)\))?\s*$', v)
    if not m:
        return _sub(RX_TIPO, TIPOS, v)
    tam, resto, _, subs = m.group(1), m.group(2), m.group(3), m.group(4)
    tam_es = TAMANOS.get(tam)
    if tam_es is None:                      # no empieza por un tamaño
        return _sub(RX_SUB, SUBTIPOS, _sub(RX_TIPO, TIPOS, v))
    tipo_es = _sub(RX_TIPO, TIPOS, resto)
    # concordancia: "Bestia mágica" es femenino
    if tipo_es[:1].isupper() and tipo_es.split()[0].endswith('a'):
        tam_es = tam_es[:-1] + 'a' if tam_es.endswith('o') else tam_es
    fuera = '%s %s' % (tipo_es, tam_es)
    if subs:
        fuera += ' (%s)' % _sub(RX_SUB, SUBTIPOS, subs).lower()
    return fuera


def velocidad(v):
    """'30 ft. (6 squares), fly 100 ft. (average)' ->
       '30 pies (6 casillas), volar 100 pies (media)'."""
    v = re.sub(r'\((%s)\)' % '|'.join(MANIOBRA), lambda m: '(%s)' % MANIOBRA[m.group(1)], v)
    return _sub(RX_TERM, TERMINOS, v)


def lista_hab(v):
    v = _sub(RX_HAB, HABILIDADES, v)
    # lo que va entre paréntesis es una aclaración, no el nombre de la habilidad
    return re.sub(r'\(([^)]*)\)', lambda m: '(%s)' % _sub(RX_TERM, TERMINOS, m.group(1)), v)


def lista_dotes(v):
    # "AlertnessB" = dote adicional; se marca con el superíndice del SRD
    v = re.sub(r'(?<=[a-z])B\b', 'ᴮ', v)
    v = re.sub(r'\s+ᴮ', 'ᴮ', v)
    return _sub(RX_DOTE, DOTES, v)


def _niveles(v):
    """'1 leader of 3rd-6th level' -> '1 líder de nivel 3-6';
       '2 3rd-level sergeants' -> '2 sargentos de nivel 3'."""
    ord_ = r'(\d+)(?:st|nd|rd|th)'
    v = re.sub(r'of %s-%s level' % (ord_, ord_), r'de nivel \1-\2', v, flags=re.I)
    v = re.sub(r'of %s or %s level' % (ord_, ord_), r'de nivel \1 o \2', v, flags=re.I)
    v = re.sub(r'of %s level' % ord_, r'de nivel \1', v, flags=re.I)
    v = re.sub(r'%s-%s-level' % (ord_, ord_), r'de nivel \1-\2', v, flags=re.I)
    v = re.sub(r'%s-level\s+(\w+)' % ord_, r'\2 de nivel \1', v, flags=re.I)
    # ordinales sueltos: "nivel de lanzador 15th" -> "… 15"
    v = re.sub(r'\b(\d+)(?:st|nd|rd|th)\b', r'\1', v)
    return v


def generico(v):
    return _sub(RX_TERM, TERMINOS, _niveles(v))


def avance(v):
    """'9-16 HD (Huge); 17-24 HD (Gargantuan)' -> '9-16 DG (enorme); …'"""
    v = re.sub(r'\(([^)]*)\)', lambda m: '(%s)' % _sub(RX_TAM, TAMANOS, m.group(1)).lower(), v)
    return _sub(RX_TERM, TERMINOS, v)


# qué función traduce cada campo del bloque
CAMPOS = {
    'Size/Type': ('sizeType', tam_tipo),
    'Type': ('sizeType', tam_tipo),
    'Hit Dice': ('hitDice', generico),
    'Initiative': ('initiative', generico),
    'Speed': ('speed', velocidad),
    'Armor Class': ('armorClass', generico),
    'Base Attack/Grapple': ('baseAttack', generico),
    'Attack': ('attack', generico),
    'Full Attack': ('fullAttack', generico),
    'Space/Reach': ('spaceReach', generico),
    'Special Attacks': ('specialAttacks', generico),
    'Special Qualities': ('specialQualities', generico),
    'Saves': ('saves', generico),
    'Abilities': ('abilities', generico),
    'Skills': ('skills', lista_hab),
    'Feats': ('feats', lista_dotes),
    'Environment': ('environment', entorno),
    'Organization': ('organization', generico),
    'Challenge Rating': ('challengeRating', generico),
    'Treasure': ('treasure', generico),
    'Alignment': ('alignment', generico),
    'Advancement': ('advancement', avance),
    'Level Adjustment': ('levelAdjustment', generico),
}


def tipo_base(size_type_es):
    """El tipo de criatura suelto, para poder filtrar por él."""
    if not size_type_es:
        return ''
    cabeza = re.split(r'\s*\(', size_type_es)[0]
    for tipo in sorted(TIPOS.values(), key=len, reverse=True):
        if cabeza.startswith(tipo):
            return tipo
    return cabeza.split()[0] if cabeza else ''


def vd_num(v):
    """El VD como número, para ordenar y filtrar. '½' -> 0.5, '—' -> None."""
    if not v:
        return None
    v = v.strip().replace('½', '1/2').replace('⅓', '1/3').replace('¼', '1/4')
    m = re.match(r'^(\d+)\s*/\s*(\d+)', v)      # "1/4"
    if m:
        return round(int(m.group(1)) / int(m.group(2)), 3)
    m = re.match(r'^(\d+(?:\.\d+)?)', v)
    return float(m.group(1)) if m else None


def convertir(m):
    stats = m['stats']
    out = {'nameEn': m['name'], 'name': tr_nombres.traducir(m['name']) or m['name'],
           'family': m['family'], 'page': m['page'], 'descriptionEn': m['desc']}
    for etiqueta, (campo, fn) in CAMPOS.items():
        v = stats.get(etiqueta, '')
        traducido = fn(v) if v else ''
        # 'Size/Type' y 'Type' escriben el mismo campo: el vacío no pisa al lleno
        if traducido or campo not in out:
            out[campo] = traducido
    out['creatureType'] = tipo_base(out['sizeType'])
    out['cr'] = vd_num(stats.get('Challenge Rating', ''))
    return out


if __name__ == '__main__':
    ms = json.load(open('monsters_raw.json'))
    fuera = [convertir(m) for m in ms]
    json.dump(fuera, open('monsters_es.json', 'w'), ensure_ascii=False, indent=1)
    print('convertidos:', len(fuera))
    # ¿cuánto inglés queda suelto en los campos cortos?
    ingles = re.compile(r'(?<![\w-])(the|of|and|with|from|their|its|creature|'
                        r'against|damage|attack|save|round|rounds|level|feet|foot)(?![\w-])', re.I)
    quedan = {}
    for f in fuera:
        for campo in ('sizeType', 'specialQualities', 'specialAttacks', 'environment',
                      'organization', 'treasure', 'alignment', 'advancement', 'speed'):
            for w in ingles.findall(f[campo]):
                quedan[w.lower()] = quedan.get(w.lower(), 0) + 1
    print('restos en inglés:', sorted(quedan.items(), key=lambda x: -x[1])[:12])
    for f in fuera[:3] + fuera[300:302]:
        print('\n---', f['nameEn'], '->', f['name'])
        for k in ('sizeType', 'speed', 'armorClass', 'attack', 'specialQualities',
                  'saves', 'abilities', 'skills', 'feats', 'environment',
                  'organization', 'treasure', 'alignment', 'advancement'):
            if f[k]:
                print('   %-16s %s' % (k, f[k][:150]))
