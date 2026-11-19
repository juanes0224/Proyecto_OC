**Organización de computadores 2026-2 — Proyecto 4: carrera de tres carriles en Jack y VM**

# Integrantes

| Nombre | Usuario GitHub | Aportes principales |
|---|---|---|
| Jerónimo Gutiérrez | [Wimax3010](https://github.com/Wimax3010) | `Carrera`, `Obstaculo`, `TipoObstaculo`, `Aleatorio.vm` y pruebas de la lógica |
| Juan Esteban Grisales | [juanes0224](https://github.com/juanes0224) | `Grafico.vm`, `Vista`, `Sprites`, `Juego`, `Teclado` y README |

# Compilación y ejecución

Se necesitan Java 8 o superior y la carpeta `tools` de Nand2Tetris, 2.ª edición.

1. Compilar:

   ```
   tools\JackCompiler.bat RUTA\proyecto4
   ```

   Si no aparece ningún mensaje que empiece por `In ...`, compiló sin errores.

2. Ejecutar:
   1. Abrir `tools\VMEmulator.bat`.
   2. `File → Load Program` y elegir la carpeta `proyecto4`. Si pregunta por las implementaciones *built-in*, responder **Yes**.
   3. Elegir **No animation** y la velocidad **Fast**.
   4. Presionar **Run** y hacer clic sobre la pantalla del emulador.
   5. Presionar `1`, `2` o `3` para elegir la distancia.

3. Pruebas públicas, desde Git Bash:

   ```
   cd material-apoyo/pruebas
   ./correr_pruebas.sh RUTA/proyecto4 RUTA/nand2tetris/tools
   ```

   Resultado: `Total: 24/24 casos aprobados`.

# Controles

| Tecla | Acción |
|---|---|
| `1` / `2` / `3` | Meta de 100, 250 o 500 pasos |
| Flecha arriba / abajo | Cambiar de carril, una vez por pulsación |
| `P` | Pausar y continuar |
| `R` | Volver a la pantalla inicial |
| `ENTER` | Volver a jugar desde el mensaje final |
| `ESC` | Salir |

# Diseño de clases

| Clase | Responsabilidad |
|---|---|
| `Main` | Crea el juego, lo ejecuta y lo libera |
| `Juego` | Pantalla inicial, bucle de la partida, pausa, reinicio y salida |
| `Teclado` | Lee el teclado sin bloquear y reporta cada tecla una vez |
| `Vista` | Dibuja la vía, el carro, los obstáculos, el marcador y los mensajes |
| `Sprites` | Guarda los dibujos de 16 × 16 píxeles |
| `Carrera` | Lógica del juego: carriles, vidas, puntaje, choques y generación |
| `Obstaculo` | Un obstáculo: carril, columna y su tipo |
| `TipoObstaculo` | Datos de un tipo: largo, velocidad, puntos y si es letal |

```
Main ──► Juego ──► Teclado
           ├──► Vista ──► Sprites
           │      └──► Grafico.vm
           └──► Carrera ──► Obstaculo ──► TipoObstaculo
                   └──► Aleatorio.vm
```

**Obstáculos sin herencia.** Hay una sola clase `Obstaculo`. Cada obstáculo contiene un `TipoObstaculo` con sus datos:

| Tipo | Largo | Velocidad | Puntos | Letal |
|---|---|---|---|---|
| Cono | 1 | 1 | 0 | sí |
| Camión | 3 | 1 | 0 | sí |
| Moto | 1 | 2 | 0 | sí |
| Moneda | 1 | 1 | 10 | no |

El mismo código mueve, detecta choques y elimina los cuatro tipos. `Carrera` crea los cuatro tipos y los comparte entre sus obstáculos.

**Lógica separada de la presentación.** `Carrera`, `Obstaculo` y `TipoObstaculo` no dibujan ni leen el teclado. `Carrera.llenarMapa` entrega un código por celda y `Vista` dibuja solo las celdas que cambiaron.

**Memoria.** Cada obstáculo que choca o sale se libera con `dispose`, `Carrera.dispose` libera todo lo que creó y `Vista.escribir` libera cada texto después de imprimirlo.

# Rutinas VM

`Grafico.vm` y `Aleatorio.vm` están escritos a mano. No usan `Memory.poke`, `Memory.peek` ni `Math.multiply`.

| Función | Qué hace | Dónde se usa |
|---|---|---|
| `Grafico.dibujarCelda(fila, col, sprite)` | Copia las 16 palabras del sprite en la celda | `Vista`: carro, obstáculos, vía, barra y leyenda |
| `Grafico.borrarCelda(fila, col)` | Pone la celda en 0 | `Vista.dibujarCambios` |
| `Grafico.desplazarFila(fila)` | Rota cada línea de la fila una palabra a la izquierda | `Vista.actualizar`, para mover las líneas divisorias |
| `Grafico.direccion(fila, col)` | Calcula `16384 + fila*512 + col` con sumas | Funciones de `Grafico` |
| `Grafico.rotarLinea(dir)` | Rota una línea de 32 palabras | `Grafico.desplazarFila` |
| `Aleatorio.semilla(s)` | `x ← s` | `Carrera.new` |
| `Aleatorio.siguiente()` | `x ← 5x + 3` y retorna `x` | `Carrera.azar`, usada por `Carrera.generar` |

# Uso de IA

- **Herramienta:** Claude Code (Anthropic).
- **Uso:** diseño de clases, código de las clases Jack y de `Grafico.vm` y `Aleatorio.vm`, dibujos de los sprites, este README y ejecución de las pruebas en el VM Emulator.
- **Fuentes:** plantilla del material de apoyo y documentación oficial de Nand2Tetris. No se usaron los juegos de ejemplo de Nand2Tetris ni código de terceros.
