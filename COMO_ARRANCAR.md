# Cómo arrancarlo

## Lo que necesitas instalado

| | Comprobar con |
|---|---|
| JDK 21+ | `java -version` |
| Maven 3.9+ | `mvn -v` |
| Docker | `docker -v` |

En macOS: `brew install openjdk@21 maven`. En Linux: `sudo apt install openjdk-21-jdk maven`.

---

## 1. Levantar Postgres

```bash
docker compose up -d db
docker compose ps          # debe decir "healthy"
```

Solo arranca la base de datos. Los servicios `api` y `web` están comentados a
propósito: todavía no existen sus Dockerfile, y mientras desarrollas es más
cómodo arrancar el backend a mano porque recompila sin reconstruir la imagen.

## 2. Arrancar el backend

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

**El `-Dspring-boot.run.profiles=dev` no es opcional.** Sin él, Spring Security
bloquea todo con una contraseña generada y `DevController` ni siquiera se carga.
Ambas clases están atadas al perfil `dev` para que no se te cuelen en un
despliegue por accidente.

Al arrancar, Flyway aplica `V1__schema.sql` y `V2__seed_dorakan.sql`. En el log
verás algo como `Successfully applied 2 migrations`.

## 3. Entrar

```bash
curl -s -X POST localhost:8080/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"mix@trycatchmix.com","password":"archivos"}' | jq
```

Devuelve `accessToken`, `refreshToken` y `expiresIn` (900 s). Guarda el access:

```bash
TOKEN=$(curl -s -X POST localhost:8080/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"mix@trycatchmix.com","password":"archivos"}' | jq -r .accessToken)

curl -s localhost:8080/api/auth/me -H "Authorization: Bearer $TOKEN" | jq
```

Contraseña de los cinco usuarios de desarrollo: **`archivos`**.

**Ojo con el refresh:** cada llamada a `/api/auth/refresh` devuelve un token
nuevo y quema el anterior. Si reintentas con el viejo, se cierra la sesión
entera por sospecha de robo. Es intencionado, pero significa que el interceptor
de Angular tiene que serializar los refrescos.

## 4. Comprobar el resto

```bash
# Los cuatro nombres en el libro (pantalla 01)
curl -s localhost:8080/api/dev/personajes | jq

# La ficha de Gorash (pantalla 02) — copia su id del comando anterior
curl -s localhost:8080/api/dev/personajes/<ID> | jq

# El motor de tiradas: debe devolver 50 %
curl -s "localhost:8080/api/dev/probabilidad?mod=7&cd=18" | jq
```

Si todo está bien, Gorash sale con **VIGOR 4/6**, bolsa **214 po · 6 pp · 2 pc**,
carga **61 lb / 86 lb ligera** y **Trepar +7**. Son exactamente los números de
tus mockups.

## 5. Ver el tablón

```bash
# id de Gorash
CHAR=$(curl -s localhost:8080/api/dev/personajes | jq -r '.[]|select(.nombre=="Gorash")|.id')

curl -s localhost:8080/api/personajes/$CHAR/tablon \
  -H "Authorization: Bearer $TOKEN" | jq '.[] | {title, availability, reason}'
```

Verás **La procesión del Farolero** con `BLOCKED_BY_WORLD` y el motivo
"Requiere: Puente Norte en pie". Ese bloqueo no está escrito a mano: sale de la
flag `puente_norte_en_pie` del seed. Si la pones a `true` en la base de datos, el
encargo se desbloquea solo para los cuatro personajes.

## 6. Jugar un encargo entero

```bash
QUEST=$(curl -s localhost:8080/api/personajes/$CHAR/tablon \
  -H "Authorization: Bearer $TOKEN" | jq -r '.[]|select(.availability=="AVAILABLE")|.id' | head -1)

# firmar: cobra el Vigor y devuelve la primera escena
curl -s -X POST localhost:8080/api/personajes/$CHAR/encargos/$QUEST \
  -H "Authorization: Bearer $TOKEN" | jq

# elegir una salida: el servidor tira el d20 y devuelve el desglose
OPT=<id de una opción de la respuesta anterior>
curl -s -X POST localhost:8080/api/personajes/$CHAR/escena/opciones/$OPT \
  -H "Authorization: Bearer $TOKEN" | jq
```

