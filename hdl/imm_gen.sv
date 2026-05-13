module imm_gen(
	input logic [11:0] imm_i,
	output logic [31:0] imm_o
	);
	
	assign imm_o = {{20{imm_i[11]}}, imm_i};

endmodule
	