// RAM[2] = RAM[0] * RAM[1]
    @2
    M=0         // Inicializar resultado (RAM[2]) en 0
    
    @0
    D=M
    @END
    D;JEQ       // Si RAM[0] == 0, terminar
    
    @1
    D=M
    @END
    D;JEQ       // Si RAM[1] == 0, terminar
    
    @R1_copy
    M=D         // R1_copy = RAM[1] (Contador de iteraciones)
    
(LOOP)
    @R1_copy
    D=M
    @END
    D;JEQ       // Si el contador es 0, terminar
    
    @0
    D=M
    @2
    M=D+M       // RAM[2] = RAM[2] + RAM[0]
    
    @R1_copy
    M=M-1       // R1_copy = R1_copy - 1
    
    @LOOP
    0;JMP       // Repetir ciclo
    
(END)
    @END
    0;JMP       // Ciclo infinito para terminar