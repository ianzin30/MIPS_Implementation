control_unit(
    // Inputs
    // clk e reset
    input wire        clk,
    input wire        reset,

    // Instruções
    input wire [5:0]  input_op,

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

//States

// R Istructions

// I Instructions 

// J Istructions