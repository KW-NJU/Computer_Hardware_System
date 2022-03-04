module store_char(clk, ipt_buf, len, process_over, char, do_loop);
	input [127:0]ipt_buf;
	input [3:0]len;
	input process_over;
	input clk;
	reg [7:0]i;
	/*wire [7:0]buf_0;
	wire [7:0]buf_1;
	wire [7:0]buf_2;
	wire [7:0]buf_3;
	wire [7:0]buf_4;
	wire [7:0]buf_5;
	wire [7:0]buf_6;
	wire [7:0]buf_7;
	wire [7:0]buf_8;
	wire [7:0]buf_9;
	wire [7:0]buf_10;
	wire [7:0]buf_11;
	wire [7:0]buf_12;
	wire [7:0]buf_13;
	wire [7:0]buf_14;
	wire [7:0]buf_15;*/
	output reg do_loop;
	output reg [7:0] char;
	wire [7:0]back_buf[16];
	assign back_buf[0] = ipt_buf[7:0];
	assign back_buf[1] = ipt_buf[15:8];
	assign back_buf[2] = ipt_buf[23:16];
	assign back_buf[3] = ipt_buf[31:24];
	assign back_buf[4] = ipt_buf[39:32];
	assign back_buf[5] = ipt_buf[47:40];
	assign back_buf[6] = ipt_buf[55:48];
	assign back_buf[7] = ipt_buf[63:56];
	assign back_buf[8] = ipt_buf[71:64];
	assign back_buf[9] = ipt_buf[79:72];
	assign back_buf[10] = ipt_buf[87:80];
	assign back_buf[11] = ipt_buf[95:88];
	assign back_buf[12] = ipt_buf[103:96];
	assign back_buf[13] = ipt_buf[111:104];
	assign back_buf[14] = ipt_buf[119:112];
	assign back_buf[15] = ipt_buf[127:120];
	initial begin
		i = 0;
	end
	reg prev;
	always @ (negedge clk) begin
		if(!prev && process_over)
			do_loop = 1;
		if(do_loop) begin
			if(i < len) begin
				char = back_buf[i];
				i = i + 1;
			end
			else if(i == len) begin
				i = 0;
				do_loop = 0;
			end
		end
		prev = process_over;
	end
endmodule