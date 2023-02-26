// Imports dos módulos da Especificação

`include "arquivos_espec/Banco_reg.vhd"
`include "arquivos_espec/Instr_Reg.vhd"
`include "arquivos_espec/Memoria.vhd"
`include "arquivos_espec/RegDesloc.vhd"
`include "arquivos_espec/Registrador.vhd"
`include "arquivos_espec/ula32.vhd"

module CPU(
    input wire clk,
    input wire reset
);

// Control wires
    wire PC_wr;

// Data wires
    wire [31:0] PC_Source_out;
    wire [31:0] PC_Out;

    Registrador PC(
        clk,
        reset,
        PC_wr,
        PC_Source_out,
        PC_Out
    );


endmodule
