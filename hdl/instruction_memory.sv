module instruction_memory(
	input logic [31:0] addr_in,
	input logic	clk,
	output logic [31:0] data_out
	);
	
	logic [31:0] mem_array[0:16383]; // 64kB/270kB dedicated to ROM. 64kB = 16384 words in one column
	
	initial $readmemh("../test/sumtest.hex", mem_array); //read data from hex_file.txt and write to mem_array
		
	always_ff @(posedge clk) begin
		data_out <= mem_array[addr_in[15:2]]; // 5 address bits to select one word (log(16384) = 14)
	end
	
endmodule


/*
[15:2] forces word addressibility. Only addresses that're multiples of 4 are addressible in ROM. 
*/