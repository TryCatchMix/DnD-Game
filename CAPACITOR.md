# Los Archivos — app móvil (Capacitor)

La app móvil es un envoltorio nativo (Capacitor) que carga el sitio en vivo. Es
la vía más simple para tener un `.apk`/`.aab` instalable en Android reutilizando
el frontend Angular tal cual, sin tocar el backend.

> **Cómo funciona:** `capacitor.config.ts` usa `server.url =
> https://archivos.trycatchmix.com`, así que el WebView carga directamente el
> dominio de producción. Las llamadas a `/api` van al mismo origen igual que en
> la web: no hace falta CORS ni cambiar ninguna URL. Requisito: el sitio tiene
> que estar desplegado (ver README) para que la app tenga algo que cargar.

## Requisitos (en tu máquina de desarrollo)

- Node 22.22+ (el mismo que pide el frontend).
- **Android Studio** con el SDK de Android (para compilar el `.apk`).
- Java 21 (Android Studio trae su propio JDK; vale).

## Puesta en marcha (una sola vez)

```bash
cd frontend
npm install                 # baja @capacitor/core, cli y android
npm run build               # genera dist/ (Capacitor necesita que exista)
npx cap add android         # crea la carpeta android/ con el proyecto nativo
npx cap sync                # copia la config al proyecto nativo
```

## Abrir y compilar el APK

```bash
npm run cap:android         # abre el proyecto en Android Studio
```

En Android Studio: **Run** para probar en un emulador o móvil conectado, o
**Build → Build Bundle(s)/APK(s) → Build APK(s)** para generar el instalable.

Desde terminal también:

```bash
cd frontend/android
./gradlew assembleDebug      # apk de pruebas en app/build/outputs/apk/debug/
```

## Cada vez que cambies algo

- **Solo frontend** (HTML/CSS/TS): como la app carga el sitio en vivo, basta
  con desplegar la web. La app se actualiza sola al abrirla. **No** hay que
  recompilar el APK.
- **Config de Capacitor** (`capacitor.config.ts`, plugins, icono): 
  ```bash
  npm run cap:sync         # ng build + cap sync
  ```

## Probar contra tu PC antes de desplegar

Para no depender del dominio de producción mientras desarrollas, en
`capacitor.config.ts` cambia temporalmente:

```ts
server: {
  url: 'http://192.168.1.XX:4300',   // la IP de tu PC en la red local
  cleartext: true,                    // permite http en desarrollo
},
```

Arranca el frontend (`npm start`) y el backend, y lanza la app en un móvil de la
misma red. **Vuelve a dejarlo en `https://archivos.trycatchmix.com` antes de
publicar.**

## iOS

Mismo flujo con `@capacitor/ios` y `npx cap add ios`, pero **necesita un Mac**
con Xcode. En Linux no se puede compilar para iOS.

## Limitaciones conocidas y mejoras futuras

- **La sesión no se recuerda entre reinicios.** El token vive en memoria (una
  decisión de seguridad del proyecto), así que al cerrar la app hay que volver a
  entrar. Para móvil lo suyo sería guardar el *refresh token* con
  `@capacitor/preferences` (almacenamiento nativo) y rehidratar la sesión al
  abrir. Es la primera mejora recomendada.
- **App online.** Al cargar el sitio en vivo, la app necesita conexión para
  arrancar. Si en el futuro quieres que funcione sin conexión, hay que
  empaquetar los assets (quitar `server.url`), apuntar las llamadas a la URL
  absoluta de la API mediante un interceptor que detecte
  `Capacitor.isNativePlatform()`, y **habilitar CORS** en el backend para el
  origen de la app (`https://localhost`). Es bastante más trabajo; el enfoque
  actual es el correcto para empezar.
