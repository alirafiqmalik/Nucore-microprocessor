module RegFile(Clk,Rst,RegWrite,RegNo,Din,Qout);
//module for Regfile to be used for REGA and REGB 
parameter n=32,widthbit=4;

input Clk,Rst,RegWrite;
input [widthbit-1:0]RegNo;
input [n-1:0]Din;
output [n-1:0]Qout;

reg [n-1:0]RF [(2**widthbit)-1:0];
integer k;

always@(posedge Clk)begin
if(!Rst)begin
	for(k=0;k<2**widthbit;k=k+1)RF[k]<=0; //setting all registers to 0 when reset
end
else if(RegWrite)begin
	RF[RegNo]<=Din;
end
end

assign Qout=RF[RegNo];
endmodule
