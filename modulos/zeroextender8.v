module zeroextender8 (
    input wire [7:0] in_1,
    output wire [31:0] out
);

    assign out = {{24{1'b0}},in_1};

endmodule
