# Raspador del bestiario

De aquí sale `src/main/resources/db/migration/V21__monsters.sql`: las 581
criaturas del SRD 3.5 (más 7 plantillas) de d20srd.org, contenido abierto OGL.

Se guarda en el repo porque el raspador de los conjuros (V8) se perdió y hubo
que reconstruirlo de cero.

## Cómo se vuelve a ejecutar

```sh
cd tools/bestiario
curl -s https://www.d20srd.org/indexes/monsters.htm -o idx.htm
python3 fetch.py       # descarga las 249 páginas a pages/ (~2 min)
python3 parse.py       # pages/ -> monsters_raw.json
python3 dragons.py     # añade los 120 dragones por categoría de edad
python3 traducir.py    # monsters_raw.json -> monsters_es.json
DESTINO=../../src/main/resources/db/migration/V21__monsters.sql python3 gen_sql.py
```

## Las trampas que costaron tiempo

1. **`<table class="statBlock right">`**: la clase lleva sufijos. Exigir la
   comilla justo tras `statBlock` perdía 103 criaturas (ape, ankheg, bat…).
2. **No todas las tablas traen fila de cabecera.** Si la primera fila ya tiene
   `<td>`, no hay cabecera y el nombre sale del encabezado `<hN>` anterior.
3. **Una página son varias criaturas.** Hay que trabajar por secciones (de un
   encabezado al siguiente), no por página.
4. **Las secciones sin tabla ("Combat", "Ecology") describen a la criatura
   anterior**, no empiezan una nueva.
5. **Los dragones verdaderos no tienen bloque**: sus valores están en
   `<table id="blackDragonsbyAge">` y `<table id="blackDragonAbilitiesbyAge">`,
   con una fila por categoría de edad. Eso es `dragons.py`.
6. **El pie de página va DESPUÉS del `<h1>`**: buscar `<div class="footer"` desde
   el principio del documento devuelve -1 y deja el cuerpo vacío.
7. **Plantillas sin bloque** (fantasma, liche, semidragón…): se guardan con
   `kind='plantilla'`, solo nombre y prosa.

## Qué queda en inglés

La prosa descriptiva, igual que en los conjuros. El bloque de estadísticas está
traducido entero; lo que se escapa son nombres propios de conjuros dentro de las
aptitudes sobrenaturales.
