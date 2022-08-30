module control(Clk,Rst,Instruction,RegWriteA,RegWriteB,ALUCtrl);
//control unit to decode instruction and generate required control signals
input Clk;
input [38:0] Instruction;
output RegWriteA,RegWriteB,Rst;
output [2:0]ALUCtrl;

assign Rst=(Instruction[38:36]!=3'b000);
assign RegWriteA=(Instruction[38:36]==3'b001);
assign RegWriteB=(Instruction[38:36]==3'b010);

assign ALUCtrl=Instruction[38:36];

endmodule
