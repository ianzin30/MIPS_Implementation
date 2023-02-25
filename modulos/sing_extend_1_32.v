module sing_extend_1_32( // O certo seria zero extend para ele extender apenas com zeros
    input wire aluRes;
    output wire out;
);
    assign out ={{31{0'b1}},aluRes};
endmodule