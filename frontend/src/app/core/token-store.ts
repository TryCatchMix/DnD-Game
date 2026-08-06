import { Injectable, signal } from '@angular/core';
import { TokenResponse } from './api.types';

/**
 * La sesión, EN MEMORIA a propósito.
 *
 * Un token en localStorage lo lee cualquier script que acabe en la página, y
 * aquí no hay nada que compense ese riesgo: el access token dura 15 minutos.
 * Al recargar la pestaña se pierde la sesión y toca volver a entrar; es el
 * precio correcto. Si algún día hace falta "recuérdame", va con una cookie
 * httpOnly puesta por el backend, no moviendo esto a localStorage.
 */
@Injectable({ providedIn: 'root' })
export class TokenStore {

  private readonly _access = signal<string | null>(null);
  private readonly _refresh = signal<string | null>(null);

  /** Se leen como funciones: accessToken() devuelve el valor actual. */
  readonly accessToken = this._access.asReadonly();
  readonly refreshToken = this._refresh.asReadonly();

  save(t: TokenResponse): void {
    this._access.set(t.accessToken);
    this._refresh.set(t.refreshToken);
  }

  clear(): void {
    this._access.set(null);
    this._refresh.set(null);
  }
}
