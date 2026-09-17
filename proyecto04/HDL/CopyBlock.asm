// copiar bloque de memoria de RAM[0] a RAM[1] con longitud RAM[2]
    @2
    D=M
    @END
    D;JLE       // Si N <= 0, terminar
    
    @i
    M=0         // contador i = 0
    
(LOOP)
    @i
    D=M
    @2
    D=D-M
    @END
    D;JGE       // Si i >= N, terminar
    
    // Leer desde origen
    @0
    D=M
    @i
    A=D+M       // A = ORIGEN + i
    D=M         // D = RAM[ORIGEN + i]
    @temp
    M=D         // Guardar valor temporalme
    
    // Calcular dirección destino
    @1
    D=M
    @i
    D=D+M       // D = DESTINO + i
    @dest_addr
    M=D         // Guardar direccion destino
    
    // Escribir en destino
    @temp
    D=M
    @dest_addr
    A=M         // Puntero a direion destino
    M=D         // RAM[DESTINO + i] = temp
    
    @i
    M=M+1       // i++
    
    @LOOP
    0;JMP
    
(END)
    @END
    0;JMP