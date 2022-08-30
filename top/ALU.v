module ALU(OPA,OPB,ALUCtrl,Result,Zero);
//module for ALU which decodes instruction directly from 3 bit instruction
parameter n=32;

input [2:0]ALUCtrl;
input [n-1:0]OPA,OPB;
output reg [n-1:0]Result;
output Zero;

assign Zero=(Result==0);

always@(*)begin
			case(ALUCtrl)
			3'b011:Result=OPA + OPB;
			3'b100:Result=OPA - OPB;
			3'b101:Result=OPA | OPB;
			3'b110:Result=OPA & OPB;
			3'b111:Result=OPA<<OPB;
			default:Result=0;
		endcase
	end
endmodule


