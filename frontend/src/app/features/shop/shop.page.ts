import { Component, OnInit, computed, inject, input, signal } from '@angular/core';
import { InventoryItem, Shop, ShopOffer } from '../../core/api.types';

import { AuthService } from '../../core/auth.service';
import { FormsModule } from '@angular/forms';
import { JuegoService } from '../../core/juego.service';
import { NavBar } from '../../shared/nav';
import { Router } from '@angular/router';

/**
 * Iconos del mostrador.
 *
 * Son trazos sueltos sobre una caja de 24×24: se dibujan con el color de la
 * tinta, así que envejecen con el resto de la hoja. Cada entrada lleva las
 * palabras que la invocan; al escribir «pico» en el alta, el mostrador ya
 * enseña el pico antes de guardar.
 *
 * El orden importa: gana la primera que casa, así que lo específico va antes
 * que lo genérico.
 */
interface Icono { key: string; palabras: string[]; paths: string[] }

const ICONOS: Icono[] = [
  { key: 'pico', palabras: ['pico', 'piqueta', 'zapapico', 'piolet'],
    paths: ['M3.5 11c2.6-3.7 5.5-5.5 8.5-5.5s5.9 1.8 8.5 5.5', 'M12 6v15', 'M9.5 8.5h5'] },
  { key: 'pala', palabras: ['pala', 'azada', 'laya'],
    paths: ['M12 3v11', 'M8 3h8', 'M8 14h8l-1.5 5c-.4 1.4-1.4 2-2.5 2s-2.1-.6-2.5-2z'] },
  { key: 'martillo', palabras: ['martillo', 'mazo', 'maza'],
    paths: ['M6 4h12v5H6z', 'M12 9v12'] },
  { key: 'hacha', palabras: ['hacha', 'segur', 'destral'],
    paths: ['M9 21 14 3.5', 'M12.8 3.8c4.6-1 8 1.6 7.6 5.1-.36 3.1-3.7 4.7-7.5 4'] },
  { key: 'espada', palabras: ['espada', 'sable', 'mandoble', 'estoque', 'cimitarra', 'katana'],
    paths: ['M12 2l2 3.5V14h-4V5.5z', 'M7 14h10', 'M12 14v5', 'M10 19h4'] },
  { key: 'daga', palabras: ['daga', 'punal', 'cuchillo', 'estilete', 'navaja'],
    paths: ['M12 4l1.6 2.8V12h-3.2V6.8z', 'M8.8 12h6.4', 'M12 12v6', 'M10.6 18h2.8'] },
  { key: 'lanza', palabras: ['lanza', 'jabalina', 'pica', 'tridente', 'alabarda', 'venablo'],
    paths: ['M12 22V7', 'M12 2l3.2 5H8.8z', 'M9.5 9h5'] },
  { key: 'arco', palabras: ['arco', 'ballesta', 'onda', 'honda'],
    paths: ['M8 3c6.5 3.5 6.5 14.5 0 18', 'M8 3v18', 'M8 12h11', 'M16 9l3 3-3 3'] },
  { key: 'flecha', palabras: ['flecha', 'virote', 'saeta', 'carcaj', 'aljaba', 'dardo'],
    paths: ['M4 20 18 6', 'M13 4h7v7', 'M4 20v-3.5', 'M4 20h3.5'] },
  { key: 'escudo', palabras: ['escudo', 'broquel', 'rodela', 'pavesa'],
    paths: ['M12 2.5l8 2.8v5.9c0 4.9-3.4 8.4-8 10.3-4.6-1.9-8-5.4-8-10.3V5.3z', 'M12 7v9'] },
  { key: 'armadura', palabras: ['armadura', 'coraza', 'cota', 'peto', 'malla', 'brigantina', 'guantelete'],
    paths: ['M8 3l4 2 4-2 2.5 4-2 2v9H7.5v-9l-2-2z', 'M12 9v7'] },
  { key: 'casco', palabras: ['casco', 'yelmo', 'capacete', 'celada'],
    paths: ['M5 13a7 7 0 0114 0v5h-4.5v-3h-5v3H5z', 'M5 13h14', 'M12 13.5V18'] },
  { key: 'bota', palabras: ['bota', 'botas', 'calzado', 'sandalia', 'zapato'],
    paths: ['M8.5 3h3.5v8.5c0 3 1.5 3.5 4 4.5 2 .8 2.5 1.8 2.5 3.5v1.5H6V3z', 'M6 17h10'] },
  { key: 'capa', palabras: ['capa', 'manto', 'tunica', 'tabardo', 'sudario', 'ropa', 'traje'],
    paths: ['M9 3l3 2 3-2c3 1.5 5 5 5 9v9H4v-9c0-4 2-7.5 5-9z', 'M12 5v17'] },
  { key: 'pocion', palabras: ['pocion', 'elixir', 'frasco', 'brebaje', 'redoma', 'aceite', 'veneno', 'antidoto', 'vial'],
    paths: ['M10 3v5.2L6.4 16.6A3.2 3.2 0 009.3 21h5.4a3.2 3.2 0 002.9-4.4L14 8.2V3', 'M9 3h6', 'M7.4 15h9.2'] },
  { key: 'pergamino', palabras: ['pergamino', 'rollo', 'mapa', 'carta', 'nota', 'contrato', 'plano'],
    paths: ['M6 3h12v15a3 3 0 01-3 3H6a3 3 0 003-3z', 'M6 3a3 3 0 000 6h3', 'M11 8h4', 'M11 12h4', 'M11 16h3'] },
  { key: 'libro', palabras: ['libro', 'tomo', 'grimorio', 'diario', 'manual', 'cronica', 'codice'],
    paths: ['M4 4h6.5A1.5 1.5 0 0112 5.5V20a2 2 0 00-2-1.5H4z', 'M20 4h-6.5A1.5 1.5 0 0012 5.5V20a2 2 0 012-1.5h6z'] },
  { key: 'varita', palabras: ['varita', 'baston', 'cetro', 'vara', 'bastón'],
    paths: ['M4 20 15 9', 'M18.5 2.5l1 3.2 3.2 1-3.2 1-1 3.2-1-3.2-3.2-1 3.2-1z'] },
  { key: 'anillo', palabras: ['anillo', 'sortija', 'sello', 'amuleto', 'colgante', 'talisman'],
    paths: ['M12 21a5.5 5.5 0 100-11 5.5 5.5 0 000 11z', 'M9 7l3-4 3 4', 'M9 7h6'] },
  { key: 'gema', palabras: ['gema', 'joya', 'diamante', 'rubi', 'zafiro', 'esmeralda', 'perla', 'cristal', 'piedra'],
    paths: ['M12 3l7.5 5.5L12 21 4.5 8.5z', 'M4.5 8.5h15', 'M12 3L8.8 8.5 12 21l3.2-12.5z'] },
  { key: 'moneda', palabras: ['moneda', 'monedas', 'oro', 'tesoro', 'lingote', 'bolsa'],
    paths: ['M12 21a9 9 0 100-18 9 9 0 000 18z', 'M12 16a4 4 0 100-8 4 4 0 000 8z', 'M12 3v5', 'M12 16v5'] },
  { key: 'cofre', palabras: ['cofre', 'arcon', 'baul', 'caja', 'urna'],
    paths: ['M3.5 9.5h17V20h-17z', 'M3.5 9.5a8.5 5 0 0117 0', 'M11 12.5h2v3.5h-2z'] },
  { key: 'llave', palabras: ['llave', 'ganzua', 'cerradura', 'candado'],
    paths: ['M7 16a4 4 0 100-8 4 4 0 000 8z', 'M11 12h10', 'M17.5 12v3.5', 'M20.5 12v3'] },
  { key: 'cuerda', palabras: ['cuerda', 'soga', 'garfio', 'cadena', 'grillete', 'red'],
    paths: ['M3.5 8c4 0 4 8 8.5 8s4.5-8 8.5-8', 'M3.5 13c4 0 4 8 8.5 8'] },
  { key: 'antorcha', palabras: ['antorcha', 'tea', 'hachon'],
    paths: ['M12 2.5c2.2 3.2 4.2 4.3 4.2 7.3a4.2 4.2 0 11-8.4 0c0-3 2-4.1 4.2-7.3z', 'M12 14v7.5'] },
  { key: 'linterna', palabras: ['linterna', 'farol', 'lampara', 'candil', 'vela', 'cirio'],
    paths: ['M7 8.5h10V21H7z', 'M9.5 8.5V6a2.5 2.5 0 015 0v2.5', 'M7 12h10'] },
  { key: 'comida', palabras: ['racion', 'raciones', 'comida', 'pan', 'carne', 'queso', 'provision', 'viveres', 'hogaza'],
    paths: ['M4 12.5a8 4.5 0 0116 0V17a4 4 0 01-4 4H8a4 4 0 01-4-4z', 'M4 14.5h16'] },
  { key: 'bebida', palabras: ['cerveza', 'vino', 'hidromiel', 'jarra', 'odre', 'agua', 'bebida', 'pellejo', 'barril'],
    paths: ['M6.5 5h9v16h-9z', 'M15.5 8.5h2.5a2.5 2.5 0 010 5h-2.5', 'M6.5 9h9'] },
  { key: 'mochila', palabras: ['mochila', 'morral', 'saco', 'zurron', 'petate', 'alforja', 'macuto'],
    paths: ['M6 8.5h12V21H6z', 'M9 8.5V6a3 3 0 016 0v2.5', 'M9 13.5h6v3H9z'] },
  { key: 'hierba', palabras: ['hierba', 'planta', 'hoja', 'raiz', 'flor', 'seta', 'reactivo', 'componente', 'incienso'],
    paths: ['M5 20c-.5-8 5.5-13 14.5-14C20 14 14 20 5 20z', 'M5 20 13 12'] },
  { key: 'reliquia', palabras: ['calavera', 'craneo', 'hueso', 'reliquia', 'idolo', 'estatuilla', 'totem'],
    paths: ['M12 3a7 7 0 00-5 12v3h10v-3a7 7 0 00-5-12z', 'M9.5 11.5a1.5 1.5 0 100-3 1.5 1.5 0 000 3z', 'M14.5 11.5a1.5 1.5 0 100-3 1.5 1.5 0 000 3z', 'M10 21v-3', 'M14 21v-3'] },
  { key: 'herramienta', palabras: ['herramienta', 'utiles', 'kit', 'juego de', 'yunque', 'sierra', 'clavo'],
    paths: ['M14.5 3a5 5 0 00-4.6 6.9L3 16.8 6.2 20l6.9-6.9A5 5 0 1014.5 3z', 'M17.5 7.5l-2.5-2.5'] },
  { key: 'montura', palabras: ['caballo', 'montura', 'mula', 'poni', 'silla', 'carro', 'carreta'],
    paths: ['M4 20c0-6 3-9 7-10l1-4 3 2 4 1c1 3 0 5-2 6-1 4-3 5-6 5z', 'M7 20v-4'] },
];

