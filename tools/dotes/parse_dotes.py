"""Saca las dotes del SRD 3.5 de d20srd.org/srd/feats.htm.

La página es de las limpias: cada dote es un <h3>Nombre [Tipo]</h3> y debajo
van sus apartados como <h5>Prerequisites</h5><p>…</p>. Lo único que hay que
vigilar es que los siete primeros <h3> NO son dotes, sino las secciones que
explican qué es una dote.
"""
import re, json, html

TAG = re.compile(r'<[^>]+>')
H3 = re.compile(r'<h3[^>]*>(.*?)</h3>', re.S | re.I)
H5 = re.compile(r'<h5[^>]*>(.*?)</h5>', re.S | re.I)

# los <h3> del principio explican las reglas; no son dotes
NO_SON_DOTES = {
    'Prerequisites', 'Types Of Feats', 'General Feats', 'Fighter Bonus Feats',
    'Item Creation Feats', 'Metamagic Feats', 'Feat Descriptions',
    'Feat Name [Type Of Feat]', 'Special',
}

APARTADOS = {
    'Prerequisite': 'prerequisite', 'Prerequisites': 'prerequisite',
    'Benefit': 'benefit', 'Normal': 'normal', 'Special': 'special',
}


# La tabla de Liderazgo vive entre dos dotes y, si no se quita, se cuela
# entera en el beneficio de la dote anterior (Voluntad de hierro).
TABLA = re.compile(r'<table.*?</table>', re.S | re.I)


def txt(s):
    s = TABLA.sub(' ', s)
    s = re.sub(r'</p>', '\n\n', s, flags=re.I)
    s = re.sub(r'<li[^>]*>', '\n· ', s, flags=re.I)
    s = TAG.sub('', s)
    s = html.unescape(s).replace('\xa0', ' ')
    s = re.sub(r'[ \t]+', ' ', s)
    s = re.sub(r'\n\s*\n+', '\n\n', s)
    return s.strip()


def una_linea(s):
    return re.sub(r'\s+', ' ', txt(s)).strip()


def parse(path):
    h = open(path, encoding='utf-8', errors='replace').read()
    fin = h.find('<div class="footer"')
    cuerpo = h[:fin if fin > 0 else len(h)]

    cabeceras = list(H3.finditer(cuerpo))
    fuera = []
    for i, m in enumerate(cabeceras):
        titulo = una_linea(m.group(1))
        if titulo in NO_SON_DOTES:
            continue
        # "Cleave [General]" -> nombre + tipo
        mt = re.match(r'^(.*?)\s*\[(.*?)\]\s*$', titulo)
        if not mt:
            continue
        nombre, tipo = mt.group(1).strip(), mt.group(2).strip()

        hasta = cabeceras[i + 1].start() if i + 1 < len(cabeceras) else len(cuerpo)
        seccion = cuerpo[m.end():hasta]

        # los <h5> parten la sección en apartados
        campos = {}
        marcas = list(H5.finditer(seccion))
        if not marcas:
            campos['benefit'] = txt(seccion)
        for j, h5 in enumerate(marcas):
            etiqueta = una_linea(h5.group(1)).rstrip(':')
            clave = APARTADOS.get(etiqueta)
            if clave is None:
                continue
            tope = marcas[j + 1].start() if j + 1 < len(marcas) else len(seccion)
            campos[clave] = txt(seccion[h5.end():tope])

        fuera.append({
            'nameEn': nombre,
            'typeEn': tipo,
            'prerequisiteEn': campos.get('prerequisite', ''),
            'benefitEn': campos.get('benefit', ''),
            'normalEn': campos.get('normal', ''),
            'specialEn': campos.get('special', ''),
        })
    return fuera


if __name__ == '__main__':
    dotes = parse('feats.htm')
    json.dump(dotes, open('dotes_raw.json', 'w'), ensure_ascii=False, indent=1)
    from collections import Counter
    print('dotes:', len(dotes))
    print('tipos:', Counter(d['typeEn'] for d in dotes))
    print('sin beneficio:', [d['nameEn'] for d in dotes if not d['benefitEn']])
    print('con prerrequisito:', sum(1 for d in dotes if d['prerequisiteEn']))
    for d in dotes[:2]:
        print(json.dumps(d, ensure_ascii=False, indent=1)[:600])
