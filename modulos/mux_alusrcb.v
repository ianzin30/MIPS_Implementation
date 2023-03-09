module mux_alusrcb(
    input wire [31:0] in_00, // Reg_B
    input wire [31:0] in_10, // Sign_extend
    input wire [31:0] in_11, // shift
    input wire [1:0] sel,
    output reg [31:0] out
);

  always@(*) begin
    case (sel)
      2'b00: out = in_00; 
      2'b01: out = 32'd4; // 4
      2'b10: out = in_10;
      2'b11: out = in_11;
    endcase
  end
endmodule
