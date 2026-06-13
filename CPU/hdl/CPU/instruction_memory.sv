module instruction_memory(
	input logic [31:0] addr_in,
	input logic	clk,
	output logic [31:0] data_out
	);
	
	(* ramstyle = "M9K" *) logic [31:0] mem_array[0:1279]; // word addressible 5kB memory (1280 words)
	
	initial begin
		$readmemh("../test/sumtest_ROM.hex", mem_array);
	end
	
	always_ff @(posedge clk) begin // synchronous read 
		data_out <= mem_array[addr_in[12:2]]; // 11 address bits to select one word (log2(1280) = 10.32)
	end
	
endmodule


/*
[12:2] forces word addressibility. Only addresses that're multiples of 4 are addressible in ROM. 
*/