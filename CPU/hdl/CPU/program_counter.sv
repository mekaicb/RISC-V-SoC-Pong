module program_counter(
	input logic [31:0] addr_in,
	input logic clk, rst_n, pcwrite, ebreak, pcsrc,
	output logic [31:0] addr_out
	);
	
	always_ff @(posedge clk) begin
		if(!rst_n) begin
			addr_out <= 32'b0;
		end
		else if(ebreak) begin
			addr_out <= addr_out;
		end
		else if(!pcwrite || pcsrc) begin // if pcwrite = 0 or pcsrc, continue as normal, else stall
			addr_out <= addr_in; 
		end
		
		// else if pcwrite, hold prev value (addr_out <= addr_in)
		
	end
	
endmodule
