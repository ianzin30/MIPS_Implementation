control_unit(
    // Inputs
    // clk e reset
    input wire        clk,
    input wire        reset,

    // Instruções
    input wire [5:0]  input_op,
    input wire [5:0]  input_funct,
    // Flags
    input wire        div_zero,
    input wire        overflow,

    // Outputs
    // Operações
    output wire [2:0]  sel_aluop,     // Selecionar função da ALU
    output wire [2:0]  sel_shift_reg, //sinal para selecionar a operação no shift_reg
    
    // Registradores
    output wire [1:0]  sel_alusrcb,   // Selecionar entrada do registrador B
    output wire        sel_alusrca,   // Selecionar entrada do registrador A
    output wire        AB_load,
    output wire        wr,            // MemRead or MemWrite
    output wire        regwrite,      // Selecionar Registrador Central
    output wire        sel_ir,        // Selecionar instrução
    output wire        EPC_load,      // sinal para carregar no EPC
    output wire        aluout_load,   
    output wire        HiLo_load,

    // PC Write
    output wire        PC_WriteCond,  // oi rubens
    output wire        PC_write,      // PC_Write
    
    // Muxes
    output wire [3:0]  sel_mux_mem_to_reg,
    output wire [2:0]  sel_mux_iord,
    output wire [2:0]  sel_pc_source,       // Selecionar mux do pc_source
    output wire [2:0]  sel_regDst,          // Selecionar registrador destino
    output wire [1:0]  sel_regread          // sinal do mux regread
    output wire [1:0]  sel_shift_amt,       //Selecionar a porta da qnt a deslocar
    output wire        sel_shift_src,       // sinal do shift src
    output wire        sel_branchop,        // Selecionar a operação a Branch
    output wire        sel_mux_hi,          // sinal do mux hi select
    output wire        sel_mux_lo,          // sinal do mux lo select
    
    // Size Operations
    output wire        ls_control_1,    // Controlador do Load Size1
    output wire        ls_control_2,    // Controlador do Load Size2
    output wire        ss_control_1,    // Seletor do Store Size
    output wire        ss_control_2,    // Seletor do Store Size
);


// Opcode Parameters

// R Istructions
parameter R_OPCODE = 6'h0;
parameter FUN_ADD      = 6'h20;
parameter FUN_AND      = 6'h24;
parameter FUN_DIV      = 6'h1a;
parameter FUN_MULT     = 6'h18;
parameter FUN_JR       = 6'h8;
parameter FUN_MFHI     = 6'h10;
parameter FUN_MFLO     = 6'h12;
parameter FUN_SLL      = 6'h0;
parameter FUN_SLLV     = 6'h4;
parameter FUN_SLT      = 6'h2a;
parameter FUN_SRA      = 6'h3;
parameter FUN_SRAV     = 6'h7;
parameter FUN_SRL      = 6'h2;
parameter FUN_SUB      = 6'h22;
parameter FUN_BREAK    = 6'hd;
parameter FUN_RTE      = 6'h13
parameter FUN_XCHG     = 6'h5;

// I Instructions 
parameter ADDI     = 6'h8;
parameter ADDIU    = 6'h9;
parameter BEQ      = 6'h4;
parameter BNE      = 6'h5;
parameter BLE      = 6'h6;
parameter BGT      = 6'h7;
parameter SRAM     = 6'h1;
parameter LB       = 6'h20;
parameter LH       = 6'h21;
parameter LUI      = 6'hf;
parameter LW       = 6'h23;
parameter SB       = 6'h28;
parameter SH       = 6'h29;
parameter SLTI     = 6'ha;
parameter SW       = 6'h2b;

// J Istructions
parameter J        = 6'h2;
parameter JAL      = 6'h3;

//States
