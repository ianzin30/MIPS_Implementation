module mux_RegDst(
    input  wire  [2:0]  select,
    input  wire  [4:0] in_000, // rt
    input  wire  [4:0] in_011, // rd
    input  wire  [4:0] in_100, // rs
    output wire  [4:0] out
);

    always @(*) begin
        case(select)
            3'b000 out = in_000;   
            3'b001 out = 5'b11101; // 29
            3'b010 out = 5'b11111; // 31
            3'b011 out = in_011;
            3'b100 out = in_100;
            3'b101 out = 32'b0; // entradas unitilizadas
            3'b110 out = 32'b0;
            3'b111 out = 32'b0;
        endcase
    end
endmodule