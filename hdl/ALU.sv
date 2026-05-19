module ALU(
	input logic [31:0] in1, in2,
	input logic [3:0] ALUcontrol,
	output logic [31:0] out
	);
	
	always_comb begin
		case(ALUcontrol)
		
		4'b0000 : out = in1 + in2; // ADD/ADDI
		4'b0001 : out = in1 - in2; // SUB/SUBI
		4'b0010 : out = in1 << in2[4:0]; // SLL/SLLI
		4'b0011 : out = ($signed(in1) < $signed(in2)) ? 1 : 0; // SLT/SLTI - Cares about sign bit
		4'b0100 : out = (in1 < in2) ? 1 : 0; // SLTU/SLTIU - Sign bit does not matter
		4'b0101 : out = in1 ^ in2; // XOR/XORI
		4'b0110 : out = in1 >> in2[4:0]; // SRL/SRLI
		4'b0111 : out = $signed(in1) >>> in2[4:0]; // SRA/SRAI (>>> duplicates sign bit)
		4'b1000 : out = in1 | in2; // OR/ORI
		4'b1001 : out = in1 & in2; // AND/ANDI
		default : out = 32'b0;
		endcase
	end

endmodule