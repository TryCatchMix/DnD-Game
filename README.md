# Los Archivos — Downtime

Aplicación web de mesa para D&D 3.5: gestión de personajes, tienda, crónica del
clan, grimorio de conjuros e invocaciones, bloc de notas y un editor de encargos
para el DM.

**Stack:** Spring Boot 3.3.5 (Java 21) · PostgreSQL 16 · Angular 22 (standalone,
signals, zoneless) · JWT con rotación de refresh tokens.

## Estructura

```
.
├── src/                 backend Spring Boot (com.trycatchmix.archivos)
│   └── main/resources/db/migration/   migraciones Flyway (V1…V9)
├── frontend/            aplicación Angular 22
├── docker-compose.yml   base de datos PostgreSQL
├── pom.xml              build del backend (Maven)
├── probar.sh            prueba de humo end-to-end (curl + jq)
├── ejemplo_aguas_dorakan.json   encargo de ejemplo para el editor del DM
├── CAPACITOR.md         cómo empaquetar el frontend como app Android
└── COMO_ARRANCAR*.md    guías de puesta en marcha (general y Manjaro)
```

## Arrancar

**1. Base de datos** (Docker):

```bash
docker compose up -d          # levanta PostgreSQL en el 5432
```

**2. Backend** (Maven, necesita Java 21):

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

Queda escuchando en `http://localhost:8080`. Flyway aplica las migraciones y
siembra los datos, incluidas dos cuentas de máster (DM): `mix@trycatchmix.com`
y `admin@trycatchmix.com`, ambas con contraseña `archivos`. **Cámbialas en
producción** (ver «Cuentas y roles»).

**3. Frontend** (necesita Node 22.22+):

```bash
cd frontend
npm install
npm start                     # http://localhost:4300
```

`proxy.conf.json` redirige `/api` al backend del 8080, así que no hay CORS en
desarrollo.

> **Nota (Manjaro / Arch):** si tienes PostgreSQL nativo ocupando el 5432, el
> contenedor no puede publicar su puerto y el backend acaba conectando a la BD
> equivocada. Párala con `sudo systemctl stop postgresql` antes de arrancar.
> Los detalles están en `COMO_ARRANCAR_MANJARO.md`.

## Comprobar

```bash
# Backend arriba en el 8080 con perfil dev:
./probar.sh                   # login → personaje → tablón → escena → tirada

# Frontend, sin arrancar nada:
cd frontend && npm run check   # compila y valida plantillas (strictTemplates)
```

## Qué hay

| Área | |
|---|---|
| **Campañas** | Crear una mesa, repartir su código y unir personajes (`/campanas`, `/api/campanas/**`) |
| **Personajes** | Elegir, crear (`/personajes/nuevo`), borrar (con confirmación) y ficha D&D 3.5 completa y editable |
| **Tienda** | Un mostrador **por campaña** (dentro de ella no depende de la ciudad); catálogo del SRD 3.5 con precios de manual (equipo, armas y armaduras, pociones, pergaminos, varitas y objetos maravillosos); panel del máster para poner cosas a la venta |
| **Crónica del clan** | Memoria compartida del mundo, común a todas las campañas; quien dirija alguna anota y revela verdades selladas |
| **Habilidades** | Conjuros (7 clases, stat block completo) + invocaciones de warlock + aptitudes de clase (Bárbaro/Guerrero/Monje); paginado en servidor (25 por defecto) |
| **Elenco** | La gente **de cada campaña** con su retrato vertical; el máster escribe la ficha entera y va destapando campos según los descubren (`/personajes/:id/elenco`) |
| **Bloc de notas** | Notas del jugador **en cada campaña** (PNJ, ciudades…) con categorías, fijado y búsqueda |
| **Propiedades** | Comprar negocios (taberna, mina, puerto…), recaudar renta, mejorar y vender |
| **Tablón / Escena** | Encargos con los bloqueados a la vista; escena con la tirada lacrada |
| **Editor del máster** | Crear/validar/publicar encargos de su campaña (`/api/campanas/{id}/encargos`) |
| **La Mesa** (máster) | Preparar partidas: tarjetas de misión con portada, guion por pasos y material (imágenes y PDF subidos al servidor) + modo mesa para jugar (`/api/campanas/{id}/mesa`) |
| **Cuentas** | Registro público (`/registro`); cada jugador solo ve y edita sus personajes |

## Campañas

Una **campaña** es la mesa: quien la crea la dirige, reparte un código de seis
letras y los demás entran con él. Cada campaña tiene lo suyo y no ve lo de las
otras: su tienda, su tablón de encargos, su estado del mundo, las misiones y el
material del máster, sus enemigos y combates, su elenco de personajes y el bloc
de notas de cada jugador. El catálogo de objetos, el bestiario, el grimorio y la
crónica del clan siguen siendo comunes: son el manual, no la partida.

