module frame_buffer(
	input logic clk_50, clk_25, we,
	input logic [17:0] addr_w,
	input logic [17:0] addr_r,
	input logic [31:0] data_i,
	output logic [31:0] data_o
	);
	
	logic [17:0] eff_addr_w;
	logic [17:0] eff_addr_r;
	
	(* ramstyle = "M9K" *) logic [31:0] vram[0:19199];
	localparam offset = 32'h5000;  // 0x5000 to 0x17BFF
	
	assign eff_addr_r = addr_r; // address from read pipe is already from 0 to 19199, no need to subtract offset
	assign eff_addr_w = (addr_w - offset) >> 2; // address from processor would be something like 0x00028000, need to subtract offset
	
	always_ff @(posedge clk_50) begin // Writes at processor speed, 50MHz
		if(we)
			vram[eff_addr_w] <= data_i;// Synchronous write
	end	

	always_ff @(posedge clk_25) begin // Reads at 25.175MHz
		data_o <= vram[eff_addr_r]; // Synchronous read
	end
	

endmodule