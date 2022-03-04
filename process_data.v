module process_data(ready, make_code, ascii, res_code, res_ascii, count, cap, combination);
	input ready;
	input [7:0]make_code;
	output reg cap;
	reg combination_prepare;
	output reg combination;
	reg shift;
	reg output_forbid;
	reg [7:0]last_code;
	reg [7:0]prev_ascii;
	reg [7:0]my_ascii[10];
	input [7:0]ascii;
	output reg [7:0]res_code;
	output reg [7:0]res_ascii;
	output reg [7:0]count;
	initial begin
		output_forbid = 0;
		last_code = 8'b0;
		prev_ascii = 8'b1;
		cap = 0;
		my_ascii[0] = 8'h29;
		my_ascii[1] = 8'h21;
		my_ascii[2] = 8'h40;
		my_ascii[3] = 8'h23;
		my_ascii[4] = 8'h24;
		my_ascii[5] = 8'h25;
		my_ascii[6] = 8'h5E;
		my_ascii[7] = 8'h26;
		my_ascii[8] = 8'h2A;
		my_ascii[9] = 8'h28;
	end
	always @ (negedge ready) begin
			if(make_code == 8'hF0) begin
				res_code <= 8'h0;
				res_ascii <= 8'h0;
				output_forbid <= 1;
			end
			else begin
				if(output_forbid == 0) begin
					res_code <= make_code;
					if(make_code == 8'h58)
						cap = ~cap;
					if(make_code == 8'h12 || make_code == 8'h59) begin
						shift <= 1;
						combination_prepare <= 1;
					end
					if(make_code == 8'h14)
						combination_prepare <= 1;
					if((cap || shift) && ascii >= 8'h61 && ascii <= 8'h7A)
						res_ascii <= ascii - 8'h20;
					else if(shift && ascii >= 8'h30 && ascii <= 8'h39) begin
						res_ascii <= my_ascii[ascii - 8'h30];
					end
					else
						res_ascii <= ascii;
					//if(combination_prepare && ascii != 8'b0) combination <= 1;
					//else combination <= 0;
				end
				else begin
					if(make_code == 8'h12 || make_code == 8'h59) begin
						shift <= 0;
						combination_prepare <= 0;
					end
					if(make_code == 8'h14)
						combination_prepare <= 0;
					output_forbid <= 0;
					res_code <= 8'h0;
					res_ascii <= 8'h0;
				end
				if(combination_prepare && ascii != 8'b0) combination <= 1;
				else combination <= 0;
			end
			if(ascii != prev_ascii && ascii != 0 && prev_ascii == 0) count <= count + 1;
			prev_ascii <= ascii;
		end
endmodule