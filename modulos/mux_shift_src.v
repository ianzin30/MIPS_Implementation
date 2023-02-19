module mux_shift_src(
    input wire [31:0] in_0, // shamt
    input wire [31:0] in_1, // reg
    input wire        select, //Controlado pelo ShiftSrc
    output reg [4:0]  out;
);

always@(*)begin
    case (select)
        1'b0: out = in_0;
        1'b1: out = in_1;
    endcase
end
endmodule