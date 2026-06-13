module RAM(
	input logic memwrite, memread, clk,
	input logic [31:0] addr_in,
	input logic [31:0] data_i,
	input logic [2:0] funct3,
	output logic [31:0] data_o
	);
	
	logic [2:0] byte_en; // Selects which byte of the word to load from memory, or store to memory
	logic [1:0] byte_sel;
	
	logic [31:0] eff_addr;
	(* ramstyle = "M9K" *) logic [31:0] mem_array[0:15359]; // Word addressible 15kB RAM. (15kB = 3840 words = 15360 bytes)
	
	localparam offset = 32'h0000A000; // Start at 15kB
	
	assign eff_addr = addr_in - offset;
	assign byte_sel = eff_addr[1:0]; // Assign byte enable to the lower two bits of the address input
	
	always_comb begin
		case(funct3)
			3'b000 : byte_en = 3'b000; // LB/SB, select byte 0
			3'b001 : byte_en = 3'b001; // LH/SH, select byte 0+1
			3'b010 : byte_en = 3'b010; // LW/SW, select full word
			3'b100 : byte_en = 3'b011; // LBU, select byte 0 & sign extend
			3'b101 : byte_en = 3'b100; // LHU, select byte 0 & sign extend
			default : byte_en = 2'b10;
		endcase
	end
	
	always_ff @(posedge clk) begin // Synchronous read
		if(memread) begin 
			case(byte_en) 
				3'b000 : begin // Will be selecting one byte
					case(byte_sel) // Which one byte to select specfically from the word in memory?
						2'b00 : data_o <= {24'b0, mem_array[eff_addr[15:2]][7:0]}; // Select the first byte of the word from the memory array, zero extend
						2'b01 : data_o <= {24'b0, mem_array[eff_addr[15:2]][15:8]}; 
						2'b10 : data_o <= {24'b0, mem_array[eff_addr[15:2]][23:16]};
						2'b11 : data_o <= {24'b0, mem_array[eff_addr[15:2]][31:24]};
					endcase
				end
				3'b001 : begin // Select two bytes
					case(byte_sel) // Which two bytes to select specifically
						2'b00 : data_o <= {16'b0, mem_array[eff_addr[15:2]][15:0]};
						2'b10 : data_o <= {16'b0, mem_array[eff_addr[15:2]][31:16]};
					endcase
				end
				3'b010 : begin
					data_o <= mem_array[eff_addr[15:2]];
				end
				3'b011 : begin
					case(byte_sel)
						2'b00 : data_o <= {{24{mem_array[eff_addr[15:2]][7]}}, mem_array[eff_addr[15:2]][7:0]}; // Sign extend the byte to 32 bits
						2'b01 : data_o <= {{24{mem_array[eff_addr[15:2]][15]}}, mem_array[eff_addr[15:2]][15:8]}; // Select the 2nd byte, place as lowest byte and sign extend to 32 bits
						2'b10 : data_o <= {{24{mem_array[eff_addr[15:2]][23]}}, mem_array[eff_addr[15:2]][23:16]};
						2'b11 : data_o <= {{24{mem_array[eff_addr[15:2]][31]}}, mem_array[eff_addr[15:2]][31:24]};
					endcase
				end
				3'b100 : begin
					case(byte_sel)
						2'b00 : data_o <= {{16{mem_array[eff_addr[15:2]][15]}}, mem_array[eff_addr[15:2]][15:0]}; // Sign extend the byte to 32 bits
						2'b01 : data_o <= {{16{mem_array[eff_addr[15:2]][31]}}, mem_array[eff_addr[15:2]][31:16]}; // Select the 2nd byte, place as lowest byte and sign extend to 32 bits
					endcase
				end
				default : data_o <= mem_array[eff_addr[15:2]]; // default read the full word
			endcase
		end
		if(memwrite) begin
			case(byte_en)
				2'b00 : begin
					case(byte_sel)
						2'b00 : mem_array[eff_addr[15:2]][7:0] <= data_i[7:0];
						2'b01 : mem_array[eff_addr[15:2]][15:8] <= data_i[7:0];
						2'b10 : mem_array[eff_addr[15:2]][23:16] <= data_i[7:0];
						2'b11 : mem_array[eff_addr[15:2]][31:24] <= data_i[7:0];
					endcase
				end
				2'b01 : begin
					case(byte_sel)
						2'b00 : mem_array[eff_addr[15:2]][15:0] <= data_i[15:0];
						2'b01 : mem_array[eff_addr[15:2]][31:16] <= data_i[15:0];
					endcase
				end
				2'b10 : begin
					mem_array[eff_addr[15:2]] <= data_i;
				end
				default : mem_array[eff_addr[15:2]] <= data_i;
			endcase
		end
			
	end
	
endmodule
	
	
/*
	- [15:2] because we are assuming word aligned address inputs
	- Assuming the lowest two bits refer to the byte address
*/
