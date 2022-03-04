module display(make_code, ascii, count, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [7:0]make_code;
	input [7:0]ascii;
	input [7:0]count;
	output reg [6:0]HEX0;
	output reg [6:0]HEX1;
	output reg [6:0]HEX2;
	output reg [6:0]HEX3;
	output reg [6:0]HEX4;
	output reg [6:0]HEX5;
	
	always @ (*) begin
		case(make_code % 16)
			0: HEX0 = 7'b1000000;
			1: HEX0 = 7'b1111001;
			2: HEX0 = 7'b0100100;
			3: HEX0 = 7'b0110000;
			4: HEX0 = 7'b0011001;
			5: HEX0 = 7'b0010010;
			6: HEX0 = 7'b0000010;
			7: HEX0 = 7'b1111000;
			8: HEX0 = 7'b0000000;
			9: HEX0 = 7'b0010000;
			10: HEX0 = 7'b0001000;
			11: HEX0 = 7'b0000011;
			12: HEX0 = 7'b1000110;
			13: HEX0 = 7'b0100001;
			14: HEX0 = 7'b0000110;
			15: HEX0 = 7'b0001110;
		endcase
		case(make_code / 16)
			0: HEX1 = 7'b1000000;
			1: HEX1 = 7'b1111001;
			2: HEX1 = 7'b0100100;
			3: HEX1 = 7'b0110000;
			4: HEX1 = 7'b0011001;
			5: HEX1 = 7'b0010010;
			6: HEX1 = 7'b0000010;
			7: HEX1 = 7'b1111000;
			8: HEX1 = 7'b0000000;
			9: HEX1 = 7'b0010000;
			10: HEX1 = 7'b0001000;
			11: HEX1 = 7'b0000011;
			12: HEX1 = 7'b1000110;
			13: HEX1 = 7'b0100001;
			14: HEX1 = 7'b0000110;
			15: HEX1 = 7'b0001110;
		endcase
		case(ascii % 16)
			0: HEX2 = 7'b1000000;
			1: HEX2 = 7'b1111001;
			2: HEX2 = 7'b0100100;
			3: HEX2 = 7'b0110000;
			4: HEX2 = 7'b0011001;
			5: HEX2 = 7'b0010010;
			6: HEX2 = 7'b0000010;
			7: HEX2 = 7'b1111000;
			8: HEX2 = 7'b0000000;
			9: HEX2 = 7'b0010000;	
			10: HEX2 = 7'b0001000;
			11: HEX2 = 7'b0000011;
			12: HEX2 = 7'b1000110;	
			13: HEX2 = 7'b0100001;
			14: HEX2 = 7'b0000110;
			15: HEX2 = 7'b0001110;
		endcase
		case(ascii / 16)
			0: HEX3 = 7'b1000000;	
			1: HEX3 = 7'b1111001;	
			2: HEX3 = 7'b0100100;
			3: HEX3 = 7'b0110000;
			4: HEX3 = 7'b0011001;
			5: HEX3 = 7'b0010010;
			6: HEX3 = 7'b0000010;
			7: HEX3 = 7'b1111000;
			8: HEX3 = 7'b0000000;
			9: HEX3 = 7'b0010000;
			10: HEX3 = 7'b0001000;
			11: HEX3 = 7'b0000011;
			12: HEX3 = 7'b1000110;
			13: HEX3 = 7'b0100001;
			14: HEX3 = 7'b0000110;
			15: HEX3 = 7'b0001110;	
		endcase
		case(count % 16)
			0: HEX4 = 7'b1000000;	
			1: HEX4 = 7'b1111001;	
			2: HEX4 = 7'b0100100;
			3: HEX4 = 7'b0110000;
			4: HEX4 = 7'b0011001;
			5: HEX4 = 7'b0010010;
			6: HEX4 = 7'b0000010;
			7: HEX4 = 7'b1111000;
			8: HEX4 = 7'b0000000;
			9: HEX4 = 7'b0010000;
			10: HEX4 = 7'b0001000;
			11: HEX4 = 7'b0000011;
			12: HEX4 = 7'b1000110;
			13: HEX4 = 7'b0100001;
			14: HEX4 = 7'b0000110;
			15: HEX4 = 7'b0001110;	
		endcase
		case(count / 16)
			0: HEX5 = 7'b1000000;	
			1: HEX5 = 7'b1111001;	
			2: HEX5 = 7'b0100100;
			3: HEX5 = 7'b0110000;
			4: HEX5 = 7'b0011001;
			5: HEX5 = 7'b0010010;
			6: HEX5 = 7'b0000010;
			7: HEX5 = 7'b1111000;
			8: HEX5 = 7'b0000000;
			9: HEX5 = 7'b0010000;
			10: HEX5 = 7'b0001000;
			11: HEX5 = 7'b0000011;
			12: HEX5 = 7'b1000110;
			13: HEX5 = 7'b0100001;
			14: HEX5 = 7'b0000110;
			15: HEX5 = 7'b0001110;	
		endcase
	end
endmodule