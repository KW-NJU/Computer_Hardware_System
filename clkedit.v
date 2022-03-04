module clockedit(clk, clk_1s);
input clk;
output reg clk_1s;
integer count_clk;
always @(posedge clk)
	begin
		if(count_clk==25000000)
		begin
			count_clk <=0;
			clk_1s <= ~clk_1s;
		end
		else count_clk <= count_clk+1;
		
		end

endmodule
