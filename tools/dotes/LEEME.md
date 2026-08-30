# Raspador de las dotes

De aquí sale `src/main/resources/db/migration/V23__feats.sql`: las 110 dotes del
SRD 3.5 (OGL) de d20srd.org.

## Cómo se vuelve a ejecutar

```sh
cd tools/dotes
curl -s https://www.d20srd.org/srd/feats.htm -o feats.htm
python3 parse_dotes.py     # -> dotes_raw.json
DESTINO=../../src/main/resources/db/migration/V23__feats.sql python3 gen_sql_dotes.py
```

## Aquí SÍ se tradujo todo

A diferencia de los conjuros y los monstruos, cuya prosa se dejó en inglés
porque son miles de párrafos, **una dote son dos o tres frases**: las 110 están
traducidas enteras a mano en `dotes_es_a.py` y `dotes_es_b.py`, con su
prerrequisito, su beneficio, su «sin ella» y su apartado especial. Una dote en
inglés no sirve de nada en la mesa.

El texto es fiel en los números pero más directo que el original, que repite
mucho. Si hay que corregir algo, se corrige en esos dos ficheros y se regenera.

## Las trampas

1. **Los siete primeros `<h3>` NO son dotes**: son las secciones que explican
   qué es una dote ("Prerequisites", "Types Of Feats"…). Van en `NO_SON_DOTES`.
2. **La tabla de Liderazgo vive entre dos dotes** y, si no se quita, se cuela
   entera en el beneficio de la anterior (Voluntad de hierro salía con toda la
   tabla dentro). Por eso `txt()` borra los `<table>` antes de aplanar.
3. **Liderazgo se queda sin beneficio** porque su regla ES esa tabla; su texto
   está escrito a mano en el diccionario.
4. Los apartados van en `<h5>`: Prerequisite(s), Benefit, Normal, Special.

## Las dos tablas

- `feats` — el compendio, que se consulta en la pestaña Habilidades.
- `character_feats` — las que tiene puestas un personaje. Guarda el NOMBRE y un
  `detail` ("espada larga", "Evocación"), porque muchas dotes se eligen «para
  algo»; y un `feat_id` opcional al compendio, que es lo que permite a la ficha
  enseñar el beneficio sin que el jugador se vaya a buscarlo. Una dote de la
  casa cabe igual: viaja sin beneficio.
