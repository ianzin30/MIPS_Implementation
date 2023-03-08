module shift_left_16 (
    input wire [15:0] in,
    output reg [31:0] out
);

    assign out = in << 16; // desloca colocando zeros à direita
    
endmodule
