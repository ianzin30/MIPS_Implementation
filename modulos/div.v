module div(
    input clk,
    input reset,
    input signed [31:0] A, 
    input signed [31:0] B,
    output reg signed [31:0] hi, 
    output reg signed [31:0] lo,
    output reg div_zero
);

reg signed [31:0] a;
reg signed [31:0] b;
reg signed [31:0] quociente;
reg signed [31:0] resto;

always @(posedge clk or posedge reset) 
    begin
        if (reset) 
            begin
                a = 32'b0;
                b = 32'b0;
                quociente = 32'b0;
                resto = 32'b0;
                div_zero = 0;
                hi = 32'b0;
                lo = 32'b0;
            end 
        else 
            begin
            a = A;
            b = B;
            
            if (b == 32'b0) 
                begin
                    div_zero = 1;
                end 
            else 
                begin
                    quociente = a / b;
                    resto = a % b;
                    lo = quociente;
                    hi = resto;
                    div_zero = 0;
                end
            end
    end

endmodule