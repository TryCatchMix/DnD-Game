import urllib.request, os, time
PC = ['barbarian','bard','cleric','druid','fighter','monk','paladin','ranger','rogue','sorcerer','wizard']
NPC = ['adept','aristocrat','commoner','expert','warrior']
PRESTIGIO = ['blackguard']
def baja(url, dest):
    if os.path.exists(dest) and os.path.getsize(dest) > 2000: return
    req = urllib.request.Request(url, headers={'User-Agent':'Mozilla/5.0 (class tables, personal use)'})
    open(dest,'wb').write(urllib.request.urlopen(req, timeout=30).read())
    time.sleep(0.4)
for c in PC:        baja('https://www.d20srd.org/srd/classes/%s.htm'%c, c+'.htm')
for c in NPC:       baja('https://www.d20srd.org/srd/npcClasses/%s.htm'%c, c+'.htm')
for c in PRESTIGIO: baja('https://www.d20srd.org/srd/prestigeClasses/%s.htm'%c, c+'.htm')
print('descargadas:', len([f for f in os.listdir('.') if f.endswith('.htm')]))
