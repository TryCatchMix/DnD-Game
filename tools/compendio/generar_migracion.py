#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera src/main/resources/db/migration/V34__compendio.sql a partir de los
JSON de la carpeta compendio/ (extraídos del Manual del Jugador 3.5 español).

Estrategia (decidida con el usuario):
  - El compendio es la fuente AUTORITATIVA de contenido.
  - Para cada registro: UPDATE si ya existe una fila cuyo nombre coincide
    (normalizado, sin tildes ni mayúsculas), INSERT si no existe.
  - NUNCA se borra una fila que esté en la BD y no en el compendio.
  - En un UPDATE sólo se sobrescriben los campos donde el compendio trae
    valor (no vacío): así nunca se borra un dato bueno con un "".
  - Nunca se sobrescribe la columna `name` de una fila existente (se conserva
    la ortografía correcta de la BD; el match ya es sin tildes).

El emparejamiento lo decide el propio SQL en tiempo de aplicación, con
lower(translate(name,...)), para ser robusto ante cualquier dato real
(conjuros de la casa, cambios de sesiones anteriores, etc.).

Uso:  python3 tools/compendio/generar_migracion.py [--report]
"""
import json, re, sys, os, unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
COMP = os.path.join(RAIZ, 'compendio')
MIGR = os.path.join(RAIZ, 'src/main/resources/db/migration')
SALIDA = os.path.join(MIGR, 'V34__compendio.sql')
SALIDA_H = os.path.join(MIGR, 'V35__compendio_hechizos.sql')

ESCUELAS = ['Abjuración','Conjuración','Evocación','Encantamiento','Adivinación',
            'Ilusión','Nigromancia','Transmutación','Universal']

# Correcciones puntuales de nombres estructuralmente rotos por el OCR
# (no reparables con reglas generales).
NAME_FIX = {
    '1 Imbral': 'Umbral',
    'Abjuración': 'Cascarón antivida',            # desc: campo semiesférico antivida
    'Adivinación': 'Vínculo telepático de Rary',  # desc: vínculo telepático
    'Contingencia =': 'Contingencia',
    'Ligadura de los planos 1 14': 'Ligadura de los planos',
    'Sanctasanctórum privado de 111 Mordenkainen': 'Sanctasanctórum privado de Mordenkainen',
    'Sirviente invisible 1 / 1 / 1 / 1 / 1 / 1': 'Sirviente invisible',
    'Forma qaseosa noo ar umaa maamaa': 'Forma gaseosa',
    'lnvertir qravedad': 'Invertir gravedad',
}

# Palabras concretas mal reconocidas (además de la regla general q->g).
PALABRAS = {
    'lnvertir': 'Invertir',
}

def fix_q(s):
    """En español la 'q' siempre va seguida de 'u'. Una 'q' que no va antes de
    'u' es casi siempre una 'g' mal reconocida por el OCR (maqia->magia)."""
    return re.sub(r'q(?![uU])', lambda m: 'G' if m.group(0)=='Q' else 'g', s)

def fix_words(s):
    for mal, bien in PALABRAS.items():
        s = re.sub(r'\b' + re.escape(mal) + r'\b', bien, s)
    return s

def limpiar_texto(s):
    if not s:
        return ''
    s = s.replace('\r', ' ')
    # rachas de guiones o subrayados (\_\_\_ ...) que el OCR mete como relleno
    s = re.sub(r'(?:\\?[_-]\s*){3,}', ' ', s)
    s = fix_q(s)
    s = fix_words(s)
    # colapsar espacios y saltos
    s = re.sub(r'[ \t]*\n[ \t]*', '\n', s)
    s = re.sub(r'[ \t]{2,}', ' ', s)
    s = re.sub(r'\n{3,}', '\n\n', s)
    return s.strip()

def cap_first(s):
    """Capitaliza la primera letra de un cuerpo descriptivo (el OCR los captura
    en minúscula porque no incluye el término que define)."""
    s = limpiar_texto(s)
    if s and s[0].islower():
        s = s[0].upper() + s[1:]
    return s

def limpiar_nombre(s):
    if s in NAME_FIX:
        return NAME_FIX[s]
    s = limpiar_texto(s)
    # quitar cola tras una escuela pegada: "Gracia felina Transmutación [tierra]"
    for esc in ESCUELAS:
        m = re.search(r'\s+' + re.escape(esc) + r'\b.*$', s)
        if m:
            s = s[:m.start()]
            break
    # colas de basura: "= ...", secuencias de números/barras al final
    s = re.sub(r'\s*=\s*.*$', '', s)
    s = re.sub(r'(?:\s+\d+(?:\s*/\s*\d+)*)+$', '', s)
    s = re.sub(r'[\s\-_=/·]+$', '', s)
    return s.strip()

# ---------------------------------------------------------------------------
# Normalización para el emparejamiento (idéntica en Python y en SQL).
#   SQL:  lower(translate(col, 'áéíóúüñ', 'aeiouun'))
# Aquí replicamos exactamente ese resultado sobre el nombre YA limpio.
# ---------------------------------------------------------------------------
TRANS = str.maketrans('áéíóúüñ', 'aeiouun')
def norm_sql(s):
    return s.lower().translate(TRANS)

SQL_TRANSLATE = "lower(translate(%s, 'áéíóúüñ', 'aeiouun'))"

# ---------------------------------------------------------------------------
# Utilidades de emisión SQL
# ---------------------------------------------------------------------------
def dollar(s):
    """Literal con dollar-quoting seguro."""
    tag = '$c$'
    if tag in s:
        # elige otra etiqueta
        i = 0
        while f'$c{i}$' in s:
            i += 1
        tag = f'$c{i}$'
    return f'{tag}{s}{tag}'

def sqlstr(s):
    return "'" + s.replace("'", "''") + "'"

def where_norm(col, nombre):
    return f"{SQL_TRANSLATE % col} = {sqlstr(norm_sql(nombre))}"

# ---------------------------------------------------------------------------
# Generadores por categoría
# ---------------------------------------------------------------------------
def bloque_generico(tabla, registros, campos, nombre_key='name', extra_where='',
                    extra_insert_cols=None, extra_insert_vals=None,
                    no_update_cols=(), update_only=False):
    """
    campos: lista de (columna_sql, clave_json). Sólo strings.
    extra_where: condición adicional para el match (p.ej. clase de aptitud).
    update_only=True: sólo enriquece filas existentes, nunca inserta (para
        hechizos: la BD ya tiene 514 conjuros en español limpio y no queremos
        duplicados por traducción divergente).
    """
    out = []
    for r in registros:
        nombre = r['_nombre']
        cond = where_norm('name', nombre)
        if extra_where:
            cond += ' and ' + extra_where(r)
        # ---- UPDATE (sólo campos con valor no vacío) ----
        sets = []
        for col, key in campos:
            if col in no_update_cols:
                continue
            val = r.get(key, '')
            if isinstance(val, str):
                val = val.strip()
            if val:
                sets.append(f"{col} = {dollar(val)}")
        if sets:
            out.append(f"update {tabla} set {', '.join(sets)} where {cond};")
        if update_only:
            continue
        # ---- INSERT si no existe ----
        cols = ['name'] + [c for c, _ in campos]
        vals = [dollar(nombre)] + [dollar(str(r.get(k, '') or '')) for _, k in campos]
        if extra_insert_cols:
            cols += extra_insert_cols
            vals += [extra_insert_vals(r)]
        out.append(
            f"insert into {tabla} ({', '.join(cols)})\n"
            f"select {', '.join(vals)}\n"
            f"where not exists (select 1 from {tabla} where {cond});"
        )
    return out


def gen_condiciones():
    data = json.load(open(os.path.join(COMP, 'condiciones.json')))
    for r in data:
        r['_nombre'] = limpiar_nombre(r['name'])
        r['description'] = cap_first(r.get('description', ''))
    campos = [('name_en', 'nameEn'), ('description', 'description'), ('source', 'source')]
    return data, bloque_generico('conditions', data, campos, no_update_cols=())


def gen_dotes():
    data = json.load(open(os.path.join(COMP, 'dotes.json')))
    for r in data:
        r['_nombre'] = limpiar_nombre(r['name'])
        r['prerequisite'] = limpiar_texto(r.get('prerequisite', ''))
        for k in ('benefit', 'normal', 'special'):
            r[k] = cap_first(r.get(k, ''))
    campos = [('name_en', 'nameEn'), ('kind', 'kind'),
              ('prerequisite', 'prerequisite'), ('benefit', 'benefit'),
              ('normal', 'normal'), ('special', 'special'), ('source', 'source')]
    return data, bloque_generico('feats', data, campos)


def gen_aptitudes():
    data = json.load(open(os.path.join(COMP, 'aptitudes.json')))
    for r in data:
        r['_nombre'] = limpiar_nombre(r['name'])
        r['clazz'] = r['clazz'].strip()
        r['description'] = cap_first(r.get('description', ''))
    # match por nombre Y clase (una misma aptitud puede existir para otra clase)
    def extra(r):
        return where_norm('clazz', r['clazz'])
    campos = [('clazz', 'clazz'), ('kind', 'kind'),
              ('description', 'description'), ('source', 'source')]
    # `level` NO viene en el compendio: en INSERT va 0; en UPDATE no se toca.
    return data, bloque_generico(
        'class_features', data, campos, extra_where=extra,
        extra_insert_cols=['level'], extra_insert_vals=lambda r: '0',
        no_update_cols=())


def gen_hechizos():
    data = json.load(open(os.path.join(COMP, 'hechizos.json')))
    limpios = []
    for r in data:
        nombre = limpiar_nombre(r['name'])
        if not nombre or nombre in ESCUELAS:
            r['_saltado'] = r['name']
            continue
        r['_nombre'] = nombre
        for k in ('school', 'subschool', 'descriptors',
                  'components', 'castingTime', 'range', 'target', 'targetKind',
                  'duration', 'savingThrow', 'spellResistance', 'dice',
                  'scaling', 'cap', 'source'):
            r[k] = limpiar_texto(str(r.get(k, '') or ''))
        r['description'] = cap_first(str(r.get('description', '') or ''))
        limpios.append(r)
    campos = [
        ('name_en', 'nameEn'), ('school', 'school'), ('subschool', 'subschool'),
        ('descriptors', 'descriptors'), ('description', 'description'),
        ('components', 'components'), ('casting_time', 'castingTime'),
        ('spell_range', 'range'), ('target', 'target'),
        ('target_kind', 'targetKind'), ('duration', 'duration'),
        ('saving_throw', 'savingThrow'), ('spell_resistance', 'spellResistance'),
        ('dice', 'dice'), ('scaling', 'scaling'), ('cap', 'cap'),
        ('source', 'source'),
    ]
    # SÓLO enriquecer los conjuros que YA existen (match por nombre sin tildes):
    # la BD tiene 514 en español limpio (V13) y no queremos duplicados por
    # traducción divergente. No se insertan nuevos ni se tocan spell_classes.
    out = bloque_generico('spells', limpios, campos, update_only=True)
    return limpios, out, []


# ---------------------------------------------------------------------------
CABECERA = (
    "-- =====================================================================\n"
    "-- Compendio del Manual del Jugador 3.5 (español), volcado a la pestaña\n"
    "-- Habilidades. Generado por tools/compendio/generar_migracion.py.\n"
    "--\n"
    "-- Para cada ficha: UPDATE si ya existe (match por nombre sin tildes) o\n"
    "-- INSERT si no. No se borra nada. En UPDATE sólo se tocan los campos\n"
    "-- con valor en el compendio (no se blanquea un dato bueno con '').\n"
    "-- El compendio es la fuente autoritativa de descripción y uso.\n"
    "-- =====================================================================\n"
)


def main():
    cond_data, cond_sql = gen_condiciones()
    dote_data, dote_sql = gen_dotes()
    apt_data, apt_sql = gen_aptitudes()

    partes = [CABECERA]
    partes.append("\n-- ------------------------- CONDICIONES -------------------------\n")
    partes += cond_sql
    partes.append("\n-- ---------------------------- DOTES ----------------------------\n")
    partes += dote_sql
    partes.append("\n-- -------------------------- APTITUDES --------------------------\n")
    # Algunas aptitudes del compendio (p. ej. Aura del clérigo) superan los
    # 2000 caracteres de la columna original; se amplía a text.
    partes.append("alter table class_features alter column description type text;\n")
    partes += apt_sql
    with open(SALIDA, 'w') as f:
        f.write('\n'.join(partes) + '\n')
    print(f"Escrito {SALIDA} ({os.path.getsize(SALIDA)/1024:.0f} KB)")
    print(f"  condiciones: {len(cond_data)}")
    print(f"  dotes:       {len(dote_data)}")
    print(f"  aptitudes:   {len(apt_data)}")

    # Hechizos aparte (V35): SOLO enriquecer los existentes (UPDATE, sin INSERT).
    sp_data, sp_sql, _ = gen_hechizos()
    ph = [CABECERA.replace(
        "El compendio es la fuente autoritativa de descripción y uso.",
        "HECHIZOS: sólo se ENRIQUECEN los que ya existen (UPDATE por nombre sin\n"
        "-- tildes). No se inserta ninguno: la BD ya tiene 514 en español (V13) y se\n"
        "-- evitan duplicados por traducción divergente.")]
    ph.append("\n-- ------------------- HECHIZOS (solo enriquecer) ----------------\n")
    ph += sp_sql
    with open(SALIDA_H, 'w') as f:
        f.write('\n'.join(ph) + '\n')
    print(f"Escrito {SALIDA_H} ({os.path.getsize(SALIDA_H)/1024:.0f} KB)")
    print(f"  hechizos (updates):    {sum(1 for s in sp_sql if s.startswith('update'))}")

    if '--report' in sys.argv:
        print("\n== HECHIZOS saltados ==")
        raw = json.load(open(os.path.join(COMP, 'hechizos.json')))
        for r in raw:
            n = limpiar_nombre(r['name'])
            if not n or n in ESCUELAS:
                print("  ", repr(r['name']))
        print("\n== nombres de hechizo sospechosos tras limpiar ==")
        for r in sp_data:
            n = r['_nombre']
            if len(n) > 34 or re.search(r"[0-9\\]", n) or re.search(r'q(?![uU])', n):
                print("  ", repr(n))

if __name__ == '__main__':
    main()
