"""Los dragones verdaderos no traen bloque de estadísticas: sus valores están en
dos tablas por categoría de edad (una de combate y otra de aptitudes). Aquí se
funden las dos con el bloque resumen para sacar un monstruo por edad."""
import re, json, html

TAM = {'T': 'Tiny', 'S': 'Small', 'M': 'Medium', 'L': 'Large',
       'H': 'Huge', 'G': 'Gargantuan', 'C': 'Colossal'}
COLORES = ['black', 'blue', 'green', 'red', 'white',
           'brass', 'bronze', 'copper', 'gold', 'silver']

def clean(c):
    return re.sub(r'\s+', ' ', html.unescape(re.sub('<[^>]+>', '', c))).strip()

def tabla(h, tid):
    m = re.search(r'<table id="%s".*?</table>' % tid, h, re.S | re.I)
    if not m: return None
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', m.group(0), re.S)
    filas = [[clean(c) for c in re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', r, re.S)] for r in rows]
    filas = [f for f in filas if f]
    cab = [re.sub(r'\d+$', '', c) for c in filas[0]]   # "CasterLevel1" -> "CasterLevel"
    return [dict(zip(cab, f)) for f in filas[1:] if len(f) >= 3]

def por_edad(texto):
    """'Wyrmling 3; very young 4; …' -> {'wyrmling': '3', 'very young': '4'}"""
    out = {}
    for trozo in texto.split(';'):
        t = trozo.strip()
        if not t: continue
        m = re.match(r'^(.*?)\s+([+\-]?[\dÂ½/]+.*)$', t)
        if m: out[m.group(1).strip().lower()] = m.group(2).strip()
        elif t.lower().startswith('others'):
            out['others'] = t.split(None, 1)[1] if ' ' in t else ''
    return out

def extraer(path, resumenes):
    h = open(path, encoding='utf-8', errors='replace').read()
    out = []
    for color in COLORES:
        combate = tabla(h, color + 'DragonsbyAge')
        aptitud = tabla(h, color + 'DragonAbilitiesbyAge')
        if not combate or not aptitud: continue
        nombre_en = color.capitalize() + ' Dragon'
        base = resumenes.get(nombre_en)
        if not base: continue
        apt = {a['Age'].lower(): a for a in aptitud}
        vd  = por_edad(base['stats'].get('Challenge Rating', ''))
        adv = por_edad(base['stats'].get('Advancement', ''))
        aju = por_edad(base['stats'].get('Level Adjustment', ''))
        acumuladas = []
        for fila in combate:
            edad = fila['Age']
            a = apt.get(edad.lower(), {})
            nueva = a.get('Special Abilities', '').strip()
            if nueva and nueva not in ('—', '-'):
                acumuladas += [x.strip() for x in nueva.split(',') if x.strip()]
            aliento = fila.get('BreathWeapon (DC)', '')
            presencia = fila.get('FrightfulPresence DC', '')
            especiales = []
            if aliento and aliento != '—': especiales.append('arma de aliento ' + aliento)
            if presencia and presencia not in ('—', '-'):
                especiales.append('presencia aterradora CD ' + presencia)
            calidades = list(acumuladas)
            sr = a.get('SR', '')
            if sr and sr != '—': calidades.append('RC ' + sr)
            nl = a.get('CasterLevel', '')
            if nl and nl != '—': calidades.append('nivel de lanzador ' + nl)

            hd = fila.get('Hit Dice (hp)', '')
            hd = re.sub(r'\(([\d,]+)\)', r'(\1 hp)', hd)
            stats = {
                'Size/Type': (TAM.get(fila.get('Size', ''), fila.get('Size', '')) + ' ' +
                              base['stats'].get('Type', 'Dragon')).strip(),
                'Hit Dice': hd,
                'Initiative': a.get('Initiative', ''),
                'Speed': a.get('Speed', ''),
                'Armor Class': a.get('AC', ''),
                'Base Attack/Grapple': fila.get('Base Attack/Grapple', ''),
                'Attack': fila.get('Attack', '') + ' (según tamaño; ver tabla de ataques de dragón)',
                'Full Attack': fila.get('Attack', '') + ' (según tamaño; ver tabla de ataques de dragón)',
                'Space/Reach': '',
                'Special Attacks': ', '.join(especiales) or '—',
                'Special Qualities': ', '.join(calidades) or '—',
                'Saves': 'Fort %s, Ref %s, Will %s' % (fila.get('FortSave', ''),
                                                       fila.get('RefSave', ''), fila.get('WillSave', '')),
                'Abilities': 'Str %s, Dex %s, Con %s, Int %s, Wis %s, Cha %s' % tuple(
                    fila.get(k, '') for k in ('Str', 'Dex', 'Con', 'Int', 'Wis', 'Cha')),
                'Environment': base['stats'].get('Environment', ''),
                'Organization': base['stats'].get('Organization', ''),
                'Challenge Rating': vd.get(edad.lower(), ''),
                'Treasure': base['stats'].get('Treasure', ''),
                'Alignment': base['stats'].get('Alignment', ''),
                'Advancement': adv.get(edad.lower(), ''),
                'Level Adjustment': aju.get(edad.lower(), aju.get('others', '—')),
            }
            out.append({'page': 'dragonTrue', 'family': 'Dragon, True',
                        'section': nombre_en, 'name': '%s, %s' % (nombre_en, edad),
                        'stats': {k: v for k, v in stats.items() if v},
                        'desc': base['desc']})
    return out

if __name__ == '__main__':
    ms = json.load(open('monsters_raw.json'))
    resumenes = {m['name']: m for m in ms if m['page'] == 'dragonTrue'}
    print('resúmenes de dragón:', len(resumenes))
    nuevos = extraer('pages/dragonTrue.htm', resumenes)
    print('dragones por edad:', len(nuevos))
    otros = [m for m in ms if m['page'] != 'dragonTrue']
    todo = otros + nuevos
    json.dump(todo, open('monsters_raw.json', 'w'), ensure_ascii=False, indent=1)
    print('total:', len(todo))
    print(json.dumps(nuevos[5]['stats'], ensure_ascii=False, indent=1))
