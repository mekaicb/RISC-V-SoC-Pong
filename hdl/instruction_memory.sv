module instruction_memory(
	input logic [31:0] addr_in,
	input logic	clk,
	output logic [31:0] data_out
	);
	
	logic [31:0] mem_array[0:69119]; //69120 words in a single column
	
	// Note: Wont compile since quartus will try to load 32x69120 dff's. Will run in Modelsim though

	initial $readmemh("../test/sumtest.txt", mem_array); //read data from hex_file.txt and write to mem_array
		
	always_ff @(posedge clk) begin
		data_out <= mem_array[addr_in[18:2]]; // 17 address bits to select one word (log(69120) = 16.02 -> 17)
	end
	
endmodule


/*
Without shifting: addr_in = 0x00000004 -> mem_array[4] -> 5th word
But we want this to refer to byte 5, not word 5. 
To convert this to byte addressibility, divide by 4 (shift bits right by two)
Which is the same as addressing [18:2] instead of [16:0]
*/