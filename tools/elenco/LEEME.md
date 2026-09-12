# Cargar un elenco desde un dossier

Meter cuarenta y cuatro PNJs a mano por la pantalla del Elenco son cuarenta y
cuatro formularios. Esto los mete por la API.

```bash
node tools/elenco/cargar.mjs
```

Necesita el backend arriba (`mvn spring-boot:run -Dspring-boot.run.profiles=dev`).

| Variable | Por defecto | Qué es |
|---|---|---|
| `API` | `http://localhost:8080` | dónde escucha el backend |
| `EMAIL` | `mix@trycatchmix.com` | la cuenta que dirige la mesa |
| `PASSWORD` | `archivos` | su contraseña |
| `CAMPANA` | `Velmorra` | el nombre de la campaña; se crea si no existe |
| `RESELLAR` | *(sin poner)* | `1` fuerza los sellos del dossier sobre las fichas que ya existen |

## Qué hace

1. Entra y busca la campaña por nombre. Si no está, la crea y te dice el código.
2. Crea los personajes jugadores del dossier si faltan y los apunta a la mesa.
3. Crea o actualiza las fichas del elenco, buscándolas por nombre.
4. Rehace los tratos de cada ficha que los declare.

**Es idempotente**: se puede relanzar después de tocar el dossier y no duplica
nada. Con una excepción que conviene saber: los tratos de una ficha se borran y
se vuelven a poner, así que **los tratos que hayas apuntado a mano en la
interfaz se pierden al recargar**. Todo lo demás se respeta.

**No vuelve a sellar lo que revelaste jugando.** Si a mitad de campaña
destapaste el alineamiento de alguien, recargar el dossier no lo vuelve a
tapar. Para imponer el reparto del fichero, `RESELLAR=1`.

## El dossier

`velmorra.mjs` es la fuente. Dos listas: `PJS` (los personajes jugadores) y
`ELENCO` (las fichas). Lo único que hay que entender para escribir una ficha
nueva es el reparto de sellos, y está explicado en la cabecera del fichero:

- **Por defecto se ve** nombre, título, ubicación, raza y descripción. Es lo que
  ves al conocer a alguien.
- **Por defecto se sella** el alineamiento (es una chuleta del máster), las
  curiosidades (son los ganchos) y los tratos.
- `ve: { … }` corrige ese reparto ficha a ficha. `ve: { race: false }` para
  quien no enseña lo que es; `ve: { listed: false }` para quien todavía no ha
  salido en la mesa y solo ve el máster.
- En cada trato, `visto: true` lo deja a la vista desde el principio.

`tratos[].a` dice a quién apunta: `npc:<nombre de otra ficha>`,
`pj:<nombre de un personaje jugador>`, o cualquier otro texto para un nombre
suelto (un gremio, una institución, alguien sin ficha).

Para otra campaña, copia `velmorra.mjs`, cámbiale el contenido y ajusta el
`import` de `cargar.mjs`.
