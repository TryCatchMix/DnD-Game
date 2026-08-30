# Raspador del equipo

De aquí sale `src/main/resources/db/migration/V22__equipment.sql`: 78 armas,
21 armaduras y escudos, 154 objetos y 16 servicios del SRD 3.5 (OGL) de
d20srd.org, con nombres y valores en español.

## Cómo se vuelve a ejecutar

```sh
cd tools/equipo
for p in weapons armor goodsAndServices; do
  curl -s "https://www.d20srd.org/srd/equipment/$p.htm" -o "$p.htm"
done
python3 parse_equipo.py      # -> equipo_raw.json
python3 traducir_equipo.py   # -> equipo_es.json
DESTINO=../../src/main/resources/db/migration/V22__equipment.sql python3 gen_sql_equipo.py
```

## Las trampas

1. **El `<tfoot>` va ANTES del `<tbody>`** (estilo HTML4), así que la primera
   fila de la tabla son las notas al pie, no la cabecera. Hay que leer el
   `<tbody>` explícitamente.
2. **Los `<sup>` se pegan al valor**: `1d2` con su nota al pie sale como `1d23`.
   Se quitan antes de aplanar el HTML.
3. **Filas de sección de una sola celda** ("Light Melee Weapons", "Heavy armor")
   dicen de qué tipo es lo que viene debajo; no son objetos.
4. **Los grupos no marcan dónde terminan**: tras "Ale" vienen Gallon y Mug, y
   luego "Banquet", que ya no es cerveza. Como son ocho grupos y la tabla es
   fija, sus miembros están declarados a mano en `MIEMBROS`.
5. **Las etiquetas de armadura van en minúscula** ("Light armor", no "Light
   Armor"), al revés que las de armas.
6. **Nombres repetidos**: "Arrows (20)" sale cuatro veces (una por arco) y los
   virotes dos. Son idénticos, así que se quedan con el primero.

## Cómo encaja con lo que ya había

Se amplía la tabla `items` en vez de crear tablas nuevas, porque `shop_offers`
y `inventory` ya apuntan a `items(code)`: así todo lo importado se puede comprar
y vender sin tocar la tienda.

Los 7 objetos que ya estaban en el catálogo de Dorakan (antorcha, aceite,
ración, piqueta, daga, farol y cuerda de cáñamo) **conservan su nombre, su
descripción escrita a mano y su precio**; solo se les rellenan las columnas
nuevas. La daga, por ejemplo, mantiene su "Corta, se arroja y abre cartas
selladas" y gana su 1d4 / 19-20/×2.

Los precios van en piezas de **cobre** (1 po = 100 pc), como el resto de la app.
Lo que no tiene precio fijo (la barda, que cuesta ×2 la armadura; un conjuro,
que cuesta "nivel de lanzador × 60 po") se queda a 0 con la fórmula en la
descripción, y por eso no entra en la vitrina.
