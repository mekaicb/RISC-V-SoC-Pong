module frame_buffer(
	input logic clk, we,
	input logic [14:0] addr_w, addr_r,
	input logic [31:0] data_i,
	output logic [31:0] data_o
	);
	
	logic [14:0] eff_addr_r, eff_addr_w;
	(* ramstyle = "M9K" *) logic [31:0] vram[0:19199]; 
	localparam offset = 32'h00028000;
	
	assign eff_addr_r = addr_r - offset;
	assign eff_addr_w = addr_w - offset;
	
	always_ff @(posedge clk) begin 
		if(we)
			vram[eff_addr_w] <= data_i;// Synchronous write
		data_o <= vram[eff_addr_r]; // Synchronous read
	end	
	
endmodule