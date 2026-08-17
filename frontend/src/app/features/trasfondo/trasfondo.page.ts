import {
  Component, ElementRef, computed, inject, input, signal, viewChild, OnInit, OnDestroy,
} from '@angular/core';

import { JuegoService } from '../../core/juego.service';
import { NavBar } from '../../shared/nav';

/**
 * El Trasfondo: la historia del personaje escrita como un documento con
 * formato, al estilo de un procesador de textos (negritas, colores, listas,
 * títulos…). Cada personaje tiene el suyo; se guarda como HTML en el backend.
 *
 * El editor es un `contenteditable` gobernado con `document.execCommand`. Sí,
 * execCommand está "deprecado", pero sigue funcionando en todos los navegadores
 * y es, con diferencia, la forma más corta de tener negrita/color/listas sin
 * arrastrar una librería de editor de 200 KB a un proyecto hecho a mano.
 *
 * OJO con Angular: NO usamos `[innerHTML]` para pintar el documento, porque el
 * saneador de Angular borra los estilos en línea (¡y con ellos los colores!).
 * En su lugar escribimos el HTML directamente en el `<div>` por el DOM
 * (`nativeElement.innerHTML`) y lo leemos igual al guardar.
 */
@Component({
  selector: 'arc-trasfondo',
  imports: [NavBar],
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

      <!-- ---------- barra de herramientas ---------- -->
      <div class="barra-formato" role="toolbar" aria-label="Formato">

        <!-- deshacer / rehacer -->
        <div class="grupo">
          <button type="button" class="bh" title="Deshacer" (mousedown)="frenar($event)"
                  (click)="cmd('undo')">↶</button>
          <button type="button" class="bh" title="Rehacer" (mousedown)="frenar($event)"
                  (click)="cmd('redo')">↷</button>
        </div>

        <!-- estilo de párrafo -->
        <div class="grupo">
          <select class="sel" title="Estilo de párrafo" aria-label="Estilo de párrafo"
                  (change)="bloque($any($event.target).value)">
            <option value="p">Normal</option>
            <option value="h1">Título 1</option>
            <option value="h2">Título 2</option>
            <option value="h3">Título 3</option>
            <option value="blockquote">Cita</option>
            <option value="pre">Código</option>
          </select>

          <select class="sel" title="Tipo de letra" aria-label="Tipo de letra"
                  (change)="fuente($any($event.target).value); $any($event.target).value=''">
            <option value="">Letra…</option>
            <option value="Georgia, serif">Serif</option>
            <option value="system-ui, sans-serif">Sans</option>
            <option value="'Courier New', monospace">Mono</option>
            <option value="'Brush Script MT', cursive">Manuscrita</option>
          </select>

          <select class="sel sel--corto" title="Tamaño" aria-label="Tamaño de letra"
                  (change)="tamano($any($event.target).value); $any($event.target).value=''">
            <option value="">Tamaño…</option>
            <option value="13px">Pequeño</option>
            <option value="16px">Normal</option>
            <option value="20px">Grande</option>
            <option value="26px">Enorme</option>
            <option value="34px">Gigante</option>
          </select>
        </div>

        <!-- estilos de texto -->
        <div class="grupo">
          <button type="button" class="bh bh--b" title="Negrita (Ctrl+B)" [class.on]="est().bold"
                  (mousedown)="frenar($event)" (click)="cmd('bold')">B</button>
          <button type="button" class="bh bh--i" title="Cursiva (Ctrl+I)" [class.on]="est().italic"
                  (mousedown)="frenar($event)" (click)="cmd('italic')">I</button>
          <button type="button" class="bh bh--u" title="Subrayado (Ctrl+U)" [class.on]="est().underline"
                  (mousedown)="frenar($event)" (click)="cmd('underline')">U</button>
          <button type="button" class="bh bh--s" title="Tachado" [class.on]="est().strike"
                  (mousedown)="frenar($event)" (click)="cmd('strikeThrough')">S</button>
        </div>

        <!-- color de texto -->
        <div class="grupo grupo--color">
          <span class="mini-rotulo" aria-hidden="true">A</span>
          @for (c of coloresTexto; track c) {
            <button type="button" class="muestra" [style.background]="c" [title]="'Color ' + c"
                    (mousedown)="frenar($event)" (click)="color(c)"></button>
          }
          <label class="muestra muestra--custom" title="Color personalizado">
            <span aria-hidden="true">+</span>
            <input type="color" (input)="color($any($event.target).value)" />
          </label>
        </div>

        <!-- resaltado -->
        <div class="grupo grupo--color">
          <span class="mini-rotulo mini-rotulo--marca" aria-hidden="true">▮</span>
          @for (c of coloresMarca; track c) {
            <button type="button" class="muestra" [style.background]="c" [title]="'Resaltar ' + c"
                    (mousedown)="frenar($event)" (click)="resaltar(c)"></button>
          }
          <button type="button" class="muestra muestra--quita" title="Quitar resaltado"
                  (mousedown)="frenar($event)" (click)="resaltar('transparent')">⌫</button>
        </div>

        <!-- listas e indentado -->
        <div class="grupo">
          <button type="button" class="bh" title="Lista con viñetas" [class.on]="est().ul"
                  (mousedown)="frenar($event)" (click)="cmd('insertUnorderedList')">•≡</button>
          <button type="button" class="bh" title="Lista numerada" [class.on]="est().ol"
                  (mousedown)="frenar($event)" (click)="cmd('insertOrderedList')">1.≡</button>
          <button type="button" class="bh" title="Reducir sangría" (mousedown)="frenar($event)"
                  (click)="cmd('outdent')">⇤</button>
          <button type="button" class="bh" title="Aumentar sangría" (mousedown)="frenar($event)"
                  (click)="cmd('indent')">⇥</button>
        </div>

        <!-- alineación -->
        <div class="grupo">
          <button type="button" class="bh" title="Alinear a la izquierda" [class.on]="est().alignL"
                  (mousedown)="frenar($event)" (click)="cmd('justifyLeft')">⯇</button>
          <button type="button" class="bh" title="Centrar" [class.on]="est().alignC"
                  (mousedown)="frenar($event)" (click)="cmd('justifyCenter')">≡</button>
          <button type="button" class="bh" title="Alinear a la derecha" [class.on]="est().alignR"
                  (mousedown)="frenar($event)" (click)="cmd('justifyRight')">⯈</button>
          <button type="button" class="bh" title="Justificar" [class.on]="est().alignJ"
                  (mousedown)="frenar($event)" (click)="cmd('justifyFull')">☰</button>
        </div>

        <!-- extras -->
        <div class="grupo">
          <button type="button" class="bh" title="Insertar enlace" (mousedown)="frenar($event)"
                  (click)="enlazar()">🔗</button>
          <button type="button" class="bh" title="Quitar enlace" (mousedown)="frenar($event)"
                  (click)="cmd('unlink')">⛓</button>
          <button type="button" class="bh" title="Línea separadora" (mousedown)="frenar($event)"
                  (click)="cmd('insertHorizontalRule')">―</button>
          <button type="button" class="bh" title="Limpiar formato" (mousedown)="frenar($event)"
                  (click)="limpiar()">✕ formato</button>
        </div>
      </div>

      <!-- ---------- la hoja ---------- -->
      <div class="marco">
        @if (cargando()) {
          <p class="aviso">Desempolvando la biografía…</p>
        } @else if (error(); as e) {
          <p class="aviso aviso--mal" role="alert">{{ e }}</p>
        }

        <div #lienzo class="lienzo" contenteditable="true" spellcheck="true"
             role="textbox" aria-multiline="true" aria-label="Trasfondo del personaje"
             [attr.data-vacio]="vacio() ? 'El pergamino está en blanco. Empieza a escribir la historia de tu personaje…' : null"
             (input)="alEscribir()"
             (blur)="alPerderFoco()"
             (keyup)="actualizarEstado()"
             (mouseup)="actualizarEstado()"></div>
      </div>

      <!-- ---------- pie con acciones ---------- -->
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

    /* ---- barra de herramientas ---- */
    .barra-formato {
      position: sticky; top: 44px; z-index: 5;
      display: flex; flex-wrap: wrap; gap: 6px 10px; align-items: center;
      padding: 8px 10px; margin-bottom: 12px;
      background: rgba(23, 18, 8, .94); backdrop-filter: blur(6px);
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
    }
    .grupo { display: flex; align-items: center; gap: 4px; padding-right: 8px; border-right: 1px solid var(--linea-noche); }
    .grupo:last-child { border-right: 0; padding-right: 0; }
    .grupo--color { gap: 3px; }

    .bh {
      min-width: 30px; height: 30px; padding: 0 7px;
      font-family: var(--dato); font-size: 13px; line-height: 1;
      color: var(--sepia-claro); background: transparent;
      border: 1px solid transparent; border-radius: var(--radio); cursor: pointer;
    }
    .bh:hover { color: var(--pergamino); background: rgba(239, 228, 205, .07); }
    .bh.on { color: var(--oro); border-color: rgba(157,122,47,.5); background: rgba(157,122,47,.12); }
    .bh--b { font-weight: 800; }
    .bh--i { font-style: italic; }
    .bh--u { text-decoration: underline; }
    .bh--s { text-decoration: line-through; }

    .sel {
      height: 30px; font: inherit; font-size: 12px; color: var(--pergamino);
      background: rgba(239,228,205,.06); border: 1px solid var(--linea-noche);
      border-radius: var(--radio); padding: 0 6px; max-width: 130px;
    }
    .sel--corto { max-width: 104px; }
    .sel option { color: #000; }

    .mini-rotulo { font-family: var(--titular, Georgia), serif; font-weight: 700; color: var(--sepia-claro); font-size: 14px; padding-right: 2px; }
    .mini-rotulo--marca { color: var(--oro); }
    .muestra {
      width: 20px; height: 20px; padding: 0; border-radius: 4px; cursor: pointer;
      border: 1px solid rgba(239,228,205,.25);
      display: inline-flex; align-items: center; justify-content: center;
      font-size: 11px; color: rgba(239,228,205,.7);
    }
    .muestra:hover { transform: scale(1.12); }
    .muestra--custom { position: relative; overflow: hidden; background: conic-gradient(from 0deg, #e33, #ee3, #3e3, #3ee, #33e, #e3e, #e33); color: #fff; text-shadow: 0 0 2px #000; }
    .muestra--custom input { position: absolute; inset: 0; opacity: 0; cursor: pointer; }
    .muestra--quita { background: transparent; }

    /* ---- la hoja ---- */
    .marco { position: relative; }
    .aviso { font-style: italic; color: var(--sepia-claro); padding: 14px 4px; }
    .aviso--mal { color: #d98a7c; font-style: normal; }

    .lienzo {
      min-height: 60vh;
      background: var(--pergamino, #efe4cd);
      color: var(--tinta, #2b2117);
      border: 1px solid var(--linea-fuerte);
      border-radius: var(--radio);
      box-shadow: 0 10px 30px rgba(0,0,0,.35);
      padding: 42px 52px;
      font-family: var(--cuerpo, Georgia), serif;
      font-size: 16px; line-height: 1.7;
      outline: none;
      max-width: 820px; margin: 0 auto;
    }
    .lienzo:empty::before {
      content: attr(data-vacio);
      color: var(--sepia); font-style: italic;
    }
    .lienzo:focus { border-color: var(--oro); box-shadow: 0 10px 30px rgba(0,0,0,.35), 0 0 0 2px rgba(157,122,47,.25); }

    /* tipografía dentro del documento */
    .lienzo h1 { font-size: 30px; line-height: 1.25; margin: 18px 0 10px; color: var(--tinta); border-bottom: 1px solid var(--linea); padding-bottom: 4px; }
    .lienzo h2 { font-size: 24px; line-height: 1.3; margin: 16px 0 8px; color: var(--tinta); }
    .lienzo h3 { font-size: 19px; margin: 14px 0 6px; color: var(--sepia-hondo); }
    .lienzo p { margin: 0 0 12px; }
    .lienzo blockquote {
      margin: 12px 0; padding: 6px 16px; border-left: 3px solid var(--oro);
      color: var(--sepia-hondo); font-style: italic; background: rgba(157,122,47,.06);
    }
    .lienzo pre {
      background: rgba(43,33,23,.08); border: 1px solid var(--linea);
      border-radius: var(--radio); padding: 10px 12px; overflow-x: auto;
      font-family: 'Courier New', monospace; font-size: 14px; white-space: pre-wrap;
    }
    .lienzo ul, .lienzo ol { margin: 0 0 12px; padding-left: 26px; }
    .lienzo li { margin: 2px 0; }
    .lienzo a { color: var(--vino); text-decoration: underline; }
    .lienzo hr { border: 0; border-top: 1px solid var(--linea-fuerte); margin: 18px 0; }
    .lienzo img { max-width: 100%; }

    /* ---- pie ---- */
    .pie {
      display: flex; align-items: center; justify-content: space-between; gap: 12px;
      margin: 14px auto 30px; max-width: 820px;
    }
    .cuenta { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }

    @media (max-width: 640px) {
      .lienzo { padding: 26px 20px; font-size: 15px; }
      .barra-formato { top: 0; }
    }
  `,
})
export class TrasfondoPage implements OnInit, OnDestroy {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly lienzo = viewChild<ElementRef<HTMLDivElement>>('lienzo');

  readonly cargando = signal(true);
  readonly guardando = signal(false);
  readonly error = signal<string | null>(null);
  readonly nombre = signal('');
  readonly ultima = signal<string>('');

  /** guardado | sucio | guardando | error — pinta la etiqueta de estado. */
  readonly estado = signal<'guardado' | 'sucio' | 'guardando' | 'error'>('guardado');
  readonly vacio = signal(true);
  readonly palabras = signal(0);

  /** Estado de los botones que se "encienden" según dónde esté el cursor. */
  readonly est = signal({
    bold: false, italic: false, underline: false, strike: false,
    ul: false, ol: false, alignL: false, alignC: false, alignR: false, alignJ: false,
  });

  /** Paleta cálida acorde a la piel de pergamino de la app. */
  readonly coloresTexto = ['#2b2117', '#8f2e22', '#9d7a2f', '#4c6a37', '#2f5a7a', '#5a3a7a', '#a04a1e'];
  readonly coloresMarca = ['#f4e08a', '#bfe0a0', '#a9d3e6', '#e6b8c9', '#e0cba0'];

  private timer: ReturnType<typeof setTimeout> | null = null;
  /** El último rango de selección dentro del editor, para restaurarlo tras
   *  tocar un <select> o el selector de color (que le roban el foco). */
  private rango: Range | null = null;

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
        const el = this.lienzo()?.nativeElement;
        if (el) el.innerHTML = b.html ?? '';
        this.fijarFecha(b.updatedAt);
        this.cargando.set(false);
        this.recalcular();
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

  // --- edición ---

  /** Evita que el botón robe el foco/selección al pulsar en la barra: así el
   *  comando se aplica sobre lo que había seleccionado en el editor. */
  frenar(ev: Event): void { ev.preventDefault(); }

  /** Al perder el foco: recuerda dónde estaba el cursor (para los <select>, que
   *  no pueden usar `frenar`) y aprovecha para autoguardar. */
  alPerderFoco(): void {
    const el = this.lienzo()?.nativeElement;
    const sel = window.getSelection();
    if (el && sel && sel.rangeCount && el.contains(sel.anchorNode)) {
      this.rango = sel.getRangeAt(0).cloneRange();
    }
    this.guardar();
  }

  /** Devuelve el foco al editor y restaura la selección guardada SOLO si el
   *  editor no la tiene ya (los botones la conservan; los <select> no). */
  private enfocarConSeleccion(): void {
    const el = this.lienzo()?.nativeElement;
    if (!el) return;
    if (document.activeElement !== el) {
      el.focus();
      if (this.rango) {
        const sel = window.getSelection();
        sel?.removeAllRanges();
        sel?.addRange(this.rango);
      }
    }
  }

  /** Ejecuta un comando de formato sobre la selección actual. */
  cmd(comando: string, valor?: string): void {
    const el = this.lienzo()?.nativeElement;
    if (!el) return;
    this.enfocarConSeleccion();
    // styleWithCSS = true → color/fuente salen como <span style>, no como <font>.
    try { document.execCommand('styleWithCSS', false, 'true'); } catch { /* algún navegador no lo soporta */ }
    document.execCommand(comando, false, valor);
    this.alEscribir();
    this.actualizarEstado();
  }

  bloque(tag: string): void {
    if (!tag) return;
    this.cmd('formatBlock', tag === 'p' ? 'p' : tag);
  }

  fuente(familia: string): void {
    if (!familia) return;
    this.cmd('fontName', familia);
  }

  color(c: string): void { this.cmd('foreColor', c); }

  resaltar(c: string): void {
    const el = this.lienzo()?.nativeElement;
    if (!el) return;
    this.enfocarConSeleccion();
    try { document.execCommand('styleWithCSS', false, 'true'); } catch { /* ignore */ }
    // hiliteColor es el estándar; algunos navegadores solo entienden backColor.
    if (!document.execCommand('hiliteColor', false, c))
      document.execCommand('backColor', false, c);
    this.alEscribir();
  }

  /** Tamaño real en px. execCommand('fontSize') solo admite 1-7, así que usamos
   *  el 7 como marca y sustituimos los <font> resultantes por spans con el px. */
  tamano(px: string): void {
    const el = this.lienzo()?.nativeElement;
    if (!px || !el) return;
    this.enfocarConSeleccion();
    try { document.execCommand('styleWithCSS', false, 'false'); } catch { /* ignore */ }
    document.execCommand('fontSize', false, '7');
    el.querySelectorAll('font[size="7"]').forEach(f => {
      const span = document.createElement('span');
      span.style.fontSize = px;
      while (f.firstChild) span.appendChild(f.firstChild);
      f.replaceWith(span);
    });
    this.alEscribir();
  }

  enlazar(): void {
    const url = window.prompt('Dirección del enlace (https://…):', 'https://');
    if (url && url.trim() && url.trim() !== 'https://') this.cmd('createLink', url.trim());
  }

  limpiar(): void {
    this.cmd('removeFormat');
    // removeFormat no toca bloques ni listas; devolvemos el párrafo a normal.
    this.cmd('formatBlock', 'p');
  }

  // --- estado del cursor (botones encendidos) ---

  actualizarEstado(): void {
    try {
      this.est.set({
        bold: document.queryCommandState('bold'),
        italic: document.queryCommandState('italic'),
        underline: document.queryCommandState('underline'),
        strike: document.queryCommandState('strikeThrough'),
        ul: document.queryCommandState('insertUnorderedList'),
        ol: document.queryCommandState('insertOrderedList'),
        alignL: document.queryCommandState('justifyLeft'),
        alignC: document.queryCommandState('justifyCenter'),
        alignR: document.queryCommandState('justifyRight'),
        alignJ: document.queryCommandState('justifyFull'),
      });
    } catch { /* fuera del editor no pasa nada */ }
  }

  // --- guardado ---

  /** Al teclear: marca sucio, recalcula adornos y programa el autoguardado. */
  alEscribir(): void {
    this.estado.set('sucio');
    this.recalcular();
    if (this.timer) clearTimeout(this.timer);
    this.timer = setTimeout(() => this.guardar(), 1500);
  }

  guardar(forzar = false): void {
    const el = this.lienzo()?.nativeElement;
    if (!el || this.guardando()) return;
    if (!forzar && this.estado() === 'guardado') return;   // nada que guardar

    if (this.timer) { clearTimeout(this.timer); this.timer = null; }
    const html = el.innerHTML;
    this.guardando.set(true);
    this.estado.set('guardando');

    this.juego.guardarTrasfondo(this.personajeId(), html).subscribe({
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

  // --- utilidades ---

  private recalcular(): void {
    const el = this.lienzo()?.nativeElement;
    const texto = (el?.innerText ?? '').trim();
    this.vacio.set(texto.length === 0);
    this.palabras.set(texto ? texto.split(/\s+/).length : 0);
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
