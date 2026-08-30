"""Traduce un nombre de criatura del SRD al español.

Reglas: el núcleo (última palabra en inglés) va delante y los modificadores
detrás, concordando en género. Lo que va tras una coma es un sufijo (tamaño,
edad, clase de PNJ o forma de licántropo) y se traduce aparte.
"""
import re
from nombres import NUCLEOS, MODS, ENTEROS, SUFIJOS, EXCEPCIONES

CLASES = {'Warrior': 'guerrero', 'Wizard': 'mago', 'Cleric': 'clérigo',
          'Fighter': 'guerrera', 'Barbarian': 'bárbaro', 'Ranger': 'explorador',
          'Paladin': 'paladín', 'Blackguard': 'caballero negro', 'Commoner': 'plebeyo',
          'Rogue': 'pícaro', 'Sorcerer': 'hechicero', 'Bard': 'bardo', 'Druid': 'druida',
          'Monk': 'monje', 'Adept': 'adepto', 'Aristocrat': 'aristócrata',
          'Expert': 'experto'}


def _mod(palabra, gen):
    if palabra in MODS:
        return MODS[palabra][0 if gen == 'm' else 1]
    if palabra in ENTEROS:
        return 'de ' + ENTEROS[palabra].lower()
    if palabra in NUCLEOS:
        return 'de ' + NUCLEOS[palabra][0].lower()
    return None


def _grupo(texto):
    """Traduce un grupo sin comas. Devuelve (texto, género) o (None, None)."""
    texto = texto.strip()
    if not texto:
        return None, None
    if texto in ENTEROS:
        return ENTEROS[texto], 'f' if ENTEROS[texto].endswith('a') else 'm'

    # "… Form" -> "forma …"
    m = re.match(r'^(.*)\s+Form$', texto)
    if m:
        interior = _mod(m.group(1), 'f')
        if interior is None:
            interior, _ = _grupo(m.group(1))
            if interior is not None:
                interior = 'de ' + interior.lower()
        if interior is None:
            return None, None
        return 'forma ' + interior.lower(), 'f'

    # "Cloud Giant Skeleton" -> "Esqueleto de gigante de las nubes": lo que
    # precede es la criatura de la que salió, no un adjetivo
    m = re.match(r'^(.+)\s+(Skeleton|Zombie)$', texto)
    if m:
        interior, _ = _grupo(m.group(1))
        if interior is not None:
            base = NUCLEOS[m.group(2)][0]
            return '%s de %s' % (base, interior.lower()), 'm'

    # "Rat Swarm" -> "Enjambre de ratas" (el enjambre pide plural)
    PLURAL = {'Rat': 'ratas', 'Bat': 'murciélagos', 'Spider': 'arañas',
              'Centipede': 'ciempiés', 'Locust': 'langostas',
              'Hellwasp': 'avispas infernales'}
    m = re.match(r'^(\w+)\s+Swarm$', texto)
    if m and m.group(1) in PLURAL:
        return 'Enjambre de ' + PLURAL[m.group(1)], 'm'

    # "Eight-Headed Hydra" -> "Hidra de ocho cabezas"
    m = re.match(r'^(\w+)-Headed\s+Hydra$', texto)
    if m:
        num = {'Five': 'cinco', 'Six': 'seis', 'Seven': 'siete', 'Eight': 'ocho',
               'Nine': 'nueve', 'Ten': 'diez', 'Eleven': 'once', 'Twelve': 'doce'}
        if m.group(1) in num:
            return 'Hidra de %s cabezas' % num[m.group(1)], 'f'

    # "10th-Level Wizard" -> "mago de nivel 10"
    m = re.match(r'^(\d+)(?:st|nd|rd|th)-Level\s+(\w+)$', texto)
    if m and m.group(2) in CLASES:
        return '%s de nivel %s' % (CLASES[m.group(2)], m.group(1)), 'm'

    palabras = texto.split()
    nucleo = palabras[-1]
    if nucleo in NUCLEOS:
        base, gen = NUCLEOS[nucleo]
    elif nucleo in ENTEROS:
        base = ENTEROS[nucleo]
        gen = 'f' if base.endswith('a') else 'm'
    else:
        return None, None

    cola = []
    for p in palabras[:-1]:
        t = _mod(p, gen)
        if t is None:
            return None, None
        cola.append(t)
    # en inglés el modificador más pegado al núcleo va el último; en español,
    # el primero: "Elder Black Pudding" -> "Pudin negro anciano"
    cola.reverse()
    return ' '.join([base] + cola), gen


def traducir(nombre_en):
    """Devuelve el nombre en español, o None si no se sabe traducir."""
    if nombre_en in EXCEPCIONES:
        return EXCEPCIONES[nombre_en]
    # paréntesis explicativos: "Barbed Devil (Hamatula)"
    paren = ''
    m = re.match(r'^(.*?)\s*\((.*)\)$', nombre_en)
    if m:
        nombre_en, paren = m.group(1), m.group(2)

    # "Snake, Medium Viper" -> "Víbora mediana" (la coma del SRD es de índice)
    m = re.match(r'^Snake,\s*(\w+)\s+Viper$', nombre_en)
    if m and m.group(1) in SUFIJOS:
        return 'Víbora ' + SUFIJOS[m.group(1)][1]

    partes = [p.strip() for p in nombre_en.split(',')]
    cabeza, gen = _grupo(partes[0])
    if cabeza is None:
        return None

    fuera = [cabeza]
    for p in partes[1:]:
        if p in SUFIJOS:
            fuera.append(SUFIJOS[p][0 if gen == 'm' else 1])
            continue
        t, _ = _grupo(p)
        if t is None:
            t = _mod(p, gen)
        if t is None:
            return None
        fuera.append(t.lower() if not t[0].isupper() or t.split()[0] in
                     ('forma',) else t.lower())
    salida = fuera[0] + (', ' + ', '.join(fuera[1:]) if len(fuera) > 1 else '')
    if paren:
        salida += ' (%s)' % paren
    return salida


if __name__ == '__main__':
    import json
    ms = json.load(open('monsters_raw.json'))
    nombres = sorted({m['name'] for m in ms})
    fallos = []
    for n in nombres:
        t = traducir(n)
        if t is None:
            fallos.append(n)
    print('traducidos: %d/%d' % (len(nombres) - len(fallos), len(nombres)))
    print('--- sin traducir ---')
    for f in fallos:
        print('  ', f)
