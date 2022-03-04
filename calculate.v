module calculate(x, y, res); // 计算70x+y
	input [5:0]x;
	input [7:0]y;
	wire [11:0]_x = {6'b0, x};
	wire [11:0]_y = {4'b0, y};
	output [11:0]res;
	assign res = (_x << 6) + (_x << 2) + (_x << 1) + _y;
endmodule