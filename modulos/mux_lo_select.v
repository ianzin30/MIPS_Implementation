module mux_lo_select(
    input wire [31:0] in_0, // div low
    input wire [31:0] in_1, // mult low
    input wire        select, //Controlado pelo LoSelect
    output reg [31:0]  out
);

always@(*)begin
    case (select)
        1'b0: out = in_0;
        1'b1: out = in_1;
    endcase
end
endmodule
