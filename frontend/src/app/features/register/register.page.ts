import { Component, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';

import { AuthService } from '../../core/auth.service';

/**
 * Alta de cuenta. El rol lo decide el backend (siempre PLAYER), aquí solo se
 * piden nombre, correo y contraseña. Al crearla, la sesión queda abierta y se
 * va directo a elegir personaje.
 */
@Component({
  selector: 'arc-registro',
  imports: [FormsModule, RouterLink],
  template: `
    <div class="marco">
      <div class="hoja carta">

        <div class="lacre" aria-hidden="true"><span>LA</span></div>

        <p class="rotulo">Alta en el libro</p>
        <h1>Los Archivos</h1>
        <p class="anno">Crea tu cuenta para llevar tus propios personajes</p>

        <hr class="regla" />

        <form (ngSubmit)="crear()">
          <label class="campo">
            <span class="rotulo">Nombre para mostrar</span>
            <input name="displayName" type="text" autocomplete="nickname"
                   [(ngModel)]="displayName" required />
          </label>

          <label class="campo">
            <span class="rotulo">Correo</span>
            <input name="email" type="email" autocomplete="username"
                   [(ngModel)]="email" required />
          </label>

          <label class="campo">
            <span class="rotulo">Contraseña</span>
            <input name="password" type="password" autocomplete="new-password"
                   [(ngModel)]="password" required />
            <span class="pista">Al menos 8 caracteres.</span>
          </label>

          <label class="campo">
            <span class="rotulo">Repite la contraseña</span>
            <input name="password2" type="password" autocomplete="new-password"
                   [(ngModel)]="password2" required />
          </label>

          @if (error(); as e) {
            <p class="error" role="alert">{{ e }}</p>
          }

          <button class="boton boton--lacre ancho" type="submit"
                  [disabled]="cargando() || !completo()">
            {{ cargando() ? 'Registrando…' : 'Crear cuenta' }}
          </button>
        </form>

        <p class="alterna">
          ¿Ya tienes cuenta? <a routerLink="/entrar">Entrar</a>
        </p>
      </div>

      <p class="pie">Cotejan, registran y no preguntan dos veces.</p>
    </div>
  `,
  styles: `
    .marco {
      min-height: 100dvh;
      display: grid;
      place-content: center;
      gap: 18px;
      padding: 24px 18px;
      position: relative;
      z-index: 1;
    }
    .carta {
      width: min(420px, 92vw);
      padding: 44px 32px 34px;
      text-align: center;
      position: relative;
    }
    .lacre {
      position: absolute;
      top: -22px; left: 50%;
      transform: translateX(-50%) rotate(-4deg);
      width: 52px; height: 52px;
      border-radius: 50%;
      background: var(--vino);
      border: 1px solid rgba(0,0,0,.35);
      box-shadow: 0 3px 8px rgba(0,0,0,.5),
                  0 2px 0 rgba(255,255,255,.14) inset;
      display: grid; place-content: center;
    }
    .lacre span {
      font-family: var(--display);
      font-size: 19px;
      letter-spacing: .06em;
      color: #f3dcc9;
    }
    h1 {
      font-size: 30px;
      letter-spacing: .02em;
      margin: 6px 0 4px;
      color: var(--tinta);
    }
    .anno {
      font-family: var(--dato);
      font-size: 10px;
      letter-spacing: .14em;
      text-transform: uppercase;
      color: var(--sepia);
      margin: 0;
    }
    .regla {
      border: 0;
      border-top: 1px solid var(--linea);
      margin: 22px 0 20px;
    }
    .campo { display: block; text-align: left; margin-bottom: 16px; }
    .campo .rotulo { display: block; margin-bottom: 6px; }
    .pista {
      display: block;
      font-family: var(--dato);
      font-size: 10px;
      letter-spacing: .08em;
      text-transform: uppercase;
      color: var(--sepia);
      margin-top: 5px;
    }
    .ancho { width: 100%; margin-top: 6px; }
    .error {
      font-size: 14px;
      text-align: left;
      border-left: 2px solid var(--vino);
      padding: 6px 10px;
      margin: 0 0 14px;
      color: var(--sepia-hondo);
      background: rgba(143,46,34,.06);
    }
    .alterna {
      font-size: 14px;
      color: var(--sepia);
      margin: 18px 0 0;
    }
    .alterna a { color: var(--oro); }
    .pie {
      font-family: var(--cuerpo);
      font-style: italic;
      font-size: 14px;
      color: var(--sepia);
      text-align: center;
      margin: 0;
    }
  `,
})
export class RegistroPage {

  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  readonly displayName = signal('');
  readonly email = signal('');
  readonly password = signal('');
  readonly password2 = signal('');
  readonly cargando = signal(false);
  readonly error = signal<string | null>(null);

  readonly completo = computed(() =>
    this.displayName().trim().length > 0 &&
    this.email().trim().length > 0 &&
    this.password().length > 0 &&
    this.password2().length > 0);

  crear(): void {
    if (this.cargando()) return;

    // Comprobación local antes de molestar al servidor.
    if (this.password().length < 8) {
      this.error.set('La contraseña necesita al menos 8 caracteres.');
      return;
    }
    if (this.password() !== this.password2()) {
      this.error.set('Las dos contraseñas no coinciden.');
      return;
    }

    this.cargando.set(true);
    this.error.set(null);

    this.auth.register({
      email: this.email().trim(),
      displayName: this.displayName().trim(),
      password: this.password(),
    }).subscribe({
      next: () => {
        this.cargando.set(false);
        void this.router.navigate(['/personajes']);
      },
      error: err => {
        this.cargando.set(false);
        this.error.set(err?.error?.message ?? 'No se ha podido crear la cuenta.');
      },
    });
  }
}
