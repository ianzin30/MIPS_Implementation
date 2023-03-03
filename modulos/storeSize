module storeSize(
    input  wire SSControl1,
    input  wire SSControl2,
    input  wire [31:0] SSin_regB, 
    input  wire [31:0] SSin_mdr, 
    output wire [31:0] SSout
);

    wire [31:0] Aux;

    assign SSout = (SSControl1) ? Aux : SSin_regB;
    assign Aux   = (SSControl2) ? {SSin_mdr[31:8], SSin_regB[7:0]} : {SSin_mdr[31:16], SSin_regB[15:0]};


endmodule
