import { Component, inject, signal, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';

import { AuthService } from '../../core/auth.service';
import { TokenStore } from '../../core/token-store';

@Component({
  selector: 'arc-login',
  imports: [FormsModule, RouterLink],
  template: `
    <div class="marco">
      <div class="hoja carta">

        <!-- El sello es la firma visual: todo lo que hace el clan va lacrado. -->
        <div class="lacre" aria-hidden="true">
          <span>LA</span>
        </div>

        <p class="rotulo">Registro de intermisión</p>
        <h1>Los Archivos</h1>
        <p class="anno">Año 1127 después del Cataclismo · Ciudades Libres</p>

        <hr class="regla" />

        @if (auth.avisoDeSesion(); as aviso) {
          <p class="aviso" role="status">{{ aviso }}</p>
        }

        <form (ngSubmit)="entrar()">
          <label class="campo">
            <span class="rotulo">Nombre en el libro</span>
            <input name="email" type="email" autocomplete="username"
                   [(ngModel)]="email" required />
          </label>

          <label class="campo">
            <span class="rotulo">Contraseña</span>
            <input name="password" type="password" autocomplete="current-password"
                   [(ngModel)]="password" required />
          </label>

          @if (error(); as e) {
            <p class="error" role="alert">{{ e }}</p>
          }

          <button class="boton boton--lacre ancho" type="submit"
                  [disabled]="cargando() || !email() || !password()">
            {{ cargando() ? 'Cotejando…' : 'Entrar' }}
          </button>
        </form>

        <p class="alterna">
          ¿No tienes cuenta? <a routerLink="/registro">Crear una</a>
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

    /* Lacre: círculo de cera con las iniciales del clan. Es el único elemento
       decorativo de toda la interfaz, y va aquí porque entrar es el momento en
       que te identificas ante Los Archivos. */
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

    .ancho { width: 100%; margin-top: 6px; }

    .error, .aviso {
      font-size: 14px;
      text-align: left;
      border-left: 2px solid var(--vino);
      padding: 6px 10px;
      margin: 0 0 14px;
      color: var(--sepia-hondo);
      background: rgba(143,46,34,.06);
    }
    .aviso { border-left-color: var(--oro); background: rgba(157,122,47,.08); }

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
export class LoginPage implements OnInit {

  readonly auth = inject(AuthService);
  private readonly router = inject(Router);
  private readonly store = inject(TokenStore);

  ngOnInit(): void {
    // Si al llegar ya hay sesión (la app nativa la restauró al arrancar), no
    // enseñamos el formulario: directos a elegir personaje.
    if (this.store.accessToken()) void this.router.navigate(['/personajes']);
  }

  readonly email = signal('');
  readonly password = signal('');
  readonly cargando = signal(false);
  readonly error = signal<string | null>(null);

  entrar(): void {
    if (this.cargando()) return;

    this.cargando.set(true);
    this.error.set(null);

    this.auth.login(this.email(), this.password()).subscribe({
      next: () => {
        this.cargando.set(false);
        void this.router.navigate(['/personajes']);
      },
      error: err => {
        this.cargando.set(false);
        // El backend devuelve el mismo mensaje para correo inexistente y
        // contraseña mala, a propósito. Lo mostramos tal cual.
        this.error.set(err?.error?.message ?? 'No se ha podido comprobar el registro.');
      },
    });
  }
}
