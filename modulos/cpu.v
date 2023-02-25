module cpu(
    input wire clk,
    input wire reset
);

// Control wires
    wire PC_wr;

// Data wires
    wire [31:0] PC_Source_out;
    wire [31:0] PC_Out;

    Registrador PC(
        clk,
        reset,
        PC_wr,
        PC_Source_out,
        PC_Out
    );


endmodule