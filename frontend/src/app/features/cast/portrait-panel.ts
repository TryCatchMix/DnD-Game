import { Component, computed, inject, input, output, signal } from '@angular/core';

import { ElencoService } from '../../core/cast.service';
import { Elenco, Pnj, Quien } from '../../core/cast.types';
import { Retrato } from './portrait';
import { RetratoAmpliado } from './retrato-ampliado';

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
  imports: [Retrato, RetratoAmpliado],
  template: `
    <arc-retrato [npcId]="pnj().id" [hay]="pnj().portrait" [nombre]="pnj().name"
                 [ampliable]="ampliable()" (abrir)="ampliada.set($event)" />

    <!-- La cara en grande. Vive aquí y no dentro de <arc-retrato> porque aquel
         tiene container-type y atraparía el overlay fijo; este :host no. -->
    @if (ampliada(); as u) {
      <arc-retrato-ampliado [src]="u" [nombre]="pnj().name" (cerrar)="ampliada.set(null)" />
    }

    @if (dm()) {
      <input #foto type="file" [accept]="ACEPTA" hidden (change)="elegida($event)" />
      <div class="acc">
        @if (pnj().reveal; as rev) {
          <button type="button" class="sello" [class.sello--visto]="rev.portrait"
                  [class.sello--parcial]="!rev.portrait && vistos().length > 0"
                  [disabled]="ocupado()" (click)="revelar()"
                  [title]="rev.portrait ? 'Sellarla para todos' : 'Enseñársela a toda la mesa'">
            {{ rev.portrait ? 'Vista por todos'
               : vistos().length > 0 ? 'Vista por ' + vistos().length : 'Cara sellada' }}
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

      <!-- Jugador a jugador: la exploradora se asomó al callejón y le vio la
           cara; los demás estaban en la taberna. Solo tiene sentido si hay
           retrato y gente a la que enseñárselo. -->
      @if (pnj().portrait && jugadores().length > 0) {
        <fieldset class="vistos" [disabled]="ocupado()">
          <legend>¿Quién le ha visto la cara?</legend>
          @for (j of jugadores(); track j.id) {
            <label class="casilla">
              <input type="checkbox" [checked]="haVisto(j.id)" (change)="alternar(j.id)" />
              <span>{{ j.name }}</span>
            </label>
          }
        </fieldset>
      }
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
    .sello--parcial { border-color: rgba(157,122,47,.5); color: var(--oro); }
    .sello--parcial:hover:not(:disabled) { background: rgba(157,122,47,.08); }

    .vistos {
      margin: 0; padding: 8px 12px 10px; border: 0; border-top: 1px dashed var(--linea);
      display: grid; gap: 4px;
    }
    .vistos legend {
      padding: 8px 0 2px; float: left; width: 100%;
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia);
    }
    .casilla { display: flex; align-items: center; gap: 8px; font-size: 14px; color: var(--tinta); }
    .casilla input { width: auto; padding: 0; accent-color: var(--musgo); }
    .mini:hover:not(:disabled) { color: var(--tinta); background: rgba(43,33,23,.06); }
    .mini--mal { color: var(--vino); border-color: rgba(143,46,34,.35); }
    .mal { color: var(--vino); font-size: 14px; margin: 0; padding: 0 12px 10px; }
  `,
})
export class RetratoPanel {

  readonly pnj = input.required<Pnj>();
  readonly dm = input(false);
  /** Los jugadores de la mesa (usuarios). Solo le llegan al máster. */
  readonly jugadores = input<Quien[]>([]);
  /** Si al pinchar la cara se abre a pantalla completa. Lo enciende el
   *  expediente; en el editor no hace falta. */
  readonly ampliable = input(false);

  /** Subir, quitar o revelar devuelve el elenco entero ya actualizado. */
  readonly cambiado = output<Elenco>();

  protected readonly ACEPTA = ACEPTA;

  private readonly elenco = inject(ElencoService);

  readonly subiendo = signal(false);
  readonly sellando = signal(false);
  readonly error = signal<string | null>(null);

  /** La URL de la cara mientras está abierta en grande; null si está cerrada. */
  readonly ampliada = signal<string | null>(null);

  readonly ocupado = computed(() => this.subiendo() || this.sellando());

  /** Quién la ha visto a solas (sin contar el «vista por todos»). */
  readonly vistos = computed(() => this.pnj().vistoPor ?? []);

  haVisto(userId: string): boolean {
    return !!this.pnj().reveal?.portrait || this.vistos().includes(userId);
  }

  /**
   * Marcar o desmarcar a uno. Si la cara estaba vista por todos, desmarcar a
   * uno la pasa a «todos menos él»: la lista se manda entera y a partir de
   * ahí manda ella.
   */
  alternar(userId: string): void {
    const antes = this.pnj().reveal?.portrait
      ? this.jugadores().map(j => j.id)
      : this.vistos();
    const despues = antes.includes(userId)
      ? antes.filter(id => id !== userId)
      : [...antes, userId];

    this.sellando.set(true);
    this.error.set(null);
    this.elenco.vistos(this.pnj().id, despues).subscribe({
      next: r => { this.sellando.set(false); this.cambiado.emit(r); },
      error: err => {
        this.sellando.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido guardar quién la ha visto.');
      },
    });
  }

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
