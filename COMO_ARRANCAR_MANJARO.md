# Montarlo en Manjaro

Manjaro te lo pone fácil: todo está en los repos oficiales y Docker corre
nativo, sin la capa de WSL2 que complica Windows.

---

## 1. Instalar lo necesario

```bash
sudo pacman -Syu
sudo pacman -S jdk21-openjdk maven docker docker-compose nodejs npm jq
```

Comprueba las versiones:

```bash
java -version    # tiene que decir 21
mvn -v
node -v          # necesita 22.22.3 o superior
docker -v
```

**Si tienes varios JDK instalados**, Manjaro los gestiona con `archlinux-java`:

```bash
archlinux-java status
sudo archlinux-java set java-21-openjdk
```

**Si `node -v` sale por debajo de 22.22.3**, el CLI de Angular se negará a
arrancar. Actualiza con `sudo pacman -S nodejs` o instala una versión concreta
con `nvm`.

## 2. Arrancar Docker

En Arch y derivadas el servicio no arranca solo:

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
```

**Cierra sesión y vuelve a entrar** (o `newgrp docker`), o cada comando de
Docker te pedirá `sudo`. Comprueba que funciona sin root:

```bash
docker run --rm hello-world
```

## 3. Levantar Postgres

```bash
cd archivos
docker compose up -d db
docker compose ps        # tiene que decir "healthy"
```

Si te dice que el **puerto 5432 está ocupado**, es que tienes Postgres nativo
corriendo. Dos opciones:

```bash
sudo systemctl stop postgresql          # apagarlo mientras juegas
```

o cambiar el puerto publicado en `docker-compose.yml` a `"5433:5432"` y arrancar
el backend con `SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5433/archivos`.

## 4. Arrancar el backend

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

El perfil `dev` no es opcional: sin él, Spring Security bloquea todo y los
endpoints `/api/dev/**` ni se cargan.

Al arrancar, Flyway aplica las tres migraciones. En el log verás
`Successfully applied 3 migrations`.

> No hay `mvnw` en el repo, por eso hace falta Maven instalado. Si prefieres el
> wrapper, genéralo una vez con `mvn wrapper:wrapper` y ya podrás usar `./mvnw`.

## 5. Probarlo entero de una tacada

En otra terminal:

```bash
./probar.sh
```

El script entra, lista los personajes, comprueba que **Gorash sale con Trepar
+7** (el número de tus mockups), enseña el tablón, firma un encargo, elige una
opción y muestra el desglose completo de la tirada. Si algo no cuadra, te dice
cuál de los pasos falló.

Salida esperada, más o menos:

```
1 · Entrar
  ✓ dentro como Mix (DM)
4 · La ficha de Gorash
  Bolsa: 214 po · 6 pp · 2 pc
  Carga: 61 lb / 86 lb ligera
  ✓ Trepar +7, igual que el mockup
5 · El tablón
  [AVAILABLE]        El silencio de las minas
  [BLOCKED_BY_WORLD] La procesión del Farolero — Requiere: Puente Norte en pie
  ✓ hay 1 encargo(s) bloqueado(s) por el estado del mundo
7 · Elegir una opción
  d20 9
  Trepar: +7
  Cable resbaladizo: -2
  Total 14 contra CD 18  →  Éxito con coste (grado 3 de 5)
```

## 6. Arrancar el frontend

Tercera terminal:

```bash
cd frontend
npm install
npm start
```

Abre `http://localhost:4200`. Entra con `mix@trycatchmix.com` / `archivos`.

El `proxy.conf.json` manda `/api` al 8080, así que no hay CORS que configurar.

## 7. Pasar los tests

```bash
mvn test                        # 118 comprobaciones del backend
cd frontend && npm run check    # compila y valida plantillas
npm run check:interceptor       # demuestra el refresco serializado
```

---

## Si algo falla

**`Cannot connect to the Docker daemon`**
No has salido y entrado de sesión tras el `usermod`. Prueba `newgrp docker`.

**`Schema-validation: missing table`**
Flyway no llegó a aplicarse, casi siempre por datos viejos de un intento
anterior:
```bash
docker compose down -v && docker compose up -d db
```
El `-v` borra el volumen. En desarrollo es justo lo que quieres.

**`Connection refused` al 5432**
O Postgres aún no está listo (`docker compose ps` debe decir *healthy*), o
tienes el nativo ocupando el puerto (ver paso 3).

**`ARCHIVOS_JWT_SECRET necesita al menos 32 bytes`**
La aplicación se niega a arrancar con una clave débil, a propósito:
```bash
export ARCHIVOS_JWT_SECRET=$(openssl rand -base64 48)
```

**401 en todo**
El access token dura 15 minutos. Vuelve a lanzar `./probar.sh`, que hace login
de nuevo.

**`UnsupportedClassVersionError`**
Maven está usando un JDK más viejo. Comprueba con `mvn -v` qué JDK ve y
apúntalo si hace falta:
```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
```

**Acentos raros en los logs**
No debería pasar: Java 21 usa UTF-8 por defecto y Manjaro también. Si aparece,
`echo $LANG` debería devolver algo acabado en `.UTF-8`.

---

## Los tres comandos del día a día

```bash
docker compose up -d db                                  # una vez al arrancar
mvn spring-boot:run -Dspring-boot.run.profiles=dev       # backend
cd frontend && npm start                                 # frontend
```
