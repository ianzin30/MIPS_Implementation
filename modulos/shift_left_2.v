module shift_left_2 (
    input wire [31:0] in,
    output wire [31:0] out
);

    assign out = in << 2; // desloca colocando zeros à direita
    
endmodule