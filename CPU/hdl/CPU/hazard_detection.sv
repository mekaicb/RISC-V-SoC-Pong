module hazard_detection(
	input logic clk, rst_n,
	input logic [4:0] IFID_rs1_addr, IFID_rs2_addr, IDEX_rd_addr,
	input logic IDEX_memread, EXMEM_memread,
	output logic pcwrite, IFID_write, IDEX_hazard_flush,
	output logic IDEX_write, EXMEM_write, MEMWB_hazard_flush
);

	logic ram_stall_active;

	always_ff @(posedge clk) begin 	// 1-cycle state memory to prevent infinite stalls
		if(!rst_n)
			ram_stall_active <= 1'b0;
		else if(EXMEM_memread && !ram_stall_active) // If load current in MEM and hasnt stalled already
			ram_stall_active <= 1'b1; 
		else
			ram_stall_active <= 1'b0; // Lift stall on the next cycle
	end
	
	always_comb begin
		pcwrite = 1'b0; // Initialize to no stalls, active lows
		IFID_write = 1'b0;
		IDEX_write = 1'b0;
		EXMEM_write = 1'b0;
		IDEX_hazard_flush = 1'b0;
		MEMWB_hazard_flush = 1'b0;
		
		if(EXMEM_memread && !ram_stall_active) begin  // If load is in mem and hasnt stalled
			pcwrite = 1'b1;        
			IFID_write = 1'b1;     
			IDEX_write = 1'b1;     
			EXMEM_write = 1'b1;    
			MEMWB_hazard_flush = 1'b1; // Insert NOP bubble into WB stage to prevent double write back
		end
		
		else if(IDEX_memread) begin // if load in EX, check for store in ID
			if(IDEX_rd_addr == IFID_rs1_addr || IDEX_rd_addr == IFID_rs2_addr) begin // check if 1st instr src reg is 2nd instr dest reg
				pcwrite = 1'b1; // Hold the PC value
				IFID_write = 1'b1; // Hold the dependant instr in ID
				IDEX_hazard_flush = 1'b1; // Instead of allowing the dependant instr to advance to EX, place a NOP in the ex stage
			end
		end
	end

endmodule

/*
	Module to detect Load/Store hazards
	
	Flushing a pipeline sets its value on the NEXT clock cycle to a nop, nature of flip flops
	
*/