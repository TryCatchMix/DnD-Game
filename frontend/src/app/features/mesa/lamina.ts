import { Component, computed, inject, input } from '@angular/core';

import { MesaService } from '../../core/mesa.service';

/**
 * Una lámina: la miniatura de un archivo de La Mesa.
 *
 * Existe porque el contenido va autenticado y no se puede poner la ruta en un
 * <img src> a pelo (ver MesaService.contenido). Mientras baja el blob se enseña
 * un hueco de pergamino en vez de un salto de maquetación.
 */
@Component({
  selector: 'arc-lamina',
  template: `
    @if (esImagen() && url()) {
      <img [src]="url()" [alt]="alt()" loading="lazy" />
    } @else if (esImagen() && url() === null) {
      <span class="cargando" aria-hidden="true"></span>
    } @else {
      <span class="marca" aria-hidden="true">{{ marca() }}</span>
    }
  `,
  host: { class: 'lamina' },
  styles: `
    :host {
      display: block;
      position: relative;
      overflow: hidden;
      background:
        repeating-linear-gradient(135deg,
          rgba(122,103,73,.10) 0 6px, rgba(122,103,73,.04) 6px 12px);
      border-bottom: 1px solid var(--linea);
    }
    img { width: 100%; height: 100%; object-fit: cover; display: block; }

    /* El hueco mientras baja: una respiración, no un spinner. */
    .cargando {
      position: absolute; inset: 0;
      background: linear-gradient(90deg,
        rgba(239,228,205,.05), rgba(239,228,205,.16), rgba(239,228,205,.05));
      background-size: 200% 100%;
      animation: barrido 1.4s ease-in-out infinite;
    }
    @keyframes barrido { from { background-position: 200% 0; } to { background-position: -200% 0; } }

    /* Sin imagen: la inicial del título, como un sello en el lacre. */
    .marca {
      position: absolute; inset: 0;
      display: grid; place-items: center;
      font-family: var(--display);
      font-size: 34px;
      color: rgba(122,103,73,.55);
      letter-spacing: .04em;
    }
  `,
})
export class Lamina {

  /** El archivo a enseñar. null = no hay portada. */
  readonly assetId = input<string | null>(null);
  /** Qué poner de texto alternativo y de inicial cuando no hay imagen. */
  readonly alt = input('');
  /** 'imagen' pinta la miniatura; cualquier otro tipo enseña su marca. */
  readonly kind = input<'imagen' | 'pdf' | 'otro'>('imagen');

  private readonly mesa = inject(MesaService);

  readonly esImagen = computed(() => this.kind() === 'imagen' && !!this.assetId());
  readonly url = computed(() => {
    const id = this.assetId();
    return id && this.kind() === 'imagen' ? this.mesa.contenido(id)() : '';
  });

  readonly marca = computed(() => {
    if (this.kind() === 'pdf') return 'PDF';
    const t = this.alt().trim();
    return t ? t.charAt(0).toUpperCase() : '§';
  });
}
