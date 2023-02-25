module RegRead(input wire [5:0] in_00, // rs
                     input wire [1:0] sel, // seleção
                     output reg [5:0] out, // output
                     );
  
  always@(*) begin
    case (sel)
      1'b0: out = in_00; 
      1'b1: out = 32'b11111; //31; 
    endcase
  end
endmodule
