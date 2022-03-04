module write_wait(clk, put_back, back_ascii, res_ascii, current_ascii);
	input clk;
	input [7:0]res_ascii;
	input [7:0]back_ascii;
	input put_back;
	output reg [7:0]current_ascii;
	always @ (posedge clk) begin
		if(put_back)
			current_ascii <= back_ascii;
		else if(res_ascii != 0)
			current_ascii <= res_ascii;
		else begin
			current_ascii <= 95;
		end
	end
endmodule