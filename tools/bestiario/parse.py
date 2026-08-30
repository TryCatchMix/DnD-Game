import re, os, json, html
from collections import Counter

TAG   = re.compile(r'<[^>]+>')
HEAD  = re.compile(r'<h([1-6])[^>]*>(.*?)</h\1>', re.S | re.I)
TABLE = re.compile(r'<table[^>]*class="statBlock[^"]*".*?</table>', re.S | re.I)

def txt(s):
    s = re.sub(r'<br\s*/?>', ' / ', s, flags=re.I)
    s = re.sub(r'</(p|li|div|tr|h[1-6])>', '\n', s, flags=re.I)
    s = TAG.sub('', s)
    s = html.unescape(s).replace('\xa0', ' ')
    s = re.sub(r'[ \t]+', ' ', s)
    s = re.sub(r'\n\s*\n+', '\n\n', s)
    return s.strip()

def one(s):
    return re.sub(r'\s+', ' ', txt(s)).strip()

def cells(row, tag):
    return re.findall(r'<%s[^>]*>(.*?)</%s>' % (tag, tag), row, re.S | re.I)

def read_table(table, base):
    """Devuelve [(nombre, {etiqueta: valor})] — una entrada por columna."""
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table, re.S | re.I)
    if not rows: return []
    head_row = rows[0] if not cells(rows[0], 'td') else None
    if head_row is not None:
        names = [one(c) for c in cells(head_row, 'th')]
        if names and names[0] == '': names = names[1:]
        rows = rows[1:]
    else:
        names = [base]
    if not names: return []
    stats = [dict() for _ in names]
    for row in rows:
        th, td = cells(row, 'th'), cells(row, 'td')
        if not th or not td: continue
        label = re.sub(r'\s*:\s*$', '', one(th[0]))
        for i in range(min(len(names), len(td))):
            v = one(td[i])
            if v: stats[i][label] = v
    return [(n, s) for n, s in zip(names, stats) if n and s]

def parse_page(path):
    h = open(path, encoding='utf-8', errors='replace').read()
    m = re.search(r'<h1[^>]*>', h, re.I)
    if not m: return []
    end = h.find('<div class="footer"', m.start())
    body = h[m.start(): end if end > 0 else len(h)]

    heads = [(hm.start(), hm.end(), int(hm.group(1)), one(hm.group(2))) for hm in HEAD.finditer(body)]
    if not heads: return []
    page_title = heads[0][3]

    # una sección por encabezado: del final del encabezado al siguiente encabezado
    secs = []
    for i, (s, e, lvl, title) in enumerate(heads):
        stop = heads[i + 1][0] if i + 1 < len(heads) else len(body)
        secs.append({'lvl': lvl, 'title': title, 'html': body[e:stop]})

    intro = ''
    for s in secs:
        if s['lvl'] == 1:
            intro = txt(TABLE.sub('', s['html']))
            break

    out, ultimos = [], []
    for s in secs:
        tables = TABLE.findall(s['html'])
        prosa = txt(TABLE.sub('\n', s['html']))
        if not tables:
            # una sección sin tabla ("Combat", "Ecology"…) describe a los
            # últimos monstruos emitidos, no empieza uno nuevo
            if ultimos and len(prosa) > 20:
                trozo = (s['title'] + '\n' + prosa).strip()
                for m in ultimos:
                    m['desc'] = (m['desc'] + '\n\n' + trozo).strip()
            continue
        if len(prosa) < 40: prosa = intro
        ultimos = []
        for t in tables:
            for name, stats in read_table(t, s['title']):
                m = {'page': os.path.basename(path).replace('.htm', ''),
                     'family': page_title, 'section': s['title'],
                     'name': name, 'stats': stats, 'desc': prosa}
                out.append(m); ultimos.append(m)
    return out

if __name__ == '__main__':
    allm = []
    for f in sorted(os.listdir('pages')):
        allm += parse_page('pages/' + f)
    json.dump(allm, open('monsters_raw.json', 'w'), ensure_ascii=False, indent=1)
    print('monstruos:', len(allm), 'de', len(os.listdir('pages')), 'páginas')
    labels = Counter(k for m in allm for k in m['stats'])
    for k, c in labels.most_common(26): print(' ', c, '|', k)
    corta = [m for m in allm if len(m['desc']) < 40]
    print('sin descripción:', len(corta), [m['name'] for m in corta][:12])
