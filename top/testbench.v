`timescale 1 ps/ 1 ps
module testbench();
// constants                                           
// general purpose registers
reg Clk;
reg PC_RST;
// wires                                               
wire [31:0] ALUresult;
wire [31:0] ID_OPA;
wire [31:0] ID_OPB;
//wire [38:0] IF_Instruction;

wire [38:36]IF_opcode;
wire [35:32]IF_RegAddress;
wire [31:0]IF_Immedval;


wire [5:0] IF_PC;
wire Rst;
wire Zero;

// NuCore module assignment                        
NuCore NuCore_TB(   
	.ALUresult(ALUresult),
	.Clk(Clk),
	.ID_OPA(ID_OPA),
	.ID_OPB(ID_OPB),
	.IF_Instruction({IF_opcode,IF_RegAddress,IF_Immedval}),
	.IF_PC(IF_PC),
	.PC_RST(PC_RST),
	.Rst(Rst),
	.Zero(Zero)
);
initial 
begin 
#1000000 $stop;
end 

// Clk
always
begin
	Clk = 1'b0;
	Clk = #5000 1'b1;
	#5000;
end 

// PC_RST
initial
begin
	PC_RST = 1'b0;
	PC_RST = #10000 1'b1;
	//PC_RST = #400000 1'b0;
	//PC_RST = #10000 1'b1;
end 
endmodule

