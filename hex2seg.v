module hex2seg(hex,seg);
	input [3:0] hex;
	output reg [6:0] seg;
	always @ (hex)
		begin
			case(hex)
				15: seg=7'b0001110;
				14: seg=7'b0000110;
				13: seg=7'b0100001;
				12: seg=7'b1000110;
				11: seg=7'b0000011;
				10: seg=7'b0001000;
				9: seg=7'b0010000;
				8: seg=7'b0000000;
				7: seg=7'b1111000;
				6: seg=7'b0000010;
				5: seg=7'b0010010;
				4: seg=7'b0011001;
				3: seg=7'b0110000;
				2: seg=7'b0100100;
				1: seg=7'b1111001;
				0: seg=7'b1000000;
				default: seg=7'b1111111;
			endcase
		end
endmodule