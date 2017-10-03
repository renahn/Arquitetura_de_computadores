module alu32_tb;

  reg [31:0] a, b;
  reg [1:0] f;

  wire [31:0] y;

  logic zero, overflow, negativo, carry;

  reg clk;

  // Variáveis de simulacao
  reg  [31:0]   VetorNum, Erros;
  reg  [100:0]  VetorTeste[10000:0];
  reg  [31:0]   YEsperado;
  reg           ZeroEsperado;
  reg           OverflowEsperado;
  reg           NegativoEsperado;
  reg           CarryEsperado;

  // Instancia o device under test
  alu32 dut(
	.a(a),
	.b(b),
	.ALUControl(f),
	.Result(y),
	.zero(zero),
	.overflow(overflow),
	.neg(negativo),
	.carry(carry));

  // clock a cada 5 ps
  always
     begin
      	clk = 1;
	#5;
	clk = 0;
	#5;
     end

  // carrega vetores
  initial
     begin
      	$readmemh("alu32_teste.txt", VetorTeste);
      	VetorNum = 0; 
	Erros = 0;
     end

  // clock positivo
  always @ (posedge clk)
     begin
    	#1;
 	{CarryEsperado, NegativoEsperado, OverflowEsperado, ZeroEsperado, f, a, b, YEsperado} = VetorTeste[VetorNum];
    end

  // checagem dos resultados no clock negativo
  always @(negedge clk)
     begin
     	if ({y, zero, overflow, negativo, carry} !== {YEsperado, ZeroEsperado, OverflowEsperado, NegativoEsperado, CarryEsperado})
	  begin
	   $display("Teste numero: %.2d mal sucedido" , VetorNum);
           $display("outputs: y = %h | zero = %b | overflow = %b | negativo = %b | carry = %b", y, zero, overflow, negativo, carry);
	   $display("esperado:    %h |        %b |            %b |            %b |         %b", YEsperado, ZeroEsperado, OverflowEsperado, NegativoEsperado, CarryEsperado);
           $display("Error: inputs: f = %h | a = %h | b = %h \n", f, a, b);
	   Erros = Erros + 1;
      	  end
     	else
	  begin
	    $display("Teste numero: %.2d bem sucedido\n", VetorNum);
	  end

	VetorNum = VetorNum + 1;
     
	if (VetorTeste[VetorNum] === 101'hx)
          begin
       		$display("%d teste completado com %d erros", VetorNum, Erros);
          	$finish;
          end
  end
endmodule

