import { Component, inject, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { JuegoService } from '../../core/juego.service';
import { QuestSummary, ValidationReport } from '../../core/api.types';

const PLANTILLA = `{
  "code": "mi_encargo",
  "title": "Título del encargo",
  "hook": "El gancho que se lee en el tablón.",
  "location": "Dorakan",
  "faction": "",
  "vigorCost": 1,
  "duration": "3 h",
  "rewardNote": "40 po",
  "skills": ["Trepar"],
  "scenes": [
    {
      "key": "inicio",
      "title": "La primera escena",
      "body": "Lo que ve el personaje al llegar.",
      "options": [
        {
          "label": "Una opción con tirada",
          "skill": "trepar", "dc": 15, "vigorCost": 1, "risk": "MEDIUM",
          "modifiers": [{ "label": "Terreno difícil", "value": -2 }],
          "outcomes": {
            "1": { "text": "Desastre.", "end": true },
            "2": { "text": "Fallo.", "end": true },
            "3": { "text": "Éxito con coste.", "next": "final" },
            "4": { "text": "Éxito.", "next": "final" },
            "5": { "text": "Éxito rotundo.", "next": "final" }
          }
        },
        {
          "label": "Marcharse sin más",
          "vigorCost": 0,
          "outcomes": { "4": { "text": "Lo dejas para otro día.", "end": true } }
        }
      ]
    },
    {
      "key": "final",
      "title": "El desenlace",
      "body": "Cómo termina.",
      "final": true,
      "options": [
        {
          "label": "Cerrar el encargo",
          "vigorCost": 0,
          "outcomes": { "4": { "text": "Hecho.", "end": true } }
        }
      ]
    }
  ]
}`;

/**
 * Editor de encargos: se escribe un encargo en JSON, se comprueba, se guarda y
 * se publica. Lo publicado sale jugable en el tablón al instante. Vive dentro
 * del panel de administración (sin barra propia).
 */
@Component({
  selector: 'arc-encargos-panel',
  imports: [FormsModule],
  template: `
    <header class="cabecera">
      <p class="rotulo">Editor de encargos · Los Archivos</p>
      <p class="intro">Escribe un encargo, compruébalo y publícalo. Lo publicado sale jugable en el tablón.</p>
    </header>

    <!-- Lista -->
    <p class="rotulo separador">Encargos</p>
    @if (encargos().length === 0) {
      <p class="estado">Aún no hay encargos.</p>
    } @else {
      <ul class="lista">
        @for (q of encargos(); track q.code) {
          <li class="hoja fila">
            <div class="info">
              <h2>{{ q.title }}</h2>
              <p class="meta">
                {{ q.code }} · {{ q.location }} · {{ q.sceneCount }} escenas ·
                <span [class]="q.published ? 'pub' : 'bor'">{{ q.published ? 'publicado' : 'borrador' }}</span>
              </p>
            </div>
            <div class="acc">
              <button class="boton" [disabled]="ocupado()" (click)="editar(q.code)">Editar</button>
              @if (q.published) {
                <button class="boton" [disabled]="ocupado()" (click)="despublicar(q.code)">Despublicar</button>
              } @else {
                <button class="boton boton--lacre" [disabled]="ocupado()" (click)="publicar(q.code)">Publicar</button>
              }
            </div>
          </li>
        }
      </ul>
    }

    <div class="acciones">
      <button class="boton" (click)="nuevo()">+ Encargo nuevo (plantilla)</button>
    </div>

    <!-- Editor -->
    <p class="rotulo separador">Borrador (JSON)</p>
    <textarea class="editor" spellcheck="false" [(ngModel)]="draftText"
              placeholder="Pulsa «Editar» en un encargo o «Encargo nuevo»…"></textarea>

    <div class="acciones">
      <button class="boton" [disabled]="ocupado()" (click)="comprobar()">Comprobar</button>
      <button class="boton boton--lacre" [disabled]="ocupado()" (click)="guardar()">Guardar</button>
    </div>

    @if (mensaje(); as m) { <p class="ok" role="status">{{ m }}</p> }
    @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

    @if (report(); as r) {
      @if (r.errors.length === 0 && r.warnings.length === 0) {
        <p class="ok">Sin problemas. Listo para guardar.</p>
      }
      @if (r.errors.length > 0) {
        <p class="rotulo separador">Errores</p>
        <ul class="problemas">
          @for (p of r.errors; track $index) {
            <li class="prob prob--err"><span class="campo">{{ p.field }}</span>{{ p.message }}</li>
          }
        </ul>
      }
      @if (r.warnings.length > 0) {
        <p class="rotulo separador">Avisos</p>
        <ul class="problemas">
          @for (p of r.warnings; track $index) {
            <li class="prob prob--warn"><span class="campo">{{ p.field }}</span>{{ p.message }}</li>
          }
        </ul>
      }
    }
  `,
  styles: `
    .cabecera { margin: 0 0 8px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 8px 0 0; }

    .separador { margin: 24px 0 10px; color: var(--sepia); }

    .lista { list-style: none; margin: 0; padding: 0; display: grid; gap: 10px; }
    .fila { padding: 14px 16px; display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
    .fila h2 { font-size: 19px; color: var(--tinta); }
    .meta { font-family: var(--dato); font-size: 10px; letter-spacing: .08em; text-transform: uppercase; color: var(--sepia); margin: 4px 0 0; }
    .pub { color: var(--musgo); }
    .bor { color: var(--oro); }
    .acc { display: flex; gap: 8px; flex-wrap: wrap; }

    .acciones { display: flex; gap: 10px; flex-wrap: wrap; margin: 12px 0; }

    .editor {
      width: 100%; min-height: 340px; resize: vertical;
      font-family: var(--dato); font-size: 12.5px; line-height: 1.5;
      padding: 14px; border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-claro); color: var(--tinta);
      white-space: pre; overflow-wrap: normal; overflow-x: auto;
    }

    .ok { color: var(--musgo); border-left: 2px solid var(--musgo); padding: 6px 10px; margin: 12px 0 0; }
    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 12px 0 0; }

    .problemas { list-style: none; margin: 0; padding: 0; display: grid; gap: 6px; }
    .prob { font-family: var(--dato); font-size: 12px; padding: 6px 10px; border-radius: var(--radio); }
    .prob .campo { display: inline-block; color: var(--sepia); margin-right: 8px; }
    .prob--err { color: var(--sepia-hondo); border-left: 2px solid var(--vino); background: rgba(143,46,34,.06); }
    .prob--warn { color: var(--sepia-hondo); border-left: 2px solid var(--oro); background: rgba(157,122,47,.07); }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 12px 0; }
  `,
})
export class EncargosPanel implements OnInit {

  private readonly juego = inject(JuegoService);

  readonly encargos = signal<QuestSummary[]>([]);
  readonly draftText = signal('');
  readonly report = signal<ValidationReport | null>(null);
  readonly mensaje = signal<string | null>(null);
  readonly error = signal<string | null>(null);
  readonly ocupado = signal(false);

  ngOnInit(): void { this.cargarLista(); }

  private cargarLista(): void {
    this.juego.encargos().subscribe({
      next: qs => this.encargos.set(qs),
      error: () => this.error.set('No se ha podido leer la lista de encargos.'),
    });
  }

  nuevo(): void {
    this.draftText.set(PLANTILLA);
    this.report.set(null);
    this.mensaje.set('Plantilla cargada. Edítala y pulsa Comprobar.');
    this.error.set(null);
  }

  editar(code: string): void {
    this.limpiar();
    this.ocupado.set(true);
    this.juego.exportarEncargo(code).subscribe({
      next: d => { this.draftText.set(JSON.stringify(d, null, 2)); this.ocupado.set(false); this.mensaje.set('Cargado «' + code + '».'); },
      error: () => { this.ocupado.set(false); this.error.set('No se ha podido cargar el encargo.'); },
    });
  }

  comprobar(): void {
    const d = this.parse();
    if (d === undefined) return;
    this.limpiar();
    this.ocupado.set(true);
    this.juego.comprobarEncargo(d).subscribe({
      next: r => { this.report.set(r); this.ocupado.set(false); },
      error: err => { this.ocupado.set(false); this.mostrarError(err); },
    });
  }

  guardar(): void {
    const d = this.parse();
    if (d === undefined) return;
    this.limpiar();
    this.ocupado.set(true);
    this.juego.guardarEncargo(d).subscribe({
      next: res => {
        this.report.set(res.report);
        this.mensaje.set((res.created ? 'Creado' : 'Actualizado') + ' «' + res.code + '». Ahora puedes publicarlo.');
        this.ocupado.set(false);
        this.cargarLista();
      },
      error: err => { this.ocupado.set(false); this.mostrarError(err); },
    });
  }

  publicar(code: string): void {
    this.limpiar();
    this.ocupado.set(true);
    this.juego.publicarEncargo(code).subscribe({
      next: () => { this.ocupado.set(false); this.mensaje.set('«' + code + '» publicado. Ya está en el tablón.'); this.cargarLista(); },
      error: err => { this.ocupado.set(false); this.mostrarError(err); },
    });
  }

  despublicar(code: string): void {
    this.limpiar();
    this.ocupado.set(true);
    this.juego.despublicarEncargo(code).subscribe({
      next: () => { this.ocupado.set(false); this.mensaje.set('«' + code + '» retirado del tablón.'); this.cargarLista(); },
      error: err => { this.ocupado.set(false); this.mostrarError(err); },
    });
  }

  /** Devuelve el objeto parseado, o undefined si el JSON está mal (y avisa). */
  private parse(): unknown | undefined {
    try {
      return JSON.parse(this.draftText());
    } catch {
      this.limpiar();
      this.error.set('El JSON no es válido. Revisa comas y llaves.');
      return undefined;
    }
  }

  private mostrarError(err: any): void {
    if (err?.error?.report) this.report.set(err.error.report as ValidationReport);
    this.error.set(err?.error?.message ?? 'Algo ha ido mal.');
  }

  private limpiar(): void {
    this.mensaje.set(null);
    this.error.set(null);
    this.report.set(null);
  }
}
