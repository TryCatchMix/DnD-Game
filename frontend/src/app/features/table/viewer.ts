import {
  Component, ElementRef, computed, inject, input, output, signal, viewChild,
} from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';

import { MesaService } from '../../core/table.service';
import { Archivo } from '../../core/table.types';

/**
 * El visor a pantalla completa: una imagen grande o un PDF, con las flechas
 * para pasar al siguiente archivo de la misma misión.
 *
 * Se abre con la lista entera y un índice (no con un archivo suelto) porque
 * mirando un mapa lo siguiente que quieres es el otro mapa, no cerrar y volver
 * a buscar.
 */
@Component({
  selector: 'arc-visor',
  template: `
    <div class="fondo" role="dialog" aria-modal="true" [attr.aria-label]="actual().title"
         tabindex="-1" (click)="cerrar.emit()">

      <div class="marco" #marco (click)="$event.stopPropagation()">
        <header class="barra">
          <div class="quien">
            <p class="rotulo">{{ actual().kind === 'pdf' ? 'Documento' : 'Lámina' }}
              @if (archivos().length > 1) { · {{ i() + 1 }} de {{ archivos().length }} }
            </p>
            <h2>{{ actual().title }}</h2>
          </div>
          <div class="acc">
            <button class="boton" (click)="alternarCompleta()"
                    [attr.aria-label]="completa() ? 'Salir de pantalla completa' : 'Pantalla completa'">
              {{ completa() ? '⤢ Salir de pantalla completa' : '⛶ Pantalla completa' }}
            </button>
            @if (url(); as u) {
              <a class="boton" [href]="u" [download]="actual().filename">Descargar</a>
            }
            <button class="boton" (click)="cerrar.emit()" aria-label="Cerrar">Cerrar ✕</button>
          </div>
        </header>

        <div class="lienzo">
          @if (url() === null) {
            <p class="esperando">Abriendo…</p>
          } @else if (url() === '') {
            <p class="esperando">No se ha podido abrir este archivo.</p>
          } @else if (actual().kind === 'pdf') {
            <iframe [src]="pdf()" [title]="actual().title"></iframe>
          } @else {
            <img [src]="url()" [alt]="actual().title" />
          }

          @if (archivos().length > 1) {
            <button class="flecha flecha--izq" (click)="mover(-1)" aria-label="Anterior">‹</button>
            <button class="flecha flecha--der" (click)="mover(1)" aria-label="Siguiente">›</button>
          }
        </div>
      </div>
    </div>
  `,
  // Esc y flechas funcionan sin tener que pinchar antes dentro del visor.
  host: {
    '(document:keydown)': 'tecla($event)',
    '(document:fullscreenchange)': 'sincronizar()',
  },
  styles: `
    .fondo {
      position: fixed; inset: 0; z-index: 50;
      background: rgba(15, 11, 5, .93);
      backdrop-filter: blur(3px);
      display: grid; place-items: center;
      padding: 16px;
    }
    .marco {
      width: min(1200px, 100%); height: min(92vh, 100%);
      display: flex; flex-direction: column; gap: 10px;
    }
    /* En pantalla completa el marco ocupa toda la pantalla, sin bandas negras. */
    .marco:fullscreen {
      width: 100%; height: 100%; max-width: none; padding: 14px;
      background: var(--noche-honda, rgba(15,11,5,.98));
    }

    .barra { display: flex; align-items: flex-end; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
    .barra .rotulo { color: var(--sepia-claro); margin: 0; }
    .barra h2 { font-size: 22px; color: var(--pergamino); margin-top: 2px; }
    .acc { display: flex; gap: 8px; }
    .acc .boton, .acc a.boton {
      color: var(--pergamino); border-color: var(--linea-noche); text-decoration: none;
    }
    .acc .boton:hover { background: rgba(239,228,205,.08); }

    .lienzo {
      position: relative; flex: 1; min-height: 0;
      display: grid; place-items: center;
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
      background: rgba(0,0,0,.35);
      overflow: hidden;
    }
    img { max-width: 100%; max-height: 100%; object-fit: contain; display: block; }
    iframe { width: 100%; height: 100%; border: 0; background: var(--pergamino); }
    .esperando { color: var(--sepia-claro); font-style: italic; }

    .flecha {
      position: absolute; top: 50%; transform: translateY(-50%);
      width: 44px; height: 64px;
      font-size: 30px; line-height: 1;
      color: var(--pergamino);
      background: rgba(23,18,8,.6);
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
    }
    .flecha:hover { background: rgba(23,18,8,.85); }
    .flecha--izq { left: 8px; }
    .flecha--der { right: 8px; }
  `,
})
export class Visor {

  readonly archivos = input.required<Archivo[]>();
  readonly indice = input(0);
  readonly cerrar = output<void>();

  private readonly mesa = inject(MesaService);
  private readonly sanitizer = inject(DomSanitizer);

  /** El marco, sobre el que se pide la pantalla completa del navegador. */
  private readonly marco = viewChild.required<ElementRef<HTMLElement>>('marco');
  /** Si estamos en pantalla completa de verdad (la del navegador, no el modal). */
  readonly completa = signal(false);

  /** El índice vivo: arranca en el que se pidió y se mueve con las flechas. */
  private readonly saltos = signal(0);
  readonly i = computed(() => {
    const n = this.archivos().length || 1;
    return (((this.indice() + this.saltos()) % n) + n) % n;
  });

  readonly actual = computed(() => this.archivos()[this.i()]);
  readonly url = computed(() => this.mesa.contenido(this.actual().id)());

  /** El iframe del PDF necesita permiso explícito para una URL blob:. */
  readonly pdf = computed(() => {
    const u = this.url();
    return u ? this.sanitizer.bypassSecurityTrustResourceUrl(u) : null;
  });

  mover(paso: number): void {
    this.saltos.update(s => s + paso);
  }

  /** Entrar o salir de la pantalla completa del navegador. */
  alternarCompleta(): void {
    if (document.fullscreenElement) {
      void document.exitFullscreen();
    } else {
      void this.marco().nativeElement.requestFullscreen?.().catch(() => {});
    }
  }

  /** El navegador puede salir de pantalla completa por su cuenta (Esc, F11…). */
  sincronizar(): void {
    this.completa.set(!!document.fullscreenElement);
  }

  tecla(e: KeyboardEvent): void {
    // En pantalla completa, Esc lo gestiona el navegador (sale de ella); no
    // cerramos también el visor, o se iría todo de golpe.
    if (e.key === 'Escape') { if (!this.completa()) this.cerrar.emit(); }
    else if (e.key === 'ArrowLeft') this.mover(-1);
    else if (e.key === 'ArrowRight') this.mover(1);
  }
}
