module read_pipe(
	input logic [9:0] x, y,
	output logic [17:0] r_addr
	);
	
	assign r_addr = (y << 5) + (y << 3) + (x >> 4);
	
endmodule

/*
	To convert a 2D address (x,y) into a 1D address to send to the frame buffer, we have
	1D = 640*y + x (Where 1D is the address for a single pixel)
	   = 512y+128y+x
		= y<<9 + y<<7 + x
	Since 1 address (word) = 16 pixels (For rgb support, 2 bits/pixel, 32 bits/word, -> 16 pixels/word)
	We must divide this by 16, equivalent to shifting right by 4
	
	Address = y<<5 + y<<3 + x>>4
*/

