// Si teclado (KBD) > 0, pantalla negra. Si no, blanca.
(LOOP)
    @KBD
    D=M
    @WHITE
    D;JEQ       // Si no hay tecla, saltar a WHITE

(BLACK)
    D=-1        // D = -1 (1111111111111111 en binario -> píxeles negros)
    @SET_COLOR
    0;JMP

(WHITE)
    @0
    D=A         // D = 0 (0000000000000000 en binario -> píxeles blancos)

(SET_COLOR)
    @color
    M=D         // Guardar el color deseado
    @SCREEN
    D=A
    @pixel_addr
    M=D         // Puntero pixel_addr apunta al inicio de la pantalla (16384)

(FILL_LOOP)
    @pixel_addr
    D=M
    @24576
    D=D-A
    @LOOP
    D;JEQ       // Si pixel_addr == 24576 (KBD), terminó de pintar, volver al inicio

    @color
    D=M
    @pixel_addr
    A=M
    M=D         // Pintar el registro actual con el color

    @pixel_addr
    M=M+1       // Avanzar al siguiente registro de pantalla

    @FILL_LOOP
    0;JMP