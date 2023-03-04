// Imports dos módulos da Especificação

`include "arquivos_espec/Banco_reg.vhd"
`include "arquivos_espec/Instr_Reg.vhd"
`include "arquivos_espec/Memoria.vhd"
`include "arquivos_espec/RegDesloc.vhd"
`include "arquivos_espec/Registrador.vhd"
`include "arquivos_espec/ula32.vhd"


// Inports dos Módulos Criados
`include "modulos/mux_alusrca.v"
`include "modulos/mux_alusrcb.v"
`include "modulos/mux_BranchOp.v"
`include "modulos/mux_IorD.v"
`include "modulos/mux_pc_source.v"
`include "modulos/mux_RegDst.v"
`include "modulos/mux_shift_amt.v"
`include "modulos/mux_shift_src.v"
`include "modulos/RegRead.v"
`include "modulos/shift_left_2.v"
`include "modulos/shift_left_2_PC.v"
`include "modulos/sing_extend_16_32.v"
`include "modulos/sing_extend_1_32.v"
`include "modulos/zero_extend_8_32.v"

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
    wire sel_ir;        // selecionador do Registrador de Instruções
    wire sel_shift_src; // selecionador do mux de shift src
    wire sel_branchop;  // sinal do mux branchOp
    wire output_branchop; // saida do mux branchop
    wire regwrite;      // sinal do banco de registradores
    wire MDR_load;      // sinal do MDR
    wire LSControl1;    // primeiro sinal do Load Size
    wire LSControl2;    // segundo sinal do Load Size
    wire SSControl1;    // primeiro sinal do Store Size
    wire SSControl2;    // segundo sinal do Store Size
    

// Control wires 2 bits
    wire [1:0] sel_alusrcb;    // sinal do mux alusrcb
    wire [1:0] sel_shift_amt;  // sinal para selecioar o valor a deslocar


// Control wire 3 bits
    wire [2:0]  sel_shift_reg; //sinal para selecionar a operação no shift_reg
    wire [2:0]  sel_mux_iord;  // sinal do mux IorD


// Instruction wires
    wire [5:0]  instr31_26;
    wire [4:0]  instr25_21;
    wire [4:0]  instr20_16;
    wire [15:0] instr15_00;
    wire [25:0] instr25_00;


// Data wires 5 bits
    wire [4:0]  out_shift_amt;
    wire [4:0]  regread_out;            // saida do mux regread
    wire [4:0]  regdst_out;             // saida do mux regdst
    wire [4:0]  memtoreg_out;           // saida do mux memtoreg

// Data wires 32 bits
    wire [31:0] PC_Source_out;          // fio que sai do mux pc_source
    wire [31:0] PC_Out;                 // saida do pc
    wire [31:0] IorD_out;               // saida do mux IorD
    wire [31:0] input_a;                // valor que vai para A (do banco_reg)
    wire [31:0] output_a;               // saida de A
    wire [31:0] input_b;                // valor que vai para B (do banco_reg)
    wire [31:0] output_b;               // saida de B
    wire [31:0] MEM_out                 // saida da memoria
    wire [31:0] StoreSize_out;          // saida do store size
    wire [31:0] ALU_out;                // saida da ALU
    wire [31:0] ALUOut_Out;             // saida da ALUOut
    wire [31:0] HiSelect_out;           // saida do mux Hiselect
    wire [31:0] Hi_Out;                 // saida de Hi
    wire [31:0] LoSelect_out;           // saida do mux Loselect
    wire [31:0] Lo_Out;                 // saida de Lo
    wire [31:0] EPC_out;                // saida do epc
    wire [31:0] alusrca_out;            // saida do AluSrcA
    wire [31:0] sign_extend_16_32_out;  // saida do sign extend 16-32
    wire [31:0] shift_left_2_out;       // saida do shift left 2
    wire [31:0] alusrcb_out;            // saida do alusrcb
    wire [31:0] output_shift_src;       // saida do shift_src
    wire [31:0] output_shift;           // saida do ShiftReg
    wire [31:0] lt_extended;            // resultado do LT extendido


// Flags
    wire alu_lt;
    wire alu_eq;
    wire alu_gt;


// registradores
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
    
    Registrador MDR(
        clk,
        reset,
        MDR_load,
        MEM_out,
        MDR_out
    );
        

// multiplexadores
    mux_alusrca MUX_alusra(
        PC_Out,
        output_a,
        sel_alusrca,
        alusrca_out
    );

    mux_alusrcb MUX_alusrb(
        output_b,
        sign_extend_16_32_out,
        shift_left_2_out,
        sel_alusrcb,
        alusrcb_out
    );

    mux_shift_amt MUX_shift_amt(
        instr15_00,
        output_b,
        // mem -> tem que adicionar a porta
        sel_shift_amt,
        out_shift_amt
    );

    mux_shift_src MUX_shift_src(
        output_b,
        output_a,
        sel_shift_src,
        output_shift_src
    );

    mux_BranchOp MUX_branchop(
        sel_branchop,
        alu_eq,
        ~alu_eq,
        alu_gt,
        ~alu_gt,
        output_branchop
    );

    mux_IorD MUX_iord(
        sel_mux_iord,
        PC_Out,
        ALU_out,
        IorD_out
    );


// outros componentes
    Memoria MEM(
        IorD_out,
        clk,
        wr,
        StoreSize_out,
        MEM_out
    );

    Instr_Reg RegistradorInstr(
        clk,
        reset,
        sel_ir,
        MEM_out,
        instr31_26,
        instr25_21,
        instr20_16,
        instr15_00
    );

    RegDesloc ShiftReg(
        clk,
        reset,
        sel_shift_reg,
        out_shift_amt,
        output_shift_src,
        output_shift
    );

    Banco_reg BANCO_reg(
        clk,
        reset,
        regwrite,
        regread_out,
        instr20_16,
        regdst_out,
        memtoreg_out,
        input_a,
        input_b
    );

    sing_extend_1_32 Zero_extend_1_32(
        alu_lt,
        lt_extended,
    );

    sing_extend_16_32 Sign_extend_16_32(
        instr15_00,
        sign_extend_16_32_out
    );

    shift_left_2 Shift_left_2(
        sign_extend_16_32_out,
        shift_left_2_out
    );

    shift_left_2_PC Shift_left_2_PC(
        instr25_00,
        shift_left_2_pc_out
    );
    
    loadSize Load_Size(
        LSControl1,
        LSControl2,
        MDR_out,
        load_size_out
    );
    
    storeSize Store_Size(
        SSControl1,
        SSControl2,
        output_b,
        MDR_out,
        StoreSize_out
    );


endmodule
