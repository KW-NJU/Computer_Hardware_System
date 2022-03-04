module os(cur_num,txt_line, txt_len, run_end,
argv, code_start, code_end, process,
clk,ps2_clk,ps2_data,rst,hsync,vsync,vga_r,vga_g,vga_b,vga_sync_n,pclk,valid,
led, show_time,alahour,alamin,ret0,watch);
/* keyboard & monitor */

	/* CPU回传输出信号 */
	
	input [127:0]txt_line;
	input [3:0]txt_len;
	input run_end;
	wire [7:0]back_ascii;
	wire occupy;
	store_char(clk, txt_line, txt_len, run_end, back_ascii, occupy);
	
	/* 键盘信号*/
	input clk,ps2_clk,ps2_data;
	
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
	wire clrn, nextdata_n, overflow;
	wire wren;
	reg ready;
	
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
	write_location wl(clk, clear, occupy, back_ascii, res_ascii, loc_x, loc_y, ready, wren);
	calculate cw(loc_x, loc_y, waddr); // 显存写入位
	wire [7:0]ascii_display; // 从显存读取到的ASCII码
	wire [11:0]single_line; // 每次读取单个字模的一行
	wire current_bit; // 单字模行中的列位
	templates read_rom(ascii_display, current_bit, char_h, char_v, ascii_v, raddr, waddr); // 从ROM里读数据
	wire [7:0]cur_ascii;
	write_wait ww(clk, occupy, back_ascii, res_ascii, cur_ascii);
	/* keboard units */
	make2ascii u1(
		.clock(clk),
		.data(din),
		.rdaddress(make_code),
		.wraddress(make_code),
		.wren(forbid),
		.q(ascii));
	ps2_keyboard u2(clk, clrn, ps2_clk, ps2_data, make_code, out_ready, nextdata_n, overflow);
	wire out_ready;
	always @ (*)
		ready = out_ready;
	process_data u3(ready, make_code, ascii, res_code, res_ascii, count, cap, combination);
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

/* end of keyboard & monitor */


/* clock & alarm clock */
output reg [4:0] alahour;
output reg [5:0] alamin;
output reg [1:0] show_time;
reg clear;

/* operating system */

output reg[31:0] code_start; // eip指针起始位置
output reg[31:0] code_end; // endeip
output reg process;
output reg [9:0] led;
output reg [31:0]argv; // 传给CPU的参数
output reg ret0,watch;
reg process_instruction;
reg argv_ready;
reg [31:0] argvtemp;
reg [7:0]pointer;
reg [7:0]instruction[32];
reg [7:0]str_argv[3]; // 输入的参数，全是ASCII码
reg need_argv; // 是否即将或正在为程序输入参数
reg[3:0] argv_len;
reg[3:0]	cur_cnt;
reg str_argv_ready;
wire OK;
reg finished;
initial begin
	finished <= 0;
	pointer <= 0;
	process_instruction <= 0;
	need_argv <= 0;
	argv_len <= 0;
	argv_ready <= 0;
	str_argv_ready <= 0;
	process <= 0;
	convert <= 0;
	cur_cnt <= 0;
	prev_str_argv_ready <= 0;
	show_time <= 0;
	led[9:0] <= 10'b0000000000;
	prev_end <= 0;
	cur_num <= 0;
	ret0 <= 0;
	watch <= 0;
	alahour <= 25;
	alamin <= 0;
	clear <= 0;
end
wire [7:0]y;
assign y = loc_y - 10;
reg calculated;
/* 只要是键盘有输入，就读进来，在模块里分流为指令和参数 */
always @ (posedge clk) begin
	argv_ready = 0;
	if(ready) begin
		if(need_argv && !argv_ready && run_end)
		begin
			process_instruction = 0; // 唯一增加
			argvtemp=argv;
			if(res_ascii != 10) begin
				if(res_ascii != 0) begin
					if(res_ascii >= 8'h30 && res_ascii <= 8'h39) begin
						cur_num = res_ascii - 8'h30;
						if(!calculated)
							argv = argvtemp * 10 + cur_num;
						calculated = 1;
					end
					else begin
						cur_num = 0;
					end
				end
			end
			else
				argv_ready = 1;
		end
		else 
		begin
			calculated = 0;
			argv = 0;
			argv_len = 0;
			if(res_ascii != 10) 
			begin
				process_instruction = 0;
				if(res_ascii != 0) 
				begin	
					instruction[y] = res_ascii;
				end
			end
			else 
			begin
				process_instruction = 1;
			end
		end
	end
	else
		calculated = 0;
