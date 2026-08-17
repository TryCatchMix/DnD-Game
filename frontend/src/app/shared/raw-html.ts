import { Directive, ElementRef, effect, inject, input } from '@angular/core';

/**
 * Convierte un valor guardado en HTML listo para pintar.
 *
 * - Si ya trae etiquetas, se asume HTML (viene del editor rico) y se respeta.
 * - Si es texto plano (contenido antiguo, escrito con `<textarea>`), se escapa
 *   y se convierten los saltos de línea en `<br>` para que no se pierdan.
 *
 * No es un saneador: de eso se encarga el backend al guardar. Esto solo decide
 * cómo enseñar lo que ya está guardado.
 */
export function aHtmlSeguro(valor: string | null | undefined): string {
  const v = valor ?? '';
  if (v.trim() === '') return '';
  // ¿Parece HTML? (una etiqueta de apertura, cierre o comentario)
  if (/<[a-z!/][\s\S]*>/i.test(v)) return v;
  const esc = v.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  return esc.replace(/\n/g, '<br>');
}

/** El texto sin formato de un HTML, para contar palabras o comprobar si está vacío. */
export function textoPlano(html: string | null | undefined): string {
  const doc = new DOMParser().parseFromString(aHtmlSeguro(html), 'text/html');
  return (doc.body.textContent ?? '').trim();
}

/**
 * Pinta HTML "tal cual" en el elemento anfitrión, POR EL DOM.
 *
 * Hace falta porque el binding `[innerHTML]` de Angular pasa el saneador, que
 * borra los estilos en línea (¡y con ellos los colores del texto!). Como el
 * HTML ya viene saneado del backend, aquí lo escribimos directo.
 *
 *   <p [arcHtml]="nota.body"></p>
 */
@Directive({ selector: '[arcHtml]' })
export class HtmlCrudo {
  readonly arcHtml = input.required<string>();

  private readonly el = inject<ElementRef<HTMLElement>>(ElementRef);

  constructor() {
    effect(() => { this.el.nativeElement.innerHTML = aHtmlSeguro(this.arcHtml()); });
  }
}
