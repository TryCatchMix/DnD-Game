import { DOCUMENT } from '@angular/common';
import { Component, OnDestroy, inject, input, output } from '@angular/core';

/**
 * El retrato a pantalla completa: la misma cara que se ve en el expediente,
 * pero en grande, para poder mirarla de cerca (o dejar que corra el GIF sin la
 * lámina recortándolo).
 *
 * Es hermano del visor de La Mesa —mismo lacre, mismo Esc, mismo fondo— pero
 * más humilde: aquí no se pasa de una a otra, solo se abre una cara y se cierra.
 * Se cierra pinchando el fondo, la cruz de la esquina o con Escape.
 *
 * No pide los bytes: recibe la URL que el retrato pequeño ya bajó, así abrir en
 * grande es instantáneo y no hay una segunda descarga del mismo blob.
 */
@Component({
  selector: 'arc-retrato-ampliado',
  template: `
    <div class="fondo" role="dialog" aria-modal="true"
         [attr.aria-label]="'Retrato de ' + nombre()"
         tabindex="-1" (click)="cerrar.emit()">

      <!-- La cruz para salir, siempre arriba a la derecha y respetando el
           notch del móvil. Va fuera del <img> para que no la tape la lámina. -->
      <button class="cruz" type="button" (click)="cerrar.emit()" aria-label="Cerrar">✕</button>

      <!-- Pinchar la propia imagen no cierra: solo el fondo y la cruz. -->
      <img class="lamina" [src]="src()" [alt]="'Retrato de ' + nombre()"
           (click)="$event.stopPropagation()" />
    </div>
  `,
  // Esc cierra sin tener que pinchar antes dentro.
  host: { '(document:keydown.escape)': 'cerrar.emit()' },
  styles: `
    .fondo {
      position: fixed; inset: 0; z-index: 60;
      /* dvh para que la barra del navegador móvil no deje una franja muerta. */
      height: 100dvh;
      background: rgba(15, 11, 5, .94);
      backdrop-filter: blur(3px);
      display: grid; place-items: center;
      /* Deja aire alrededor y respeta el notch en las cuatro esquinas. */
      padding:
        max(env(safe-area-inset-top), 16px)
        max(env(safe-area-inset-right), 16px)
        max(env(safe-area-inset-bottom), 16px)
        max(env(safe-area-inset-left), 16px);
      /* El rebote del móvil no arrastra la página de debajo. */
      overscroll-behavior: contain;
    }
    .lamina {
      max-width: 100%; max-height: 100%;
      object-fit: contain; display: block;
      border-radius: var(--radio);
      box-shadow: 0 18px 60px rgba(0, 0, 0, .6);
    }
    .cruz {
      position: absolute;
      top: max(env(safe-area-inset-top), 10px);
      right: max(env(safe-area-inset-right), 10px);
      /* 44px: el mínimo cómodo para el dedo. */
      width: 44px; height: 44px;
      display: grid; place-items: center;
      font-size: 22px; line-height: 1;
      color: var(--pergamino);
      background: rgba(23, 18, 8, .6);
      border: 1px solid var(--linea-noche);
      border-radius: 50%;
      cursor: pointer;
    }
    .cruz:hover { background: rgba(23, 18, 8, .85); }
    .cruz:focus-visible { outline: 2px solid var(--oro); outline-offset: 2px; }
  `,
})
export class RetratoAmpliado implements OnDestroy {

  /** La URL local (blob) que el retrato pequeño ya tenía bajada. */
  readonly src = input.required<string>();
  /** Para el texto alternativo y el aria-label. */
  readonly nombre = input('');

  readonly cerrar = output<void>();

  private readonly doc = inject(DOCUMENT);
  /** Lo que había en overflow antes de abrir, para dejarlo como estaba. */
  private readonly overflowPrevio = this.doc.body.style.overflow;

  constructor() {
    // Mientras la cara está en grande, la página de debajo no se desplaza:
    // en el móvil, arrastrar sobre el fondo movía el elenco por detrás.
    this.doc.body.style.overflow = 'hidden';
  }

  ngOnDestroy(): void {
    this.doc.body.style.overflow = this.overflowPrevio;
  }
}
