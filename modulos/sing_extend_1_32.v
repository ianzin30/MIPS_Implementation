module sing_extend_1_32( // O certo seria zero extend para ele extender apenas com zeros
    input  wire        aluRes,
    output wire [31:0] out
);
    assign out ={{31{1'b0}},aluRes};
endmodule