module shift_left_2_PC (
    input wire [25:0] in,
    output reg [27:0] out
);

    assign out = {in, {2{1'b0}}};
    
endmodule