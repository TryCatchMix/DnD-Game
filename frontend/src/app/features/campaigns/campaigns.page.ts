import { Component, computed, inject, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

import { CampanasService } from '../../core/campaign.service';
import {
  Campana, DetalleCampana, MiembroDeCampana, PersonajeDeCampana, VistaCampanas,
} from '../../core/campaign.types';

/**
 * Las campañas: la mesa a la que se une la gente.
 *
 * Es la pantalla que faltaba. Antes había una sola partida implícita —una
 * tienda, un tablón, un escritorio de máster— y quien mandaba lo hacía en todas
 * partes. Aquí se crea una mesa, se reparte su código y se apuntan personajes.
 *
 * Dos cosas guían el diseño:
 *
 *  · EL CÓDIGO ES LA PUERTA. Se enseña grande y con un botón de copiar, porque
 *    lo que hace de verdad un máster es dictárselo a sus jugadores. Solo lo ve
 *    él; el jugador ve el nombre de la mesa y quién está dentro.
 *
 *  · UN PERSONAJE ESTÁ EN UNA MESA O EN NINGUNA. Los que no están en ninguna
 *    salen arriba, señalados, con el botón de meterlos: es el paso que se
 *    olvida y deja al jugador con un personaje que no puede comprar ni firmar.
 */
@Component({
  selector: 'arc-campanas',
  imports: [FormsModule],
  template: `
    <div class="contenedor">
      <header class="cabecera">
        <div>
          <p class="rotulo">Registro de mesas</p>
          <h1>Campañas</h1>
        </div>
        <button class="boton" (click)="volver()">Mis personajes</button>
      </header>

      @if (aviso(); as a) { <p class="estado estado--bien" role="status">{{ a }}</p> }
      @if (error(); as e) { <p class="estado estado--mal" role="alert">{{ e }}</p> }

      <!-- ------------------------- crear / entrar ------------------------- -->
      <div class="dos">
        <div class="hoja panel">
          <p class="rotulo">Abrir mesa</p>
          <h2>Crear una campaña</h2>
          <p class="letra-pequena">La diriges tú. Nace con su tienda surtida y su
            tablón, y te da un código para repartir.</p>
          <input class="campo" placeholder="Nombre de la campaña"
                 [(ngModel)]="nuevoNombre" (keydown.enter)="crear()" />
          <textarea class="campo" rows="2" placeholder="De qué va (opcional)"
                    [(ngModel)]="nuevaDesc"></textarea>
          <button class="boton boton--lacre" [disabled]="!nuevoNombre().trim() || ocupado()"
                  (click)="crear()">{{ ocupado() ? 'Abriendo…' : 'Crear campaña' }}</button>
        </div>

        <div class="hoja panel">
          <p class="rotulo">Sentarse a jugar</p>
          <h2>Entrar con un código</h2>
          <p class="letra-pequena">Pídeselo al máster. Si eliges un personaje,
            entra contigo; si no, lo apuntas después.</p>
          <input class="campo campo--codigo" placeholder="CÓDIGO" maxlength="8"
                 [ngModel]="codigo()" (ngModelChange)="codigo.set($any($event).toUpperCase())"
                 (keydown.enter)="unirse()" />
          <select class="campo" [(ngModel)]="personajeElegido">
            <option value="">Sin personaje, de momento</option>
            @for (p of libres(); track p.id) {
              <option [value]="p.id">{{ p.name }} · {{ p.clazz }} (nivel {{ p.level }})</option>
            }
          </select>
          <button class="boton boton--lacre" [disabled]="!codigo().trim() || ocupado()"
                  (click)="unirse()">{{ ocupado() ? 'Entrando…' : 'Entrar' }}</button>
        </div>
      </div>

      <!-- --------------------- personajes sin campaña --------------------- -->
      @if (libres().length > 0) {
        <div class="hoja sueltos">
          <p class="rotulo">Sin mesa</p>
          <p class="letra-pequena">
            Estos personajes no están en ninguna campaña, así que no tienen
            tablón, ni tienda, ni bloc. Mételos en una.
          </p>
          <ul class="chips">
            @for (p of libres(); track p.id) {
              <li class="chip">{{ p.name }} <span class="chip-dato">{{ p.clazz }}</span></li>
            }
          </ul>
        </div>
      }

      <!-- ---------------------------- mis mesas --------------------------- -->
      @if (cargando()) {
        <p class="estado">Buscando tus mesas…</p>
      } @else if (campanas().length === 0) {
        <p class="estado">No estás en ninguna campaña todavía. Crea una o entra con un código.</p>
      } @else {
        <ul class="lista">
          @for (c of campanas(); track c.id) {
            <li class="hoja mesa">
              <div class="fila">
                <h2>{{ c.name }}</h2>
                <span class="dato papel" [class.papel--dm]="c.role === 'DM'">
                  {{ c.role === 'DM' ? 'Diriges' : 'Juegas' }}
                </span>
              </div>
              @if (c.description) { <p class="subtitulo">{{ c.description }}</p> }

              <div class="pie-ficha">
                <span class="dato">{{ c.memberCount }} en la mesa</span>
                <span class="sep">·</span>
                <span class="dato">{{ c.characterCount }} personaje(s)</span>
                @if (!c.open) { <span class="sep">·</span><span class="dato cerrada">Puerta cerrada</span> }
              </div>

              <!-- El código: solo su máster, grande y copiable. -->
              @if (c.joinCode) {
                <div class="codigo">
                  <span class="rotulo">Código de entrada</span>
                  <strong>{{ c.joinCode }}</strong>
                  <button class="mini" (click)="copiar(c.joinCode!)">Copiar</button>
                  <button class="mini" (click)="renovar(c)">Cambiar</button>
                </div>
              }

              <!-- Mis personajes en esta mesa -->
              <div class="mios">
                @if (c.myCharacters.length === 0) {
                  <p class="letra-pequena">No has traído ningún personaje a esta mesa.</p>
                } @else {
                  <ul class="chips">
                    @for (p of c.myCharacters; track p.id) {
                      <li class="chip">
                        <button class="chip-link" (click)="jugar(p)">{{ p.name }}</button>
                        <button class="chip-x" title="Sacar de la campaña"
                                (click)="sacar(c, p)">×</button>
                      </li>
                    }
                  </ul>
                }
                @if (libres().length > 0) {
                  <div class="traer">
                    <select [(ngModel)]="traerElegido">
                      <option value="">Traer un personaje…</option>
                      @for (p of libres(); track p.id) {
                        <option [value]="p.id">{{ p.name }}</option>
                      }
                    </select>
                    <button class="mini" [disabled]="!traerElegido() || ocupado()"
                            (click)="traer(c)">Meter en la mesa</button>
                  </div>
                }
              </div>

              <div class="acc-mesa">
                <button class="mini" (click)="abrir(c)">
                  {{ abierta() === c.id ? 'Ocultar el grupo' : 'Ver el grupo' }}
                </button>
                @if (c.owner) {
                  <button class="mini mini--mal" (click)="pedirBorrado(c)">Borrar campaña</button>
                } @else {
                  <button class="mini mini--mal" (click)="salir(c)">Salirme</button>
                }
              </div>

              <!-- El grupo, desplegado -->
              @if (abierta() === c.id) {
                @if (detalle(); as d) {
                  <ul class="grupo">
                    @for (m of d.members; track m.userId) {
                      <li class="miembro">
                        <div class="fila">
                          <span class="nombre">{{ m.displayName }}</span>
                          <span class="dato papel" [class.papel--dm]="m.role === 'DM'">
                            {{ m.owner ? 'Máster' : (m.role === 'DM' ? 'Co-máster' : 'Jugador') }}
                          </span>
                        </div>
                        @if (m.characters.length > 0) {
                          <p class="letra-pequena">
                            @for (p of m.characters; track p.id) {
                              {{ p.name }} ({{ p.clazz }} {{ p.level }})@if (!$last) {, }
                            }
                          </p>
                        }
                        @if (c.role === 'DM' && !m.owner && !m.me) {
                          <span class="acc">
                            <button class="mini" (click)="papel(c, m)">
                              {{ m.role === 'DM' ? 'Bajar a jugador' : 'Hacer co-máster' }}
                            </button>
                            <button class="mini mini--mal" (click)="expulsar(c, m)">Echar</button>
                          </span>
                        }
                      </li>
                    }
                  </ul>
                } @else {
                  <p class="estado">Pasando lista…</p>
                }
              }
            </li>
          }
        </ul>
      }

      <!-- Borrar una campaña no se deshace: parada obligatoria. -->
      @if (borrando(); as c) {
        <div class="velo" (click)="cancelarBorrado()">
          <div class="hoja dialogo" role="alertdialog" aria-modal="true"
               (click)="$event.stopPropagation()">
            <p class="rotulo">Cerrar la mesa</p>
            <h2>¿Seguro que quieres borrar «{{ c.name }}»?</h2>
            <p class="letra-pequena">
              Se van con ella su tienda, sus misiones, su material, sus enemigos,
              sus encargos y el bloc de notas de cada jugador.
              Los personajes NO se borran: salen de la mesa y siguen siendo suyos.
              <strong>Esto no se puede deshacer.</strong>
            </p>
            <div class="acciones dialogo-acc">
              <button class="boton boton--lacre" [disabled]="ocupado()"
                      (click)="confirmarBorrado(c)">Sí, borrar</button>
              <button class="boton" [disabled]="ocupado()" (click)="cancelarBorrado()">Cancelar</button>
            </div>
          </div>
        </div>
      }
    </div>
  `,
  host: { '(document:keydown.escape)': 'cancelarBorrado()' },
  styles: `
    .cabecera {
      margin-bottom: 22px;
      display: flex; align-items: flex-start; justify-content: space-between;
      gap: 14px; flex-wrap: wrap;
    }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .cabecera .rotulo { color: var(--sepia-claro); }

    .dos { display: grid; gap: 14px; grid-template-columns: 1fr 1fr; margin-bottom: 18px; }
    @media (max-width: 720px) { .dos { grid-template-columns: 1fr; } }

    .panel { padding: 18px 20px; display: grid; gap: 10px; align-content: start; }
    .panel h2 { font-size: 20px; color: var(--tinta); margin: 0; }
    .panel .rotulo { color: var(--sepia); margin: 0; }
    .campo {
      width: 100%; padding: 9px 11px;
      background: rgba(0,0,0,.14);
      border: 1px solid var(--linea);
      border-radius: var(--radio);
      color: var(--tinta); font: inherit;
    }
    .campo--codigo {
      font-family: var(--dato); font-size: 20px; letter-spacing: .3em; text-align: center;
      text-transform: uppercase;
    }

    .sueltos { padding: 16px 20px; margin-bottom: 18px; border-left: 3px solid var(--oro); }
    .sueltos .rotulo { color: var(--oro); margin: 0 0 4px; }

    .lista { list-style: none; margin: 0 0 24px; padding: 0; display: grid; gap: 14px; }
    .mesa { padding: 18px 20px 16px; }

    .fila { display: flex; align-items: baseline; gap: 10px; justify-content: space-between; }
    h2 { font-size: 22px; color: var(--tinta); }
    .subtitulo { color: var(--sepia-hondo); margin: 6px 0 12px; }
    .sep { color: var(--linea-fuerte); margin: 0 4px; }
    .papel { color: var(--sepia); white-space: nowrap; }
    .papel--dm { color: var(--musgo); }
    .cerrada { color: var(--vino); }

    .pie-ficha {
      display: flex; flex-wrap: wrap; align-items: center; gap: 6px;
      color: var(--sepia);
      border-top: 1px solid var(--linea-clara);
      padding-top: 10px;
    }

    .codigo {
      display: flex; align-items: center; gap: 10px; flex-wrap: wrap;
      margin-top: 12px; padding: 10px 12px;
      background: rgba(157,122,47,.08);
      border: 1px solid rgba(157,122,47,.35);
      border-radius: var(--radio);
    }
    .codigo .rotulo { color: var(--oro); margin: 0; }
    .codigo strong {
      font-family: var(--dato); font-size: 20px; letter-spacing: .28em; color: var(--oro);
      font-weight: 400;
    }

    .mios { margin-top: 12px; }
    .traer { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px; }

    .chips { list-style: none; margin: 6px 0 0; padding: 0; display: flex; flex-wrap: wrap; gap: 6px; }
    .chip {
      display: inline-flex; align-items: center; gap: 6px;
      padding: 4px 8px;
      border: 1px solid var(--linea); border-radius: var(--radio);
      color: var(--tinta); font-size: 14px;
    }
    .chip-dato { color: var(--sepia); font-family: var(--dato); font-size: 10px;
                 letter-spacing: .1em; text-transform: uppercase; }
    .chip-link { background: none; border: 0; color: var(--tinta); font: inherit;
                 cursor: pointer; padding: 0; }
    .chip-link:hover { color: var(--vino); }
    .chip-x { background: none; border: 0; color: var(--sepia); cursor: pointer; padding: 0 2px; }
    .chip-x:hover { color: var(--vino); }

    .acc-mesa { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px; }

    .grupo { list-style: none; margin: 12px 0 0; padding: 12px 0 0; display: grid; gap: 10px;
             border-top: 1px solid var(--linea-clara); }
    .miembro .nombre { color: var(--tinta); }
    .miembro .acc { display: flex; gap: 6px; margin-top: 4px; }

    .mini {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--vino); background: transparent;
      border: 1px solid rgba(143,46,34,.4); border-radius: var(--radio);
      padding: 4px 8px; cursor: pointer;
    }
    .mini:hover:not(:disabled) { background: rgba(143,46,34,.08); }
    .mini:disabled { opacity: .45; cursor: default; }
    .mini--mal { color: var(--sepia); border-color: var(--linea); }
    .mini--mal:hover { color: var(--vino); border-color: rgba(143,46,34,.45); }

    .velo {
      position: fixed; inset: 0; z-index: 60;
      background: rgba(15, 11, 5, .82); backdrop-filter: blur(3px);
      display: grid; place-items: center; padding: 18px;
    }
    .dialogo { width: min(460px, 100%); padding: 22px 24px 20px; }
    .dialogo h2 { font-size: 23px; color: var(--tinta); margin: 6px 0 0; }
    .dialogo-acc { margin-top: 18px; }
    .acciones { display: flex; gap: 12px; flex-wrap: wrap; }

    .letra-pequena { color: var(--sepia-hondo); font-size: 15px; margin: 6px 0 0; }
    .letra-pequena strong { color: var(--vino); font-weight: 400; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 18px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
    .estado--bien { color: var(--musgo); font-style: normal; }
  `,
})
export class CampanasPage implements OnInit {

  private readonly campanasApi = inject(CampanasService);
  private readonly router = inject(Router);

  readonly campanas = signal<Campana[]>([]);
  readonly libres = signal<PersonajeDeCampana[]>([]);
  readonly cargando = signal(true);
  readonly ocupado = signal(false);
  readonly error = signal<string | null>(null);
  readonly aviso = signal<string | null>(null);

  // alta y entrada
  readonly nuevoNombre = signal('');
  readonly nuevaDesc = signal('');
  readonly codigo = signal('');
  readonly personajeElegido = signal('');
  readonly traerElegido = signal('');

  // el grupo desplegado
  readonly abierta = signal<string | null>(null);
  readonly detalle = signal<DetalleCampana | null>(null);

  readonly borrando = signal<Campana | null>(null);

  ngOnInit(): void { this.cargar(); }

  private cargar(): void {
    this.campanasApi.mias().subscribe({
      next: v => { this.aplicar(v); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido leer el registro de mesas.');
      },
    });
  }

  private aplicar(v: VistaCampanas): void {
    this.campanas.set(v.campaigns);
    this.libres.set(v.free);
  }

  /** Tras cualquier cambio en una mesa concreta hay que releer la lista: el
   *  detalle solo cuenta esa campaña, y aquí se pintan todas. */
  private trasCambio(d: DetalleCampana, mensaje: string): void {
    this.ocupado.set(false);
    this.aviso.set(mensaje);
    this.error.set(null);
    if (this.abierta() === d.campaign.id) this.detalle.set(d);
    this.cargar();
  }

  private falla(err: unknown, porDefecto: string): void {
    this.ocupado.set(false);
    this.aviso.set(null);
    this.error.set((err as { error?: { message?: string } })?.error?.message ?? porDefecto);
  }

  // -------------------------------------------------------------- acciones

  crear(): void {
    const name = this.nuevoNombre().trim();
    if (!name || this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.crear({ name, description: this.nuevaDesc().trim() }).subscribe({
      next: d => {
        this.nuevoNombre.set('');
        this.nuevaDesc.set('');
        this.trasCambio(d, `Mesa abierta. Reparte el código ${d.campaign.joinCode}.`);
      },
      error: e => this.falla(e, 'No se ha podido crear la campaña.'),
    });
  }

  unirse(): void {
    const code = this.codigo().trim();
    if (!code || this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.unirse(code, this.personajeElegido() || null).subscribe({
      next: d => {
        this.codigo.set('');
        this.personajeElegido.set('');
        this.trasCambio(d, `Ya estás en «${d.campaign.name}».`);
      },
      error: e => this.falla(e, 'No se ha podido entrar en esa campaña.'),
    });
  }

  traer(c: Campana): void {
    const id = this.traerElegido();
    if (!id || this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.apuntar(c.id, id).subscribe({
      next: d => { this.traerElegido.set(''); this.trasCambio(d, 'Personaje apuntado a la mesa.'); },
      error: e => this.falla(e, 'No se ha podido apuntar el personaje.'),
    });
  }

  sacar(c: Campana, p: PersonajeDeCampana): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.sacar(c.id, p.id).subscribe({
      next: d => this.trasCambio(d, `${p.name} sale de la mesa. Su ficha y su dinero siguen intactos.`),
      error: e => this.falla(e, 'No se ha podido sacar el personaje.'),
    });
  }

  renovar(c: Campana): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.renovarCodigo(c.id).subscribe({
      next: d => this.trasCambio(d, `Código nuevo: ${d.campaign.joinCode}. El anterior ya no vale.`),
      error: e => this.falla(e, 'No se ha podido cambiar el código.'),
    });
  }

  abrir(c: Campana): void {
    if (this.abierta() === c.id) { this.abierta.set(null); return; }
    this.abierta.set(c.id);
    this.detalle.set(null);
    this.campanasApi.abrir(c.id).subscribe({
      next: d => this.detalle.set(d),
      error: e => this.falla(e, 'No se ha podido leer el grupo.'),
    });
  }

  papel(c: Campana, m: MiembroDeCampana): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.cambiarPapel(c.id, m.userId, m.role === 'DM' ? 'PLAYER' : 'DM').subscribe({
      next: d => this.trasCambio(d, 'Cambiado el papel en la mesa.'),
      error: e => this.falla(e, 'No se ha podido cambiar el papel.'),
    });
  }

  expulsar(c: Campana, m: MiembroDeCampana): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.expulsar(c.id, m.userId).subscribe({
      next: d => this.trasCambio(d, `${m.displayName} sale de la campaña.`),
      error: e => this.falla(e, 'No se ha podido echar a esa persona.'),
    });
  }

  salir(c: Campana): void {
    if (this.ocupado()) return;
    this.ocupado.set(true);
    this.campanasApi.salir(c.id).subscribe({
      next: v => {
        this.ocupado.set(false);
        this.abierta.set(null);
        this.aviso.set(`Has salido de «${c.name}». Tus personajes vuelven a estar libres.`);
        this.aplicar(v);
      },
      error: e => this.falla(e, 'No se ha podido salir de la campaña.'),
    });
  }

  pedirBorrado(c: Campana): void { this.error.set(null); this.borrando.set(c); }

  cancelarBorrado(): void { if (!this.ocupado()) this.borrando.set(null); }

  confirmarBorrado(c: Campana): void {
    this.ocupado.set(true);
    this.campanasApi.borrar(c.id).subscribe({
      next: v => {
        this.ocupado.set(false);
        this.borrando.set(null);
        this.abierta.set(null);
        this.aviso.set(`«${c.name}» ya no existe.`);
        this.aplicar(v);
      },
      error: e => { this.borrando.set(null); this.falla(e, 'No se ha podido borrar la campaña.'); },
    });
  }

  /** Copiar el código es lo que se hace con él el 90 % de las veces. */
  copiar(codigo: string): void {
    void navigator.clipboard?.writeText(codigo)
      .then(() => this.aviso.set(`Código ${codigo} copiado.`))
      .catch(() => this.aviso.set(`El código es ${codigo}.`));
  }

  jugar(p: PersonajeDeCampana): void {
    void this.router.navigate(['/personajes', p.id, 'ficha']);
  }

  volver(): void {
    void this.router.navigate(['/personajes']);
  }
}
