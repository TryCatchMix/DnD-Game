import { Component, computed, inject, input, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

import { JuegoService } from '../../core/juego.service';
import { AuthService } from '../../core/auth.service';
import { InventoryItem, Shop, ShopOffer } from '../../core/api.types';
import { NavBar } from '../../shared/nav';

/**
 * Pantalla 06: la tienda. A la izquierda lo que se vende en la ciudad, abajo
 * lo que llevas (y puedes vender a mitad de precio). El monedero manda: si no
 * te llega, el botón de comprar se apaga.
 */
@Component({
  selector: 'arc-shop',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />
    <div class="contenedor">
      <header class="cabecera">
        <p class="rotulo">Mercado · Dorakan</p>
        <div class="titulo">
          <h1>La tienda</h1>
          @if (tienda(); as t) {
            <span class="monedero" title="Tu monedero">{{ t.purse }}</span>
          }
        </div>
      </header>

      @if (cargando()) {
        <p class="estado">Abriendo el mostrador…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (tienda(); as t) {

        <!-- A la venta -->
        <p class="rotulo separador">A la venta</p>
        <ul class="lista">
          @for (o of t.offers; track o.itemCode) {
            <li class="hoja articulo">
              <div class="art-texto">
                <div class="fila">
                  <h2>{{ o.name }}</h2>
                  <span class="precio">{{ o.price }}</span>
                </div>
                <p class="desc">{{ o.description }}</p>
                <p class="meta">
                  <span class="etq">{{ o.category }}</span>
                  @if (o.stock >= 0) {
                    <span class="sep">·</span>
                    <span [class.agotado]="o.stock === 0">
                      {{ o.stock === 0 ? 'agotado' : 'quedan ' + o.stock }}
                    </span>
                  }
                </p>
              </div>
              <div class="art-acc">
                <button class="boton boton--lacre"
                        [disabled]="!o.affordable || o.stock === 0 || ocupado() === o.itemCode"
                        (click)="comprar(o)">
                  {{ ocupado() === o.itemCode ? '…' : 'Comprar' }}
                </button>
                @if (esDM()) {
                  <button class="boton-quitar" title="Retirar del mostrador"
                          [disabled]="ocupado() === o.itemCode"
                          (click)="quitar(o)">✕</button>
                }
              </div>
            </li>
          }
        </ul>

        <!-- ====== Panel del DM: poner algo a la venta ====== -->
        @if (esDM()) {
          <div class="hoja panel-dm">
            <p class="rotulo panel-titulo">Poner a la venta · master</p>
            <div class="dm-campos">
              <label class="c-nombre">Objeto
                <input placeholder="Nombre del objeto" [(ngModel)]="nombre" />
              </label>
              <label class="c-precio">Precio
                <span class="monedas">
                  <input type="number" min="0" [(ngModel)]="precioPo" aria-label="oro" /><span class="ud">po</span>
                  <input type="number" min="0" [(ngModel)]="precioPp" aria-label="plata" /><span class="ud">pp</span>
                  <input type="number" min="0" [(ngModel)]="precioPc" aria-label="cobre" /><span class="ud">pc</span>
                </span>
              </label>
              <label class="c-cant">Cantidad
                <input type="number" min="0" [disabled]="ilimitado()" placeholder="stock"
                       [(ngModel)]="cantidad" />
              </label>
              <label class="c-inf">
                <input type="checkbox" [(ngModel)]="ilimitado" /> Sin límite
              </label>
            </div>
            <div class="dm-acc">
              <button class="boton boton--lacre" [disabled]="!nombre().trim() || guardando()"
                      (click)="anadirOferta()">
                {{ guardando() ? 'Guardando…' : 'Añadir a la tienda' }}
              </button>
              <span class="dm-previo">{{ previoPrecio() }}</span>
            </div>
            @if (errorDm(); as e) { <p class="estado estado--mal" role="alert">{{ e }}</p> }
          </div>
        }

        <!-- Lo que llevas -->
        <p class="rotulo separador">En tu bolsa</p>
        @if (t.inventory.length === 0) {
          <p class="estado">No llevas nada encima.</p>
        } @else {
          <ul class="lista">
            @for (i of t.inventory; track i.itemCode) {
              <li class="hoja articulo">
                <div class="art-texto">
                  <div class="fila">
                    <h2>{{ i.name }} <span class="cantidad">×{{ i.quantity }}</span></h2>
                    <span class="precio oro">{{ i.sellPrice }}</span>
                  </div>
                  <p class="meta">La tienda te lo paga a mitad de precio.</p>
                </div>
                <button class="boton"
                        [disabled]="ocupado() === i.itemCode"
                        (click)="vender(i)">
                  {{ ocupado() === i.itemCode ? '…' : 'Vender' }}
                </button>
              </li>
            }
          </ul>
        }

        <div class="acciones">
          <button class="boton" (click)="alTablon()">Ir al tablón</button>
          <button class="boton" (click)="volver()">Volver</button>
        </div>
      }
    </div>
  `,
  styles: `
    .cabecera { margin-bottom: 18px; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .titulo { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; margin-top: 4px; }
    .titulo h1 { font-size: 28px; color: var(--pergamino); }
    .monedero {
      font-family: var(--dato); font-size: 13px; letter-spacing: .04em;
      color: var(--oro); white-space: nowrap;
      border: 1px solid rgba(157,122,47,.4); border-radius: var(--radio); padding: 5px 10px;
    }

    .separador { margin: 24px 0 12px; color: var(--sepia); }

    .lista { list-style: none; margin: 0 0 8px; padding: 0; display: grid; gap: 12px; }

    .articulo {
      padding: 14px 16px;
      display: flex; align-items: center; gap: 14px; justify-content: space-between;
    }
    .art-texto { min-width: 0; }
    .fila { display: flex; align-items: baseline; gap: 10px; flex-wrap: wrap; }
    h2 { font-size: 19px; color: var(--tinta); }
    .cantidad { font-family: var(--dato); font-size: 13px; color: var(--sepia); }
    .precio { font-family: var(--dato); font-size: 13px; color: var(--tinta); white-space: nowrap; }
    .precio.oro { color: var(--oro); }

    .desc { color: var(--sepia-hondo); margin: 6px 0 8px; font-size: 15px; line-height: 1.45; }

    .meta {
      display: flex; flex-wrap: wrap; align-items: center; gap: 6px;
      font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase;
      color: var(--sepia); margin: 0;
    }
    .etq { color: var(--musgo); }
    .sep { color: var(--linea-fuerte); }
    .agotado { color: var(--vino); }

    .articulo .boton { flex-shrink: 0; }
    .art-acc { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
    .boton-quitar {
      width: 34px; height: 38px; flex: 0 0 auto;
      border: 1px solid rgba(143,46,34,.4); background: transparent; color: var(--vino);
      border-radius: var(--radio); font-size: 14px;
    }
    .boton-quitar:hover:not(:disabled) { background: rgba(143,46,34,.08); }

    /* ---------- panel del DM ---------- */
    .panel-dm { padding: 16px; margin: 4px 0 8px; border-color: rgba(76,106,55,.4); }
    .panel-titulo { color: var(--musgo); margin: 0 0 12px; }
    .dm-campos { display: flex; flex-wrap: wrap; gap: 12px 16px; align-items: flex-end; }
    .dm-campos label { display: grid; gap: 5px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia-claro); }
    .c-nombre { flex: 1 1 200px; min-width: 160px; }
    .c-cant input { width: 90px; }
    .c-inf { flex-direction: row; align-items: center; gap: 6px !important; text-transform: none; letter-spacing: 0; font-size: 12px; color: var(--sepia-hondo); }
    .c-inf input { width: auto; }
    .monedas { display: inline-flex; align-items: center; gap: 4px; }
    .monedas input { width: 58px; }
    .monedas .ud { font-family: var(--dato); font-size: 10px; color: var(--sepia); margin-right: 4px; }
    .dm-acc { display: flex; align-items: center; gap: 12px; margin-top: 14px; flex-wrap: wrap; }
    .dm-previo { font-family: var(--dato); font-size: 12px; color: var(--oro); }

    .acciones { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 18px; }

    .estado { font-style: italic; color: var(--sepia-claro); padding: 20px 0; }
    .estado--mal { color: #d98a7c; font-style: normal; }
  `,
})
export class ShopPage implements OnInit {

  readonly personajeId = input.required<string>();

  private readonly juego = inject(JuegoService);
  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  readonly tienda = signal<Shop | null>(null);
  readonly cargando = signal(true);
  readonly error = signal<string | null>(null);
  /** itemCode de la compra/venta en curso, para desactivar su botón. */
  readonly ocupado = signal<string | null>(null);

  /** Solo el DM ve el panel de alta y los botones de quitar. */
  readonly esDM = computed(() => this.auth.rol() === 'DM');

  // --- panel del DM ---
  readonly nombre = signal('');
  readonly precioPo = signal(0);
  readonly precioPp = signal(0);
  readonly precioPc = signal(0);
  readonly cantidad = signal(1);
  readonly ilimitado = signal(false);
  readonly guardando = signal(false);
  readonly errorDm = signal<string | null>(null);

  /** El precio elegido, ya formateado, como vista previa. */
  readonly previoPrecio = computed(() => {
    const cp = this.precioCp();
    if (cp <= 0) return 'gratis';
    const po = Math.floor(cp / 100), pp = Math.floor((cp % 100) / 10), pc = cp % 10;
    return [po && `${po} po`, pp && `${pp} pp`, pc && `${pc} pc`].filter(Boolean).join(' · ');
  });

  private precioCp(): number {
    const n = (s: () => number) => Math.max(0, Math.floor(Number(s()) || 0));
    return n(this.precioPo) * 100 + n(this.precioPp) * 10 + n(this.precioPc);
  }

  ngOnInit(): void {
    this.juego.tienda(this.personajeId()).subscribe({
      next: t => { this.tienda.set(t); this.cargando.set(false); },
      error: () => {
        this.cargando.set(false);
        this.error.set('No se ha podido abrir la tienda.');
      },
    });
  }

  comprar(o: ShopOffer): void {
    if (this.ocupado()) return;
    this.ocupado.set(o.itemCode);
    this.error.set(null);
    this.juego.comprar(this.personajeId(), o.itemCode).subscribe({
      next: t => { this.tienda.set(t); this.ocupado.set(null); },
      error: err => {
        this.ocupado.set(null);
        this.error.set(err?.error?.message ?? 'No se ha podido comprar.');
      },
    });
  }

  vender(i: InventoryItem): void {
    if (this.ocupado()) return;
    this.ocupado.set(i.itemCode);
    this.error.set(null);
    this.juego.vender(this.personajeId(), i.itemCode).subscribe({
      next: t => { this.tienda.set(t); this.ocupado.set(null); },
      error: err => {
        this.ocupado.set(null);
        this.error.set(err?.error?.message ?? 'No se ha podido vender.');
      },
    });
  }

  // --- panel del DM ---

  anadirOferta(): void {
    const name = this.nombre().trim();
    if (!name || this.guardando()) return;
    this.guardando.set(true);
    this.errorDm.set(null);

    const stock = this.ilimitado() ? -1 : Math.max(0, Math.floor(Number(this.cantidad()) || 0));
    this.juego.crearOferta(this.personajeId(), { name, priceCp: this.precioCp(), stock }).subscribe({
      next: t => {
        this.tienda.set(t);
        this.guardando.set(false);
        // Vaciar el formulario para encadenar altas.
        this.nombre.set('');
        this.precioPo.set(0); this.precioPp.set(0); this.precioPc.set(0);
        this.cantidad.set(1); this.ilimitado.set(false);
      },
      error: err => {
        this.guardando.set(false);
        this.errorDm.set(err?.error?.message ?? 'No se ha podido añadir a la tienda.');
      },
    });
  }

  quitar(o: ShopOffer): void {
    if (this.ocupado()) return;
    this.ocupado.set(o.itemCode);
    this.errorDm.set(null);
    this.juego.quitarOferta(this.personajeId(), o.itemCode).subscribe({
      next: t => { this.tienda.set(t); this.ocupado.set(null); },
      error: err => {
        this.ocupado.set(null);
        this.errorDm.set(err?.error?.message ?? 'No se ha podido retirar la oferta.');
      },
    });
  }

  alTablon(): void {
    void this.router.navigate(['/personajes', this.personajeId(), 'tablon']);
  }

  volver(): void {
    void this.router.navigate(['/personajes']);
  }
}
