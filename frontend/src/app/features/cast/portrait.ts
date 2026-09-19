import { Component, computed, inject, input, output } from '@angular/core';

import { ElencoService } from '../../core/cast.service';

/**
 * El retrato de un PNJ: una lámina vertical, como el daguerrotipo de un
 * expediente.
 *
 * Existe por lo mismo que la lámina de La Mesa —el contenido va autenticado y
 * no se puede poner la ruta en un <img src>, hay que bajar el blob—, pero con
 * una diferencia que importa: aquí el hueco es lo normal, no la excepción. Un
 * PNJ recién visto no tiene cara todavía, así que el sitio vacío tiene que
 * parecer una ficha por rellenar y no una imagen rota.
 */
@Component({
  selector: 'arc-retrato',
  template: `
    @if (url(); as u) {
      <img [src]="u" [alt]="'Retrato de ' + nombre()" loading="lazy"
           [class.ampliable]="ampliable()"
           [attr.role]="ampliable() ? 'button' : null"
           [attr.tabindex]="ampliable() ? 0 : null"
           [attr.aria-label]="ampliable() ? 'Ver el retrato de ' + nombre() + ' en grande' : null"
           (click)="ampliable() && abrir.emit(u)"
           (keydown.enter)="ampliable() && abrir.emit(u)"
           (keydown.space)="ampliable() && abrir.emit(u); ampliable() && $event.preventDefault()" />
    } @else if (hay() && url() === null) {
      <span class="cargando" aria-hidden="true"></span>
    } @else {
      <span class="silueta" aria-hidden="true">{{ inicial() }}</span>
    }
  `,
  host: { class: 'retrato' },
  styles: `
    :host {
      display: block;
      position: relative;
      overflow: hidden;
      /* Vertical siempre: dos de ancho por tres de alto es la proporción del
         retrato pintado, y es la que hace que una fila de caras se lea como
         una galería y no como una tira de miniaturas. */
      aspect-ratio: 2 / 3;
      /* Para que la inicial del hueco crezca con el ancho de la lámina y no
         con el de la ventana: la misma ficha se usa en la rejilla y grande. */
      container-type: inline-size;
      background:
        radial-gradient(120% 80% at 50% 0%, rgba(122,103,73,.16), transparent 70%),
        repeating-linear-gradient(135deg,
          rgba(122,103,73,.10) 0 6px, rgba(122,103,73,.04) 6px 12px);
      border-bottom: 1px solid var(--linea);
    }
    img { width: 100%; height: 100%; object-fit: cover; display: block; }
    /* Cuando la cara se puede abrir en grande, la lupa lo anuncia. */
    img.ampliable { cursor: zoom-in; }
    img.ampliable:focus-visible { outline: 2px solid var(--oro); outline-offset: -2px; }

    .cargando {
      position: absolute; inset: 0;
      background: linear-gradient(90deg,
        rgba(239,228,205,.05), rgba(239,228,205,.16), rgba(239,228,205,.05));
      background-size: 200% 100%;
      animation: barrido 1.4s ease-in-out infinite;
    }
    @keyframes barrido { from { background-position: 200% 0; } to { background-position: -200% 0; } }

    /* Sin cara: la inicial grabada, como la marca de agua de un expediente. */
    .silueta {
      position: absolute; inset: 0;
      display: grid; place-items: center;
      font-family: var(--display);
      font-size: clamp(38px, 22cqw, 88px);
      color: rgba(122,103,73,.45);
      letter-spacing: .04em;
    }
  `,
})
export class Retrato {

  /** De quién es la cara. */
  readonly npcId = input.required<string>();

  /** Si hay retrato Y quien mira puede verlo. En false ni se pide. */
  readonly hay = input(false);

  /** Para el texto alternativo y para la inicial del hueco. */
  readonly nombre = input('');

  /** Si la cara se puede pinchar para verla a pantalla completa. Por defecto
   *  no: en la rejilla del elenco pinchar la cara abre el expediente, no la
   *  amplía. Solo el expediente la enciende. */
  readonly ampliable = input(false);

  /** Al pinchar (si es ampliable), la URL ya cargada del retrato, para que
   *  quien la muestra abra el lightbox sin volver a bajar el blob. */
  readonly abrir = output<string>();

  /**
   * De dónde se bajan los bytes. Un PNJ suelto no tiene mesa, así que su cara
   * tampoco se pide por la ruta de una: se sirve por /api/elenco-suelto.
   */
  readonly fuente = input<'mesa' | 'suelto'>('mesa');

  private readonly elenco = inject(ElencoService);

  readonly url = computed(() => {
    if (!this.hay()) return '';
    return this.fuente() === 'suelto'
      ? this.elenco.retratoSuelto(this.npcId())()
      : this.elenco.retrato(this.npcId())();
  });

  readonly inicial = computed(() => {
    const n = this.nombre().trim();
    return n ? n.charAt(0).toUpperCase() : '§';
  });
}
