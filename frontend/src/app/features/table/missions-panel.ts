import { Component, computed, inject, output, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { MesaService } from '../../core/table.service';
import { ESTADOS, EstadoMision, TarjetaMision } from '../../core/table.types';
import { Lamina } from './plate';

const norm = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');

/** Lo que se está escribiendo en la ficha de alta/edición. */
interface Borrador {
  id: string | null;          // null = misión nueva
  title: string;
  summary: string;
  status: EstadoMision;
  tags: string;
  sessionDate: string;
}

const EN_BLANCO: Borrador = {
  id: null, title: '', summary: '', status: 'idea', tags: '', sessionDate: '',
};

/**
 * La rejilla de misiones: una tarjeta por partida en preparación, con su
 * miniatura, su sello de estado y lo que lleva dentro.
 *
 * El orden lo pone el backend (por estado y por fecha de sesión), así que lo
 * primero que se ve arriba a la izquierda es lo que toca preparar antes. Aquí
 * solo se filtra y se busca.
 */
@Component({
  selector: 'arc-misiones-panel',
  imports: [FormsModule, Lamina],
  template: `
    <!-- ---------- barra de mando ---------- -->
    <div class="mando">
      <input class="buscar" type="search" placeholder="Buscar por título, resumen o etiqueta…"
             [(ngModel)]="busqueda" aria-label="Buscar misión" />
      <button class="boton boton--lacre" (click)="nueva()">+ Misión nueva</button>
    </div>

    <div class="filtros" role="group" aria-label="Filtrar por estado">
      <button class="chip" [class.activo]="filtro() === 'todas'" (click)="filtro.set('todas')">
        Todas <span class="cuenta">{{ misiones().length }}</span>
      </button>
      @for (e of estados(); track e) {
        <button class="chip" [class]="'chip chip--' + e" [class.activo]="filtro() === e"
                (click)="filtro.set(e)">
          {{ nombreEstado(e) }} <span class="cuenta">{{ cuenta(e) }}</span>
        </button>
      }
    </div>

    <!-- ---------- ficha de alta / edición ---------- -->
    @if (borrador(); as b) {
      <section class="hoja ficha">
        <p class="rotulo">{{ b.id ? 'Editar misión' : 'Misión nueva' }}</p>

        <label class="campo">
          <span class="etiqueta">Título</span>
          <input [ngModel]="b.title" (ngModelChange)="cambiar('title', $event)"
                 placeholder="El silencio de las minas" (keydown.enter)="guardar()" />
        </label>

        <label class="campo">
          <span class="etiqueta">De qué va</span>
          <textarea rows="2" [ngModel]="b.summary" (ngModelChange)="cambiar('summary', $event)"
                    placeholder="El gancho en una línea: lo que verás tú al abrir la tarjeta."></textarea>
        </label>

        <div class="fila">
          <label class="campo">
            <span class="etiqueta">Estado</span>
            <select [ngModel]="b.status" (ngModelChange)="cambiar('status', $event)">
              @for (e of estados(); track e) { <option [value]="e">{{ nombreEstado(e) }}</option> }
            </select>
          </label>
          <label class="campo">
            <span class="etiqueta">Se juega el</span>
            <input type="date" [ngModel]="b.sessionDate"
                   (ngModelChange)="cambiar('sessionDate', $event)" />
          </label>
          <label class="campo">
            <span class="etiqueta">Etiquetas</span>
            <input [ngModel]="b.tags" (ngModelChange)="cambiar('tags', $event)"
                   placeholder="dorakan, minas, nivel 3" />
          </label>
        </div>

        <div class="acciones">
          <button class="boton boton--lacre" [disabled]="!b.title.trim() || ocupado()"
                  (click)="guardar()">{{ b.id ? 'Guardar cambios' : 'Crear misión' }}</button>
          <button class="boton" (click)="borrador.set(null)">Cancelar</button>
        </div>
      </section>
    }

    @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

    <!-- ---------- rejilla ---------- -->
    @if (cargando()) {
      <p class="vacio">Abriendo la mesa…</p>
    } @else if (visibles().length === 0) {
      <div class="hoja vacia">
        @if (misiones().length === 0) {
          <h2>La mesa está despejada</h2>
          <p>Aquí van las partidas que estés preparando: una tarjeta por misión, con su mapa
             de portada, el guion y los PDF que hagan falta.</p>
          <button class="boton boton--lacre" (click)="nueva()">Crear la primera</button>
        } @else {
          <h2>Nada con ese filtro</h2>
          <p>Prueba con otro estado o borra la búsqueda.</p>
        }
      </div>
    } @else {
      <ul class="rejilla">
        @for (m of visibles(); track m.id) {
          <li>
            <article class="carta hoja" [class.carta--jugada]="m.status === 'jugada'">
              <button class="tapa" (click)="abrir.emit(m.id)"
                      [attr.aria-label]="'Abrir ' + m.title">
                <arc-lamina [assetId]="m.coverId" [alt]="m.title" />
                <span class="sello" [class]="'sello sello--' + m.status">{{ nombreEstado(m.status) }}</span>
              </button>

              <div class="cuerpo">
                <h2><button class="titulo" (click)="abrir.emit(m.id)">{{ m.title }}</button></h2>
                @if (m.summary) { <p class="resumen">{{ m.summary }}</p> }
                @if (m.tags.length) {
                  <ul class="etiquetas">
                    @for (t of m.tags; track t) { <li>{{ t }}</li> }
                  </ul>
                }
              </div>

              <footer class="pie">
                <p class="dato">{{ contenido(m) }}</p>
                @if (m.sessionDate) { <p class="dato fecha">{{ fecha(m.sessionDate) }}</p> }
              </footer>

              @if (confirmando() === m.id) {
                <div class="confirmar">
                  <p>¿Borrar «{{ m.title }}»? El guion se pierde; el material vuelve a la biblioteca.</p>
                  <div class="acciones">
                    <button class="boton boton--lacre" [disabled]="ocupado()"
                            (click)="borrar(m.id)">Sí, borrar</button>
                    <button class="boton" (click)="confirmando.set(null)">No</button>
                  </div>
                </div>
              } @else {
                <div class="acc">
                  <button class="boton" (click)="abrir.emit(m.id)">Abrir</button>
                  <button class="boton" (click)="editar(m)">Editar</button>
                  <button class="boton boton--peligro" (click)="confirmando.set(m.id)"
                          [attr.aria-label]="'Eliminar ' + m.title">Eliminar</button>
                </div>
              }
            </article>
          </li>
        }
      </ul>
    }
  `,
  styles: `
    /* ---------------------------------------------------------- barra ------ */
    .mando { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; margin-bottom: 12px; }
    .buscar { flex: 1; min-width: 220px; }

    .filtros { display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 20px; }
    .chip {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--sepia-claro); background: transparent;
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
      padding: 7px 11px;
    }
    .chip:hover { color: var(--pergamino); background: rgba(239,228,205,.06); }
    .chip.activo { color: var(--pergamino); background: rgba(239,228,205,.10); border-color: var(--sepia); }
    .chip .cuenta { opacity: .6; margin-left: 5px; }
    .chip--preparando.activo { border-color: rgba(157,122,47,.6); }
    .chip--lista.activo     { border-color: rgba(76,106,55,.6); }
    .chip--jugada.activo    { border-color: rgba(143,46,34,.6); }

    /* ---------------------------------------------------------- ficha ------ */
    .ficha { padding: 18px; margin-bottom: 22px; display: grid; gap: 12px; }
    .ficha .rotulo { color: var(--sepia); margin: 0; }
    .campo { display: block; }
    .etiqueta {
      display: block; font-family: var(--dato); font-size: 10px; letter-spacing: .14em;
      text-transform: uppercase; color: var(--sepia); margin-bottom: 5px;
    }
    .fila { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; }
    textarea, select {
      font: inherit; width: 100%; padding: 11px 12px;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-claro); color: var(--tinta);
    }
    textarea { resize: vertical; }
    .acciones { display: flex; gap: 8px; flex-wrap: wrap; }

    /* ---------------------------------------------------------- rejilla ---- */
    .rejilla {
      list-style: none; margin: 0; padding: 0;
      display: grid; gap: 18px;
      grid-template-columns: repeat(auto-fill, minmax(258px, 1fr));
    }

    .carta {
      display: flex; flex-direction: column; height: 100%;
      overflow: hidden;
      transition: transform .15s ease, box-shadow .15s ease;
    }
    .carta:hover { transform: translateY(-2px); box-shadow: 0 1px 0 rgba(255,255,255,.35) inset, 0 16px 34px rgba(0,0,0,.5); }
    /* Lo ya jugado se apaga: sigue ahí para consultarlo, pero no compite. */
    .carta--jugada { opacity: .62; }
    .carta--jugada:hover { opacity: 1; }

    .tapa {
      position: relative; display: block; width: 100%; padding: 0;
      border: 0; background: none; cursor: pointer;
    }
    arc-lamina { height: 148px; }

    /* El sello de estado: lacre en la esquina, como en un documento sellado. */
    .sello {
      position: absolute; top: 8px; right: 8px;
      font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase;
      padding: 4px 8px; border-radius: var(--radio);
      background: rgba(23,18,8,.82); color: var(--pergamino);
      border: 1px solid var(--linea-noche);
    }
    .sello--idea       { color: #cbb994; }
    .sello--preparando { color: #d7a94a; border-color: rgba(157,122,47,.6); }
    .sello--lista      { color: #8fb46a; border-color: rgba(76,106,55,.7); }
    .sello--jugada     { color: #d98a7c; border-color: rgba(143,46,34,.6); }

    .cuerpo { padding: 12px 14px 6px; flex: 1; }
    .titulo {
      font: inherit; text-align: left; padding: 0; border: 0; background: none;
      color: var(--tinta); font-family: var(--display); font-size: 20px; line-height: 1.2;
    }
    .titulo:hover { color: var(--vino); }
    .resumen {
      color: var(--sepia-hondo); font-size: 15px; margin: 6px 0 0;
      display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;
    }

    .etiquetas { list-style: none; display: flex; gap: 5px; flex-wrap: wrap; margin: 10px 0 0; padding: 0; }
    .etiquetas li {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia); border: 1px solid var(--linea); border-radius: var(--radio);
      padding: 2px 6px;
    }

    .pie {
      display: flex; justify-content: space-between; gap: 8px; flex-wrap: wrap;
      padding: 8px 14px; border-top: 1px solid var(--linea-clara); margin-top: 10px;
    }
    .pie .dato { color: var(--sepia); text-transform: uppercase; margin: 0; }
    .fecha { color: var(--sepia-hondo); }

    .acc { display: flex; gap: 6px; padding: 0 14px 14px; flex-wrap: wrap; }
    .acc .boton { font-size: 10px; padding: 8px 11px; letter-spacing: .1em; }
    .boton--peligro { color: var(--vino); border-color: rgba(143,46,34,.35); }
    .boton--peligro:hover:not(:disabled) { background: rgba(143,46,34,.08); }

    .confirmar { padding: 0 14px 14px; }
    .confirmar p { color: var(--sepia-hondo); font-size: 14px; margin: 0 0 10px; }

    /* ---------------------------------------------------------- vacíos ----- */
    .vacia { padding: 30px 22px; text-align: center; }
    .vacia h2 { font-size: 22px; color: var(--tinta); }
    .vacia p { color: var(--sepia-hondo); margin: 8px auto 16px; max-width: 46ch; }
    .vacio { color: var(--sepia-claro); font-style: italic; padding: 20px 0; }

    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 0 0 14px; }
  `,
})
export class MisionesPanel implements OnInit {

  /** El DM ha pulsado una tarjeta: que la página abra el detalle. */
  readonly abrir = output<string>();

  private readonly mesa = inject(MesaService);

  readonly misiones = signal<TarjetaMision[]>([]);
  readonly estados = signal<EstadoMision[]>(['idea', 'preparando', 'lista', 'jugada']);
  readonly filtro = signal<EstadoMision | 'todas'>('todas');
  readonly busqueda = signal('');
  readonly borrador = signal<Borrador | null>(null);
  readonly confirmando = signal<string | null>(null);
  readonly cargando = signal(true);
  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);

  readonly visibles = computed(() => {
    const q = norm(this.busqueda().trim());
    const f = this.filtro();
    return this.misiones().filter(m => {
      if (f !== 'todas' && m.status !== f) return false;
      if (!q) return true;
      return norm(m.title + ' ' + m.summary + ' ' + m.tags.join(' ')).includes(q);
    });
  });

  ngOnInit(): void { this.cargar(); }

  cuenta(e: EstadoMision): number {
    return this.misiones().filter(m => m.status === e).length;
  }

  nombreEstado(e: EstadoMision): string { return ESTADOS[e]; }

  /** "3 láminas · 1 PDF · 5 pasos", saltando lo que esté a cero. */
  contenido(m: TarjetaMision): string {
    const partes: string[] = [];
    if (m.imageCount) partes.push(m.imageCount + (m.imageCount === 1 ? ' lámina' : ' láminas'));
    if (m.pdfCount) partes.push(m.pdfCount + ' PDF');
    if (m.noteCount) partes.push(m.noteCount + (m.noteCount === 1 ? ' paso' : ' pasos'));
    return partes.length ? partes.join(' · ') : 'Vacía';
  }

  fecha(iso: string): string {
    const d = new Date(iso + 'T00:00:00');
    return d.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' });
  }

  nueva(): void {
    this.confirmando.set(null);
    this.borrador.set({ ...EN_BLANCO });
  }

  editar(m: TarjetaMision): void {
    this.confirmando.set(null);
    this.borrador.set({
      id: m.id, title: m.title, summary: m.summary, status: m.status,
      tags: m.tags.join(', '), sessionDate: m.sessionDate ?? '',
    });
  }

  cambiar<K extends keyof Borrador>(campo: K, valor: Borrador[K]): void {
    this.borrador.update(b => (b ? { ...b, [campo]: valor } : b));
  }

  guardar(): void {
    const b = this.borrador();
    if (!b || !b.title.trim()) return;

    const req = {
      title: b.title.trim(), summary: b.summary.trim(), status: b.status,
      tags: b.tags.trim(), sessionDate: b.sessionDate,
    };
    this.ocupado.set(true);
    this.error.set(null);

    const peticion = b.id
      ? this.mesa.editarMision(b.id, req)
      : this.mesa.crearMision(req);

    peticion.subscribe({
      next: () => { this.ocupado.set(false); this.borrador.set(null); this.cargar(); },
      error: err => { this.ocupado.set(false); this.fallo(err); },
    });
  }

  borrar(id: string): void {
    this.ocupado.set(true);
    this.mesa.borrarMision(id).subscribe({
      next: v => {
        this.ocupado.set(false);
        this.confirmando.set(null);
        this.misiones.set(v.misiones);
      },
      error: err => { this.ocupado.set(false); this.fallo(err); },
    });
  }

  /** Recarga la rejilla; la llama también la página al volver del detalle. */
  cargar(): void {
    this.mesa.misiones().subscribe({
      next: v => {
        this.misiones.set(v.misiones);
        if (v.estados?.length) this.estados.set(v.estados);
        this.cargando.set(false);
      },
      error: err => { this.cargando.set(false); this.fallo(err); },
    });
  }

  private fallo(err: any): void {
    this.error.set(err?.error?.message ?? 'Algo ha ido mal en la mesa.');
  }
}
