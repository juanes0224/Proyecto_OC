**Organización de computadores**
**Proyecto 4 - Programación: juego de carreras de tres carriles en Jack y lenguaje VM**
**2026-2**

# Integrantes

| Nombre | Usuario GitHub | Aportes principales |
|---|---|---|
| Jerónimo Gutiérrez | [Wimax3010](https://github.com/Wimax3010) | Lógica del juego: `Carrera`, `Obstaculo`, `TipoObstaculo`; generador `Aleatorio.vm`; pruebas de la lógica |
| Juan Esteban Grisales | [juanes0224](https://github.com/juanes0224) | Rutinas gráficas `Grafico.vm`; `Vista`, `Sprites`, `Juego` y `Teclado`; README |

# Compilación y ejecución

Herramientas: `JackCompiler` y `VMEmulator` de Nand2Tetris, 2.ª edición (carpeta `tools` del curso) y Java 8 o superior.

1. **Compilar** (genera un `.vm` por cada `.jack`; `Grafico.vm` y `Aleatorio.vm` ya están escritos a mano y no tienen `.jack`):

   ```
   tools\JackCompiler.bat RUTA\proyecto4        (Windows)
   tools/JackCompiler.sh  RUTA/proyecto4        (Linux / macOS)
   ```

   Si no aparece ningún mensaje que empiece por `In ...`, compiló sin errores.

2. **Ejecutar**:
   1. Abrir `tools\VMEmulator.bat`.
   2. `File → Load Program` y elegir la **carpeta** `proyecto4` (no un archivo). No se incluyen los `.vm` del sistema operativo: el emulador usa los suyos. Si pregunta si se usan las implementaciones *built-in*, responder **Yes**.
   3. En `Animate` elegir **No animation** y mover el control de velocidad al máximo (**Fast**).
   4. Presionar **Run** (▶▶) y hacer **clic sobre la pantalla del emulador** para que reciba el teclado.
   5. En la pantalla inicial presionar `1`, `2` o `3` para elegir la distancia.

3. **Pruebas públicas** (Git Bash en Windows):

   ```
   cd material-apoyo/pruebas
   ./correr_pruebas.sh RUTA/proyecto4 RUTA/nand2tetris/tools
   ```

   Resultado obtenido: `Total: 24/24 casos aprobados` (18 de `carrera`, 3 de `grafico`, 3 de `bono`).

# Controles

| Tecla | Código (`Keyboard.keyPressed`) | Acción |
|---|---|---|
| `1` / `2` / `3` | 49 / 50 / 51 | En la pantalla inicial: meta corta (100 pasos), media (250) o larga (500) |
| Flecha arriba | 131 | Subir un carril (una vez por pulsación) |
| Flecha abajo | 133 | Bajar un carril (una vez por pulsación) |
| `P` | 80 | Pausar y continuar |
| `R` | 82 | Reiniciar: volver a la pantalla inicial sin recargar el programa |
| `ENTER` | 128 | En el mensaje final: volver a jugar (igual que `R`) |
| `ESC` | 140 | Salir del juego |

Mantener una flecha presionada cambia de carril una sola vez: `Teclado.leer()` solo reporta una tecla en el momento en que cambia respecto a la lectura anterior.

# Diseño de clases

| Clase | Tipo | Responsabilidad |
|---|---|---|
| `Main` | Jack | Solo crea el `Juego`, lo ejecuta y lo libera. Ninguna otra clase llama a `Main`. |
| `Juego` | Jack, con constructor | Controlador: pantalla inicial, bucle de cada partida, pausa, reinicio y salida. Une lógica, vista y teclado. Controla la velocidad con `Sys.wait`. |
| `Teclado` | Jack, con constructor | Lee `Keyboard.keyPressed()` sin bloquear y detecta el momento de cada pulsación. |
| `Vista` | Jack, con constructor | Presentación: textos, vía, carro, obstáculos, marcador, barra de progreso y mensajes. Lee la `Carrera` pero nunca la modifica. |
| `Sprites` | Jack, con constructor | Crea una sola vez los dibujos de 16 × 16 píxeles (arreglos de 16 palabras) y los entrega por código. |
| `Carrera` | Jack, con constructor | Lógica del juego (interfaz fija de la sección 8): carril, vidas, puntaje, progreso, estado, obstáculos, choques y generación. |
| `Obstaculo` | Jack, con constructor | **Única** clase de obstáculo: carril, columna actual y anterior, y una referencia a su `TipoObstaculo`. |
| `TipoObstaculo` | Jack, con constructor | Datos que distinguen a cada tipo: código, largo, velocidad, puntos y si es letal. |
| `Grafico` | VM escrito a mano | Dibujo en la memoria de video (sección 9 y bonos). |
| `Aleatorio` | VM escrito a mano | Generador pseudoaleatorio `x ← 5x + 3` (bono). |

```
Main ──► Juego ──► Teclado ──► Keyboard.keyPressed
           │
           ├──► Vista ──► Sprites
           │      └──► Grafico.vm (dibujarCelda, borrarCelda, desplazarFila)
           │
           └──► Carrera ──► Obstaculo[20] ──► TipoObstaculo (4 objetos compartidos)
                   └──► Aleatorio.vm
```

**Especialización de los obstáculos sin herencia.** Jack no tiene herencia, así que no hay una clase por tipo. Hay una sola clase `Obstaculo`, y cada obstáculo **contiene** (composición) un objeto `TipoObstaculo` que trae sus datos (parametrización por datos):

| Objeto `TipoObstaculo` | código | largo | velocidad | puntos | letal |
|---|---|---|---|---|---|
| cono | 0 | 1 | 1 | 0 | sí |
| camión | 1 | 3 | 1 | 0 | sí |
| moto | 2 | 1 | 2 | 0 | sí |
| moneda | 3 | 1 | 1 | 10 | no |

El mismo código de `Obstaculo.mover()`, `toca()`, `salio()`, `enRango()` y `marcar()` sirve para los cuatro tipos porque usa `datos.largo()`, `datos.velocidad()`, `datos.letal()` y `datos.puntos()`. Agregar un tipo nuevo solo exige crear otro `TipoObstaculo` con otros datos. `Carrera` crea los cuatro tipos una vez y los comparte entre todos sus obstáculos; `Obstaculo.dispose()` libera solo el obstáculo y `Carrera.dispose()` libera los tipos.

**Lógica separada de la presentación.** `Carrera`, `Obstaculo` y `TipoObstaculo` no llaman a `Screen`, `Output`, `Keyboard`, `Grafico` ni `Sys.wait`. Para que la vista sepa qué dibujar sin conocer las reglas, `Carrera.llenarMapa(mapa)` escribe en un arreglo de 96 celdas (3 carriles × 32 columnas) un código por celda: `-1` libre o `tipo * 4 + parte`. `Vista` traduce cada código a un sprite y compara ese mapa con lo que ya está dibujado: **solo redibuja las celdas que cambiaron**, porque el VM Emulator es lento.

**Memoria.** Cada obstáculo eliminado (por choque o por salir por la izquierda) se libera con `dispose` en `Carrera.eliminar`, y `Carrera.dispose` libera todo lo que creó. Los textos se imprimen con `Vista.escribir`, que libera cada `String` después de imprimirla. Se verificó que tras 6 partidas seguidas la cantidad de bloques vivos del heap vuelve exactamente al mismo valor.

# Rutinas VM

Archivos escritos a mano (no existe `Grafico.jack` ni `Aleatorio.jack`). No llaman a `Memory.poke`, `Memory.peek` ni `Math.multiply`: la memoria se lee y escribe con los segmentos `pointer`, `this` y `that`, y las multiplicaciones se hacen con sumas.

| Función | Archivo | Qué hace | Dónde la usa el juego |
|---|---|---|---|
| `Grafico.dibujarCelda(fila, col, sprite)` | `Grafico.vm` | Copia `sprite[k]` en `RAM[16384 + fila*512 + k*32 + col]` para k = 0..15. `THIS` apunta al sprite y `THAT` a la pantalla. | `Vista.dibujarCambios` (carro y obstáculos), `Vista.dibujarVia` (bordes, líneas, barra), `Vista.llenarBarra`, `Vista.leyenda` |
| `Grafico.borrarCelda(fila, col)` (bono) | `Grafico.vm` | Pone en 0 las 16 palabras de la celda. | `Vista.dibujarCambios`: borra la celda que un obstáculo o el carro dejó libre |
| `Grafico.desplazarFila(fila)` (bono) | `Grafico.vm` | Rota a la izquierda las 32 palabras de cada una de las 16 líneas de la fila de celdas. | `Vista.actualizar`: mueve las líneas divisorias (filas 6 y 8) en cada paso |
| `Grafico.direccion(fila, col)` (auxiliar) | `Grafico.vm` | Retorna `16384 + fila*512 + col`, sumando 512 `fila` veces. | Las tres funciones anteriores |
| `Grafico.rotarLinea(dir)` (auxiliar) | `Grafico.vm` | Rota una línea de 32 palabras con `that 1 → that 0`. | `Grafico.desplazarFila` |
| `Aleatorio.semilla(s)` (bono) | `Aleatorio.vm` | `x ← s` (estado en `static 0`). | `Carrera.new`, con la semilla que recibe |
| `Aleatorio.siguiente()` (bono) | `Aleatorio.vm` | `x ← 5x + 3` en 16 bits (5x = (x+x)+(x+x)+x) y retorna x. | `Carrera.azar`, usada por `Carrera.generar` y `Carrera.elegirTipo` |

# Uso de IA

[Revisar y completar con la verdad antes de entregar.]

- **Herramienta:** Claude Code (Claude, de Anthropic).
- **Para qué y en qué partes:** se usó para proponer el diseño de clases y escribir el código inicial de todas las clases Jack (`Main`, `Juego`, `Teclado`, `Vista`, `Sprites`, `Carrera`, `Obstaculo`, `TipoObstaculo`), de las rutinas escritas a mano en VM (`Grafico.vm` y `Aleatorio.vm`), de los dibujos de los sprites y de este README; también para correr las pruebas públicas y pruebas adicionales en el VM Emulator.
- **Revisión del grupo:** [describir qué revisaron, probaron o cambiaron Jerónimo y Juan Esteban]. Cada integrante debe poder explicar cualquier línea del proyecto.
- **Fuentes:** se partió de la plantilla del material de apoyo (firmas de `Carrera` y `Grafico`) y de la documentación oficial de Nand2Tetris (API del sistema operativo de Jack y especificación de la VM). No se usaron los juegos de ejemplo de Nand2Tetris ni código de terceros.
