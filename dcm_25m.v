module dcm_25m( input clkin, output reg clkout, input rst);

	parameter clk_freq=1000;
	parameter countlimit=50000000/2/clk_freq; // 自 动 计 算 计 数 次 数
	
	reg[31:0] clkcount;
	
	always @ (posedge clkin)
		if(rst) begin
			clkcount=0;
			clkout=1'b0;
		end
		else begin
			clkcount=clkcount+1;
			if(clkcount>=countlimit) begin
				clkcount=32'd0;
				clkout=~clkout;
			end
			else
				clkout=clkout;
		end
		
endmodule