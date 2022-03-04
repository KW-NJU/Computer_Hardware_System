module seperate(h_cnt, v_cnt, ascii_h, ascii_v, char_h, char_v);
	input [9:0]      h_cnt;
   input [9:0]      v_cnt;
	output wire [5:0]ascii_h; // 当前在显存中的行,h_cnt / 16
	output reg [7:0]ascii_v; // 当前在显存中的列, v_cnt / 9
	output wire [3:0]char_h; // 当前在字模中的行, h_cnt % 16
	output reg [4:0]char_v; // 当前在字模中的列, v_cnt % 9
	reg [9:0]prev;
	assign ascii_h = h_cnt[9:4];
	assign char_h = h_cnt[3:0];
	always @ (*) begin
		if(prev != v_cnt) begin
			char_v = char_v + 1;
			if(char_v == 9) begin
				char_v = 0;
				ascii_v = ascii_v + 1;
				if(ascii_v == 8'd70)
					ascii_v = 0;
			end
		end
	end
endmodule