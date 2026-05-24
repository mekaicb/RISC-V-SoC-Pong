`timescale 1ns/1ps

module tb_CPU();
	logic clk, rst_n;
	logic [6:0] opcode;
	logic [2:0] funct3;
	logic funct7;
	int c_count;
	string inst_type;
	
	CPU dut(.clk(clk), .rst_n(rst_n));

	initial begin
		clk <= 1;
		rst_n <= 0;
		c_count = 0;
		$timeformat(-9, 0, " ns");
	end
	
	always #5ns clk = ~clk; // 100MHz clk
	
	initial begin
		#10;
		rst_n <= 1;
	end
	
	always_comb begin
		
		opcode = dut.opcode;
		funct3 = dut.funct3;
		funct7 = dut.funct7;
		
		case(opcode)
		
			7'b0110011 : begin // R-type
				case({funct7, funct3})
					4'b0000 : inst_type = "ADD";
					4'b1000 : inst_type = "SUB";
					4'b0001 : inst_type = "SLL";
					4'b0010 : inst_type = "SLT";
					4'b0011 : inst_type = "SLTU";
					4'b0100 : inst_type = "XOR";
					4'b0101 : inst_type = "SRL";
					4'b1101 : inst_type = "SRA";
					4'b0110 : inst_type = "OR";
					4'b0111 : inst_type = "AND";
					default  : inst_type = "R-type Unknown";
				endcase
			end
			
			7'b0010011 : begin // I-type Arith/Logic
				case(funct3)
					3'b000 : inst_type = "ADDI";
					3'b010 : inst_type = "SLTI";
					3'b011 : inst_type = "SLTIU";
					3'b100 : inst_type = "XORI";
					3'b110 : inst_type = "ORI";
					3'b111 : inst_type = "ANDI";
					3'b001 : inst_type = "SLLI";
					3'b101 : inst_type = funct7 ? "SRAI" : "SRLI";
					default : inst_type = "I-type ALU Unknown";
				endcase
			end
			
			7'b0000011 : begin // Loads
				case(funct3)
					3'b000 : inst_type = "LB";
					3'b001 : inst_type = "LH";
					3'b010 : inst_type = "LW";
					3'b100 : inst_type = "LBU";
					3'b101 : inst_type = "LHU";
					default : inst_type = "Load Unknown";
				endcase
			end
			
			7'b1100111 : inst_type = "JALR"; // JALR
			
			7'b0100011 : begin // S-type
				case(funct3)
					3'b000 : inst_type = "SB";
					3'b001 : inst_type = "SH";
					3'b010 : inst_type = "SW";
					default : inst_type = "S-type Unknown";
				endcase
			end
			
			7'b1100011 : begin // B-type
				case(funct3)
					3'b000 : inst_type = "BEQ";
					3'b001 : inst_type = "BNE";
					3'b100 : inst_type = "BLT";
					3'b101 : inst_type = "BGE";
					3'b110 : inst_type = "BLTU";
					3'b111 : inst_type = "BGEU";
					default : inst_type = "B-type Unknown";
				endcase
			end
			
			7'b0110111 : inst_type = "LUI"; 
			
			7'b0010111 : inst_type = "AUIPC";
			
			7'b1101111 : inst_type = "JAL";

			default    : inst_type = "Unknown";
		endcase
	end

	
	always @(posedge clk) begin
		c_count = c_count + 1;
		$display("| Time: %0t | Cycle: %0d | Instruction Type: %s |", $time, c_count, inst_type);
	end
	
endmodule
	
