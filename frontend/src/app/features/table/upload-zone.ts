import { Component, inject, input, output, signal } from '@angular/core';

import { MesaService } from '../../core/mesa.service';
import { Archivo } from '../../core/mesa.types';

/** Lo que acepta el backend (MesaStorage.ADMITIDOS). */
const ACEPTA = 'image/jpeg,image/png,image/webp,image/gif,application/pdf';
const MAX_MB = 25;

/**
 * El sitio donde se sueltan los archivos. Arrastrar y soltar, o pulsar para
 * abrir el explorador — las dos, porque en el móvil no se arrastra.
 *
 * Sube de uno en uno y va avisando: con 12 mapas de golpe, ver "3 de 12" es la
 * diferencia entre esperar tranquilo y pensar que se ha colgado.
 */
@Component({
  selector: 'arc-zona-subida',
  template: `
    <div class="zona" [class.encima]="encima()" [class.ocupada]="subiendo()"
         (dragover)="sobre($event)" (dragleave)="fuera($event)" (drop)="soltar($event)">
      <input #campo type="file" [accept]="ACEPTA" multiple hidden
             (change)="elegidos($event)" />

      @if (subiendo()) {
        <p class="titular">Subiendo {{ hecho() + 1 }} de {{ total() }}…</p>
        <p class="pie">{{ actual() }}</p>
      } @else {
        <p class="titular">{{ titulo() }}</p>
        <p class="pie">Arrastra aquí imágenes o PDF · máximo {{ MAX_MB }} MB</p>
        <button class="boton" type="button" (click)="campo.click()">Elegir archivos</button>
      }
    </div>

    @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }
  `,
  styles: `
    .zona {
      border: 1px dashed var(--linea-fuerte);
      border-radius: var(--radio);
      background: rgba(239,228,205,.04);
      padding: 22px 16px;
      text-align: center;
      transition: background .15s ease, border-color .15s ease;
    }
    .zona.encima { border-color: var(--oro); background: rgba(157,122,47,.12); }
    .zona.ocupada { opacity: .8; }

    .titular { font-family: var(--display); font-size: 18px; color: var(--pergamino); margin: 0; }
    .pie {
      font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia-claro); margin: 6px 0 12px;
    }
    .zona .boton { color: var(--pergamino); border-color: var(--linea-noche); }
    .zona .boton:hover { background: rgba(239,228,205,.08); }

    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 10px 0 0; }
  `,
})
export class ZonaSubida {

  /** A qué misión entran. null = a la biblioteca general. */
  readonly misionId = input<string | null>(null);
  readonly titulo = input('Suelta aquí el material');

  /** Se emite una vez por archivo subido, con su ficha ya guardada. */
  readonly subido = output<Archivo>();

  protected readonly ACEPTA = ACEPTA;
  protected readonly MAX_MB = MAX_MB;

  private readonly mesa = inject(MesaService);

  readonly encima = signal(false);
  readonly subiendo = signal(false);
  readonly total = signal(0);
  readonly hecho = signal(0);
  readonly actual = signal('');
  readonly error = signal<string | null>(null);

  sobre(e: DragEvent): void {
    e.preventDefault();
    this.encima.set(true);
  }

  fuera(e: DragEvent): void {
    e.preventDefault();
    this.encima.set(false);
  }

  soltar(e: DragEvent): void {
    e.preventDefault();
    this.encima.set(false);
    const files = Array.from(e.dataTransfer?.files ?? []);
    if (files.length) void this.subirTodos(files);
  }

  elegidos(e: Event): void {
    const campo = e.target as HTMLInputElement;
    const files = Array.from(campo.files ?? []);
    campo.value = '';   // para poder volver a elegir el mismo archivo
    if (files.length) void this.subirTodos(files);
  }

  /** De uno en uno: así el contador dice la verdad y el servidor no se atraganta. */
  private async subirTodos(files: File[]): Promise<void> {
    this.error.set(null);
    this.subiendo.set(true);
    this.total.set(files.length);
    this.hecho.set(0);

    const fallos: string[] = [];
    for (const f of files) {
      this.actual.set(f.name);
      if (f.size > MAX_MB * 1024 * 1024) {
        fallos.push(`${f.name} (pasa de ${MAX_MB} MB)`);
      } else {
        try {
          this.subido.emit(await this.subirUno(f));
        } catch (err: any) {
          fallos.push(`${f.name} (${err?.error?.message ?? 'no se pudo subir'})`);
        }
      }
      this.hecho.update(n => n + 1);
    }

    this.subiendo.set(false);
    this.actual.set('');
    if (fallos.length) this.error.set('No entraron: ' + fallos.join(', '));
  }

  private subirUno(f: File): Promise<Archivo> {
    return new Promise((resolve, reject) => {
      this.mesa.subir(f, this.misionId()).subscribe({ next: resolve, error: reject });
    });
  }
}
