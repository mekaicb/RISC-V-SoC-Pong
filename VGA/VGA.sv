module VGA(
	input logic clk_50, rst_n, we, // clk_50 is the 50MHz clock input 
	input logic [31:0] data_i,
	input logic [17:0] addr_i,
	output logic [2:0] rgb,
	output logic hsync, vsync
	);
	
	logic [17:0] addr_r;
	logic [9:0] x, y;
	logic [3:0] pixel_sel;
	logic [31:0] data_o;
	logic video_on;
	logic clk; // 25.175MHz input driving VGA modules
	
	assign pixel_sel = x[3:0]; // The upper bits of x are used to select the word, the bits shifted out are the "remainder" and are used to select the pixel in the word
	
	PLL PLL(.inclk0(clk_50), .c0(clk)); // Generates the 25.175MHz clock frequency
	frame_buffer frame_buffer(.clk_50(clk_50), .clk_25(clk), .we(we), .addr_w(addr_i), .data_i(data_i), .addr_r(addr_r),.data_o(data_o));
	VGA_controller VGA_controller(.clk(clk), .rst_n(rst_n), .x(x), .y(y), .h_sync(hsync), .v_sync(vsync), .video_on(video_on));
	pixel_color pixel_color(.clk(clk), .pixel_sel(pixel_sel), .video_on(video_on), .data_o(data_o), .rgb(rgb));
	read_pipe read_pipe(.x(x), .y(y), .r_addr(addr_r));
	
	
endmodule