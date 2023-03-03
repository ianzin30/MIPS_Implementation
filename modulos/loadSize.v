module loadSize(
    input wire LSControl1,
    input wire LSControl2,
    input wire [31:0] LSin_mdr,
    output wire [31:0] LSout
);

    wire [31:0] Aux;

    assign LSout = (LSControl1) ? Aux : LSin_mdr;
    assign Aux   = (LSControl2) ? {24'd0, LSin_mdr[7:0]} : {16'd0, LSin_mdr[15:0]};

endmodule
