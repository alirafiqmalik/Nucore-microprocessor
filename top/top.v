module top(KEY_N,LEDR,HEX0_N,HEX1_N,HEX2_N,HEX3_N,HEX4_N,HEX5_N);
//top module to interface MicroProcessor with FPGA I/O
input [1:0]KEY_N;
output [1:0]LEDR;
output [6:0]HEX0_N,HEX1_N,HEX2_N,HEX3_N,HEX4_N,HEX5_N;


wire Clk;
wire [38:0] IF_Instruction;
wire [31:0]ID_OPA,ID_OPB,ALUresult;
wire [5:0] IF_PC;
wire Zero,Rst,PC_RST;

assign Clk=KEY_N[1];//attach clock to key_1
assign PC_RST=KEY_N[0];//attach PC_RST to key_0

NuCore MP(Clk,PC_RST,Rst,IF_PC,IF_Instruction,ID_OPA,ID_OPB,ALUresult,Zero);//instantiating Pipelined MicroProcessor

//displaying ALUResult on HEX0 and HEX1 
hexto7segment H0(ALUresult[3:0],HEX0_N);
hexto7segment H1(ALUresult[7:4],HEX1_N);

hexto7segment H2(ID_OPA[3:0],HEX2_N);
hexto7segment H3(ID_OPB[3:0],HEX3_N);

hexto7segment H4(IF_PC[3:0],HEX4_N);
hexto7segment H5({2'b00,IF_PC[5:4]},HEX5_N);

assign LEDR[0]=Zero;//attach zero flag to LEDR0
assign LEDR[1]=Rst;//attach Reset flag to LEDR1

endmodule




/////////////////////////////////////////////////////////////////////////////////////////////////////
//PipelinedMP
module NuCore(Clk,PC_RST,Rst,IF_PC,IF_Instruction,ID_OPA,ID_OPB,ALUresult,Zero);
parameter n=32;//32 bit datawidth 

input Clk,PC_RST;//input signals

//output signals for running testbench and confirming outputs
output [38:0] IF_Instruction;
output [n-1:0]ID_OPA,ID_OPB,ALUresult;
output [5:0] IF_PC;
output Zero,Rst;




//////////////////////////////////////////////////////////////////////////////////////////////////////
//(Instruction Fetch) IF Stage
PC Program_Counterd(Clk,PC_RST,1'b1,IF_PC);//PC counter in IF stage
InstructionCache IC(Clk,IF_PC,IF_Instruction);//PC counter in IF stage
//////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////////////////////////////
//IF_ID Pipline REG
wire IF_Rst;
assign Rst=IF_Rst;
assign IF_Rst=IF_Instruction[38:36]!=3'b000;
wire [38:0] ID_Instruction;

Register IF_ID(Clk,PC_RST,1'b1,{IF_Instruction},{ID_Instruction});
defparam IF_ID.N=39;
//39+1=39
//////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////////////////////////////
//(Instruction Decode + Write Stage) ID+W Stage
wire ID_Rst;
wire RegWriteA,RegWriteB;
wire [3:0]RegNo;
wire [2:0]ID_ALUCtrl;

control C1(Clk,ID_Rst,ID_Instruction,RegWriteA,RegWriteB,ID_ALUCtrl);

wire RST_REG;
assign RST_REG=ID_Rst & PC_RST;
RegFile REGA(Clk,RST_REG,RegWriteA,ID_Instruction[35:32],ID_Instruction[31:0],ID_OPA);
RegFile REGB(Clk,RST_REG,RegWriteB,ID_Instruction[35:32],ID_Instruction[31:0],ID_OPB);
//////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////////////////////////////
//(ID+W)_EX Pipline REG
wire [2:0]EX_ALUCtrl;
wire [n-1:0] EX_OPA,EX_OPB,EX_ALUresult;
wire EX_Rst,EX_Zero;

Register ID_EX(Clk,PC_RST,1'b1,{ID_OPA,ID_OPB,ID_ALUCtrl,ID_Rst},{EX_OPA,EX_OPB,EX_ALUCtrl,EX_Rst});
defparam ID_EX.N=68;
//32+32+3+1=68
//////////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////////////////////////////
//(Execute)EX Stage
ALU alu(EX_OPA,EX_OPB,EX_ALUCtrl,EX_ALUresult,EX_Zero);
//////////////////////////////////////////////////////////////////////////////////////////////////////
//ALU Pipline REG
Register ALUREG(Clk,EX_Rst & PC_RST,1'b1,{EX_ALUresult,EX_Zero},{ALUresult,Zero});
defparam ALUREG.N=33;
//////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule





//REGISTER MODULE to be used for PIPELINING REGISTER's
module Register(Clk,Rst,Enable,D,Q); 
parameter N=32;
input Clk,Rst,Enable;
input [N-1:0]D;
output reg[N-1:0]Q;

always@(posedge Clk,negedge Rst)begin
if(!Rst)Q<=0;
else if(Enable)Q<=D;
else Q<=Q;
end

endmodule







module hexto7segment(input [3:0]x,output reg [6:0]z);//7 segment hex decoder to display results
always @(x)
case (x)
   4'h0 : z = 7'b1000000;
	4'h1 : z = 7'b1111001;
	4'h2 : z = 7'b0100100;
	4'h3 : z = 7'b0110000;
	4'h4 : z = 7'b0011001;
	4'h5 : z = 7'b0010010;
	4'h6 : z = 7'b0000010;
	4'h7 : z = 7'b1111000;
	4'h8 : z = 7'b0000000;
	4'h9 : z = 7'b0010000;
	4'hA : z = 7'b0001000;
	4'hB : z = 7'b0000011;
	4'hC : z = 7'b1000110;
	4'hD : z = 7'b0100001;
	4'hE : z = 7'b0000110;
	4'hF : z = 7'b0001110;
	
 default:z= 7'b1111111; 
 endcase
endmodule