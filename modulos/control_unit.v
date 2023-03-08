module control_unit(
// Inputs
    // clk e reset
    input wire clk,
    input reg reset,

    // Instruções
    input wire [5:0]  input_op,
    input wire [5:0]  input_funct,
    
    // Flags
    input wire div_zero,
    input wire div_stop,
    input wire mult_stop,
    input wire overflow,

// Outputs
    // Operações
    output reg div_control,          // Indicar início da divisão
    output reg mult_control,         // Indicar início da multiplicação
    output reg [2:0]  sel_aluop,     // Selecionar função da ALU
    output reg [2:0]  sel_shift_reg, // selecionar op no shift reg
    
    // Registradores
    output reg AB_load,
    output reg wr,            // MemRead or MemWrite
    output reg regwrite,      // escrever/ler no banco de reg
    output reg sel_ir,        // Selecionador do instruction reg
    output reg EPC_load,      // sinal para carregar no EPC
    output reg aluout_load,   
    output reg HiLo_load,
    output reg MDR_load,

    // oi jotavesse
    // PC Write
    output reg PC_WriteCond,  // branch signal
    output reg PC_write,      // PC_Write

    // Muxes
    output reg [3:0] sel_mux_mem_to_reg,
    output reg [2:0] sel_mux_iord,
    output reg [2:0] sel_pc_source,       // Selecionar mux do pc_source
    output reg [2:0] sel_regDst,          // Selecionar registrador destino
    output reg [1:0] sel_shift_amt,       //Selecionar mux amt
    output reg [1:0] sel_alusrcb,   // Selecionar entrada do registrador B
    output reg sel_regread,          // sinal do mux regread
    output reg sel_shift_src,       // sinal do shift src
    output reg [1:0] sel_branchop,        // Selecionar a operação a Branch
    output reg sel_mux_hi,          // sinal do mux hi select
    output reg sel_mux_lo,          // sinal do mux lo select
    output reg sel_alusrca,   // Selecionar entrada do registrador A

    // Size Operations
    output reg ls_control_1,    // Controlador do Load Size1
    output reg ls_control_2,    // Controlador do Load Size2
    output reg ss_control_1,    // Seletor do Store Size
    output reg ss_control_2    // Seletor do Store Size
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
parameter FUN_RTE      = 6'h13;
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
parameter ST_reset = 6'd0;
parameter ST_fetch1 = 6'd1;
parameter ST_fetch2 = 6'd2;
parameter ST_decode1 = 6'd3;
parameter ST_decode2 = 6'd4;

parameter ST_IOP = 6'd5;    // opcode invalido
parameter ST_trat1 = 6'd6;  // primeira etapa do tratamento de excecao
parameter ST_trat2 = 6'd7;
parameter ST_trat3 = 6'd8;
parameter ST_trat4 = 6'd9;  // ultima etapa

parameter ST_beq = 6'd10;
parameter ST_bne = 6'd11;
parameter ST_bgt = 6'd12;
parameter ST_ble = 6'd13;

parameter ST_j = 6'd14;
parameter ST_jal1 = 6'd15;
parameter ST_jal2 = 6'd16;
parameter ST_jr1 = 6'd17;
parameter ST_jr2 = 6'd18;

parameter ST_div1 = 6'd19;
parameter ST_div2 = 6'd43;
parameter ST_div3 = 6'd20;
parameter ST_DP0 = 6'd21;   // divisao por zero

parameter ST_mult1 = 6'd22;
parameter ST_mult2 = 6'd44;
parameter ST_mult3 = 6'd23;

parameter ST_mfhi = 6'd24;
parameter ST_mflo = 6'd25;

parameter ST_xch1 = 6'd26;
parameter ST_xch2 = 6'd27;
parameter ST_xch3 = 6'd28;
parameter ST_xch4 = 6'd29;

parameter ST_sram1 = 6'd30;
parameter ST_sram2 = 6'd31;
parameter ST_sram3 = 6'd32;
parameter ST_sram4 = 6'd33;
parameter ST_sram5 = 6'd34;

parameter ST_and = 6'd35;
parameter ST_sub = 6'd36;
parameter ST_add = 6'd37;
parameter ST_save011 = 6'd38;

parameter ST_addi = 6'd39;
parameter ST_addiu = 6'd40;
parameter ST_save000 = 6'd41;

parameter ST_overflow = 6'd42;    // overflow

parameter ST_ShiftV = 6'd43; // Funçoes de Shift com Variável (SLLV/SRAV)
parameter ST_ShiftI = 6'd44; // Funçoes de Shift com Imediato (SLL, SRA, SRL)
parameter ST_SLLV = 6'd45; 
parameter ST_SRAV = 6'd46;
parameter ST_SLL = 6'd47;
parameter ST_SRA = 6'd48;
parameter ST_SRL = 6'd49;
parameter ST_ShiftS = 6'd50; // Fim das funçoes de Shift (S de Save)

parameter ST_SLTI = 6'd51;
parameter ST_SLT = 6'd52;
parameter ST_BREAK = 6'd53;
parameter ST_RTE = 6'd54;

parameter ST_LUI = 6'd55;

parameter ST_loadstr1 = 6'd56; // O que direciona para load ou Store
parameter ST_loadstr2 = 6'd57;
parameter ST_mdrwrite = 6'd58;

parameter ST_LW = 6'd59;
parameter ST_LH = 6'd60;
parameter ST_LB = 6'd61;

parameter ST_SW = 6'd62;
parameter ST_SH = 6'd63;
parameter ST_SB = 6'd64;
parameter ST_decode3 = 6'd65;

reg [5:0] STATE;
reg [5:0] SHIFT_MODE;
reg [6:0] COUNTER;

initial begin
    STATE <= ST_reset;
end

always @(posedge clk) begin
    if (reset == 1'b1 || STATE == ST_reset) begin
        STATE <= ST_fetch1;
        AB_load <= 0;
        wr <= 0;
        sel_ir <= 0;
        EPC_load <= 0;
        aluout_load <= 0;
        HiLo_load <= 0;
        PC_WriteCond <= 0;
        PC_write <= 0;
        sel_shift_src <= 0;
        sel_branchop <= 0;
        sel_mux_hi <= 0;
        sel_mux_lo <= 0;
        sel_alusrca <= 0;
        ls_control_1 <= 0;
        ls_control_2 <= 0;
        ss_control_1 <= 0;
        ss_control_2 <= 0;
        sel_regread <= 0;
        sel_alusrcb <= 2'b0;
        sel_shift_amt <= 2'b0;
        sel_aluop <= 2'b0;
        sel_shift_reg <= 2'b0;
        sel_pc_source <= 3'b0;
        sel_mux_iord <= 3'b0;
        // resetando o topo da pilha
        sel_regDst <= 3'b001;
        sel_mux_mem_to_reg <= 4'b0101;
        regwrite <= 1;
    end else begin
        case(STATE)
            ST_fetch1:begin
                STATE <= ST_fetch2;
                sel_mux_iord <= 3'b0;
                wr <= 0;
            end
            ST_fetch2:begin
                STATE <= ST_decode1;
                sel_alusrca <= 0;
                sel_alusrcb <= 2'b01;
                sel_aluop <= 3'b001;
                sel_pc_source <= 3'b0;
                PC_write <= 1;
            end
            ST_decode1:begin
                STATE <= ST_decode2;
                sel_ir <= 1;
                sel_regread <= 0;
                regwrite <= 0;
            end
            ST_decode2:begin
                STATE <= ST_decode3;
                AB_load <= 1;
            end
            ST_decode3:begin
                sel_alusrca <= 0;
                sel_alusrcb <= 2'b11;
                sel_aluop <= 3'b001;
                aluout_load <= 1;

                case(input_op)
                    R_OPCODE:begin
                        case(input_funct)
                            FUN_ADD:begin
                                STATE <= ST_add;
                            end
                            FUN_AND:begin
                                STATE <= ST_and;
                            end
                            FUN_DIV:begin
                                STATE <= ST_div1;
                            end
                            FUN_MULT:begin
                                STATE <= ST_mult1;
                            end
                            FUN_JR:begin
                                STATE <= ST_jr1;
                            end
                            FUN_MFHI:begin
                                STATE <= ST_mfhi;
                            end
                            FUN_MFLO:begin
                                STATE <= ST_mflo;
                            end
                            FUN_SLL:begin
                                STATE <= ST_ShiftI;
                                SHIFT_MODE <= ST_SLL;
                            end
                            FUN_SLLV:begin
                                STATE <= ST_ShiftV;
                                SHIFT_MODE <= ST_SLLV;
                            end
                            FUN_SLT:begin
                                STATE <= ST_ShiftI;
                                SHIFT_MODE <= ST_SLT;
                            end
                            FUN_SRA:begin
                                STATE <= ST_ShiftI;
                                SHIFT_MODE <= ST_SRA;
                            end
                            FUN_SRAV:begin
                                STATE <= ST_ShiftV;
                                SHIFT_MODE <= ST_SRAV;
                            end
                            FUN_SRL:begin
                                STATE <= ST_ShiftI;
                                SHIFT_MODE <= ST_SRL;
                            end
                            FUN_SUB:begin
                                STATE <= ST_sub;
                            end
                            FUN_BREAK:begin
                                STATE <= ST_BREAK;
                            end
                            FUN_RTE:begin
                                STATE <= ST_RTE;
                            end 
                            FUN_XCHG:begin
                                STATE <= ST_xch1;
                            end
                        endcase
                    end
                    ADDI:begin
                        STATE <= ST_addi;
                    end
                    ADDIU:begin
                        STATE <= ST_addiu;
                    end
                    BEQ:begin
                        STATE <= ST_beq;
                    end
                    BNE:begin
                        STATE <= ST_bne;
                    end
                    BLE:begin
                        STATE <= ST_ble;
                    end
                    BGT:begin
                        STATE <= ST_bgt;
                    end
                    SRAM:begin
                        STATE <= ST_sram1;
                    end
                    LB:begin
                        STATE <= ST_LB;
                    end
                    LH:begin
                        STATE <= ST_LH;
                    end
                    LUI:begin
                        STATE <= ST_LUI;
                    end
                    LW:begin
                        STATE <= ST_LW;
                    end
                    SB:begin
                        STATE <= ST_SB;
                    end
                    SH:begin
                        STATE <= ST_SH;
                    end
                    SLTI:begin
                        STATE <= ST_SLTI;
                    end
                    SW:begin
                        STATE <= ST_SW;
                    end
                    J:begin
                        STATE <= ST_j;
                    end
                    JAL:begin
                        STATE <= ST_jal1;
                    end
                endcase
            end
            ST_and:begin
                STATE <= ST_save011;
                sel_alusrca <= 2'd1;
                sel_alusrcb <= 2'd0;
                sel_aluop <= 3'b011;
                aluout_load <= 1;
            end
            ST_add:begin
                STATE <= ST_save011;
                sel_alusrca <= 2'd1;
                sel_alusrcb <= 2'd0;
                sel_aluop <= 3'b001;
                aluout_load <= 1;
            end
            ST_sub:begin
                STATE <= ST_save011;
                sel_alusrca <= 2'd1;
                sel_alusrcb <= 2'd0;
                sel_aluop <= 3'b001;
                aluout_load <= 1;
            end
            ST_j:begin
                STATE <= ST_fetch1;
                sel_pc_source <= 3'b010;
                PC_write <= 1;
            end
            ST_IOP:begin
                STATE <= ST_trat1;
                sel_alusrca <= 0;
                sel_alusrcb <= 2'b01;
                sel_aluop <= 3'b010;
                EPC_load <= 1;
            end
            ST_trat1:begin
                STATE <= ST_trat2;
                sel_mux_iord <= 3'b010;
                wr <= 0;
            end
            ST_trat2:begin
                // estado apenas de waiting
                STATE=ST_trat3;
            end
            ST_trat3:begin
                STATE <= ST_trat4;
                MDR_load <= 1;
                ls_control_1 <= 1;
                ls_control_2 <= 1;
                sel_pc_source <= 3'b110;
            end
            ST_trat4:begin
                STATE <= ST_fetch1;
                PC_write <= 1;
            end
            ST_SLT:begin
                STATE <= ST_fetch1;
                sel_alusrca <= 1'b1;
                sel_alusrcb <= 2'b00;
                sel_aluop <= 3'b111;
                sel_mux_mem_to_reg <= 4'b1000;
                sel_regDst <= 3'b011;
            end
            ST_SLTI:begin
                STATE <= ST_fetch1;
                sel_alusrca <= 1'b1;
                sel_alusrcb <= 2'b10;
                sel_aluop <= 3'b111;
                sel_mux_mem_to_reg <= 4'b1000;
                sel_regDst <= 3'b011;
            end
            ST_BREAK:begin
                STATE <= ST_fetch1;
                sel_alusrca <= 1'b1;
                sel_alusrcb <= 2'b01;
                sel_aluop <= 3'b010;
                sel_pc_source <= 3'b000;
                PC_write <= 1'b1;
            end
            ST_RTE:begin
                sel_pc_source <= 3'b100;
                PC_write <= 1'b1;
            end
            ST_ShiftV:begin
                STATE <= SHIFT_MODE;
                sel_shift_src <= 1'b0;
                sel_shift_reg <= 3'b001;
            end
            ST_ShiftI:begin
                STATE <= SHIFT_MODE;
                sel_shift_src <= 1'b1;
                sel_shift_reg <= 3'b001;
            end
            ST_SLLV:begin
                STATE <= ST_ShiftS;
                sel_shift_amt <= 2'b00;
                sel_shift_reg <= 3'b010;
            end
            ST_SRAV:begin
                STATE <= ST_ShiftS;
                sel_shift_amt <= 2'b00;
                sel_shift_reg <= 3'b100;
            end
            ST_SLL:begin
                STATE <= ST_ShiftS;
                sel_shift_amt <= 2'b01;
                sel_shift_reg <= 3'b010;
            end
            ST_SRA:begin
                STATE <= ST_ShiftS;
                sel_shift_amt <= 2'b01;
                sel_shift_reg <= 3'b100;
            end
            ST_SRL:begin
                STATE <= ST_ShiftS;
                sel_shift_amt <= 2'b01;
                sel_shift_reg <= 3'b011;
            end
            ST_ShiftS:begin
                STATE <= ST_fetch1;
                sel_mux_mem_to_reg <= 4'b0100;
                 sel_regDst <= 3'b011;
            end
             ST_save011:begin
                STATE <= ST_fetch1;
                aluout_load <= 0;
                sel_regDst <= 3'b011;
                sel_mux_mem_to_reg <= 4'd0;
                regwrite <= 1;
            end
            default:begin
                STATE <= ST_IOP;
                
            end
        endcase
    end
end
endmodule