module shift_left_2_PC (
    input wire [31:0] pc_out,
    inout wire [4:0] instr25_21,
    inout wire [4:0] instr20_16,
    inout wire [15:0] instr15_0,
    output reg [31:0] out
);

reg [27:0] aux20_16;
reg [27:0] aux25_21;

always @ (*) begin
    aux20_16 = (instr20_16 << 16);
    aux25_21 = (instr25_21 << 21);
    out = (32'b00000000000000000000000000000000 + instr15_0);
    out = (out + aux20_16 + aux25_21);
    out = (out << 2);
    out[31] = (pc_out[31]);
    out[30] = (pc_out[30]);
    out[29] = (pc_out[29]);
    out[28] = (pc_out[28]);
end
    
endmodule