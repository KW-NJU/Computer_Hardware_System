module keyboard (clk, ps2_clk, ps2_data, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, _ready, _overflow, _nextdata_n, cap, combination);
	input clk,ps2_clk,ps2_data; 
	
	output [6:0]HEX0;
	output [6:0]HEX1;
	output [6:0]HEX2;
	output [6:0]HEX3;
	output [6:0]HEX4;
	output [6:0]HEX5;
	output wire _ready;
	output wire _overflow;
	output wire _nextdata_n;
	output wire cap;
	output wire combination;
	
	wire [7:0]din;
	wire forbid;
	wire [7:0]make_code;
	wire [7:0]ascii;
	wire [7:0]res_code;
	wire [7:0]res_ascii;
	wire [7:0]count;
	wire clrn, ready, nextdata_n, overflow;
	
	assign din = 8'b0;
	assign forbid = 0;
	assign clrn = 1;
	make2ascii LUT(
		.clock(clk),
		.data(din),
		.rdaddress(make_code),
		.wraddress(make_code),
		.wren(forbid),
		.q(ascii));
	ps2_keyboard accepting(clk, clrn, ps2_clk, ps2_data, make_code, ready, nextdata_n, overflow);
	process_data processing(ready, make_code, ascii, res_code, res_ascii, count, cap, combination);
	display displaying(res_code, res_ascii, count, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); // changed
	provide_signal_nextdata counting(clk, ready, nextdata_n);
	assign _ready = ready;
	assign _overflow = overflow;
	assign _nextdata_n = nextdata_n;
endmodule