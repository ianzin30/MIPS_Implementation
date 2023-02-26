module shift_left_16 (
  input wire [15:0] in_1; //rd
  output wire [31:0] extended;
);

  assign extended = {in_1, {16{1'b0}}}; // add 16 "0"s

endmodule
