module div(
    input wire clk, // entrada de clock
    input wire reset, // sinal de reset
    input wire div_control, // sinal para iniciar a divisão
    input signed [31:0] A, // input A
    input signed [31:0] B, // input B
    output reg signed [31:0] hi,  // registrador com o resto
    output reg signed [31:0] lo, // registrador com o quociente
    output reg div_zero // sinal para indicar divisão por 0
);

reg signed [31:0] dividendo; // registrador local do dividendo
reg signed [31:0] divisor; // registrador local do divisor
reg signed [31:0] quociente; // registrador do quociente
reg signed [31:0] resto; // registrador do resto
reg quociente_negativo; // caso os números tenham sinais diferentes
reg resto_negativo; // caso o dividendo seja negativo
integer contador; // contador para iterar pelos bits do número

initial 
    begin
        div_zero = 0; // inicalizar o div_zero como 0
        hi = 32'b0; // inicaliza o resto como 0
        lo = 32'b0; // inicializa o quociente como 0
        dividendo = A; // carrega o dividendo para o registrador a
        divisor = B; // carrega o divisor para o registrador b
        contador = 31; //seta o contador como 31
    end

always @(posedge clk or posedge reset) 
    begin
        if (reset == 1) // reseta todos os registradores e o contador
            begin
                dividendo = 32'b0;
                divisor = 32'b0;
                quociente = 32'b0;
                resto = 32'b0;
                quociente_negativo = 0;
                resto_negativo = 0;
                div_zero = 0;
                hi = 32'b0;
                lo = 32'b0;
                contador = 0;
            end 
        if(div_control == 1 && contador == 31)
            begin

                if (divisor == 32'b0) // vê se o divisor é 0
                    begin
                        div_zero = 1;  // sinal que indica divisão por 0
                        contador = -1; // interrompe o contador
                    end 
                else 
                    begin
                        div_zero = 0;
                    end
                if (A[31] != B[31]) // checa se o sinal dos números é diferente
                    begin
                        quociente_negativo = 1;
                    end
                else
                    begin
                        quociente_negativo = 0;
                    end
                if(dividendo[31] == 1'b1) // checa se o dividendo é negativo
                    begin
                        dividendo = (~dividendo + 32'd1); // converte o dividendo para seu complemento de 2
                        resto_negativo = 1; // o resto será negativo
                    end
                else
                    begin
                        resto_negativo = 0;
                    end
                if(divisor[31] == 1'b1) // checa se o divisor é negativo
                    begin
                        divisor = (~divisor + 32'd1); // converte o divisor para seu complemento de 2
                    end
                quociente = 32'b0;
                resto = 32'b0;
            end
        
        resto = (resto << 1); // shift left de 1 bit do resto

        resto[0] = dividendo[contador]; //  carrega o valor do número atual do dividendo para o resto

        if(resto >= divisor)
            begin 
                resto = resto - divisor; // se o resto for maior que o divisor, subtrai o divisor do resto
                quociente[contador] = 1; // seta o atual dígito do quociente como 1
            end
        
        if(contador == 0) // caso a divisão tenha acabado
            begin
                if(div_zero == 0)
                    begin
                        hi = resto; // salva o resto em hi
                        lo = quociente; // salva o quociente em lo
                        if(quociente_negativo == 1 && lo != 0) // caso o quociente seja negativo e diferente de 0
                            begin
                                lo = (~lo + 1); // converte o valor em lo para complemento de 2
                            end
                        if(resto_negativo == 1 && hi != 0) // caso o resto seja negativo e diferente de 0
                            begin
                                hi = (~hi + 1); // converte o valor em hi para complemento de 2
                            end
                    end
        

                contador = -1; // interrompe o contador
            
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
    

    end
    

endmodule