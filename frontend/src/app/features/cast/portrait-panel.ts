import { Component, computed, inject, input, output, signal } from '@angular/core';

import { ElencoService } from '../../core/cast.service';
import { Elenco, Pnj } from '../../core/cast.types';
import { Retrato } from './portrait';

/** Lo que acepta el backend como retrato: el armario de La Mesa, sin el PDF. */
const ACEPTA = 'image/jpeg,image/png,image/webp,image/gif';

/**
 * La columna del retrato: la lámina vertical y, si quien mira dirige la mesa,
 * lo que se puede hacer con ella (subirla, cambiarla, quitarla y decidir si ya
 * le han visto la cara).
 *
 * Está suelta porque la quieren dos pantallas: el expediente, donde se lee, y
 * el editor, donde se escribe. Duplicar la subida en las dos era la forma
 * segura de que una de las dos se quedara sin arreglar el día que cambie algo.
 */
@Component({
  selector: 'arc-retrato-panel',
  imports: [Retrato],
  template: `
    <arc-retrato [npcId]="pnj().id" [hay]="pnj().portrait" [nombre]="pnj().name" />

    @if (dm()) {
      <input #foto type="file" [accept]="ACEPTA" hidden (change)="elegida($event)" />
      <div class="acc">
        @if (pnj().reveal; as rev) {
          <button type="button" class="sello" [class.sello--visto]="rev.portrait"
                  [disabled]="ocupado()" (click)="revelar()">
            {{ rev.portrait ? 'Cara vista' : 'Cara sellada' }}
          </button>
        }
        <button type="button" class="mini" [disabled]="ocupado()" (click)="foto.click()">
          {{ subiendo() ? 'Subiendo…' : (pnj().portrait ? 'Cambiar' : 'Subir foto') }}
        </button>
        @if (pnj().portrait) {
          <button type="button" class="mini mini--mal" [disabled]="ocupado()" (click)="quitar()">
            Quitar
          </button>
        }
      </div>
      @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }
    }
  `,
  styles: `
    :host { display: block; }
    .acc {
      display: flex; flex-wrap: wrap; gap: 6px;
      padding: 10px 12px; border-top: 1px solid var(--linea);
    }
    .sello, .mini {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; padding: 4px 8px;
      border: 1px solid var(--linea); border-radius: var(--radio);
      background: transparent; color: var(--sepia); white-space: nowrap;
    }
    .sello { border-color: rgba(143,46,34,.4); color: var(--vino); }
    .sello:hover:not(:disabled) { background: rgba(143,46,34,.08); }
    .sello--visto { border-color: rgba(76,106,55,.5); color: var(--musgo); }
    .sello--visto:hover:not(:disabled) { background: rgba(76,106,55,.08); }
    .mini:hover:not(:disabled) { color: var(--tinta); background: rgba(43,33,23,.06); }
    .mini--mal { color: var(--vino); border-color: rgba(143,46,34,.35); }
    .mal { color: var(--vino); font-size: 14px; margin: 0; padding: 0 12px 10px; }
  `,
})
export class RetratoPanel {

  readonly pnj = input.required<Pnj>();
  readonly dm = input(false);

  /** Subir, quitar o revelar devuelve el elenco entero ya actualizado. */
  readonly cambiado = output<Elenco>();

  protected readonly ACEPTA = ACEPTA;

  private readonly elenco = inject(ElencoService);

  readonly subiendo = signal(false);
  readonly sellando = signal(false);
  readonly error = signal<string | null>(null);

  readonly ocupado = computed(() => this.subiendo() || this.sellando());

  elegida(e: Event): void {
    const campo = e.target as HTMLInputElement;
    const file = campo.files?.[0];
    campo.value = '';                    // para poder volver a elegir el mismo
    if (!file) return;

    this.subiendo.set(true);
    this.error.set(null);
    this.elenco.subirRetrato(this.pnj().id, file).subscribe({
      next: r => { this.subiendo.set(false); this.cambiado.emit(r); },
      error: err => {
        this.subiendo.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido subir el retrato.');
      },
    });
  }

  quitar(): void {
    this.sellando.set(true);
    this.elenco.quitarRetrato(this.pnj().id).subscribe({
      next: r => { this.sellando.set(false); this.cambiado.emit(r); },
      error: () => { this.sellando.set(false); this.error.set('No se ha podido quitar el retrato.'); },
    });
  }

  revelar(): void {
    this.sellando.set(true);
    this.elenco.revelar(this.pnj().id, 'portrait').subscribe({
      next: r => { this.sellando.set(false); this.cambiado.emit(r); },
      error: () => { this.sellando.set(false); this.error.set('No se ha podido cambiar el sello.'); },
    });
  }
}
