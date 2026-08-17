import { Component, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { SwUpdate, VersionReadyEvent } from '@angular/service-worker';
import { filter } from 'rxjs/operators';

/**
 * Avisa cuando el service worker ya ha descargado una versión nueva de la app
 * y ofrece recargar para activarla. Solo hace algo con el SW habilitado (build
 * de producción); en desarrollo `isEnabled` es false y el componente no pinta
 * nada.
 *
 * Por qué hace falta: por defecto Angular sirve la versión cacheada al instante
 * y activa la nueva en el SIGUIENTE arranque. Este banner permite que el usuario
 * salte a la versión nueva sin cerrar y reabrir la app.
 */
@Component({
  selector: 'arc-actualizar-banner',
  template: `
    @if (disponible()) {
      <div class="aviso" role="alert" aria-live="polite">
        <span class="texto">Hay una versión nueva de Los Archivos.</span>
        <button type="button" class="accion" (click)="actualizar()">Actualizar</button>
      </div>
    }
  `,
  styles: `
    .aviso {
      position: fixed;
      left: 12px;
      right: 12px;
      bottom: calc(12px + env(safe-area-inset-bottom, 0px));
      z-index: 1000;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
      max-width: 560px;
      margin: 0 auto;
      padding: 12px 14px;
      background: var(--vino, #8f2e22);
      color: var(--pergamino-claro, #f2e9d5);
      border: 1px solid rgba(0, 0, 0, .25);
      border-radius: var(--radio, 2px);
      box-shadow: 0 10px 30px rgba(0, 0, 0, .5);
      animation: subir .22s ease-out;
    }
    .texto {
      font-family: var(--cuerpo, Georgia, serif);
      font-size: 15px;
      line-height: 1.35;
    }
    .accion {
      flex: none;
      font-family: var(--dato, ui-monospace, monospace);
      font-size: 11px;
      letter-spacing: .16em;
      text-transform: uppercase;
      padding: 9px 16px;
      border-radius: var(--radio, 2px);
      border: 1px solid var(--pergamino-claro, #f2e9d5);
      background: var(--pergamino-claro, #f2e9d5);
      color: var(--vino, #8f2e22);
      cursor: pointer;
    }
    .accion:hover { background: #fff; }
    @keyframes subir {
      from { transform: translateY(12px); opacity: 0; }
      to   { transform: translateY(0);    opacity: 1; }
    }
    @media (prefers-reduced-motion: reduce) { .aviso { animation: none; } }
  `,
})
export class ActualizarBanner {
  private readonly sw = inject(SwUpdate);
  readonly disponible = signal(false);

  constructor() {
    if (!this.sw.isEnabled) return;

    // El SW anuncia que ya tiene lista la versión nueva (VERSION_READY): la
    // descarga ya está hecha, solo falta activarla.
    this.sw.versionUpdates
      .pipe(
        filter((e): e is VersionReadyEvent => e.type === 'VERSION_READY'),
        takeUntilDestroyed(),
      )
      .subscribe(() => this.disponible.set(true));

    // Si la caché queda irrecuperable, no hay banner que valga: recargar limpio.
    this.sw.unrecoverable
      .pipe(takeUntilDestroyed())
      .subscribe(() => document.location.reload());

    // Comprobar al arrancar y cada hora (por si la app se queda abierta mucho
    // rato): así el aviso aparece sin depender solo del re-arranque.
    void this.sw.checkForUpdate().catch(() => {});
    setInterval(() => void this.sw.checkForUpdate().catch(() => {}), 60 * 60 * 1000);
  }

  async actualizar(): Promise<void> {
    await this.sw.activateUpdate();
    document.location.reload();
  }
}