La respuesta trae el desglose completo (`d20`, `breakdown`, `total`, `dc`,
`grade`), la narrativa del desenlace y la lista de cambios. Si el grado es 3 o
más, verás `"El pozo tercero queda abierto para el clan"` — y esa flag acaba de
cambiar el tablón de los otros tres personajes.

Después quedarás **en camino** (`waitingFor`) durante duración/escenas. Si
intentas seguir antes, recibes un **425 Too Early** con el tiempo que falta.

## 7. Escribir un encargo nuevo

Un encargo es un JSON sin UUIDs: las escenas se referencian por claves que
eliges tú y todo lo demás por código.

```bash
# 1. Comprobar sin guardar nada
curl -s -X POST localhost:8080/api/admin/encargos/check \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d @encargos/ejemplo_aguas_dorakan.json | jq

# 2. Guardar (no publica todavía)
curl -s -X POST localhost:8080/api/admin/encargos \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d @encargos/ejemplo_aguas_dorakan.json | jq

# 3. Publicar: ya sale en el tablón
curl -s -X POST localhost:8080/api/admin/encargos/aguas_dorakan/publicar \
  -H "Authorization: Bearer $TOKEN" | jq

# 4. Bajarlo para editarlo y volver a subirlo
curl -s localhost:8080/api/admin/encargos/aguas_dorakan \
  -H "Authorization: Bearer $TOKEN" | jq > mi_encargo.json
```

Si algo está mal, recibes un **422** con la lista completa de errores y avisos,
cada uno con su ruta (`scenes[1].options[0].outcomes`). Los errores impiden
publicar; los avisos no.

Necesitas entrar como **DM** (`mix@trycatchmix.com`): `/api/admin/**` está
reservado a ese rol.

## 8. Pasar los tests

```bash
mvn test
```

118 comprobaciones entre el motor de tiradas, el auth, el tablón, el bucle de juego y el editor. Una tira el d20 veinte
mil veces para verificar que el 50 % de la tarjeta del pozo tercero es cierto;
otra simula un robo de refresh token y comprueba que la sesión muere entera; y
otra verifica que el Farolero se bloquea solo porque el Puente Norte está caído.

---

## Si algo falla

**`Schema-validation: missing table [x]`**
Flyway no llegó a aplicarse. Casi siempre es que el volumen de Postgres tiene
datos viejos de un intento anterior:
```bash
docker compose down -v && docker compose up -d db
```
El `-v` borra el volumen. Es lo que quieres en desarrollo.

**`Schema-validation: wrong column type`**
Una entidad no cuadra con el esquema. `ddl-auto: validate` está puesto a
propósito para que esto explote al arrancar y no a las tres semanas con datos
dentro. El mensaje te dice tabla y columna exactas.

**401 en todos los endpoints**
Ya hay autenticación de verdad: necesitas la cabecera
`Authorization: Bearer <accessToken>`. Los de `/api/dev/**` solo se saltan el
token si arrancaste con el perfil `dev`.

**El access token caduca a los 15 minutos**
Es a propósito. Vuelve a hacer login o usa `/api/auth/refresh`.

**`ARCHIVOS_JWT_SECRET necesita al menos 32 bytes`**
La aplicación se niega a arrancar con una clave débil. Genera una con
`openssl rand -base64 48`.

**`Connection refused` al puerto 5432**
O Postgres no ha terminado de arrancar (`docker compose ps` debe decir
*healthy*), o ya tienes otro Postgres ocupando el 5432. En ese caso cambia el
puerto publicado en `docker-compose.yml` a `5433:5432` y ajusta
`SPRING_DATASOURCE_URL`.

---

## Lo que todavía NO hay

- **API de verdad.** `DevController` devuelve entidades crudas sin DTOs ni
  paginación. Es un andamio para ver datos, no la API.
- **Frontend.** Ni una línea de Angular todavía.
- **Iniciar y jugar encargos.** El motor de tiradas funciona y está probado,
  pero falta `QuestRunService` para encadenar escenas y aplicar efectos.

`DevSecurityConfig` ya no existe: la sustituyó `SecurityConfig`. Cuando estén
los controladores de verdad, borra `DevController` entero. No lo adaptes: está
escrito para tirarse.
