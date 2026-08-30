"""Saca del SRD las condiciones, las enfermedades y los venenos.

Las condiciones son <h2 id="…">Nombre</h2> seguido de su párrafo, en
conditionSummary.htm. Las enfermedades y los venenos son dos tablas de
specialAbilities.htm, con el <tfoot> antes del <tbody> como todas las del SRD.
"""
import re, json, html

TAG = re.compile(r'<[^>]+>')
SUP = re.compile(r'<sup>.*?</sup>', re.S | re.I)


def txt(s):
    s = SUP.sub('', s)
    s = re.sub(r'</p>', '\n\n', s, flags=re.I)
    s = TAG.sub('', s)
    s = html.unescape(s).replace('\xa0', ' ')
    s = re.sub(r'[ \t]+', ' ', s)
    return re.sub(r'\n\s*\n+', '\n\n', s).strip()


def una(s):
    return re.sub(r'\s+', ' ', txt(s)).strip()


def condiciones(path):
    h = open(path, encoding='utf-8', errors='replace').read()
    fin = h.find('<div class="footer"')
    cuerpo = h[:fin if fin > 0 else len(h)]
    cabeceras = list(re.finditer(r'<h2[^>]*>(.*?)</h2>', cuerpo, re.S | re.I))
    fuera = []
    for i, m in enumerate(cabeceras):
        nombre = una(m.group(1))
        if not nombre or nombre.lower().startswith('condition'):
            continue
        hasta = cabeceras[i + 1].start() if i + 1 < len(cabeceras) else len(cuerpo)
        fuera.append({'nameEn': nombre, 'textEn': txt(cuerpo[m.end():hasta])})
    return fuera


def tabla(h, titulo):
    m = re.search(r'<table[^>]*>(?:(?!</table>).)*?%s.*?</table>' % re.escape(titulo), h, re.S)
    if not m:
        return []
    cuerpo = re.search(r'<tbody[^>]*>(.*?)</tbody>', m.group(0), re.S)
    filas = re.findall(r'<tr[^>]*>(.*?)</tr>', cuerpo.group(1) if cuerpo else m.group(0), re.S)
    return [[una(c) for c in re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', f, re.S)] for f in filas]


def enfermedades(path):
    h = open(path, encoding='utf-8', errors='replace').read()
    fuera = []
    for f in tabla(h, 'Table: Diseases'):
        if len(f) < 5 or not f[0]:
            continue
        fuera.append({'nameEn': f[0], 'infectionEn': f[1], 'dc': f[2],
                      'incubationEn': f[3], 'damageEn': f[4]})
    return fuera


def venenos(path):
    h = open(path, encoding='utf-8', errors='replace').read()
    fuera = []
    for f in tabla(h, 'Table: Poisons'):
        if len(f) < 5 or not f[0]:
            continue
        fuera.append({'nameEn': f[0], 'typeEn': f[1], 'initialEn': f[2],
                      'secondaryEn': f[3], 'priceEn': f[4]})
    return fuera


if __name__ == '__main__':
    c = condiciones('conditionSummary.htm')
    e = enfermedades('specialAbilities.htm')
    v = venenos('specialAbilities.htm')
    json.dump({'condiciones': c, 'enfermedades': e, 'venenos': v},
              open('estados_raw.json', 'w'), ensure_ascii=False, indent=1)
    print('condiciones: %d · enfermedades: %d · venenos: %d' % (len(c), len(e), len(v)))
    print('--- condiciones ---')
    print(' | '.join(x['nameEn'] for x in c))
    print('--- enfermedades ---')
    print(' | '.join(x['nameEn'] for x in e))
    print('--- venenos ---')
    print(' | '.join(x['nameEn'] for x in v))
    print('--- ejemplo ---')
    print(json.dumps(c[2], ensure_ascii=False)[:400])
