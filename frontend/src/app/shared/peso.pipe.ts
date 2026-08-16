import { Pipe, PipeTransform } from '@angular/core';

/** Factor exacto de conversión: 1 libra avoirdupois = 0,45359237 kg. */
const KG_POR_LIBRA = 0.45359237;

/**
 * Convierte un peso en libras (lb) a kilogramos y lo formatea para mostrarlo.
 *
 * D&D 3.5 lleva los pesos en libras; aquí se muestra el equivalente en kg al
 * lado, automáticamente, para quien piensa en métrico. Redondea a un decimal
 * (basta para la mesa) y usa la coma decimal española. Se descarta el «,0» para
 * que 5 lb salga como «2,3 kg» pero 20 lb como «9 kg», no «9,0 kg».
 *
 * Uso en plantilla: {{ it.weightLb | kg }}  →  "2,3 kg"
 */
@Pipe({ name: 'kg' })
export class KgPipe implements PipeTransform {
  transform(libras: number | null | undefined): string {
    const lb = Number(libras);
    if (!Number.isFinite(lb)) return '';
    const kg = lb * KG_POR_LIBRA;
    const redondeado = Math.round(kg * 10) / 10;
    return `${redondeado.toFixed(1).replace(/\.0$/, '').replace('.', ',')} kg`;
  }
}
