# Compendio D&D 3.5 — extraído del Manual del Jugador I

Datos extraídos por OCR del *Manual del Jugador I v3.5* (español) para poblar la
pestaña "Habilidades" del juego. Cada archivo calca una interfaz de
`frontend/src/app/core/api.types.ts`.

| Archivo             | Tipo           | Registros | kind (selector)     |
|---------------------|----------------|-----------|---------------------|
| `hechizos.json`     | `Spell[]`      | 413       | `hechizo`           |
| `dotes.json`        | `Feat[]`       | 106       | `dote`              |
| `aptitudes.json`    | `ClassFeature[]`| 80       | `aptitud`           |
| `condiciones.json`  | `Condicion[]`  | 32        | `condicion`         |

No están en este manual (viven en el DMG / Complete Arcane): **venenos,
enfermedades, invocaciones**.

## Notas por categoría

### hechizos.json (Spell)
- Campos de ORIGEN rellenados desde el libro: `name, school, subschool,
  descriptors, description, minLevel, components, castingTime, range, target,
  duration, savingThrow, spellResistance, classes[], source`.
- Campos que **calcula tu backend** → van vacíos (`""`): `dice, scaling, cap,
  damageSummary`, y `saveDcFormula` dentro de cada `classes[]`. `nameEn` vacío,
  `custom: false`, `targetKind: ""`.
- `classes[]` incluye sólo las 7 clases lanzadoras reconocidas. Los dominios de
  clérigo (p. ej. "Superchería 2") van en el campo extra `_domains`.
- 385 conjuros traen bloque completo; 27 son variantes ("en grupo/mayor") que en
  el libro remiten a otro conjuro y por eso heredan algunos campos (quedan vacíos).

### dotes.json (Feat)
- `name, kind, prerequisite, benefit, normal, special, source`. `kind` ∈
  {General, Metamágica, Creación de objetos, Especial, Salvaje}.
- La frase introductoria de cada dote va en el extra `_summary`.
- ~16 nombres se corrigieron a mano (el OCR se comió la capitular inicial).

### aptitudes.json (ClassFeature)
- `clazz, name, kind, description, source`. `kind` ∈ {Extraordinaria,
  Sobrenatural, Sortílega}. La clase se atribuyó por rango de página (fiable).
- Sólo se capturan rasgos etiquetados (Ex)/(Sb)/(Sob)/(Sor). Guerrero (sólo
  dotes adicionales) y Mago (familiar, va en Hechicero) aparecen con pocas o
  ninguna: es esperado.

### condiciones.json (Condicion)
- `name, nameEn(''), description, source`. Extraídas del glosario (pág. 305).

## Campos extra (con prefijo `_`)
`_domains`, `_summary`, `_nivelRaw`, `_idSeccion`, `_tituloOriginal`: son ayudas
de trazabilidad, NO están en las interfaces. Tu deserializador puede ignorarlos
(o los quitas con un `jq 'del(.._*)'`).

## Aviso de calidad
Es OCR de un escaneo: el texto de descripciones es muy fiable, pero conviene una
revisión rápida de los datos numéricos densos (CD, dados de daño) antes de
producción. La fuente es `"Manual del Jugador 3.5"` en todos los registros.
