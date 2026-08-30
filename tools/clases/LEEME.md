# Raspador de las tablas de clase

De aquí sale `src/main/resources/db/migration/V27__class_tables.sql`: las 17
clases del SRD 3.5 (11 de personaje, 5 de PNJ y el caballero negro) con su dado
de golpe, sus puntos de habilidad y los 20 niveles de ataque base y salvaciones.

```sh
cd tools/clases
python3 fetch_clases.py     # descarga las páginas
python3 parse_clases.py     # -> clases_raw.json
DESTINO=../../src/main/resources/db/migration/V27__class_tables.sql python3 gen_sql_clases.py
```

## Para qué sirve

Para el selector de nivel del bestiario. Sin estas tablas no se puede responder
a "¿y este guerrero enano, de nivel 3?", porque el ataque base y las salvaciones
no crecen igual en todas las clases.

## Las trampas

1. **Warrior y Fighter son clases DISTINTAS** aunque las dos se traduzcan
   "guerrero": d8 con 2+Int puntos frente a d10 con dote adicional cada dos
   niveles. Por eso las criaturas se emparejan por su nombre en INGLÉS
   (`monsters.class_name_en`), que es el único sitio donde se distinguen.
2. **Hechicero y mago comparten página** (`sorcererWizard.htm`): dos tablas y
   dos dados de golpe en el mismo fichero, hay que coger el que toca por índice.
3. El caballero negro es una clase de prestigio y solo llega a nivel 10, así
   que el selector se recorta a lo que tenga cada clase.

## Cómo se escala (`service/LevelScaler.java`)

Lo determinista se calcula: dados de golpe, puntos de golpe medios, ataque base,
presa, las tres salvaciones y los bonificadores de las líneas de ataque.

Lo que es una ELECCIÓN se avisa, no se inventa: qué dote coges, dónde metes el
+1 de característica cada cuatro niveles y en qué gastas los puntos de habilidad.

Ojo con los dados: muchas criaturas mezclan dados raciales con los de clase
("8d8+56 más 10d4+70"). Solo se toca el grupo de la clase, que se reconoce
porque su número de dados coincide con el nivel y su dado con el de la clase.
Si dos grupos encajan (un troll explorador tiene 6d8 raciales y 6d8 de clase),
vale el último.

La media de puntos de golpe se calcula con `floor` y coincide con la que imprime
el manual: el ogro bárbaro de nivel 4 da 79 pg, igual que en el SRD.
