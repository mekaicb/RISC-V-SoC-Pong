module instruction_memory(
	input logic [31:0] addr_in,
	input logic	clk,
	input logic stall,
	output logic [31:0] data_out
	);
	
	(* ramstyle = "M9K" *) logic [31:0] mem_array[0:1279]; // 0x0 to 0x13FF

	initial begin
		$readmemh("pong.hex", mem_array);
	end
	
	always_ff @(posedge clk) begin // synchronous read 
		if(!stall)
			data_out <= mem_array[addr_in[12:2]]; // 11 address bits to select one word (log2(1280) = 10.32)
	end
	
endmodule


/*
[12:2] forces word addressibility. Only addresses that're multiples of 4 are addressible in ROM. 
*/