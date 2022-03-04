module provide_signal_nextdata(clk, ready, nextdata_n);
	input clk;
	input ready;
	output reg nextdata_n;
	always @ (posedge clk) begin
		if(nextdata_n == 0) nextdata_n <= 1;
		else if(ready) nextdata_n <= 0;
	end
endmodule