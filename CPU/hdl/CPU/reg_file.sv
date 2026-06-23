module reg_file(
	input logic [4:0] rs2_addr, rs1_addr, rd_addr,
	input logic [31:0] rd_data,
	input logic regwrite_sel, clk, rst_n,
	output logic [31:0] rs2_data, rs1_data
	);
	
	logic [31:0] reg_in [0:31]; // array of 32 bit address input wires
	logic [31:0] reg_out [0:31]; // array of 32 bit data output wires
	logic [31:0] en;

	assign wr_en = regwrite_sel && (rd_addr != 5'd0); // Enable if write signal and not x0
	
	// decode logic
	always_comb begin
		en = 32'h0; //initialize enable as a 32 bit bus, one bit into each register 
		if(wr_en)
			en[rd_addr] = 1'b1; //only care about enable for writes
	end
	
	// generate array of registers
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin : reg_array
			reg_32bits register(reg_in[i], clk, rst_n, en[i], reg_out[i]); //reg_in[i] = 32 bit input into register
		end
	endgenerate
	
	// read/write logic
	always_comb begin
	
		for(int i = 0; i<32; i=i+1) begin // fix inferred latches warning
			reg_in[i] = 32'h0; // default all (enabled) register inputs to 0
		end
		
		// Write
		if(wr_en)
			reg_in[rd_addr] = rd_data; //write rd_data into its register
		
		// Read
		if(wr_en && (rd_addr == rs1_addr)) // Handles read after write hazard if load/store 3 cycles apart
			rs1_data = rd_data; // Forwards data to read
		else // Else read data as normal
			rs1_data = reg_out[rs1_addr];
		
		if(wr_en && (rd_addr == rs2_addr))
			rs2_data = rd_data;
		else
			rs2_data = reg_out[rs2_addr];
		
	end
	
endmodule

//
//	
//	

//module reg_file(
//	input logic [4:0] rs2_addr, rs1_addr, rd_addr,
//	input logic [31:0] rd_data,
//	input logic regwrite_sel, clk, rst_n,
//	output logic [31:0] rs2_data, rs1_data
//	);
//
//	logic [31:0] reg_in [0:31]; // array of 32 bit address input wires
//	logic [31:0] reg_out [0:31]; // array of 32 bit data output wires
//	logic [31:0] en;
//	logic        wr_en;          // effective write enable (x0 is never written)
//
//	// x0 must stay hardwired to 0: never enable a write into register 0.
//	// (Fixes jal x0 / rd==x0 corrupting register 0.)
//	assign wr_en = regwrite_sel && (rd_addr != 5'd0);
//
//	// decode logic
//	always_comb begin
//		en = 32'h0;                 // one enable bit per register
//		if(wr_en)
//			en[rd_addr] = 1'b1;     // only enable a real (non-zero) destination
//	end
//
//	// generate array of registers
//	genvar i;
//	generate
//		for(i=0; i<32; i=i+1) begin : reg_array
//			reg_32bits register(reg_in[i], clk, rst_n, en[i], reg_out[i]);
//		end
//	endgenerate
//
//	// read/write logic
//	always_comb begin
//
//		for(int i = 0; i<32; i=i+1)  // fix inferred latches warning
//			reg_in[i] = 32'h0;       // default all (enabled) register inputs to 0
//
//		if(wr_en)
//			reg_in[rd_addr] = rd_data; // write rd_data into its register
//
//		// ---- WRITE-FIRST / WRITE-THROUGH READ ----
//		// If a source register is the one being written THIS cycle, forward the
//		// new data directly to the read port. This closes the distance-3
//		// read-after-write hazard (producer in WB while consumer is in ID),
//		// which the EX/MEM and MEM/WB forwarding paths do NOT cover, and keeps
//		// x0 reading as 0 in all cases.
//		if(rs1_addr == 5'd0)
//			rs1_data = 32'h0;
//		else if(wr_en && (rd_addr == rs1_addr))
//			rs1_data = rd_data;
//		else
//			rs1_data = reg_out[rs1_addr];
//
//		if(rs2_addr == 5'd0)
//			rs2_data = 32'h0;
//		else if(wr_en && (rd_addr == rs2_addr))
//			rs2_data = rd_data;
//		else
//			rs2_data = reg_out[rs2_addr];
//
//	end
//
//endmodule