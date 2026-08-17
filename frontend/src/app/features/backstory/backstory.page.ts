import {
  Component, computed, inject, input, signal, viewChild, OnInit, OnDestroy,
} from '@angular/core';

import { JuegoService } from '../../core/game.service';
import { NavBar } from '../../shared/nav';
import { EditorRico } from '../../shared/rich-editor';
import { textoPlano } from '../../shared/raw-html';

/**
 * El Trasfondo: la historia del personaje escrita como un documento con
 * formato (negritas, colores, listas, títulos…). Cada personaje tiene el suyo.
 *
 * La edición la lleva `<arc-editor-rico>` (compartido con el guion de La Mesa);
 * esta página solo pone el marco: cabecera, estado de guardado, autoguardado y
 * el botón de guardar.
 */
@Component({
  selector: 'arc-trasfondo',
  imports: [NavBar, EditorRico],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Historia del personaje</p>
        <div class="titulo">
          <h1>Trasfondo{{ nombre() ? ' de ' + nombre() : '' }}</h1>
          <span class="estado" [class]="'estado--' + estado()">{{ textoEstado() }}</span>
        </div>
      </header>

      @if (cargando()) {
        <p class="aviso">Desempolvando la biografía…</p>
      } @else if (error(); as e) {
        <p class="aviso aviso--mal" role="alert">{{ e }}</p>
      }

      <div class="hoja-marco" [class.oculto]="cargando()">
        <arc-editor-rico
          [value]="cargado()"
          placeholder="El pergamino está en blanco. Empieza a escribir la historia de tu personaje…"
          (cambia)="alEscribir($event)"
          (sale)="guardar()" />
      </div>

      <div class="pie">
        <span class="cuenta">{{ palabras() }} palabra(s)</span>
        <button type="button" class="boton boton--lacre" [disabled]="guardando()"
                (click)="guardar(true)">
          {{ guardando() ? 'Guardando…' : 'Guardar' }}
        </button>
      </div>
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 14px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .titulo { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
    .titulo h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }

    .estado {
      font-family: var(--dato); font-size: 9px; letter-spacing: .12em; text-transform: uppercase;
      padding: 3px 9px; border: 1px solid var(--linea-noche); border-radius: var(--radio);
      white-space: nowrap;
    }
    .estado--guardado { color: var(--musgo); border-color: rgba(76,106,55,.4); }
    .estado--sucio { color: var(--oro); border-color: rgba(157,122,47,.45); }
    .estado--guardando { color: var(--sepia-claro); }
    .estado--error { color: #d98a7c; border-color: rgba(143,46,34,.5); }

    .hoja-marco { max-width: 820px; margin: 0 auto; }
    .hoja-marco.oculto { display: none; }

    .aviso { font-style: italic; color: var(--sepia-claro); padding: 14px 4px; }
    .aviso--mal { color: #d98a7c; font-style: normal; }

    .pie {
      display: flex; align-items: center; justify-content: space-between; gap: 12px;
      margin: 14px auto 30px; max-width: 820px;
    }
    .cuenta { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }
  `,
})
export class TrasfondoPage implements OnInit, OnDestroy {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly editor = viewChild(EditorRico);

  readonly cargando = signal(true);
  readonly guardando = signal(false);
  readonly error = signal<string | null>(null);
  readonly nombre = signal('');
  readonly ultima = signal<string>('');
  /** El HTML tal y como se cargó del backend; se pasa al editor como semilla. */
  readonly cargado = signal<string>('');

  /** guardado | sucio | guardando | error — pinta la etiqueta de estado. */
  readonly estado = signal<'guardado' | 'sucio' | 'guardando' | 'error'>('guardado');
  readonly palabras = signal(0);

  private timer: ReturnType<typeof setTimeout> | null = null;

  readonly textoEstado = computed(() => {
    switch (this.estado()) {
      case 'guardando': return 'Guardando…';
      case 'sucio':     return 'Sin guardar';
      case 'error':     return 'Error al guardar';
      default:          return this.ultima() ? 'Guardado · ' + this.ultima() : 'Guardado';
    }
  });

  ngOnInit(): void {
    // El nombre es un adorno: si falla, la pantalla sigue funcionando.
    this.juego.ficha(this.personajeId()).subscribe({
      next: f => this.nombre.set(f.name ?? ''),
      error: () => {},
    });

    this.juego.trasfondo(this.personajeId()).subscribe({
      next: b => {
        this.cargado.set(b.html ?? '');
        this.palabras.set(textoPlano(b.html).split(/\s+/).filter(Boolean).length);
        this.fijarFecha(b.updatedAt);
        this.cargando.set(false);
      },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido abrir el trasfondo.');
      },
    });
  }

  ngOnDestroy(): void {
    if (this.timer) clearTimeout(this.timer);
  }

  /** Al teclear en el editor: marca sucio, recuenta y programa el autoguardado. */
  alEscribir(html: string): void {
    this.estado.set('sucio');
    this.palabras.set(textoPlano(html).split(/\s+/).filter(Boolean).length);
    if (this.timer) clearTimeout(this.timer);
    this.timer = setTimeout(() => this.guardar(), 1500);
  }

  guardar(forzar = false): void {
    const ed = this.editor();
    if (!ed || this.guardando()) return;
    if (!forzar && this.estado() === 'guardado') return;   // nada que guardar

    if (this.timer) { clearTimeout(this.timer); this.timer = null; }
    this.guardando.set(true);
    this.estado.set('guardando');

    this.juego.guardarTrasfondo(this.personajeId(), ed.contenido()).subscribe({
      next: b => {
        this.guardando.set(false);
        this.estado.set('guardado');
        this.fijarFecha(b.updatedAt);
      },
      error: err => {
        this.guardando.set(false);
        this.estado.set('error');
        this.error.set(err?.error?.message ?? 'No se ha podido guardar el trasfondo.');
      },
    });
  }

  private fijarFecha(iso: string): void {
    if (!iso) { this.ultima.set(''); return; }
    const d = new Date(iso);
    if (isNaN(d.getTime())) { this.ultima.set(''); return; }
    this.ultima.set(d.toLocaleString('es-ES', {
      day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit',
    }));
  }
}