end

reg convert;
reg prev_str_argv_ready;
reg [7:0]current_ascii;
output reg [31:0]cur_num;
/* 对整条输入命令进行判断，更改need_argv, 回传给输入函数*/
reg prev_process_instruction;
reg to_process;
initial begin
	prev_process_instruction = 0;
	to_process = 0;
end
always @ (posedge clk) begin // 都改为了阻塞
	if(finished)
		need_argv = 0;
		clear = 0;
	if(!prev_process_instruction && process_instruction) begin
		if(instruction[0] != 46 || instruction[1] != 47) begin
			code_start = 0; // invalid input
			code_end = 16;
			need_argv = 0;
			to_process = 1;
		end
		else if(instruction[2] == 104 && instruction[3] == 101 && instruction[4] == 108 && instruction[5] == 108 && instruction[6] == 111) begin
			code_start = 16; // hello
			code_end = 32;
			need_argv = 0;
			to_process = 1;
		end
		else if(instruction[2] == 102 && instruction[3] == 105 && instruction[4] == 98) begin//fib
			need_argv = 1;
			code_start = 32;
			code_end = 260;
			to_process = 0;
		end
		else if(instruction[2] == 116 && instruction[3] == 105 && instruction[4] == 109 && instruction[5] == 101) begin
			need_argv = 0;//time
			to_process = 0;
			if(instruction[7] == 111 && instruction[8] == 110) show_time = 2'b01;//on
			else if(instruction[7] == 111 && instruction[8] == 102 && instruction[9] == 102 && show_time == 1) show_time = 2'b00;//off
		end
		else if(instruction[2] == 119 && instruction[3] == 97 && instruction[4] == 116 && instruction[5] == 99 & instruction[6] == 104)
			begin
				need_argv = 0;
				to_process = 0;
				if(instruction[8] == 111 && instruction[9] == 110)
					begin
						ret0 = 0;
						show_time = 2'b10;//on
					end
				else if(instruction[8] == 111 && instruction[9] == 102 && instruction[10] == 102 && show_time == 2)
					begin
						ret0 = 0;
						show_time = 2'b00;//off
					end
				else if(instruction[8] == 115 && show_time == 2)
					begin
						ret0 = 0;
						watch = 1;//start
					end
				else if(instruction[8] == 112 && show_time == 2)
					begin
						ret0 = 0;
						watch = 0;//pause
					end
				else if(instruction[8] == 114 && show_time == 2) ret0 = 1;//reset
			end
		else if(instruction[2] == 108 && instruction[3] == 101 && instruction[4] == 100) begin//led
			need_argv = 0;
			to_process = 0;
			if(instruction[6] == 97 && instruction[7] == 108 && instruction[7] == 108) led[9:0]=~led[9:0];
			else led[instruction[6]-48]=!led[instruction[6]-48];
		end
		else if(instruction[2] == 97 && instruction[3] == 108 && instruction[4] == 97 && instruction[5] == 114 && instruction[6] == 109)
		begin//alarm
			need_argv = 0;
			to_process = 0;
			if(instruction[8] == 111 && instruction[9] == 102 && instruction[10] == 102) alahour = 25;//off
			else
				begin
					alahour = ((instruction[8]-8'h30) << 3) + ((instruction[8]-8'h30) << 1) + (instruction[9]-8'h30);
					alamin = ((instruction[11]-8'h30) << 3) + ((instruction[11]-8'h30) << 1) + (instruction[12]-8'h30);
				end
		end
		else if(instruction[2] == 99 && instruction[3] == 108 && instruction[4] == 101 && instruction[5] == 97 && instruction[6] == 114)
			begin//clear
				need_argv = 0;
				to_process = 0;
				clear = 1;
			end
		else begin
			code_start = 0; // invalid input
			code_end = 16;
			need_argv = 0;
			to_process = 1;
		end
	end
	else
		to_process = 0;
		prev_process_instruction = process_instruction;
end

always @ (*) begin
	if(OK == 1) begin
		process = 1;
	end
	else if(ready == 1) begin
		process = 0;
	end
	else if(run_end == 1) begin
		process = 0;
	end
end
reg prev_end;
always @ (negedge clk) begin
	if(!prev_end && run_end)
		finished = 1;
	else
		finished = 0;
	prev_end = run_end;
end
assign OK = (need_argv && argv_ready) || (!need_argv && process_instruction && to_process);
/* end of operating system */

endmodule