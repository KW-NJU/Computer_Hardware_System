module templates(ascii, q, char_h, char_v, ascii_v, raddr, waddr);
	input [7:0]ascii;
	input [3:0]char_h;
	input [3:0]char_v;
	input [7:0]ascii_v;
	wire [11:0]addr;
	input [11:0]raddr;
	input [11:0]waddr;
	assign addr = {ascii, 4'b0} + {8'b0, char_h}; // addr = ascii * 16 + char_h
	output q;
	reg [11:0]ascii_templates[4096]; // 字模，本质上是ROM
	initial begin
		$readmemh("vga_font.txt", ascii_templates, 0, 4095);
	end
	assign q = (ascii==8'h8||ascii==8'hA||ascii_v>=70||raddr>waddr) ? 0 : (ascii_templates[addr] >> char_v) & 1'b1;
endmodule