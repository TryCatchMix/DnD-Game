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
siembra los datos (usuario DM `mix@trycatchmix.com` / `archivos`).

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
| **Personajes** | Elegir, crear (`/personajes/nuevo`) y ficha D&D 3.5 completa y editable |
| **Tienda** | Comprar/vender en la ciudad; panel del DM para poner cosas a la venta |
| **Crónica del clan** | Memoria compartida del mundo; el DM anota y revela verdades selladas |
| **Hechizos** | Grimorio con el bloque de estadísticas completo + invocaciones de warlock |
| **Bloc de notas** | Notas del jugador (PNJ, ciudades…) con categorías, fijado y búsqueda |
| **Tablón / Escena** | Encargos con los bloqueados a la vista; escena con la tirada lacrada |
| **Editor del DM** | Crear/validar/publicar encargos (`/api/admin/encargos`) |

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
