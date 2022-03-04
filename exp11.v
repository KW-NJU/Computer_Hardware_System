module kbd_mntr(clk,ps2_clk,ps2_data,rst,hsync,vsync,vga_r,vga_g,vga_b,vga_sync_n,pclk,valid,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	/* 键盘信号*/
	input clk,ps2_clk,ps2_data; 
	
	
	output [6:0]HEX0;
	output [6:0]HEX1;
	output [6:0]HEX2;
	output [6:0]HEX3;
	output [6:0]HEX4;
	output [6:0]HEX5;
	
	
	wire _ready;
	wire _overflow;
	wire _nextdata_n;
	wire cap;
	wire combination;
	
	wire [7:0]din;
	wire forbid;
	wire [7:0]make_code;
	wire [7:0]ascii;
	wire [7:0]res_code;
	wire [7:0]res_ascii;
	wire [7:0]count;
	wire clrn, ready, nextdata_n, overflow;
	wire wren;
	
	assign din = 8'b0;
	assign forbid = 0;
	assign clrn = 1;
	
	/* 显示器信号 */
   input           rst;
   
   output          hsync;
   output          vsync;
   output [7:0]    vga_r;
   output [7:0]    vga_g;
   output [7:0]    vga_b;
	output 			 vga_sync_n;
	output 			 pclk;
	output          valid;
	assign vga_sync_n = 0;
	wire [9:0]      h_cnt;
   wire [9:0]      v_cnt;
	wire [11:0]waddr; // 光标位，用于向显存输入
	wire [11:0]raddr; // 显示器读取位
	wire [5:0]ascii_h; // 当前在显存中的行,h_cnt / 16
	wire [7:0]ascii_v; // 当前在显存中的列, v_cnt / 9
	wire [3:0]char_h; // 当前在字模中的行, h_cnt % 16
	wire [3:0]char_v; // 当前在字模中的列, v_cnt % 9
	calculate cr(ascii_h, ascii_v, raddr); // 显存读取位
	wire [5:0]loc_x; // 当前光标所在行
	wire [7:0]loc_y; // 当前光标所在列
	write_location wl(res_ascii, loc_x, loc_y, ready, wren);
	calculate cw(loc_x, loc_y, waddr); // 显存写入位
	wire [7:0]ascii_display; // 从显存读取到的ASCII码
	wire [11:0]single_line; // 每次读取单个字模的一行
	wire current_bit; // 单字模行中的列位
	templates read_rom(ascii_display, current_bit, char_h, char_v, ascii_v, raddr, waddr); // 从ROM里读数据
	wire [7:0]cur_ascii;
	write_wait ww(clk, res_ascii, cur_ascii);
	/* keboard units */
	make2ascii u1(
		.clock(clk),
		.data(din),
		.rdaddress(make_code),
		.wraddress(make_code),
		.wren(forbid),
		.q(ascii));
	ps2_keyboard u2(clk, clrn, ps2_clk, ps2_data, make_code, ready, nextdata_n, overflow);
	process_data u3(ready, make_code, ascii, res_code, res_ascii, count, cap, combination);
	display u4(res_code, res_ascii, count, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); // changed
	provide_signal_nextdata u5(clk, ready, nextdata_n);
	
	/* monitor units */
	vga_640x480 monitor_1 (
		.pclk(pclk), 
		.reset(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.valid(valid), 
		.h_cnt(h_cnt), 
		.v_cnt(v_cnt),
		.ascii_h(ascii_h), 
		.ascii_v(ascii_v), 
		.char_h(char_h), 
		.char_v(char_v)
		);
	dcm_25m #(25000000) monitor_2(clk, pclk, rst);
	set_color monitor_4(vga_r, vga_g, vga_b, current_bit, ascii_v);
	LUT ascii_ram(clk, cur_ascii, raddr, waddr, 1'b1, ascii_display); // 显存，屏幕上现有的ascii码
endmodule