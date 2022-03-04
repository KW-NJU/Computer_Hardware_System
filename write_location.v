module write_location(clk, clear, put_back, back_ascii, res_ascii, loc_x, loc_y, ready, wren);
	input clk,clear;
	input ready;
	input put_back;
	input [7:0]res_ascii;
	input [7:0]back_ascii;
	output reg [5:0]loc_x;
	output reg [7:0]loc_y;
	reg [5:0]prev_x[32];
	reg [7:0]prev_y[32];
	reg [4:0]count;
	reg prev_put_back;
	output reg wren;
	reg flag;
	reg prev_ready;
	initial begin
		loc_x = 0;
		loc_y = 10;
		flag = 0;
		count = 0;
	end
	always @ (posedge clk) begin
	if(clear)
		begin
			loc_x = 0;
			loc_y = 10;
		end
	if(!prev_ready && ready) begin
		if(res_ascii != 0) begin
			if(res_ascii == 8) begin
				loc_x = prev_x[count-1];
				loc_y = prev_y[count-1];
				count = count-1;
			end
			else if(res_ascii == 10) begin
				prev_x[count] = loc_x;
				prev_y[count] = loc_y;
				count = count + 1;
				loc_y = 10;
				loc_x = loc_x + 1;
			end
			else if(loc_y == 69) begin
				prev_x[count] = loc_x;
				prev_y[count] = loc_y;
				count = count + 1;
				loc_y = 10;
				loc_x = loc_x + 1;
			end
			else begin
				if(loc_x == 0 && loc_y == 0 && flag == 0)
					flag = 1;
				else begin
					prev_x[count] = loc_x;
					prev_y[count] = loc_y;
					count = count + 1;
					loc_y = loc_y + 1;
				end
			end
		end
	end
	else if(!prev_put_back && put_back) begin
		loc_y = 10;
	end
	else if(put_back) begin
		if(back_ascii != 0) begin
			if(back_ascii == 10) begin
				loc_y = 10;
				loc_x = loc_x + 1;
			end
			else if(loc_y == 69) begin
				loc_y = 10;
				loc_x = loc_x + 1;
			end
			else begin
				if(loc_x == 0 && loc_y == 0 && flag == 0)
					flag = 1;
				else begin
					loc_y = loc_y + 1;
				end
			end
		end
	end
	prev_ready = ready;
	prev_put_back = put_back;
	end
endmodule