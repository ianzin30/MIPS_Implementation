module div(
    input wire clk, // entrada de clock
    input wire reset, // sinal de reset
    input wire div_control, // sinal para iniciar a divisão
    input signed [31:0] A, // input A
    input signed [31:0] B, // input B
    output reg [31:0] hi,  // resto
    output reg [31:0] lo, // quociente
    output reg div_stop, // indica fim da divisão
    output reg div_zero // indica divisão por 0
);

reg signed [31:0] dividendo; // registrador local do dividendo
reg signed [31:0] divisor; // registrador local do divisor
reg signed [31:0] quociente; // registrador do quociente
reg signed [31:0] resto; // registrador do resto
reg quociente_negativo; // caso os números tenham sinais diferentes
reg resto_negativo; // caso o dividendo seja negativo
integer contador = 31; // contador para iterar pelos bits do número


always @(posedge clk or posedge reset) 
    begin
        if(reset == 1)
            begin
                dividendo = 32'b0;
                divisor = 32'b0;
                quociente = 32'b0;
                resto = 32'b0;
                quociente_negativo = 0;
                resto_negativo = 0;
                div_zero = 0;
                div_stop = 0;
                hi = 32'b0;
                lo = 32'b0;
            end

        
        if (div_control == 1)
            begin
                contador = 31;
                quociente_negativo = 0;
                resto_negativo = 0;
                dividendo = A;
                divisor = B;
                quociente = 32'b0;
                resto = 32'b0;
                hi = 32'b0;
                lo = 32'b0;
                div_stop = 0;
            
        
                if (divisor == 32'b0)
                    begin
                        div_zero = 1;
                        div_stop = 1;
                        contador = -1;
                    end
                else
                    begin
                        div_zero = 0;
                    end
                
                if(dividendo[31] != divisor[31])
                    begin
                        quociente_negativo = 1;
                    end
                if(dividendo[31] == 1)
                    begin
                        dividendo = ~(dividendo) + 1'b1;
                        resto_negativo = 1;
                    end
                if(divisor[31] == 1'b1)
                    begin
                        divisor = ~(divisor) + 1'b1;
                    end 
            
            end
        
        if (contador >= 0)
            begin
                resto = resto << 1;
                resto[0] = dividendo[contador];
                if(resto >= divisor)
                    begin
                        resto = resto - divisor;
                        quociente[contador] = 1;
                    end

                
            end
        
        if (contador == 0 && div_zero == 0)
            begin
                hi = resto;
                lo = quociente;
                if(quociente_negativo == 1 && lo != 0)
                    begin
                        lo = ~(lo) + 1'b1;
                    end
                if(resto_negativo == 1 && hi != 0)
                    begin
                        hi = ~(hi) + 1'b1;
                    end
                div_stop = 1;
                contador = -1;
            end

        if (contador == -1) // mantém os registradores como 0 caso não esteja executando a divisão
            begin
                quociente = 32'b0;
                resto = 32'b0;
                dividendo = 32'b0;
                divisor = 32'b0;
                quociente_negativo = 0;
                resto_negativo = 0;
            end

        contador = contador - 1;
        if(contador == -3)
            begin
                div_stop = 0;
            end
        
    end

endmodule