/** El fardo: lo que se dibuja cuando nada casa. */
const ICONO_POR_DEFECTO = ['M12 2.5 20.5 7v10L12 21.5 3.5 17V7z', 'M3.5 7 12 11.5 20.5 7', 'M12 11.5v10'];

/** Cuando el nombre no dice nada, la categoría sí suele decirlo. */
const ICONO_CATEGORIA: Record<string, string> = {
  arma: 'espada', armas: 'espada', armadura: 'armadura', armaduras: 'armadura',
  escudo: 'escudo', consumible: 'pocion', consumibles: 'pocion', pocion: 'pocion',
  pociones: 'pocion', alquimia: 'pocion', magia: 'varita', magico: 'varita',
  conjuro: 'pergamino', conjuros: 'pergamino', pergamino: 'pergamino',
  libro: 'libro', joya: 'gema', joyas: 'gema', tesoro: 'moneda',
  provision: 'comida', provisiones: 'comida', comida: 'comida', bebida: 'bebida',
  ropa: 'capa', equipo: 'mochila', aventura: 'mochila', herramienta: 'herramienta',
  herramientas: 'herramienta', montura: 'montura', monturas: 'montura',
  varios: 'cofre', general: 'cofre', misc: 'cofre',
};

/**
 * Pantalla 06: la tienda.
 *
 * El mostrador es una vitrina: cada artículo va en su tarjeta con su icono,
 * y arriba está lo que gobierna la compra (el monedero, la búsqueda y los
 * gremios de mercancía). Lo que llevas encima se lee abajo en una fila corta,
 * porque vender es un gesto de repaso, no de exploración.
 */
