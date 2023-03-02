module mux_BranchOp(
    input  wire  [1:0]  select,
    input  wire in_00, // EQ
    input  wire in_01, // ~EQ
    input  wire in_10, // GT
    input  wire in_11, // ~GT
    output wire out
);

    always @(*) begin
        case(select)
            2'b00 out = in_00;
            2'b01 out = in_01;
            2'b10 out = in_10;
            2'b11 out = in_11;
        endcase

    end
endmodule