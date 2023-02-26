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

// Control wires 1 bit
    wire PC_write;
    wire wr;            // sinal da memoria
    wire AB_load;       // sinal para escrever em A e B
    wire aluout_load;   // sinal para escrever na ALUOut
    wire HiLo_load;     // sinal para escrever em Hi e em Lo
    wire EPC_load;      // sinal para escrever em epc
    wire sel_alusrca;   // sinal do mux alusrca

// Control wires 2 bits
    wire [1:0] sel_alusrcb; // sinal do mux alusrcb

// Control wire 3 bits


// Data wires 32 bits
    wire [31:0] PC_Source_out;      // fio que sai do mux pc_source
    wire [31:0] PC_Out;             // saida do pc
    wire [31:0] IorD_out;           // saida do mux IorD
    wire [31:0] input_a;            // valor que vai para A (do banco_reg)
    wire [31:0] output_a;           // saida de A
    wire [31:0] input_b;            // valor que vai para B (do banco_reg)
    wire [31:0] output_b;           // saida de B
    wire [31:0] MEM_out             // saida da memoria
    wire [31:0] StoreSize_out;      // saida do store size
    wire [31:0] ALU_out;            // saida da ALU
    wire [31:0] ALUOut_Out;         // saida da ALUOut
    wire [31:0] HiSelect_out;       // saida do mux Hiselect
    wire [31:0] Hi_Out;             // saida de Hi
    wire [31:0] LoSelect_out;       // saida do mux Loselect
    wire [31:0] Lo_Out;             // saida de Lo
    wire [31:0] EPC_out;            // saida do epc
    wire [31:0] alusrca_out;        // saida do AluSrcA
    wire [31:0] sign_extend_16_32_out // saida do sign extend 16-32
    wire [31:0] shift_left_2_out    // saida do shift left 2
    wire [31:0] alusrcb_out         // saida do alusrcb

// Flags



    Registrador PC(
        clk,
        reset,
        PC_write,
        PC_Source_out,
        PC_Out
    );

    Registrador A(
        clk,
        reset,
        AB_load,
        input_a,
        output_a
    );

    Registrador B(
        clk,
        reset,
        AB_load,
        input_b,
        output_b
    );

    Registrador ALUOut(
        clk,
        reset,
        aluout_load,
        ALU_out,
        ALUOut_Out
    );
    
    Registrador Hi(
        clk,
        reset,
        HiLo_load,
        HiSelect_out,
        Hi_Out
    );

    Registrador Lo(
        clk,
        reset,
        HiLo_load,
        LoSelect_out,
        Lo_Out
    );

    Registrador EPC(
        clk,
        reset,
        EPC_load,
        ALU_out,
        EPC_out
    );

    mux_alusrca mux_alusra(
        PC_Out,
        output_a,
        sel_alusrca,
        alusrca_out
    );

    mux_alusrcb mux_alusrb(
        output_b,
        sign_extend_16_32_out,
        shift_left_2_out,
        sel_alusrcb,
        alusrcb_out
    );

    Memoria MEM(
        IorD_out,
        clk,
        wr,
        StoreSize_out,
        MEM_out
    );


endmodule
