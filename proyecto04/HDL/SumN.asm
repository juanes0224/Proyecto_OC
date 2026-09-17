// RAM[1] = 1 + 2 + 3 + ... + RAM[0]
    @1
    M=0         // Inicializar RAM[1] (resultado) en 0
    
    @0
    D=M
    @END
    D;JLE       // Si N <= 0, terminar
    
    @i
    M=1         // Inicializar contador i = 1
    
(LOOP)
    @i
    D=M
    @0
    D=D-M
    @END
    D;JGT       // Si i > N, terminar
    
    @i
    D=M
    @1
    M=D+M       // RAM[1] = RAM[1] + i
    
    @i
    M=M+1       // i++
    
    @LOOP
    0;JMP
    
(END)
    @END
    0;JMP