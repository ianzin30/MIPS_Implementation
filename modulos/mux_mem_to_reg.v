module mux_mem_to_reg( 
    input wire [31:0] in_0000, // AluOut
    input wire [31:0] in_0001, // LoadSize
    input wire [31:0] in_0010, // Hi
    input wire [31:0] in_0011, // Lo
    input wire [31:0] in_0100, // ShiftReg
    input wire [31:0] in_0110, // ShifLeft16
    input wire [31:0] in_0111, // B(rt)
    input wire [31:0] in_1000, // SignExtend
    input wire [3:0]  select, //Controlado pelo MemtoReg
    output reg [31:0] out
);

    always @(*) begin
        case(select)
            4'b0000: out = in_0000;
            4'b0001: out = in_0001;
            4'b0010: out = in_0010;
            4'b0011: out = in_0011;
            4'b0100: out = in_0100;
            4'b0101: out = 32'b11100011; // 227 em binário
            4'b0110: out = in_0110;
            4'b0111: out = in_0111;
            4'b1000: out = in_1000;
            4'b1001: out = 32'b0;
            4'b1010: out = 32'b0;
            4'b1011: out = 32'b0;
            4'b1100: out = 32'b0;
            4'b1101: out = 32'b0;
            4'b1110: out = 32'b0;
            4'b1111: out = 32'b0;

        endcase

    end
endmodule