Un personaje está **en una campaña o en ninguna**. Sin campaña se le puede
rellenar la ficha, pero no tiene tablón, ni tienda, ni bloc; la pantalla
`/campanas` es donde se apunta a una.

Al crearse, una campaña nace con el surtido base de la tienda copiado y con su
propio estado del mundo, para que el primer día haya algo que comprar y los
encargos comunes no salgan bloqueados sin motivo.

## Cuentas y roles

**El papel de máster es de cada campaña, no de la cuenta.** Cualquiera puede
abrir la suya y dirigirla, y ser jugador en la de al lado. Quien la crea es su
dueño (el único que puede borrarla) y puede nombrar co-másters.

- **Registro** (`POST /api/auth/register`, pantalla `/registro`): cualquiera crea
  su cuenta y ya puede crear campañas. No hay nada que promover a mano.
- **Propiedad de personajes**: un jugador solo lista, ve y edita **sus propios**
  personajes; el máster de una campaña ve y edita además los del grupo de **esa**
  mesa. Todo lo decide `CampaignAccess` en el backend, no la interfaz.
- **Permisos de campaña**: hay dos, *miembro* (mira el tablón, la tienda y su
  bloc) y *DM* (prepara misiones, escribe encargos, pone precios y saca
  enemigos). Ninguna ruta se protege ya con `hasRole('DM')`: la comprobación
  necesita saber **de qué campaña** se habla, y eso solo lo sabe el controlador.
- `users.role` sigue existiendo pero ya no manda en el juego; queda como
  administración de la instalación.

La migración `V28` crea una campaña, **La mesa de siempre**, con todo lo que
hubiera antes dentro y con todos los usuarios como miembros, así que al
desplegar nadie pierde de vista sus personajes, sus notas ni sus misiones.

## Propiedades (mini-juego de gestión)

Cada personaje puede comprar negocios con el oro de su monedero y sacarles renta.
Hay 11 tipos (🍺 taberna, 🏨 posada, ⚒️ herrería, 🧙 tienda de magia, 🐴 establos,
🌾 granja, ⛏️ mina, 🚢 puerto, 🏛️ gremio, 🎭 teatro, 🌹 burdel), cada uno con su
precio y su renta.

- **Renta pasiva**: se acumula sola con el tiempo real (no hay proceso en
  segundo plano; el backend la calcula al vuelo desde la última recaudación, con
  un tope de 30 días). Se **recauda** a mano y va al monedero.
- **Mejoras**: hasta nivel 5. Cada nivel multiplica la renta (nivel N = base × N).
- **Venta**: devuelve la mitad de lo invertido más la renta pendiente.

La economía de cada tipo (precios, renta, fórmula de mejora) vive en
`PropertyKind` (Java), no en la BD, para poder ajustar el balance sin migrar.
Endpoints en `/api/personajes/{id}/propiedades` (tabla `properties`, migración
`V11`). Como todo lo del personaje, un jugador solo gestiona los suyos y el
máster de su campaña los del grupo.

## La Mesa (preparar partidas, solo el máster)

Pestaña **La Mesa** (`/personajes/:id/mesa`, endpoints
`/api/campanas/{id}/mesa/**`, migraciones `V15` y `V28`). Es el escritorio del
máster de esa campaña, no una pantalla de juego:

- **Misiones**: una rejilla de tarjetas, cada una con su **portada**, su sello de
  estado (idea → preparando → lista → jugada), sus etiquetas y lo que lleva
  dentro ("3 láminas · 1 PDF · 5 pasos"). Crear, editar y eliminar desde la
  propia tarjeta. El orden lo pone el servidor: lo que toca preparar antes sale
  primero; lo ya jugado se apaga al final.
- **Guion**: los pasos de la misión en orden, cada uno de un tipo (leer en voz
  alta, escena, PNJ, botín, nota). Se reordenan con ↑ ↓. El texto de lectura va
  destacado, como el recuadro de un módulo.
- **Material**: imágenes y PDF **subidos al servidor** (arrastrar y soltar; 25 MB
  por archivo; JPG/PNG/WEBP/GIF/PDF). Se ven a pantalla completa con el visor,
  se pasa de una a otra con las flechas y cualquier imagen puede hacerse portada.
- **Biblioteca**: todo lo subido, esté o no en una misión. Un mapa se reparte a
  la misión que sea sin volver a subirlo, y al borrar una misión su material
  vuelve aquí en vez de perderse.
- **Modo mesa**: pantalla completa, letra grande, un paso cada vez con las
  flechas y una tira de láminas para enseñar. Es lo que se usa *jugando*.

Los ficheros van a **disco**, no a la base de datos: ruta en `archivos.mesa.dir`
(`ARCHIVOS_MESA_DIR`, por defecto `data/mesa`). En producción está montado como
volumen `mesa` en `docker-compose.prod.yml` — sin ese volumen, cada
`up --build` se llevaría por delante todo el material subido. El nombre en disco
lo genera el servidor (uuid + extensión del MIME); nada de lo que manda el
navegador toca la ruta.

