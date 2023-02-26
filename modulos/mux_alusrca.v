module mux_alusrca(
    input wire [31:0] in_0, // pc
    input wire [31:0] in_1, // registrador a
    input wire sel,
    output reg [31:0] out
);
  
  always@(*) begin
    case (sel)
      1'b0: out = in_0;
      1'b1: out = in_1;
    endcase
  end
endmodule
