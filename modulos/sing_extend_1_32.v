module sing_extend_1_32(
    input wire aluRes;
    output wire out;
);
    assign out ={{31{0'b1}},aluRes};
endmodule