## El elenco (quién ha salido en la campaña)

Pestaña **Elenco** (`/personajes/:id/elenco`, endpoints
`/api/campanas/{id}/elenco/**`, migración `V31`). Una galería de retratos
verticales: el tabernero que sabía demasiado, la capitana que os debe un favor,
el encapuchado del callejón. Cada campaña tiene el suyo.

La idea entera es que **un personaje se descubre a trozos**. El máster escribe
la ficha completa —retrato, nombre, título, ubicación, raza, descripción,
curiosidades, alineamiento y con quién es amistoso, neutral, enemigo o
familia— y cada campo lleva su propio sello. Lo que la mesa aún no sabe no se
enseña; lo que ya sabe, sí.

- **Mientras el nombre está sellado, manda el alias.** Un PNJ sin nombre no
  deja la tarjeta muda: se le llama "El encapuchado" hasta que se presente.
  Por eso el nombre se puede ocultar como cualquier otro campo.
- **Lo sellado no viaja.** Al jugador le llega `null` en cada campo que no ha
  descubierto, no el dato con una marca de "oculto": lo que llega al navegador
  se lee abriendo las herramientas del desarrollador. El retrato va igual —su
  ruta comprueba el mismo permiso antes de leer el fichero, así que adivinarla
  no sirve de nada.
- **El contador es parte del juego.** Cada tarjeta enseña en lacre cuántas
  cosas quedan por saber. Solo cuentan los campos que el máster ha rellenado:
  prometer misterio donde no hay nada se nota a la segunda ficha.
- **Una ficha que aún no ha salido solo la ve el máster.** Se prepara con
  antelación y aparece en el elenco de la mesa el día que el PNJ se cruza con
  el grupo.
- **Los tratos se descubren de uno en uno.** Que sepas que odia al Gremio no te
  cuenta que sea hermano de la capitana. El otro extremo puede ser otro del
  elenco, un personaje jugador de la mesa o un nombre suelto; si es un PNJ cuyo
  nombre sigue sellado, en esta ficha también sale por su alias.

Los retratos van al mismo armario que el material de La Mesa (tabla
`mesa_archivos`, disco en `archivos.mesa.dir`), así que también se pueden
enseñar a pantalla completa desde el modo mesa sin volver a subirlos.

## App móvil (Android)

El frontend se empaqueta como app nativa con **Capacitor**, reutilizando el
mismo código. Los pasos completos están en `CAPACITOR.md`.

## Decisiones de diseño que importan

**El refresco de tokens va serializado.** El backend rota los refresh tokens:
cada refresco quema el anterior y, si le llega uno ya quemado, asume robo y
cierra la sesión entera. `AuthService` comparte el observable en vuelo para que
dos peticiones que reciben 401 a la vez no disparen dos refrescos en paralelo
(que matarían la sesión de un jugador inocente).

**La sesión vive en memoria, no en localStorage.** El access token dura 15
minutos; ponerlo en localStorage lo expondría a cualquier script. Para
"recuérdame" lo correcto sería una cookie httpOnly puesta por el backend.

**Los encargos bloqueados se ven, apagados.** Que un jugador vea "La procesión
del Farolero · Requiere: Puente Norte en pie" en gris es lo que le cuenta que
otro tiró el puente. Es lo que hace visible el mundo compartido.

**El bloc de notas es del jugador, no del personaje.** Los nombres de PNJ y
ciudades son del mundo, así que sobreviven al cambiar o crear personaje.

## Sistema visual

Pergamino `#efe4cd` sobre noche `#1e1810`, tinta `#2b2117`, lacre `#8f2e22`, oro
`#9d7a2f`, musgo `#4c6a37`. Radios de 2 px —son documentos, no botones de app— y
versalitas de tracking ancho en IBM Plex Mono para los metadatos; IM Fell
English para títulos, EB Garamond para narrativa. El **lacre** es el elemento con
el que se recuerda la interfaz: su color cuenta el desenlace de una tirada antes
de leer nada —vino para desastre, oro para éxito con coste, musgo para éxito.

### Diseños intercambiables

Una pantalla puede tener varias caras, y el jugador elige la suya en
**Ajustes → Diseño** (`/personajes/:id/ajustes`). Hoy la ficha viene con tres:
*Pergamino* (la hoja impresa de siempre, la de fábrica), *Mesa de noche* (una
sola columna sobre fondo oscuro, sin pestañas, pensada para el móvil en partida)
y *Celeste* (carta astral: cielo estrellado y paneles de cristal violeta).

El truco es que un diseño solo tiene plantilla y estilos: el estado y las cuentas
viven en un store aparte (`features/ficha/ficha.store.ts`), así que añadir una
hoja nueva no duplica ni una línea de lógica. Cómo hacerlo, en
[`frontend/src/app/core/diseno/README.md`](frontend/src/app/core/diseno/README.md).
