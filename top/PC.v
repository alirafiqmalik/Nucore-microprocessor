module PC(Clk,Rst,E,count);
//simple counter accting as Program counter
input Clk,Rst,E;
output reg [5:0] count;

always@(posedge Clk,negedge Rst)begin
	if(!Rst)count<=0;  //set count to 0 on 
	else if(E) count<=count+6'b000001;
	else count<=count;

	end
endmodule
