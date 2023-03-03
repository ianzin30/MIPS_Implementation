module mux_pc_source( 
    input wire [31:0] in_000,  // alu_result
    input wire [31:0] in_001,  // alu_out
    input wire [27:0] in_010,  // jump
    input wire [31:0] in_100,  // epc
    input wire        in_101,  // zero
    input wire [31:0] in_110,  // load_size
    input wire [2:0]  select,  // pc_source
    output reg [31:0] out
);

    always @(*) begin
        case(select)
            3'b000: out = in_000;
            3'b001: out = in_001;
            3'b010: out = in_010;
            3'b011: out = 32'b0;
            3'b100: out = in_100;
            3'b101: out = in_101;
            3'b110: out = in_110;
            3'b111: out = 32'b0;; 
        endcase
    end
endmodule