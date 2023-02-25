module mux_alusrca(input wire [31:0] in_0, // registrador a
                input wire [31:0] in_1, // registrador b
                input wire sel,
                output reg [31:0] out
                );
  
  always@(*) begin
    case (sel)
      1'b0: out = a;
      1'b1: out = b;
    endcase
  end
endmodule
