import { Component, OnInit, computed, inject, input, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

import { CampanasService } from '../../core/campaign.service';
import { ElencoService } from '../../core/cast.service';
import { Elenco, Pnj, PnjSuelto, Trato } from '../../core/cast.types';
import { NavBar } from '../../shared/nav';
import { ElencoSueltoPanel } from './loose-cast';
import { PnjEditor } from './npc-editor';
import { PnjFicha } from './npc-sheet';
import { Retrato } from './portrait';

const norm = (s: string) =>
  s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');

/** Qué se está mirando. Una cosa cada vez: en el móvil no caben dos. */
type Vista =
  | { modo: 'rejilla' }
  | { modo: 'ficha'; id: string }
  | { modo: 'editar'; id: string | null };   // null = personaje nuevo

/**
 * EL ELENCO de la campaña: la galería de quien ha ido saliendo.
 *
 * Cada mesa tiene el suyo, como el tablón o la tienda, así que la pantalla
 * cuelga del personaje solo para saber en qué campaña juega; lo que pinta es
 * de la campaña.
 *
 * La idea entera de esta sección es que un PNJ SE DESCUBRE A TROZOS. El máster
 * escribe la ficha completa y va soltando campos; al jugador le llegan solo los
 * destapados y una cuenta de lo que falta. Por eso la rejilla enseña caras y
 * apodos —"el encapuchado" es tan buena etiqueta como un nombre— y no una
 * tabla de datos: lo que se recuerda de una campaña son las caras.
 */
@Component({
  selector: 'arc-elenco',
  imports: [NavBar, FormsModule, RouterLink, Retrato, PnjFicha, PnjEditor, ElencoSueltoPanel],
  template: `
    <arc-nav [personajeId]="personajeId()" [ancho]="true" />

    <div class="contenedor contenedor--ancho">

      <!-- Va fuera de las tres vistas a propósito: se guarda desde el editor y
           se lee ya en el expediente, que es a donde se vuelve. -->
      @if (aviso(); as a) { <p class="bien" role="status">{{ a }}</p> }

      @if (sinCampana()) {
        <header class="cabecera">
          <p class="rotulo">Dramatis personae · Los Archivos</p>
          <h1>El elenco</h1>
        </header>
        <div class="hoja aviso">
          <p>Este personaje no está en ninguna campaña, y el elenco es de una
             mesa concreta: la gente de una partida no sale en la de al lado.</p>
          <!-- El caso típico de quien acaba de borrar su campaña: lo primero
               que se pregunta es si se ha llevado el elenco por delante. -->
          @if (sueltos().length > 0) {
            <p>Tienes <strong>{{ sueltos().length }} ficha(s) de elenco sin mesa</strong>,
               guardadas de campañas anteriores. En cuanto este personaje entre en
               una, podrás traerlas a su elenco.</p>
          }
          <a class="boton boton--lacre" routerLink="/campanas">Unirse a una campaña</a>
        </div>

      } @else if (vista().modo === 'ficha' && abierto()) {
        <arc-pnj-ficha [pnj]="abierto()!" [dm]="dm()"
                       (cambiado)="aplicar($event)"
                       (editar)="vista.set({ modo: 'editar', id: abierto()!.id })"
                       (cerrar)="vista.set({ modo: 'rejilla' })" />

      } @else if (vista().modo === 'editar') {
        <arc-pnj-editor [pnj]="enEdicion()"
                        [alineamientos]="elenco()?.alignments ?? []"
                        [tratos]="tratos()"
                        [personajes]="elenco()?.personajes ?? []"
                        [elencoOtros]="pnjs()"
                        (cambiado)="aplicar($event)"
                        (creado)="trasCrear($event)"
                        (guardado)="trasGuardar($event)"
                        (cerrar)="volver()" />

      } @else {
        <header class="cabecera">
          <p class="rotulo">Dramatis personae · Los Archivos</p>
          <h1>El elenco</h1>
          <p class="intro">
            {{ dm()
              ? 'La gente de tu campaña. Escribe la ficha entera y ve destapando lo que descubran: el nombre, la cara, de quién es hermano.'
              : 'Los que habéis conocido. Cada uno enseña lo que sabéis de él, y no más: lo demás irá saliendo.' }}
          </p>
        </header>

        <div class="mando">
          <input class="buscar" type="search" [(ngModel)]="busqueda"
                 placeholder="Buscar por nombre, ubicación, raza…" aria-label="Buscar en el elenco" />
          @if (dm()) {
            <button class="boton boton--lacre" (click)="vista.set({ modo: 'editar', id: null })">
              + Personaje nuevo
            </button>
            <!-- Solo si hay algo en el cajón: un botón que abre un sitio vacío
                 es una pregunta sin respuesta. -->
            @if (sueltos().length > 0) {
              <button class="boton" (click)="cajon.set(true)">
                Elenco suelto ({{ sueltos().length }})
              </button>
            }
          }
        </div>

        <!-- El tropiezo clásico del máster: tiene el elenco lleno y la mesa lo
             ve vacío, porque escribir una ficha no es lo mismo que sacarla. Se
             dice claro y se arregla de una vez, no ficha a ficha. -->
        @if (dm() && ocultos() > 0) {
          <p class="apunte">
            <span>
              {{ ocultos() }} ficha(s) todavía no han salido en la mesa: solo las ves tú,
              tus jugadores no las tienen en su elenco.
            </span>
            <button class="mini" [disabled]="sacando()" (click)="sacarTodos()">
              {{ sacando() ? 'Sacándolas…' : 'Sacarlas todas al elenco' }}
            </button>
          </p>
        }

        @if (error(); as e) { <p class="mal" role="alert">{{ e }}</p> }

        @if (cargando()) {
          <p class="estado">Abriendo el elenco…</p>
        } @else if (visibles().length === 0) {
          <div class="hoja aviso">
            @if (pnjs().length === 0) {
              <h2>Todavía no hay nadie</h2>
              <p>{{ dm()
                    ? 'Aquí van las caras de tu campaña: el tabernero que sabía demasiado, la capitana que os debe un favor. Crea la primera y decide qué saben de ella.'
                    : 'Cuando conozcáis a alguien, su ficha aparecerá aquí.' }}</p>
              @if (dm()) {
                <button class="boton boton--lacre" (click)="vista.set({ modo: 'editar', id: null })">
                  Crear la primera
                </button>
              }
            } @else {
              <h2>Nadie con esa búsqueda</h2>
              <p>Prueba con otro nombre o borra el filtro.</p>
            }
          </div>
        } @else {
          <ul class="galeria">
            @for (p of visibles(); track p.id) {
              <li>
                <article class="carta hoja" [class.carta--borrador]="borrador(p)">
                  <button class="tapa" (click)="abrir(p)"
                          [attr.aria-label]="'Abrir la ficha de ' + p.name">
                    <arc-retrato [npcId]="p.id" [hay]="p.portrait" [nombre]="p.name" />
                    @if (p.porDescubrir > 0) {
                      <span class="lacre">{{ p.porDescubrir }}</span>
                    }
                    @if (borrador(p)) { <span class="marca">Sin salir</span> }
                  </button>

                  <div class="cuerpo">
                    <h2>
                      <button class="titulo" [class.anonimo]="anonimo(p)" (click)="abrir(p)">
                        {{ p.name }}
                      </button>
                    </h2>
                    @if (p.title) { <p class="cargo">{{ p.title }}</p> }
                    <p class="pie">{{ resumen(p) }}</p>
                  </div>
                </article>
              </li>
            }
          </ul>
        }
      }

      <!-- El cajón de las fichas que se quedaron sin mesa. Va fuera de las
           tres vistas: se abre desde la rejilla y se cierra a la rejilla. -->
      @if (cajon()) {
        <arc-elenco-suelto [sueltos]="sueltos()"
                           (traidos)="trasTraer($event)"
                           (cambiados)="sueltos.set($event)"
                           (cerrar)="cajon.set(false)" />
      }
    </div>
  `,
  styles: `
    .cabecera { margin: 18px 0 16px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 28px; color: var(--pergamino); margin-top: 4px; }
    .intro { color: var(--sepia-claro); font-style: italic; margin: 8px 0 0; max-width: 64ch; }

    .mando { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; margin-bottom: 10px; }
    .buscar { flex: 1; min-width: 220px; }

    .apunte {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; color: var(--sepia); margin: 0 0 14px;
      display: flex; align-items: center; gap: 12px; flex-wrap: wrap;
    }
    .apunte span { max-width: 70ch; line-height: 1.6; }
    .mini {
      font-family: var(--dato); font-size: 10px; letter-spacing: .12em;
      text-transform: uppercase; padding: 4px 8px; cursor: pointer;
      background: transparent; color: var(--sepia-claro);
      border: 1px solid var(--linea-noche); border-radius: var(--radio);
    }
    .mini:hover:not(:disabled) { background: rgba(239,228,205,.08); color: var(--pergamino); }
    .mini:disabled { opacity: .45; cursor: default; }

    .bien {
      color: var(--musgo); border-left: 2px solid var(--musgo);
      padding: 6px 10px; margin: 0 0 12px;
    }

    /* ------------------------------------------------------------ galería */
    .galeria {
      list-style: none; margin: 14px 0 32px; padding: 0;
      display: grid; gap: 16px;
      grid-template-columns: repeat(auto-fill, minmax(168px, 1fr));
    }
    .carta { display: flex; flex-direction: column; overflow: hidden; }
    /* Lo que aún no ha salido en la mesa se ve apagado: está, pero no cuenta. */
    .carta--borrador { opacity: .62; }
    .carta--borrador:hover { opacity: 1; }

    .tapa {
      display: block; position: relative; padding: 0; border: 0;
      background: transparent; width: 100%; text-align: left;
    }

    /* El número de secretos, en lacre. Es la promesa de la sección: esta
       persona tiene tres cosas que todavía no sabéis. */
    .lacre {
      position: absolute; top: 8px; right: 8px;
      min-width: 22px; height: 22px; padding: 0 6px;
      display: grid; place-items: center;
      font-family: var(--dato); font-size: 11px;
      background: var(--vino); color: var(--pergamino-claro);
      border-radius: 11px;
      box-shadow: 0 1px 4px rgba(0,0,0,.4);
    }
    .marca {
      position: absolute; left: 0; bottom: 0;
      font-family: var(--dato); font-size: 9px; letter-spacing: .12em;
      text-transform: uppercase; padding: 3px 8px;
      background: rgba(30,24,16,.82); color: var(--sepia-claro);
    }

    .cuerpo { padding: 10px 12px 12px; display: grid; gap: 2px; }
    h2 { margin: 0; }
    .titulo {
      font-family: var(--display); font-size: 18px; color: var(--tinta);
      background: transparent; border: 0; padding: 0; text-align: left; line-height: 1.2;
    }
    .titulo:hover { color: var(--vino); }
    /* Un apodo no es un nombre, y se nota al leerlo. */
    .titulo.anonimo { font-style: italic; color: var(--sepia-hondo); }
    .cargo { font-size: 14px; color: var(--sepia-hondo); font-style: italic; margin: 0; }
    .pie {
      font-family: var(--dato); font-size: 9px; letter-spacing: .1em;
      text-transform: uppercase; color: var(--sepia); margin: 6px 0 0;
    }

    /* -------------------------------------------------------------- avisos */
    .aviso { padding: 22px; display: grid; gap: 10px; justify-items: start; max-width: 62ch; }
    .aviso h2 { font-size: 20px; color: var(--tinta); }
    .aviso p { margin: 0; color: var(--sepia-hondo); }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 16px 0; }
    .mal { color: #d98a7c; border-left: 2px solid var(--vino); padding: 6px 10px; margin: 0 0 12px; }
  `,
})
export class ElencoPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly campanas = inject(CampanasService);
  private readonly api = inject(ElencoService);

  readonly elenco = signal<Elenco | null>(null);
  readonly cargando = signal(true);
  readonly sinCampana = signal(false);
  readonly error = signal<string | null>(null);
  /** El «hecho» de turno. Se borra solo: es un acuse de recibo, no un cartel. */
  readonly aviso = signal<string | null>(null);
  readonly sacando = signal(false);
  readonly busqueda = signal('');
  readonly vista = signal<Vista>({ modo: 'rejilla' });

  /** Las fichas que se quedaron sin mesa al borrarse su campaña. */
  readonly sueltos = signal<PnjSuelto[]>([]);
  readonly cajon = signal(false);

  readonly dm = computed(() => this.elenco()?.dm ?? false);
  readonly pnjs = computed(() => this.elenco()?.npcs ?? []);
  readonly tratos = computed<Trato[]>(() => this.elenco()?.kinds ?? []);

  /** Cuántas fichas ve solo el máster porque el PNJ no ha salido aún. */
  readonly ocultos = computed(() => this.pnjs().filter(p => p.reveal && !p.reveal.listed).length);

  /** La ficha abierta, releída del elenco para que un cambio se vea al vuelo. */
  readonly abierto = computed(() => {
    const v = this.vista();
    if (v.modo !== 'ficha') return null;
    return this.pnjs().find(p => p.id === v.id) ?? null;
  });

  readonly enEdicion = computed(() => {
    const v = this.vista();
    if (v.modo !== 'editar' || v.id === null) return null;
    return this.pnjs().find(p => p.id === v.id) ?? null;
  });

  readonly visibles = computed(() => {
    const q = norm(this.busqueda().trim());
    if (!q) return this.pnjs();
    return this.pnjs().filter(p => norm([
      p.name, p.alias ?? '', p.title ?? '', p.location ?? '', p.race ?? '',
      p.alignment ?? '', p.description ?? '',
    ].join(' ')).includes(q));
  });

  ngOnInit(): void {
    // El cajón de sueltos es de la cuenta, no de la mesa: se pide siempre, y
    // también cuando el personaje no está en ninguna campaña —es justo el caso
    // de quien acaba de borrar la suya y quiere saber si perdió el elenco—.
    this.cargarSueltos();

    // La URL lleva el personaje, pero el elenco cuelga de la campaña.
    this.campanas.contextoDe(this.personajeId()).subscribe({
      next: c => {
        if (!c.campaignId) { this.cargando.set(false); this.sinCampana.set(true); return; }
        this.api.usar(c.campaignId);
        this.cargar();
      },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido saber en qué campaña juega este personaje.');
      },
    });
  }

  private cargar(): void {
    this.api.listar().subscribe({
      next: r => { this.elenco.set(r); this.cargando.set(false); },
      error: () => { this.cargando.set(false); this.error.set('No se ha podido abrir el elenco.'); },
    });
  }

  /**
   * El cajón de sueltos. Que falle no es motivo para teñir de rojo el elenco:
   * lo peor que pasa es que no salga el botón de traerlas, y siguen guardadas.
   */
  private cargarSueltos(): void {
    this.api.sueltos().subscribe({
      next: r => this.sueltos.set(r.npcs),
      error: () => this.sueltos.set([]),
    });
  }

  /**
   * Vuelven fichas al elenco. Se cierra el cajón y se dice cuántas, porque
   * llegan selladas y sin salir: en la rejilla aparecen apagadas y con su
   * cuenta de secretos, y sin este aviso parecería que han entrado a medias.
   */
  trasTraer(r: Elenco): void {
    const antes = this.pnjs().length;
    this.aplicar(r);
    this.cajon.set(false);
    const cuantas = r.npcs.length - antes;
    this.decir(cuantas === 1
      ? 'Ficha traída al elenco, sellada de nuevo: destápala cuando salga en la mesa.'
      : `${cuantas} fichas traídas al elenco, selladas de nuevo.`);
  }

  /** Todas las operaciones devuelven el elenco entero: solo hay que repintar. */
  aplicar(r: Elenco): void {
    this.elenco.set(r);
    this.error.set(null);
  }

  /**
   * Guardar una ficha que ya existía cierra el editor y vuelve a su expediente.
   * Quedarse en el formulario no dice si se guardó, y la pregunta siguiente
   * siempre es «¿cómo ha quedado?».
   */
  trasGuardar(r: Elenco): void {
    const v = this.vista();
    this.aplicar(r);
    if (v.modo === 'editar' && v.id) this.vista.set({ modo: 'ficha', id: v.id });
    this.decir('Ficha guardada.');
  }

  /** Saca al elenco de golpe las fichas escritas pero nunca marcadas. */
  sacarTodos(): void {
    if (this.sacando()) return;
    const cuantas = this.ocultos();
    this.sacando.set(true);
    this.api.sacarTodos().subscribe({
      next: r => {
        this.sacando.set(false);
        this.aplicar(r);
        this.decir(`${cuantas} ficha(s) ya salen en el elenco de tus jugadores.`);
      },
      error: () => {
        this.sacando.set(false);
        this.error.set('No se han podido sacar las fichas al elenco.');
      },
    });
  }

  /** Un acuse de recibo que se va solo a los cuatro segundos. */
  private decir(texto: string): void {
    this.aviso.set(texto);
    setTimeout(() => { if (this.aviso() === texto) this.aviso.set(null); }, 4000);
  }

  /**
   * Tras crear una ficha, el editor se queda abierto SOBRE ELLA. Hasta que
   * existe no tiene id, y sin id no se le puede colgar ni el retrato ni un
   * trato; cerrar aquí obligaría a volver a entrar para lo más obvio que se
   * hace después de inventarse a alguien.
   */
  trasCrear(r: Elenco): void {
    const antes = new Set(this.pnjs().map(p => p.id));
    this.aplicar(r);
    const nueva = r.npcs.find(p => !antes.has(p.id));
    this.vista.set(nueva ? { modo: 'editar', id: nueva.id } : { modo: 'rejilla' });
  }

  abrir(p: Pnj): void {
    this.vista.set({ modo: 'ficha', id: p.id });
  }

  /** Al salir del editor se vuelve a la ficha si la había, y si no, a la
   *  rejilla: quien estaba editando venía de mirarla. */
  volver(): void {
    const v = this.vista();
    this.vista.set(v.modo === 'editar' && v.id
      ? { modo: 'ficha', id: v.id }
      : { modo: 'rejilla' });
  }

  /** El nombre que se enseña todavía no es el suyo. */
  anonimo(p: Pnj): boolean {
    return p.reveal ? !p.reveal.name : false;
  }

  /** Aún no ha salido en la mesa; solo lo ve el máster. */
  borrador(p: Pnj): boolean {
    return p.reveal ? !p.reveal.listed : false;
  }

  /** La línea de abajo de la tarjeta: lo poco que se sepa, en orden. */
  resumen(p: Pnj): string {
    const trozos = [p.race, p.location].filter(Boolean) as string[];
    if (trozos.length) return trozos.join(' · ');
    return p.porDescubrir > 0 ? 'Sin datos todavía' : 'Sin más datos';
  }
}
