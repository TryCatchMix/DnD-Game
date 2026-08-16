# Diseños intercambiables

Una pantalla puede tener varias caras. El jugador elige la suya en
**Ajustes → Diseño** (`/personajes/:id/ajustes`) y se guarda en el aparato.

## La idea

Cada pantalla se parte en dos:

| Pieza | Qué tiene | Ejemplo |
|---|---|---|
| **Contenedor** | El estado, las cuentas y las llamadas al backend | `features/ficha/ficha.store.ts` |
| **Diseño** | SOLO plantilla y estilos | `features/ficha/disenos/pergamino.ts` |

El contenedor lo provee la página (`providers: [FichaStore]`), y el diseño lo
inyecta (`inject(FichaStore)`). Como el diseño se crea dentro del árbol de la
página, la inyección funciona sin pasar ni un input: por eso los diseños no
tienen `@Input`, `@Output` ni lógica que mantener por duplicado.

```
FichaPage  (provee FichaStore)
   └── <arc-diseno pagina="ficha" />     ← el hueco
          └── FichaPergamino | FichaMesa ← el diseño elegido (carga perezosa)
```

## Añadir un diseño nuevo (3 pasos)

1. **Crea el componente** en `features/<pantalla>/disenos/<nombre>.ts`.
   Copia otro diseño como punto de partida: es plantilla + estilos, y todos los
   datos salen de `store`. No añadas ahí lógica de negocio; si te falta algo,
   va al store y lo aprovechan todos los diseños.
2. **Regístralo** en `core/diseno/diseno.catalogo.ts`, dentro de las `opciones`
   de su pantalla, con un `id` estable (se guarda en las preferencias) y un
   `import()` dinámico.
3. Ya está. Aparece solo en Ajustes → Diseño. El `import()` dinámico hace que
   el diseño que no se usa no viaje en el bundle inicial.

## Añadir una pantalla nueva (tienda, notas, crónica…)

1. Saca la lógica de la página a un `<pantalla>.store.ts` (`@Injectable()`, sin
   `providedIn: 'root'`), como en `ficha.store.ts`.
2. Deja la página con `providers: [<Pantalla>Store]`, la barra de navegación y
   `<arc-diseno pagina="<pantalla>" />`.
3. Mueve la plantilla y los estilos actuales a `disenos/<actual>.ts`: ese es el
   diseño de fábrica.
4. Registra la pantalla en el catálogo. `PaginaId` ya tiene declaradas las
   pantallas candidatas (`tienda`, `notas`, `cronica`, `propiedades`,
   `habilidades`, `tablon`).

## Detalles que conviene saber

- **La primera opción de cada pantalla es la de fábrica**, la que ve quien no ha
  elegido nada.
- **Ids desconocidos se ignoran**: si retiras un diseño, quien lo tuviera elegido
  vuelve al de fábrica en vez de quedarse con la pantalla en blanco.
- **La preferencia se restaura antes de la primera pintada**
  (`provideAppInitializer` en `app.config.ts`), así no parpadea.
- **El formulario de edición de la ficha** (`ficha-editor.ts`) es común a los dos
  diseños a propósito: son 150 líneas de campos que no aportan nada duplicadas.
  Un diseño que quiera el suyo, simplemente no lo importa y escribe otro.
- **Cosas del DOM** (poner el foco, medir, hacer scroll) son del diseño, no del
  store: el store avisa con una señal (`itemAnadido`) y cada diseño reacciona
  con su propia referencia de plantilla.