@Component({
  selector: 'arc-shop',
  imports: [NavBar, FormsModule],
  template: `
    <arc-nav [personajeId]="personajeId()" />

    <div class="contenedor contenedor--tienda">

      <!-- ============ CABECERA ============ -->
      <header class="cabecera">
        <div class="cab-alto">
          <div>
            <p class="rotulo">Mercado · Dorakan</p>
            <h1>La tienda</h1>
          </div>
          @if (tienda(); as t) {
            <div class="monedero" title="Tu monedero">
              <svg class="ico ico--monedero" viewBox="0 0 24 24" aria-hidden="true">
                @for (d of iconoClave('moneda'); track $index) { <path [attr.d]="d" /> }
              </svg>
              <span class="monedero-cifra">{{ t.purse }}</span>
              <span class="monedero-rotulo">en la bolsa</span>
            </div>
          }
        </div>
      </header>

      @if (cargando()) {
        <p class="estado">Abriendo el mostrador…</p>
      } @else if (error(); as e) {
        <p class="estado estado--mal" role="alert">{{ e }}</p>
      } @else if (tienda(); as t) {

        <!-- ============ MOSTRADOR ============ -->
        <section class="seccion">
          <div class="franja">
            <p class="rotulo separador">A la venta · {{ t.offers.length }} artículos</p>
            <input class="buscador" placeholder="Buscar en el mostrador…" [(ngModel)]="busca" />
          </div>

          <!-- Los gremios de mercancía: filtro de un toque, no un desplegable -->
          <div class="filtros">
            @for (c of categorias(); track c) {
              <button type="button" class="filtro" [class.activo]="categoria() === c"
                      (click)="categoria.set(c)">{{ c === '' ? 'Todo' : c }}</button>
            }
            <button type="button" class="filtro filtro--bolsa" [class.activo]="soloAsequible()"
                    (click)="soloAsequible.set(!soloAsequible())">Lo que puedo pagar</button>
          </div>

          @if (ofertas().length === 0) {
            <p class="estado">El mostrador no tiene nada que case con esa búsqueda.</p>
          } @else {
            <ul class="vitrina">
              @for (o of ofertas(); track o.itemCode) {
                <li class="hoja art" [class.art--agotado]="o.stock === 0" [class.art--caro]="!o.affordable">
                  <div class="medalla" [class.medalla--caro]="!o.affordable">
                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                      @for (d of icono(o.name, o.category); track $index) { <path [attr.d]="d" /> }
                    </svg>
                  </div>

                  <div class="art-texto">
                    <h2>{{ o.name }}</h2>
                    <p class="precio" [class.precio--caro]="!o.affordable">{{ o.price }}</p>
                    @if (o.description) { <p class="desc">{{ o.description }}</p> }
                  </div>

                  <p class="meta">
                    @if (o.category) { <span class="etq">{{ o.category }}</span> }
                    @if (o.stock >= 0) {
                      <span class="existencias" [class.agotado]="o.stock === 0">
                        {{ o.stock === 0 ? 'agotado' : 'quedan ' + o.stock }}
                      </span>
                    } @else {
                      <span class="existencias">siempre en almacén</span>
                    }
                  </p>

                  <div class="art-pie">
                    <button class="boton boton--lacre"
                            [disabled]="!o.affordable || o.stock === 0 || ocupado() === o.itemCode"
                            (click)="comprar(o)">
                      {{ ocupado() === o.itemCode ? 'Contando…' : 'Comprar' }}
                    </button>
                    @if (!o.affordable && o.stock !== 0) {
                      <span class="falta">Te faltan {{ falta(o) }}</span>
                    }
                    @if (esDM()) {
                      <button class="boton-quitar" title="Retirar del mostrador"
                              [disabled]="ocupado() === o.itemCode"
                              (click)="quitar(o)">✕</button>
                    }
                  </div>

                  @if (o.stock === 0) { <span class="lacre-agotado">Agotado</span> }
                </li>
              }
            </ul>
          }
        </section>

        <!-- ============ PANEL DEL DM ============ -->
        @if (esDM()) {
          <section class="seccion">
            <div class="franja">
              <p class="rotulo separador separador--dm">Trastienda · master</p>
              <button class="enlace" (click)="abrirDm.set(!abrirDm())">
                {{ abrirDm() ? 'Cerrar' : 'Poner algo a la venta' }}
              </button>
            </div>

            @if (abrirDm()) {
              <div class="hoja panel-dm">
                <!-- El icono se elige solo por el nombre; aquí se ve antes de guardar. -->
                <div class="dm-previo-ico">
                  <div class="medalla medalla--grande">
                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                      @for (d of icono(nombre(), categoriaNueva()); track $index) { <path [attr.d]="d" /> }
                    </svg>
                  </div>
                  <p class="dm-pista">El icono se pone solo a partir del nombre.<br />
                    Escribe «pico», «poción» o «espada» y míralo cambiar.</p>
                </div>

                <div class="dm-campos">
                  <label class="c-nombre">Objeto
                    <input placeholder="Nombre del objeto" [(ngModel)]="nombre" />
                  </label>
                  <label class="c-cat">Categoría
                    <input placeholder="armas, pociones…" [(ngModel)]="categoriaNueva" />
                  </label>
                  <label class="c-desc">Descripción
                    <input placeholder="Una línea para el cliente" [(ngModel)]="descripcion" />
                  </label>
                  <label class="c-precio">Precio
                    <span class="monedas">
                      <input type="number" min="0" [(ngModel)]="precioPo" aria-label="oro" /><span class="ud">po</span>
                      <input type="number" min="0" [(ngModel)]="precioPp" aria-label="plata" /><span class="ud">pp</span>
                      <input type="number" min="0" [(ngModel)]="precioPc" aria-label="cobre" /><span class="ud">pc</span>
                    </span>
                  </label>
                  <label class="c-cant">Cantidad
                    <input type="number" min="0" [disabled]="ilimitado()" placeholder="stock" [(ngModel)]="cantidad" />
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
          </section>
        }

        <!-- ============ LO QUE LLEVAS ============ -->
        <section class="seccion">
          <div class="franja">
            <p class="rotulo separador">En tu bolsa</p>
            @if (t.inventory.length > 0) {
              <span class="apunte">La tienda paga la mitad de precio.</span>
            }
          </div>

          @if (t.inventory.length === 0) {
            <p class="estado">No llevas nada encima.</p>
          } @else {
            <ul class="bolsa">
              @for (i of t.inventory; track i.itemCode) {
                <li class="hoja fila-obj">
                  <div class="medalla medalla--peq">
                    <svg class="ico" viewBox="0 0 24 24" aria-hidden="true">
                      @for (d of icono(i.name, ''); track $index) { <path [attr.d]="d" /> }
                    </svg>
                  </div>
                  <span class="obj-nombre">{{ i.name }}</span>
                  <span class="cantidad">×{{ i.quantity }}</span>
                  <span class="guia"></span>
                  <span class="precio precio--oro">{{ i.sellPrice }}</span>
                  <button class="boton" [disabled]="ocupado() === i.itemCode" (click)="vender(i)">
                    {{ ocupado() === i.itemCode ? '…' : 'Vender' }}
                  </button>
                </li>
              }
            </ul>
          }
        </section>

        <div class="acciones">
          <button class="boton boton--noche" (click)="alTablon()">Ir al tablón</button>
          <button class="boton boton--noche" (click)="volver()">Volver</button>
        </div>
      }
    </div>
  `,
  styles: `
    .contenedor--tienda { max-width: 1040px; }

    /* ---------------- cabecera ---------------- */
    .cabecera { margin: 18px 0 20px; padding-bottom: 14px; border-bottom: 1px solid var(--linea-noche, rgba(239,228,205,.18)); }
    .cab-alto { display: flex; align-items: flex-end; justify-content: space-between; gap: 16px; flex-wrap: wrap; }
    .cabecera .rotulo { color: var(--sepia-claro); }
    .cabecera h1 { font-size: 34px; line-height: 1.1; margin-top: 4px; color: var(--pergamino); }

    /* El monedero manda en esta pantalla: se lee como una pieza acuñada. */
    .monedero {
      display: flex; align-items: center; gap: 10px;
      border: 1px solid rgba(157,122,47,.45); border-radius: var(--radio);
      padding: 8px 14px; background: rgba(157,122,47,.07);
    }
    .monedero-cifra { font-family: var(--dato); font-size: 16px; letter-spacing: .04em; color: var(--oro); white-space: nowrap; }
    .monedero-rotulo { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; color: var(--sepia); }
    .ico--monedero { width: 22px; height: 22px; color: var(--oro); }

    /* ---------------- secciones y filtros ---------------- */
    .seccion { margin-bottom: 26px; }
    .franja { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
    .separador { margin: 0 0 12px; color: var(--sepia); }
    .separador--dm { color: var(--musgo); }
    .apunte { font-family: var(--dato); font-size: 10px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }
    .enlace { font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase; border: none; background: transparent; color: var(--musgo); padding: 0; }

    .buscador { flex: 0 1 280px; width: auto; padding: 9px 12px; }

    .filtros { display: flex; flex-wrap: wrap; gap: 6px; margin: 0 0 14px; }
    .filtro {
      font-family: var(--dato); font-size: 9px; letter-spacing: .14em; text-transform: uppercase;
      padding: 7px 13px; border-radius: var(--radio);
      border: 1px solid var(--linea-noche, rgba(239,228,205,.2)); background: transparent; color: var(--sepia-claro);
      transition: background .15s ease, color .15s ease;
    }
    .filtro:hover { color: var(--pergamino); background: rgba(239,228,205,.06); }
    .filtro.activo { background: var(--pergamino); border-color: var(--pergamino); color: var(--tinta); }
    .filtro--bolsa { border-color: rgba(157,122,47,.45); color: var(--oro); }
    .filtro--bolsa.activo { background: var(--oro); border-color: var(--oro); color: var(--tinta); }

    /* ---------------- vitrina ---------------- */
    .vitrina { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 12px; }

    .art {
      position: relative; padding: 14px 16px 14px 14px;
      display: grid; grid-template-columns: auto 1fr; gap: 4px 14px; align-content: start;
    }
    .art--agotado { opacity: .62; }
    .art--caro .boton { opacity: .55; }

    /* La medalla: el icono va troquelado en su casilla, como un sello de gremio. */
    .medalla {
      grid-row: span 2; align-self: start;
      width: 54px; height: 54px; display: grid; place-items: center;
      border: 1px solid var(--linea-fuerte); border-radius: var(--radio);
      background: var(--pergamino-hueso); box-shadow: inset 0 0 0 3px rgba(255,255,255,.35);
    }
    .medalla--caro { border-color: rgba(143,46,34,.35); }
    .medalla--peq { width: 38px; height: 38px; grid-row: auto; }
    .medalla--grande { width: 66px; height: 66px; grid-row: auto; }
    .ico { width: 30px; height: 30px; color: var(--tinta); fill: none; stroke: currentColor; stroke-width: 1.4; stroke-linecap: round; stroke-linejoin: round; }
    .medalla--peq .ico { width: 22px; height: 22px; }
    .medalla--grande .ico { width: 38px; height: 38px; }

    .art-texto { min-width: 0; }
    .art h2 { font-size: 19px; line-height: 1.2; color: var(--tinta); }
    .precio { font-family: var(--dato); font-size: 13px; letter-spacing: .04em; color: var(--sepia-hondo); margin: 3px 0 0; white-space: nowrap; }
    .precio--caro { color: var(--vino); }
    .precio--oro { color: var(--oro); margin: 0; }
    .desc { color: var(--sepia-hondo); margin: 7px 0 0; font-size: 14px; line-height: 1.45; text-wrap: pretty; }

    .meta {
      grid-column: 2; display: flex; flex-wrap: wrap; align-items: center; gap: 8px;
      font-family: var(--dato); font-size: 9px; letter-spacing: .12em; text-transform: uppercase;
      color: var(--sepia); margin: 10px 0 0;
    }
    .etq { color: var(--musgo); border: 1px solid rgba(76,106,55,.35); border-radius: var(--radio); padding: 2px 6px; }
    .existencias { color: var(--sepia); }
    .agotado { color: var(--vino); }

    .art-pie {
      grid-column: 1 / -1; display: flex; align-items: center; gap: 10px; flex-wrap: wrap;
      margin-top: 12px; padding-top: 12px; border-top: 1px dashed var(--linea);
    }
    .art-pie .boton { flex: 0 0 auto; }
    .falta { font-family: var(--dato); font-size: 10px; letter-spacing: .06em; color: var(--vino); }
    .boton-quitar {
      margin-left: auto; width: 34px; height: 38px; flex: 0 0 auto;
      border: 1px solid rgba(143,46,34,.4); background: transparent; color: var(--vino);
      border-radius: var(--radio); font-size: 14px;
    }
    .boton-quitar:hover:not(:disabled) { background: rgba(143,46,34,.08); }

    /* El lacre de agotado, ladeado como un sello mal puesto. */
    .lacre-agotado {
      position: absolute; top: 12px; right: -6px; transform: rotate(-7deg);
      font-family: var(--dato); font-size: 9px; letter-spacing: .18em; text-transform: uppercase;
      color: var(--vino); border: 1px solid rgba(143,46,34,.5); background: rgba(143,46,34,.08);
      border-radius: var(--radio); padding: 3px 8px;
    }

    /* ---------------- bolsa ---------------- */
    .bolsa { list-style: none; margin: 0; padding: 0; display: grid; gap: 8px; }
    .fila-obj { display: flex; align-items: center; gap: 12px; padding: 10px 14px; }
    .obj-nombre { color: var(--tinta); font-size: 17px; flex: 0 0 auto; }
    .cantidad { font-family: var(--dato); font-size: 12px; color: var(--sepia); flex: 0 0 auto; }
    .guia { flex: 1 1 auto; min-width: 20px; height: 1px; border-bottom: 1px dotted var(--linea-fuerte); }
    .fila-obj .boton { flex: 0 0 auto; }

    /* ---------------- trastienda ---------------- */
    .panel-dm { padding: 16px; border-color: rgba(76,106,55,.4); }
    .dm-previo-ico { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; padding-bottom: 14px; border-bottom: 1px dashed var(--linea); }
    .dm-pista { margin: 0; font-size: 14px; line-height: 1.45; color: var(--sepia-hondo); }
    .dm-campos { display: flex; flex-wrap: wrap; gap: 12px 16px; align-items: flex-end; }
    .dm-campos label { display: grid; gap: 5px; font-family: var(--dato); font-size: 9px; letter-spacing: .1em; text-transform: uppercase; color: var(--sepia); }
    .c-nombre { flex: 1 1 200px; min-width: 160px; }
    .c-cat { flex: 0 1 150px; }
    .c-desc { flex: 1 1 240px; min-width: 180px; }
    .c-cant input { width: 90px; }
    .c-inf { flex-direction: row; align-items: center; gap: 6px !important; text-transform: none; letter-spacing: 0; font-size: 12px; color: var(--sepia-hondo); }
    .c-inf input { width: auto; }
    .monedas { display: inline-flex; align-items: center; gap: 4px; }
    .monedas input { width: 58px; }
    .monedas .ud { font-family: var(--dato); font-size: 10px; color: var(--sepia); margin-right: 4px; }
    .dm-acc { display: flex; align-items: center; gap: 12px; margin-top: 16px; flex-wrap: wrap; }
    .dm-previo { font-family: var(--dato); font-size: 12px; color: var(--oro); }

    /* ---------------- acciones ---------------- */
    .acciones { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 8px; }
    .boton--noche { border-color: rgba(239,228,205,.28); color: var(--sepia-claro); }
    .boton--noche:hover:not(:disabled) { background: rgba(239,228,205,.06); color: var(--pergamino); }

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

  /** Solo el DM ve la trastienda y los botones de quitar. */
  readonly esDM = computed(() => this.auth.rol() === 'DM');

  // --- filtros del mostrador (estado de interfaz, no del personaje) ---
  readonly busca = signal('');
  readonly categoria = signal('');
  readonly soloAsequible = signal(false);

  // --- trastienda del DM ---
  readonly abrirDm = signal(false);
  readonly nombre = signal('');
  readonly categoriaNueva = signal('');
  readonly descripcion = signal('');
  readonly precioPo = signal(0);
  readonly precioPp = signal(0);
  readonly precioPc = signal(0);
  readonly cantidad = signal(1);
  readonly ilimitado = signal(false);
  readonly guardando = signal(false);
  readonly errorDm = signal<string | null>(null);

  /** Memoria de iconos ya resueltos: el nombre no cambia entre repintados. */
  private readonly cacheIconos = new Map<string, string[]>();

  // --- derivados de la vista ---

  /** Las categorías que hay de verdad en el mostrador, más «Todo». */
  readonly categorias = computed(() => {
    const vistas = new Set<string>();
    for (const o of this.tienda()?.offers ?? []) {
      if (o.category) vistas.add(o.category);
    }
    return ['', ...[...vistas].sort((a, b) => a.localeCompare(b, 'es'))];
  });

  /** El mostrador ya filtrado: búsqueda, gremio y monedero. */
  readonly ofertas = computed<ShopOffer[]>(() => {
    const q = this.normalizar(this.busca().trim());
    const cat = this.categoria();
    const soloPago = this.soloAsequible();
    return (this.tienda()?.offers ?? []).filter(o => {
      if (cat && o.category !== cat) return false;
      if (soloPago && (!o.affordable || o.stock === 0)) return false;
      if (!q) return true;
      return this.normalizar(o.name + ' ' + (o.description ?? '') + ' ' + (o.category ?? '')).includes(q);
    });
  });

  /** El precio elegido en la trastienda, ya formateado, como vista previa. */
  readonly previoPrecio = computed(() => {
    const cp = this.precioCp();
    return cp <= 0 ? 'gratis' : this.formatoCp(cp);
  });

  // --- iconos ---

  /** Sin tildes y en minúsculas: así casan «poción» y «pocion». */
  private normalizar(s: string): string {
    return (s ?? '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  }

  /**
   * El icono de un objeto, deducido de su nombre (y de su categoría si el
   * nombre no dice nada). Se compara palabra a palabra por el principio, así
   * que «picos de minero» encuentra el pico y «mochila grande» la mochila.
   */
  icono(nombre: string, categoria?: string): string[] {
    const clave = (nombre ?? '') + '|' + (categoria ?? '');
    const guardado = this.cacheIconos.get(clave);
    if (guardado) return guardado;

    const texto = this.normalizar(nombre);
    const palabras = texto.split(/[^a-z0-9]+/).filter(Boolean);

    let elegido: Icono | undefined;
    for (const ico of ICONOS) {
      const casa = ico.palabras.some(p =>
        p.includes(' ') ? texto.includes(p) : palabras.some(w => w.startsWith(p)));
      if (casa) { elegido = ico; break; }
    }

    let paths = elegido?.paths;
    if (!paths && categoria) {
      const key = ICONO_CATEGORIA[this.normalizar(categoria)];
      paths = ICONOS.find(i => i.key === key)?.paths;
    }
    const resultado = paths ?? ICONO_POR_DEFECTO;
    this.cacheIconos.set(clave, resultado);
    return resultado;
  }

  /** Un icono concreto por su clave (para adornos fijos como el monedero). */
  iconoClave(key: string): string[] {
    return ICONOS.find(i => i.key === key)?.paths ?? ICONO_POR_DEFECTO;
  }

  // --- monedas ---

  private formatoCp(cp: number): string {
    const po = Math.floor(cp / 100), pp = Math.floor((cp % 100) / 10), pc = cp % 10;
    return [po && `${po} po`, pp && `${pp} pp`, pc && `${pc} pc`].filter(Boolean).join(' · ') || '0 pc';
  }

  private precioCp(): number {
    const n = (s: () => number) => Math.max(0, Math.floor(Number(s()) || 0));
    return n(this.precioPo) * 100 + n(this.precioPp) * 10 + n(this.precioPc);
  }

  /** Lo que falta en la bolsa para poder pagar una oferta. */
  falta(o: ShopOffer): string {
    const purse = this.tienda()?.purseCp ?? 0;
    return this.formatoCp(Math.max(0, o.priceCp - purse));
  }

  // --- carga ---

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

  // --- trastienda del DM ---

  anadirOferta(): void {
    const name = this.nombre().trim();
    if (!name || this.guardando()) return;
    this.guardando.set(true);
    this.errorDm.set(null);

    const stock = this.ilimitado() ? -1 : Math.max(0, Math.floor(Number(this.cantidad()) || 0));
    this.juego.crearOferta(this.personajeId(), {
      name,
      priceCp: this.precioCp(),
      stock,
      description: this.descripcion().trim() || undefined,
      category: this.categoriaNueva().trim() || undefined,
    }).subscribe({
      next: t => {
        this.tienda.set(t);
        this.guardando.set(false);
        // Vaciar el formulario para encadenar altas (la categoría se queda:
        // el DM suele dar de alta varias cosas del mismo gremio seguidas).
        this.nombre.set('');
        this.descripcion.set('');
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
