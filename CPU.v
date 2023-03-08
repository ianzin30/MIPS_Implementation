
/*// Imports dos módulos da Especificação

`include "Banco_reg.vhd"
`include "Instr_Reg.vhd"
`include "Memoria.vhd"
`include "RegDesloc.vhd"
`include "Registrador.vhd"
`include "ula32.vhd"


// Inports dos Módulos Criados
`include "mux_alusrca.v"
`include "mux_alusrcb.v"
`include "mux_BranchOp.v"
`include "mux_IorD.v"
`include "mux_pc_source.v"
`include "mux_RegDst.v"
`include "mux_shift_amt.v"
`include "mux_shift_src.v"
`include "mux_hi_select.v"
`include "mux_lo_select.v"
`include "mux_mem_to_reg.v"
`include "RegRead.v"
`include "shift_left_2.v"
`include "shift_left_2_PC.v"
`include "sing_extend_16_32.v"
`include "sing_extend_1_32.v"
`include "div.v"
`include "mult.v"
`include "control_unit.v"
`include "shift_left_16.v"
*/
module CPU(
    input wire clk,
    input wire reset
);

// Control wires 1 bit
    wire sel_regread;    // sinal do mux regread
    wire PC_write;
    wire wr;            // sinal da memoria
    wire AB_load;       // sinal para escrever em A e B
    wire aluout_load;   // sinal para escrever na ALUOut
    wire HiLo_load;     // sinal para escrever em Hi e em Lo
    wire EPC_load;      // sinal para escrever em epc
    wire sel_alusrca;   // sinal do mux alusrca
    wire sel_ir;        // selecionador do Registrador de Instruções
    wire sel_shift_src; // selecionador do mux de shift src
    wire sel_mux_hi;    // sinal do mux hi select
    wire sel_mux_lo;    // sinal do mux lo select
    wire output_branchop; // saida do mux branchop
    wire regwrite;      // sinal do banco de registradores
    wire MDR_load;      // sinal do MDR
    wire LSControl1;    // primeiro sinal do Load Size
    wire LSControl2;    // segundo sinal do Load Size
    wire SSControl1;    // primeiro sinal do Store Size
    wire SSControl2;    // segundo sinal do Store Size
    wire div_zero;      // indica divisão por 0
    wire div_control;   // indica início da divisão
    wire div_stop;      // indica fim da divisão
    wire mult_control;  // indica início da multiplicação
    wire mult_stop;     // indica fim da multiplicação
    wire PC_Write_Cond;
    

// Control wires 2 bits
    wire [1:0] sel_alusrcb;    // sinal do mux alusrcb
    wire [1:0] sel_shift_amt;  // sinal para selecionar o valor a deslocar
    wire [1:0] sel_branchop;  // sinal do mux branchOp


// Control wire 3 bits
    wire [2:0]  sel_shift_reg;      //sinal para selecionar a operação no shift_reg
    wire [2:0]  sel_pc_source;      //sinal para selecionar o mux do pc source
    wire [2:0]  sel_mux_iord;       // sinal do mux IorD
    wire [2:0]  sel_aluop;          // seletor ula
    wire [2:0]  sel_regDst;    // selcionar no mux RegDst


// Control wire 4 bits
    wire [3:0] sel_mux_mem_to_reg; // sinal do mux mem to reg


// Instruction wires
    wire [5:0]  instr31_26;
    wire [4:0]  instr25_21;
    wire [4:0]  instr20_16;
    wire [15:0] instr15_00;
    wire [25:0] instr25_00;
    wire [4:0]  instr15_11;


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
    wire [31:0] MEM_out;                 // saida da memoria
    wire [31:0] StoreSize_out;          // saida do store size
    wire [31:0] ALU_out;                // saida da ALU
    wire [31:0] ALUOut_Out;             // saida da ALUOut
    wire [31:0] alu_result;             // saida da alu
    wire [31:0] HiSelect_out;           // saida do mux Hiselect
    wire [31:0] Hi_Out;                 // saida de Hi
    wire [31:0] LoSelect_out;           // saida do mux Loselect
    wire [31:0] Lo_Out;                 // saida de Lo
    wire [31:0] EPC_out;                // saida do epc
    wire [31:0] alusrca_out;            // saida do AluSrcA
    wire [31:0] sign_extend_16_32_out;  // saida do sign extend 16-32
    wire [31:0] sign_extend_1_32_out;    // saída do sign extend 1-32
    wire [31:0] shift_left_2_out;       // saida do shift left 2
    wire [31:0] alusrcb_out;            // saida do alusrcb
    wire [31:0] output_shift_src;       // saida do shift_src
    wire [31:0] output_shift;           // saida do ShiftReg
    wire [31:0] lt_extended;            // resultado do LT extendido
    wire [31:0] MDR_out;                // saída do MDR
    wire [31:0] DIV_hi_out;             // saída HI da div
    wire [31:0] DIV_lo_out;             // saída LO da div
    wire [31:0] MULT_hi_out;            // saída HI da mult
    wire [31:0] MULT_lo_out;             // saída LO da mult
    wire [31:0] load_size_out;          // saída do load size
    wire [31:0] shift_left_16_out;      // saída do shift left 16


