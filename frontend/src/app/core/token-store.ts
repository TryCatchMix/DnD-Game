import { Injectable, signal } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import { Preferences } from '@capacitor/preferences';
import { TokenResponse } from './api.types';

const CLAVE_REFRESH = 'archivos.refreshToken';

/**
 * La sesión.
 *
 * El ACCESS token vive siempre en memoria (dura 15 min, no merece la pena
 * persistirlo). El REFRESH token se persiste SOLO en la app nativa
 * (@capacitor/preferences → almacenamiento nativo de Android/iOS, aislado),
 * para que la app recuerde la sesión entre reinicios.
 *
 * En la WEB NO se persiste nada, a propósito: un token en localStorage lo lee
 * cualquier script que acabe en la página. Por eso la persistencia va detrás de
 * `Capacitor.isNativePlatform()`; en el navegador el comportamiento es el de
 * siempre (sesión en memoria, se pierde al recargar).
 */
@Injectable({ providedIn: 'root' })
export class TokenStore {

  private readonly _access = signal<string | null>(null);
  private readonly _refresh = signal<string | null>(null);

  readonly accessToken = this._access.asReadonly();
  readonly refreshToken = this._refresh.asReadonly();

  /**
   * En nativo la sesión se persiste aquí (Preferences) y el refresh token
   * viaja en el cuerpo. En web el refresh token vive en una cookie httpOnly
   * que gestiona el backend: este store no lo ve ni lo guarda.
   */
  readonly esNativo = Capacitor.isNativePlatform();

  /** Solo la app nativa persiste el refresh token. */
  private readonly persiste = this.esNativo;

  save(t: TokenResponse): void {
    this._access.set(t.accessToken);
    this._refresh.set(t.refreshToken ?? null);
    if (this.persiste && t.refreshToken) {
      // Fire-and-forget: el guardado nativo no debe bloquear el login.
      void Preferences.set({ key: CLAVE_REFRESH, value: t.refreshToken });
    }
  }

  clear(): void {
    this._access.set(null);
    this._refresh.set(null);
    if (this.persiste) void Preferences.remove({ key: CLAVE_REFRESH });
  }

  /**
   * Arranque: recupera el refresh token guardado (solo nativo) y lo deja en
   * memoria para que AuthService pueda canjearlo. Devuelve el token o null.
   */
  async restaurar(): Promise<string | null> {
    if (!this.persiste) return null;
    const { value } = await Preferences.get({ key: CLAVE_REFRESH });
    if (value) this._refresh.set(value);
    return value ?? null;
  }
}
