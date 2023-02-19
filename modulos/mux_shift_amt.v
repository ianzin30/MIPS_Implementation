module mux_shift_amt( 
    input wire [31:0] in_00, // shamt
    input wire [31:0] in_01, // reg
    input wire [31:0] in_10, // mem
    input wire [1:0]  select, //Controlado pelo ShiftAmt
    output reg [4:0] out;
);

    always @(*) begin
        case(select)
            2'b00: out = in_00;
            2'b01: out = in_01;
            2'b10: out = in_10;
        endcase

    end
endmodule