// ALUExtendida.tst
// Pruebas de la ALUExtendida: las cinco operaciones nuevas
// (XOR, NAND, NOR, EQ, ABS) y verificacion de compatibilidad
// con las instrucciones de la ALU original.

load ALUExtendida.hdl,
output-file ALUExtendida.out,
compare-to ALUExtendida.cmp,
output-list x%B1.16.1 y%B1.16.1 a%B1.1.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1 ny%B1.1.1 f%B1.1.1 no%B1.1.1 out%B1.16.1 zr%B1.1.1 ng%B1.1.1;

// XOR: 0 xor 0
set x %B0000000000000000,
set y %B0000000000000000,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 1, set f 1, set no 0;
eval,
output;

// XOR: 0 xor 1
set x %B0000000000000000,
set y %B0000000000000001,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 1, set f 1, set no 0;
eval,
output;

// XOR: 1 xor 0
set x %B0000000000000001,
set y %B0000000000000000,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 1, set f 1, set no 0;
eval,
output;

// XOR: 1 xor 1
set x %B0000000000000001,
set y %B0000000000000001,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 1, set f 1, set no 0;
eval,
output;

// XOR: patrones
set x %B1010101010101010,
set y %B0101010101010101,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 1, set f 1, set no 0;
eval,
output;

// NAND: 0 nand 0
set x %B0000000000000000,
set y %B0000000000000000,
set a 0,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 1;
eval,
output;

// NAND: 0 nand 1
set x %B0000000000000000,
set y %B0000000000000001,
set a 0,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 1;
eval,
output;

// NAND: 1 nand 0
set x %B0000000000000001,
set y %B0000000000000000,
set a 0,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 1;
eval,
output;

// NAND: 1 nand 1
set x %B0000000000000001,
set y %B0000000000000001,
set a 0,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 1;
eval,
output;

// NOR: 0 nor 0
set x %B0000000000000000,
set y %B0000000000000000,
set a 0,
set zx 1, set nx 1, set zy 0, set ny 1, set f 0, set no 0;
eval,
output;

// NOR: 0 nor 1
set x %B0000000000000000,
set y %B0000000000000001,
set a 0,
set zx 1, set nx 1, set zy 0, set ny 1, set f 0, set no 0;
eval,
output;

// NOR: 1 nor 0
set x %B0000000000000001,
set y %B0000000000000000,
set a 0,
set zx 1, set nx 1, set zy 0, set ny 1, set f 0, set no 0;
eval,
output;

// NOR: 1 nor 1
set x %B0000000000000001,
set y %B0000000000000001,
set a 0,
set zx 1, set nx 1, set zy 0, set ny 1, set f 0, set no 0;
eval,
output;

// EQ: x = y
set x %B0000000000010001,
set y %B0000000000010001,
set a 0,
set zx 1, set nx 0, set zy 1, set ny 0, set f 0, set no 0;
eval,
output;

// EQ: x != y
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 1, set ny 0, set f 0, set no 0;
eval,
output;

// EQ: ambos cero
set x %B0000000000000000,
set y %B0000000000000000,
set a 0,
set zx 1, set nx 0, set zy 1, set ny 0, set f 0, set no 0;
eval,
output;

// EQ: negativos =
set x %B1111111111111111,
set y %B1111111111111111,
set a 0,
set zx 1, set nx 0, set zy 1, set ny 0, set f 0, set no 0;
eval,
output;

// ABS: positivo
set x %B0000000000000101,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 0, set ny 0, set f 1, set no 0;
eval,
output;

// ABS: negativo
set x %B1111111111111011,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 0, set ny 0, set f 1, set no 0;
eval,
output;

// ABS: cero
set x %B0000000000000000,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 0, set ny 0, set f 1, set no 0;
eval,
output;

// ABS: max negativo
set x %B1000000000000000,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 0, set ny 0, set f 1, set no 0;
eval,
output;

// ABS: max positivo
set x %B0111111111111111,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 0, set ny 0, set f 1, set no 0;
eval,
output;

// Original: 0
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 0, set zy 1, set ny 0, set f 1, set no 0;
eval,
output;

// Original: 1
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 1, set zy 1, set ny 1, set f 1, set no 1;
eval,
output;

// Original: -1
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 1, set zy 1, set ny 0, set f 1, set no 0;
eval,
output;

// Original: x
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 0, set nx 0, set zy 1, set ny 1, set f 0, set no 0;
eval,
output;

// Original: y
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 1, set nx 1, set zy 0, set ny 0, set f 0, set no 0;
eval,
output;

// Original: x+y
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 0, set nx 0, set zy 0, set ny 0, set f 1, set no 0;
eval,
output;

// Original: x-y
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 0, set f 1, set no 1;
eval,
output;

// Original: x&y
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 0, set nx 0, set zy 0, set ny 0, set f 0, set no 0;
eval,
output;

// Original: x|y
set x %B0000000000010001,
set y %B0000000000000011,
set a 0,
set zx 0, set nx 1, set zy 0, set ny 1, set f 0, set no 1;
eval,
output;
