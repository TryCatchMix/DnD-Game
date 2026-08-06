import type { CapacitorConfig } from '@capacitor/cli';

/**
 * Configuración de la app móvil (Capacitor).
 *
 * ENFOQUE: la app es un envoltorio nativo que carga el sitio EN VIVO
 * (`server.url`). Como el WebView carga directamente el dominio de producción,
 * las llamadas relativas a `/api` van al mismo origen igual que en la web:
 * no hace falta ni CORS ni reescribir URLs, y cualquier cambio en el frontend
 * aparece en la app sin volver a publicarla en la tienda.
 *
 * Para PROBAR contra tu PC en la red local, cambia `server.url` por
 * `http://TU_IP_LOCAL:4300` y pon `cleartext: true` (solo para desarrollo).
 *
 * Si algún día quieres una app que funcione sin conexión (assets empaquetados),
 * hay que quitar `server.url`, apuntar las llamadas a la URL absoluta de la API
 * y habilitar CORS en el backend. Ver CAPACITOR.md.
 */
const config: CapacitorConfig = {
  appId: 'com.trycatchmix.archivos',
  appName: 'Los Archivos',
  webDir: 'dist/archivos-frontend/browser',
  server: {
    url: 'https://archivos.trycatchmix.com',
    cleartext: false,
  },
};

export default config;
