# Raspador de condiciones, venenos y enfermedades

De aquí sale `src/main/resources/db/migration/V26__conditions_poisons.sql`:
38 condiciones, 28 venenos y 10 enfermedades del SRD 3.5 (OGL).

```sh
cd tools/estados
curl -s https://www.d20srd.org/srd/conditionSummary.htm -o conditionSummary.htm
curl -s https://www.d20srd.org/srd/specialAbilities.htm -o specialAbilities.htm
python3 parse_estados.py
DESTINO=../../src/main/resources/db/migration/V26__conditions_poisons.sql python3 gen_sql_estados.py
```

## Todo traducido

Como con las dotes: una condición son dos o tres frases y es de lo que más se
consulta a media pelea. El texto está en `estados_es.py`; si hay que corregir
algo, se corrige ahí y se regenera.

## Merece la pena la verificación cruzada

Las CD, los daños y las formas de contagio se escribieron a mano, así que
conviene comprobarlas contra lo raspado antes de generar el SQL. Al hacerlo
apareció un error real: la Perdición viscosa se contagia por CONTACTO, no
ingerida. Un script de comparación de dos minutos evita meter un dato falso en
la base de datos.

## Trampas

1. Los `<tfoot>` van antes del `<tbody>`, como en todas las tablas del SRD.
2. Los `<sup>` de las notas al pie se pegan al valor (`1d4 Str1`), así que hay
   que quitarlos antes de aplanar. Lo que dicen esas notas está recogido a mano
   en `NOTAS_ENFERMEDAD`.
3. La tabla de venenos marca con superíndice los daños que son SUCCIÓN
   (permanentes). Al quitar el superíndice se pierde ese matiz, así que en la
   traducción va escrito: "1 Con permanente".
