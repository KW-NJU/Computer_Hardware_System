module set_color(vga_r, vga_g, vga_b, current_bit, col);
	output reg[7:0] vga_r;
   output reg[7:0] vga_g;
   output reg[7:0] vga_b;
	input current_bit;
	input [7:0]col;
	always @ (*) begin
		if(current_bit) begin
			if(col < 8) begin
				vga_r = 8'b00000000;
				vga_g = 8'b11110000;
				vga_b = 8'b11110000;
			end
			else if(col < 10) begin
				vga_r = 8'b11110000;
				vga_g = 8'b11110000;
				vga_b = 8'b00000000;
			end
			else begin
				vga_r = 8'b11110000;
				vga_g = 8'b11110000;
				vga_b = 8'b11110000;
			end
		end
		else begin
			vga_r = 8'd0;
			vga_g = 8'd0;
			vga_b = 8'd0;
		end
	end
endmodule