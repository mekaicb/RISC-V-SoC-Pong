module IFID_buffer(
	input	logic [31:0] pc_addr_i, inst_data_i,
	input clk, rst_n,
	output logic [31:0] pc_addr_o, inst_data_o
	);
	
	always @(posedge clk) begin
		if(!rst_n) begin // if reset enabled, flush buffers
			pc_addr_o <= 0;
			inst_data_o <= 0;
		end
		else begin // else send input data through to output on the next clock cycle
			pc_addr_o <= pc_addr_i;
			inst_data_o <= inst_data_i;
		end
	end
endmodule

// Note: if/else in sequential blocks require begin/end statements