// Flags
    wire alu_lt;
    wire alu_eq;
    wire alu_gt;
    wire alu_zero;
    wire alu_overflow;
    wire alu_negative;

// sinal do pc
wire PC_SIGNAL;
wire branchwrite;
and BranchOut(branchwrite, output_branchop, PC_Write_Cond);
or BranchorPc(PC_SIGNAL, PC_write, branchwrite);

// registradores
    Registrador PC(
        clk,
        reset,
        PC_SIGNAL,
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
        MEM_out,
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
    
    mux_pc_source MUX_pc_source(
        alu_result,
        ALUOut_Out,
        shift_left_2_pc_out,
        EPC_out,
        alu_zero,
        load_size_out,
        sel_pc_source,
        PC_Source_out,
    );

    mux_hi_select MUX_hi_select(
        sel_mux_hi,
        DIV_hi_out,
        MULT_hi_out,
        HiSelect_out
    );

    mux_lo_select MUX_LO_select(
        sel_mux_lo,
        DIV_lo_out,
        MULT_lo_out,
        LoSelect_out
    );

    mux_mem_to_reg MUX_MEM_TO_REG(
        sel_mux_mem_to_reg,
        ALU_out,
        load_size_out,
        Hi_Out,
        Lo_Out,
        output_shift,
        shift_left_16_out,
        output_b,
        sign_extend_1_32_out,
        memtoreg_out
    );

    mux_RegDst MUX_RegDst(
        sel_regDst,
        instr25_21,
        instr20_16,
        instr15_11,
        regdst_out
    );

    RegRead MUX_RegRead(
        instr25_21,
        sel_regread,
        regread_out
    );

// outros componentes
    ula32 ULA(
        alusrca_out,
        alusrcb_out,
        sel_aluop,
        ALU_out,
        alu_overflow,
        alu_negative,
        alu_zero,
        alu_eq,
        alu_gt,
        alu_lt
    );
    
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

    div DIV(
        clk,
        reset,
        div_control,
        output_a,
        output_b,
        DIV_hi_out,
        DIV_lo_out,
        div_zero,
        div_stop
    );

    mult MULT(
        clk,
        reset,
        mult_control,
        output_a,
        output_b,
        MULT_hi_out,
        MULT_lo_out,
        mult_stop
    );

    shift_left_16 Shift_left_16(
        instr15_00,
        shift_left_16_out
    );


// unidade de controle
    control_unit Control_Unit(
    // Inputs
        // clk e reset
        .clk(clk),
        .reset(reset),
        .reset_out(1'b0), // Adicionar na cpu

        // Instruções
        .input_op(instr31_26),
        .input_funct(instr15_00[5:0]),

        // Flags
        .div_zero(div_zero),
        .div_stop(div_stop),
        .mult_stop(mult_stop),
        .overflow(alu_overflow),

    // Outputs
        // Operações
        .div_control(div_control),
        .mult_control(mult_control),
        .sel_aluop(sel_aluop),
        .sel_shift_reg(sel_shift_reg),

        // Registradores
        .AB_load(AB_load),
        .wr(wr),        
        .regwrite(regwrite),   
        .sel_ir(sel_ir),     
        .EPC_load(EPC_load),   
        .aluout_load(aluout_load),
        .HiLo_load(HiLo_load),
        .MDR_load(MDR_load),
        
        // PC Write
        .PC_Write_Cond(PC_Write_Cond),
        .PC_write(PC_write),

        // Muxes
        .sel_mux_mem_to_reg(sel_mux_mem_to_reg),
        .sel_mux_iord(sel_mux_iord),
        .sel_pc_source(sel_pc_source),     
        .sel_regDst(sel_regDst), 
        .sel_shift_amt(sel_shift_amt),     
        .sel_alusrcb(sel_alusrcb),
        .sel_regread(sel_regread),
        .sel_shift_src(sel_shift_src),     
        .sel_branchop(sel_branchop),      
        .sel_mux_hi(sel_mux_hi),        
        .sel_mux_lo(sel_mux_lo),        
        .sel_alusrca(sel_alusrca),
        
        // Size Operatios
        .ls_control_1(LSControl1),
        .ls_control_2(LSControl2),
        .ss_control_1(SSControl1),
        .ss_control_2(SSControl2)
    );
    
endmodule
