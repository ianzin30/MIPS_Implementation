control_unit(
    // Input
    wire [5:0]  input_op,
    wire        div_zero,
    wire        overflow,

    // Outputs de 1 bit
    wire        PC_WriteCond,  // Falta na CPU
    wire        PC_write,      // PC_Write
    wire        wr,            // MemRead or MemWrite
    wire        sel_ir,        // Selecionar instrução
    wire        sel_regDst,    // Selecionar registrador destino
    wire        ss_control,    // Seletor do Store Size
    wire        regwrite,      // Selecionar Registrador Central
    wire        sel_alusrca,   // Selecionar entrada do registrador A
    wire        sel_branchop,  // Selecionar a operação a Branch
    wire        ls_control,    // Controlador do Load Size
    wire        sel_mux_hi,    // sinal do mux hi select
    wire        sel_mux_lo,    // sinal do mux lo select
    wire        sel_shift_src, // sinal do shift src
    wire        EPC_load,      // sinal para carregar no EPC
    


    // Outpus de 2 bits
    wire [1:0]  sel_alusrcb,
    wire [1:0]  sel_shift_amt, //Selecionar a porta da qnt a deslocar
    // Output de 3 bits
    wire [2:0]  sel_mux_iord,
    wire [2:0]  sel_aluop,     // Selecionar função da ALU
    wire [2:0]  sel_pc_source, // Selecionar mux do pc_source
    wire [2:0]  sel_shift_reg, //sinal para selecionar a operação no shift_reg

    // Output de 4 bits
    wire [3:0]  sel_mux_mem_to_reg,

);
