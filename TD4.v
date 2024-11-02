module TD4(
		input clk,clr,
		input [3:0] CMD, DATA, regIN,
		output reg [3:0] regPC, regOUT
		);

reg [3:0] regA,regB,ADD_IN;
wire [4:0] ADD_OUT;
wire Cout;
assign Cout = ADD_OUT[4];

assign ADD_OUT = ADD_IN + DATA;

always @(posedge clk or negedge clr) begin
	//PC++
	if (!clr) begin
		// Асинхронный сброс: сбросить счётчик
		regPC <= 4'b0000;
		regA <= 4'b0000;
		regB <= 4'b0000;
		regOUT <= 4'b0000;
	end else begin
		// Инкрементирование счётчика
		regPC <= regPC + 1;
		// PC Job
		case (CMD[3:0])
			//A
			4'b0000 : begin ADD_IN <= regA; regA <= ADD_OUT; end
			4'b0001 : begin ADD_IN <= regB; regA <= ADD_OUT; end
			4'b0010 : begin ADD_IN <= regIN; regA <= ADD_OUT; end
			4'b0011 : begin ADD_IN <= 4'b0000; regA <= ADD_OUT; end
			//B
			4'b0100 : begin ADD_IN <= regA; regB <= ADD_OUT; end
			4'b0101 : begin ADD_IN <= regB; regB <= ADD_OUT; end
			4'b0110 : begin ADD_IN <= regIN; regB <= ADD_OUT; end
			4'b0111 : begin ADD_IN <= 4'b0000; regB <= ADD_OUT; end
			//OUT
			4'b1000 : begin ADD_IN <= regB; regOUT <= ADD_OUT; end
			4'b1001 : begin ADD_IN <= regB; regOUT <= ADD_OUT; end
			4'b1010 : begin ADD_IN <= 4'b0000; regOUT <= ADD_OUT; end
			4'b1011 : begin ADD_IN <= 4'b0000; regOUT <= ADD_OUT; end
			//JMP,JZ
			4'b1100 : begin ADD_IN <= regB; if (!Cout) begin  regPC <= ADD_OUT; end end
			4'b1101 : begin ADD_IN <= regB; if (!Cout) begin  regPC <= ADD_OUT; end end
			4'b1110 : begin ADD_IN <= 4'b0000; if (!Cout) begin  regPC <= ADD_OUT; end end
			4'b1111 : begin ADD_IN <= 4'b0000; regPC <= ADD_OUT; end
		endcase
		
   end
		  
 end

endmodule
