import re, os, time, urllib.request

h = open('idx.htm', encoding='utf-8').read()
links = re.findall(r'<a href="(/srd/monsters/[^"]+)"[^>]*>(.*?)</a>', h, re.S)
pages = sorted({u.split('#')[0] for u, t in links})
os.makedirs('pages', exist_ok=True)
print(len(pages), 'pages')
for i, p in enumerate(pages):
    dest = 'pages/' + p.rsplit('/', 1)[1]
    if os.path.exists(dest) and os.path.getsize(dest) > 2000:
        continue
    try:
        req = urllib.request.Request('https://www.d20srd.org' + p,
                                     headers={'User-Agent': 'Mozilla/5.0 (bestiary import, personal use)'})
        data = urllib.request.urlopen(req, timeout=30).read()
        open(dest, 'wb').write(data)
    except Exception as e:
        print('FAIL', p, e)
    time.sleep(0.4)
    if i % 25 == 0:
        print(i, flush=True)
print('done', len(os.listdir('pages')))
