module ALU(src,dest,cmd,res);
	input	[31:0] src,dest;
	input [3:0] cmd;
	reg temp;
	output reg [31:0] res;
	integer i;
	always @ (*)
	begin
		case(cmd)
			4'b0000:{temp,res[31:0]}=src[31:0]+dest[31:0];//0 add
			4'b0001://1 sub
				begin
					res[31:0]=(src[31:0]^32'b11111111111111111111111111111111)+1;
					{temp,res[31:0]}=dest[31:0]+res[31:0];
				end
			4'b0010:res[31:0]=src[31:0]&dest[31:0];//2 and
			4'b0011:res[31:0]=src[31:0]|dest[31:0];//3 or
			4'b0100:res[31:0]=~src[31:0];//4 not
			4'b0101:res[31:0]=~(src[31:0]|dest[31:0]);//5 nor
			4'b0110:res[31:0]=src[31:0]^dest[31:0];//6 xor
			4'b0111:res[31:0]=src - (dest[31:0]^32'b11111111111111111111111111111111) - 1;//7 neg输出取负结果
			4'b1000://8 逻辑左移(16位以内)
				begin
					res[31:0]=src[31:0];
					for(i=0;i<dest[3:0];i=i+1) res[31:0]={res[30:0],1'b0};
				end
			4'b1001://9 逻辑右移(16位以内)
				begin
					res[31:0]=src[31:0];
					for(i=0;i<dest[3:0];i=i+1) res[31:0]={1'b0,res[31:1]};
				end
			4'b1010://10 算术右移(16位以内)
				begin
					res[31:0]=src[31:0];
					for(i=0;i<dest[3:0];i=i+1) res[31:0]={res[31],res[31:1]};
				end
			4'b1011:res[31:0]={31'b0000000000000000000000000000000,src>=dest};//11 >=
			4'b1100:res[31:0]={31'b0000000000000000000000000000000,src<=dest};//12 <=
			4'b1101:res[31:0]={31'b0000000000000000000000000000000,src>dest};//13 >
			4'b1110:res[31:0]={31'b0000000000000000000000000000000,src<dest};//14 <
			4'b1111:res[31:0]={31'b0000000000000000000000000000000,src==dest};//15 ==
			default:res[31:0]=32'b00000000000000000000000000000000;
		endcase
	end
endmodule