module mux_hi_select(
    input wire [31:0] in_0, // div high
    input wire [31:0] in_1, // mult high
    input wire        select, //Controlado pelo HiSelect
    output reg [31:0]  out;
);

always@(*)begin
    case (select)
        1'b0: out = in_0;
        1'b1: out = in_1;
    endcase
end
endmodule