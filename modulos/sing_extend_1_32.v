module sing_extend_1_32( // O certo seria zero extend para ele extender apenas com zeros
    input  wire        aluRes,
    output reg [31:0] out
);
    assign out ={{31'd0},aluRes};
endmodule