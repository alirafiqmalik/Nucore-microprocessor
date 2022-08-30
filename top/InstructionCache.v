module InstructionCache(Clk,addr,Instruction);
parameter DATA_WIDTH=39, ADDR_WIDTH=6;

input Clk;
output [(DATA_WIDTH-1):0] Instruction;
input [(ADDR_WIDTH-1):0] addr;

//instantiating ram module for Instruction Cache
// which Reads and assigs initial values to RAM from "instruction1.txt" file
RAM ram1(
	{(DATA_WIDTH){1'b0}},
	addr,
	1'b0, 
	Clk,
	Instruction
);



endmodule



//RAM module created by modifiying ram template from quartusus 
module RAM
#(parameter DATA_WIDTH=39, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input we, Clk,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[(2**ADDR_WIDTH)-1:0];


	// Specify the initial contents.  You can also use the $readmemb
	// system task to initialize the RAM variable from a text file.
	// See the $readmemb template page for details.		
	initial 
	begin : INIT
		$readmemb("instructions1.txt", ram);//Reading and assiging initial values to RAM from "instruction1.txt" file
	end 

	
		
	always @ (posedge Clk)
	begin
		// Write
		if (we)
			ram[addr] <= data;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr];

endmodule


