module mux_IorD(
    input  wire  [2:0]  select,
    input  wire  [31:0] in_000, // PC
    input  wire  [31:0] in_001, // ALUOut
    output wire  [31:0] out;
);

    always @(*) begin
        case(select)
            3'b000 out = in_000;
            3'b001 out = in_001;
            3'b010 out = 32'b11111101; // 253
            3'b011 out = 32'b11111110; // 254
            3'b100 out = 32'b11111111; // 255
            3'b101 out = 32'b0; // entradas unitilizadas
            3'b110 out = 32'b0;
            3'b111 out = 32'b0;
        endcase
        
    end
endmodule