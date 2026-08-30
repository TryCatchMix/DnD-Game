"""Saca las tablas de progresión de clase del SRD 3.5.

Cada clase trae su dado de golpe, sus puntos de habilidad por nivel y una tabla
de 20 filas con el ataque base y las tres salvaciones. Eso es todo lo que hace
falta para escalar una criatura con niveles de clase.

CUIDADO con dos cosas: hechicero y mago comparten página (dos tablas en el
mismo fichero), y "Warrior" (clase de PNJ) y "Fighter" (clase de personaje) son
CLASES DISTINTAS aunque las dos se traduzcan "guerrero".
"""
import re, json, html, os

ES = {
    'Warrior': 'Guerrero (PNJ)', 'Expert': 'Experto', 'Adept': 'Adepto',
    'Aristocrat': 'Aristócrata', 'Commoner': 'Plebeyo',
    'Barbarian': 'Bárbaro', 'Bard': 'Bardo', 'Cleric': 'Clérigo',
    'Druid': 'Druida', 'Fighter': 'Guerrero', 'Monk': 'Monje',
    'Paladin': 'Paladín', 'Ranger': 'Explorador', 'Rogue': 'Pícaro',
    'Sorcerer': 'Hechicero', 'Wizard': 'Mago', 'Blackguard': 'Caballero negro',
}
NPC = {'Warrior', 'Expert', 'Adept', 'Aristocrat', 'Commoner'}

def clean(c):
    return re.sub(r'\s+', ' ', html.unescape(re.sub('<[^>]+>', '', c))).strip()

def entero(v):
    m = re.search(r'([+\-]?\d+)', (v or '').replace('−', '-'))
    return int(m.group(1)) if m else 0

def nivel(v):
    m = re.match(r'\s*(\d+)', v or '')
    return int(m.group(1)) if m else 0

def tabla(h, titulo):
    """La tabla cuyo <caption> es exactamente 'Table: The X'."""
    for m in re.finditer(r'<table[^>]*>.*?</table>', h, re.S):
        cap = re.search(r'<caption[^>]*>(.*?)</caption>', m.group(0), re.S)
        if cap and clean(cap.group(1)).startswith(titulo):
            cuerpo = re.search(r'<tbody[^>]*>(.*?)</tbody>', m.group(0), re.S)
            filas = re.findall(r'<tr[^>]*>(.*?)</tr>', cuerpo.group(1) if cuerpo else m.group(0), re.S)
            return [[clean(c) for c in re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', f, re.S)] for f in filas]
    return []

def clase(fichero, nombre_en, dado_idx=0):
    h = open(fichero, encoding='utf-8', errors='replace').read()
    dados = re.findall(r'Hit\s*Die:?.{0,60}?d(\d+)', h, re.I | re.S)
    ph = re.findall(r'Skill Points at (?:Each )?(?:Additional )?(?:1st )?Level:?.{0,60}?(\d+)\s*\+', h, re.I | re.S)
    filas = tabla(h, 'Table: The ' + nombre_en)

    niveles = []
    for f in filas:
        if len(f) < 5: continue
        n = nivel(f[0])
        if not 1 <= n <= 20: continue
        niveles.append({'level': n, 'bab': entero(f[1]),
                        'fort': entero(f[2]), 'ref': entero(f[3]), 'will': entero(f[4]),
                        'special': f[5] if len(f) > 5 else ''})
    return {
        'nameEn': nombre_en, 'name': ES[nombre_en],
        'hitDie': int(dados[min(dado_idx, len(dados) - 1)]) if dados else 8,
        'skillPoints': int(ph[0]) if ph else 2,
        'npc': nombre_en in NPC,
        'levels': niveles,
    }

FICHEROS = [
    ('warrior.htm', 'Warrior', 0), ('expert.htm', 'Expert', 0),
    ('adept.htm', 'Adept', 0), ('aristocrat.htm', 'Aristocrat', 0),
    ('commoner.htm', 'Commoner', 0),
    ('barbarian.htm', 'Barbarian', 0), ('bard.htm', 'Bard', 0),
    ('cleric.htm', 'Cleric', 0), ('druid.htm', 'Druid', 0),
    ('fighter.htm', 'Fighter', 0), ('monk.htm', 'Monk', 0),
    ('paladin.htm', 'Paladin', 0), ('ranger.htm', 'Ranger', 0),
    ('rogue.htm', 'Rogue', 0),
    ('sorcererWizard.htm', 'Sorcerer', 0), ('sorcererWizard.htm', 'Wizard', 1),
    ('blackguard.htm', 'Blackguard', 0),
]

if __name__ == '__main__':
    clases = [clase(f, n, i) for f, n, i in FICHEROS]
    json.dump(clases, open('clases_raw.json', 'w'), ensure_ascii=False, indent=1)
    print('clases:', len(clases))
    for c in clases:
        print('  %-16s %-18s d%-3d %d+Int  niveles=%-3d  n20: BAB %+d, Fort %+d Ref %+d Vol %+d'
              % (c['nameEn'], c['name'], c['hitDie'], c['skillPoints'], len(c['levels']),
                 c['levels'][-1]['bab'], c['levels'][-1]['fort'],
                 c['levels'][-1]['ref'], c['levels'][-1]['will']) if c['levels'] else '  SIN TABLA: ' + c['nameEn'])
