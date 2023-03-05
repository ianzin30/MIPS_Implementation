module mult(
    input wire clk, // entrada de clock
    input wire reset, // sinal de reset
    input wire mult_control, // sinal para iniciar a multiplicação
    input signed [31:0] A, // input A
    input signed [31:0] B, // input B
    output reg signed [31:0] hi,  // registrador com os 32 bits mais significativos
    output reg signed [31:0] lo, // registrador com os 32 bits menos significativos
    output reg mult_stop // indica fim da multiplicação
);

reg signed[63:0] produto; // registrador local com o resultado da multiplicação
reg [31:0] B_negativo;
reg B_sig = 0; 
integer contador;

always @(posedge clk or posedge reset) 
    begin
        if (reset == 1)
            begin
                produto = 64'b0;
                hi = 32'b0;
                lo = 32'b0;
                B_negativo = 32'b0;
                contador = 0;
                B_sig = 0;
                mult_stop = 0;
            end
        if (mult_control == 1)
            begin
                B_sig = 1'b0;
                produto = 64'b0;
                contador = 0;
                B_negativo = (~B + 32'd1); // complemento de 2 de B
                mult_stop = 0;
            end
        if(contador < 32)
            begin
                if ({A[contador], B_sig} == 2'b10) // vê se a concatenação dos bits é 2
                    begin
                        produto[63:32] = produto[63:32] + B_negativo;
                    end
                else if({A[contador], B_sig} == 2'b01) // vê se a concatenação dos bits é 1
                    begin
                        produto[63:32] = produto[63:32] + B;
                    end
                produto = produto >>> 1; // desloca para a direita preservando sinal
                B_sig = A[contador]; // atualiza B_sig
                contador = contador + 1;

                if (contador == 32)
                    begin
                        if (B == 32'h8000_0000) // 								
                            begin
                                produto = (~produto + 32'd1);
                            end
                        
                        hi = produto[63:32]; // 32 bits mais significativos
                        lo = produto[31:0]; // 32 bits menos significativos
                        mult_stop = 1;
                    end


            end
    end
                


endmodule