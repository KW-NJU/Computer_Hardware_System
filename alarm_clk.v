module alarm_clk(sign,watch,ret0,clk,hexhour,hexmin,s5,s4,s3,s2,s1,s0);
	input [1:0] sign;
	input	clk;
	input watch;
	input ret0;
	input [4:0] hexhour;
	input [5:0] hexmin;
	reg [24:0] count_clk;
	reg [17:0] count_clk1;
	reg clk_1s;
	reg clk_1ms;

	wire [1:0] hten;
	wire [3:0] hone;
	wire [2:0] mten;
	wire [3:0] mone;
	wire [2:0] sten;
	wire [3:0] sone;
	reg [4:0] hnum;
	reg [5:0] mnum;
	reg [5:0] snum;
	
	wire [3:0] hten1;
	wire [3:0] hone1;
	wire [2:0] mten1;
	wire [3:0] mone1;
	wire [3:0] sten1;
	wire [3:0] sone1;
	reg [6:0] hnum1;
	reg [5:0] mnum1;
	reg [6:0] snum1;
	/*
	wire [1:0] hten2;
	wire [3:0] hone2;
	wire [2:0] mten2;
	wire [3:0] mone2;
	reg [4:0] hnum2;
	reg [5:0] mnum2;
	*/
	initial
	begin
		count_clk=0;
		count_clk1=0;
		hnum=0;
		mnum=0;
		snum=0;
		hnum1=0;
		mnum1=0;
		snum1=0;
		//hnum2=0;
		//mnum2=0;
	end
	//output
	reg [9:0] flag;
	output reg [6:0] s5;
	output reg [6:0] s4;
	output reg [6:0] s3;
	output reg [6:0] s2;
	output reg [6:0] s1;
	output reg [6:0] s0;
	always @(posedge clk)
	begin
		if(count_clk==25000000)
		begin
			count_clk <=0;
			clk_1s <= ~clk_1s;
		end
		else count_clk <= count_clk+1;
		
		if(count_clk1==250000)
		begin
			count_clk1 <=0;
			clk_1ms <= ~clk_1ms;
		end
		else count_clk1 <= count_clk1+1;
	end
	
	always @(posedge clk_1s)
	begin
		if(snum==59)
		//||(swcase==1&&ctl_sw==1&&!ctl_but))
			begin
				snum<=0;
				if(snum==59) mnum<=mnum+1;
			end
		else snum<=snum+1;
		
		if(mnum==59&&snum==59)
			begin
				mnum<=0;
				hnum<=hnum+1;
			end
		else if(snum==59)
		//||(swcase==1&&ctl_sw==2&&!ctl_but))
			begin
				if(mnum==59) mnum<=0;
				else mnum<=mnum+1;
			end
		
		if(hnum==23&&mnum==59&&snum==59) hnum<=0;
		else if((mnum==59&&snum==59))
		//||(swcase==1&&ctl_sw==3&&!ctl_but)) 
			begin
				if(hnum==23) hnum<=0;
				else hnum<=hnum+1;
			end
		/*
		if(swcase==3)
			begin
				if(!ctl_sw[0]&&!ctl_sw[1]&&!ctl_but)
					begin
						if(mnum2==59) mnum2<=0;
						else mnum2<=mnum2+1;
					end
				else if(ctl_sw[0]&&!ctl_but)
					begin
						if(hnum2==23) hnum2<=0;
						else hnum2<=hnum2+1;
					end
				if(ctl_sw[1]) flag[1]<=1;
				else flag[1]<=0;
			end
		*/
	end
/**/
	always @(posedge clk_1ms)
	begin
		if(ret0)
			begin
				hnum1<=0;
				mnum1<=0;
				snum1<=0;
			end
		else if(watch)
			begin
				if(snum1==99)
					begin
						snum1<=0;
						mnum1<=mnum1+1;
					end
				else snum1<=snum1+1;
				if(mnum1==59&&snum1==99)
					begin
						mnum1<=0;
						hnum1<=hnum1+1;
					end
				else if(snum1==99) mnum1<=mnum1+1;
				if(hnum1==99&&mnum1==59&&snum1==99) hnum1<=0;
				else if(mnum1==59&&snum1==99) hnum1<=hnum1+1;
			end
	end
	/**/
	assign hten=hnum/10;
	assign hone=hnum%10;
	assign mten=mnum/10;
	assign mone=mnum%10;
	assign sten=snum/10;
	assign sone=snum%10;
	assign hten1=hnum1/10;
	assign hone1=hnum1%10;
	assign mten1=mnum1/10;
	assign mone1=mnum1%10;
	assign sten1=snum1/10;
	assign sone1=snum1%10;
	always @(sign or hten or hone or mten or mone or sten or sone or hten1 or hone1 or mten1 or mone1 or sten1 or sone1)
	begin
		if(hnum==hexhour&&mnum==hexmin&&snum%2==1&&snum<=10)
			begin
				s5=7'b1111111;
				s4=7'b1111111;
				s3=7'b1111111;
				s2=7'b1111111;
				s1=7'b1111111;
				s0=7'b1111111;
			end
		else if(sign == 2'b01)
			begin
				case (hten)
					2: s5=7'b0100100;
					1: s5=7'b1111001;
					0: s5=7'b1000000;
					default: s5=7'b1111111;
				endcase
				case (hone)
					9: s4=7'b0010000;
					8: s4=7'b0000000;
					7: s4=7'b1111000;
					6: s4=7'b0000010;
					5: s4=7'b0010010;
					4: s4=7'b0011001;
					3: s4=7'b0110000;
					2: s4=7'b0100100;
					1: s4=7'b1111001;
					0: s4=7'b1000000;
					default: s4=7'b1111111;
				endcase
				case (mten)
					5: s3=7'b0010010;
					4: s3=7'b0011001;
					3: s3=7'b0110000;
					2: s3=7'b0100100;
					1: s3=7'b1111001;
					0: s3=7'b1000000;
					default: s3=7'b1111111;
				endcase
				case (mone)
					9: s2=7'b0010000;
					8: s2=7'b0000000;
					7: s2=7'b1111000;
					6: s2=7'b0000010;
					5: s2=7'b0010010;
					4: s2=7'b0011001;
					3: s2=7'b0110000;
					2: s2=7'b0100100;
					1: s2=7'b1111001;
					0: s2=7'b1000000;
					default: s2=7'b1111111;
				endcase
				case (sten)
					5: s1=7'b0010010;
					4: s1=7'b0011001;
					3: s1=7'b0110000;
					2: s1=7'b0100100;
					1: s1=7'b1111001;
					0: s1=7'b1000000;
					default: s1=7'b1111111;
				endcase
				case (sone)
					9: s0=7'b0010000;
					8: s0=7'b0000000;
					7: s0=7'b1111000;
					6: s0=7'b0000010;
					5: s0=7'b0010010;
					4: s0=7'b0011001;
					3: s0=7'b0110000;
					2: s0=7'b0100100;
					1: s0=7'b1111001;
					0: s0=7'b1000000;
				default: s0=7'b1111111;
				endcase
			end
		else if(sign[1:0] == 2'b10 || sign[1:0] == 2'b11)
		begin
			case (hten1)
				9: s5=7'b0010000;
				8: s5=7'b0000000;
				7: s5=7'b1111000;
				6: s5=7'b0000010;
				5: s5=7'b0010010;
				4: s5=7'b0011001;
				3: s5=7'b0110000;
				2: s5=7'b0100100;
				1: s5=7'b1111001;
				0: s5=7'b1000000;
				default: s5=7'b1111110;
			endcase
			case (hone1)
				9: s4=7'b0010000;
				8: s4=7'b0000000;
				7: s4=7'b1111000;
				6: s4=7'b0000010;
				5: s4=7'b0010010;
				4: s4=7'b0011001;
				3: s4=7'b0110000;
				2: s4=7'b0100100;
				1: s4=7'b1111001;
				0: s4=7'b1000000;
				default: s4=7'b1111110;
			endcase
			case (mten1)
				5: s3=7'b0010010;
				4: s3=7'b0011001;
				3: s3=7'b0110000;
				2: s3=7'b0100100;
				1: s3=7'b1111001;
				0: s3=7'b1000000;
				default: s3=7'b1111110;
			endcase
			case (mone1)
				9: s2=7'b0010000;
				8: s2=7'b0000000;
				7: s2=7'b1111000;
				6: s2=7'b0000010;
				5: s2=7'b0010010;
				4: s2=7'b0011001;
				3: s2=7'b0110000;
				2: s2=7'b0100100;
				1: s2=7'b1111001;
				0: s2=7'b1000000;
				default: s2=7'b1111110;
			endcase
			case (sten1)
				9: s1=7'b0010000;
				8: s1=7'b0000000;
				7: s1=7'b1111000;
				6: s1=7'b0000010;
				5: s1=7'b0010010;
				4: s1=7'b0011001;
				3: s1=7'b0110000;
				2: s1=7'b0100100;
				1: s1=7'b1111001;
				0: s1=7'b1000000;
				default: s1=7'b1111110;
			endcase
			case (sone1)
				9: s0=7'b0010000;
				8: s0=7'b0000000;
				7: s0=7'b1111000;
				6: s0=7'b0000010;
				5: s0=7'b0010010;
				4: s0=7'b0011001;
				3: s0=7'b0110000;
				2: s0=7'b0100100;
				1: s0=7'b1111001;
				0: s0=7'b1000000;
			default: s0=7'b1111110;
			endcase
		end
		else
			begin
				s5=7'b1111111;
				s4=7'b1111111;
				s3=7'b1111111;
				s2=7'b1111111;
				s1=7'b1111111;
				s0=7'b1111111;
			end
	end
	/*	
	
	assign hten2=hnum2/10;
	assign hone2=hnum2%10;
	assign mten2=mnum2/10;
	assign mone2=mnum2%10;

	always @(hten or hten1 or hten2)
	begin
		if(flag[1]&&hnum==hnum2&&mnum==mnum2&&snum%2==0&&snum<=10) flag[9:2]=8'b11111111;
		else flag[9:2]=8'b00000000;
		if(swcase==0||swcase==1)
			begin
				case (hten)
					2: s5=7'b0100100;
					1: s5=7'b1111001;
					0: s5=7'b1000000;
					default: s5=7'b1111111;
				endcase
			end
		else if(swcase==2)
			begin
				case (hten1)
					9: s5=7'b0010000;
					8: s5=7'b0000000;
					7: s5=7'b1111000;
					6: s5=7'b0000010;
					5: s5=7'b0010010;
					4: s5=7'b0011001;
					3: s5=7'b0110000;
					2: s5=7'b0100100;
					1: s5=7'b1111001;
					0: s5=7'b1000000;
					default: s5=7'b1111111;
				endcase
			end
		else
			begin
				case (hten2)
					2: s5=7'b0100100;
					1: s5=7'b1111001;
					0: s5=7'b1000000;
					default: s5=7'b1111111;
				endcase
			end
	end
	
	always @(hone or hone1 or hone2)
	begin
		if(swcase==0||swcase==1)
			begin
				case (hone)
					9: s4=7'b0010000;
					8: s4=7'b0000000;
					7: s4=7'b1111000;
					6: s4=7'b0000010;
					5: s4=7'b0010010;
					4: s4=7'b0011001;
					3: s4=7'b0110000;
					2: s4=7'b0100100;
					1: s4=7'b1111001;
					0: s4=7'b1000000;
					default: s4=7'b1111111;
				endcase
			end
		else if(swcase==2)
			begin
				case (hone1)
					9: s4=7'b0010000;
					8: s4=7'b0000000;
					7: s4=7'b1111000;
					6: s4=7'b0000010;
					5: s4=7'b0010010;
					4: s4=7'b0011001;
					3: s4=7'b0110000;
					2: s4=7'b0100100;
					1: s4=7'b1111001;
					0: s4=7'b1000000;
					default: s4=7'b1111111;
				endcase
			end
		else
			begin
				case (hone2)
					9: s4=7'b0010000;
					8: s4=7'b0000000;
					7: s4=7'b1111000;
					6: s4=7'b0000010;
					5: s4=7'b0010010;
					4: s4=7'b0011001;
					3: s4=7'b0110000;
					2: s4=7'b0100100;
					1: s4=7'b1111001;
					0: s4=7'b1000000;
					default: s4=7'b1111111;
				endcase
			end
	end
	
	always @(mten or mten1 or mten2)
	begin
		if(swcase==0||swcase==1)
			begin
				case (mten)
					5: s3=7'b0010010;
					4: s3=7'b0011001;
					3: s3=7'b0110000;
					2: s3=7'b0100100;
					1: s3=7'b1111001;
					0: s3=7'b1000000;
					default: s3=7'b1111111;
				endcase
			end
		else if(swcase==2)
			begin
				case (mten1)
					5: s3=7'b0010010;
					4: s3=7'b0011001;
					3: s3=7'b0110000;
					2: s3=7'b0100100;
					1: s3=7'b1111001;
					0: s3=7'b1000000;
					default: s3=7'b1111111;
				endcase
			end
		else
			begin
				case (mten2)
					5: s3=7'b0010010;
					4: s3=7'b0011001;
					3: s3=7'b0110000;
					2: s3=7'b0100100;
					1: s3=7'b1111001;
					0: s3=7'b1000000;
					default: s3=7'b1111111;
				endcase
			end
	end
	
	always @(mone or mone1 or mone2)
	begin
		if(swcase==0||swcase==1)
			begin
				case (mone)
					9: s2=7'b0010000;
					8: s2=7'b0000000;
					7: s2=7'b1111000;
					6: s2=7'b0000010;
					5: s2=7'b0010010;
					4: s2=7'b0011001;
					3: s2=7'b0110000;
					2: s2=7'b0100100;
					1: s2=7'b1111001;
					0: s2=7'b1000000;
					default: s2=7'b1111111;
				endcase
			end
		else if(swcase==2)
			begin
				case (mone1)
					9: s2=7'b0010000;
					8: s2=7'b0000000;
					7: s2=7'b1111000;
					6: s2=7'b0000010;
					5: s2=7'b0010010;
					4: s2=7'b0011001;
					3: s2=7'b0110000;
					2: s2=7'b0100100;
					1: s2=7'b1111001;
					0: s2=7'b1000000;
					default: s2=7'b1111111;
				endcase
			end
		else
			begin
				case (mone2)
					9: s2=7'b0010000;
					8: s2=7'b0000000;
					7: s2=7'b1111000;
					6: s2=7'b0000010;
					5: s2=7'b0010010;
					4: s2=7'b0011001;
					3: s2=7'b0110000;
					2: s2=7'b0100100;
					1: s2=7'b1111001;
					0: s2=7'b1000000;
					default: s2=7'b1111111;
				endcase
			end
	end
	always @(sten or sten1)
	begin
		if(swcase==1&&ctl_sw) flag[0]=1;
		else flag[0]=0;
		if(swcase==0||swcase==1)
			begin
				if(swcase==1&&(ctl_sw==2||ctl_sw==3)) s1=7'b1111111;
				else
					begin
						case (sten)
							5: s1=7'b0010010;
							4: s1=7'b0011001;
							3: s1=7'b0110000;
							2: s1=7'b0100100;
							1: s1=7'b1111001;
					 		0: s1=7'b1000000;
							default: s1=7'b1111111;
						endcase
					end
			end
		else if(swcase==2)
			begin
				case (sten1)
					9: s1=7'b0010000;
					8: s1=7'b0000000;
					7: s1=7'b1111000;
					6: s1=7'b0000010;
					5: s1=7'b0010010;
					4: s1=7'b0011001;
					3: s1=7'b0110000;
					2: s1=7'b0100100;
					1: s1=7'b1111001;
					0: s1=7'b1000000;
					default: s1=7'b1111111;
				endcase
			end
		else s1=7'b0001000;
	end
	
	always @(sone or sone1)
	begin
		if(swcase==0||swcase==1)
			begin
				if(swcase==1&&ctl_sw==2) s0=7'b0001110;
				else if(swcase==1&&ctl_sw==3) s0=7'b0001001;
				else
					begin
						case (sone)
							9: s0=7'b0010000;
							8: s0=7'b0000000;
							7: s0=7'b1111000;
							6: s0=7'b0000010;
							5: s0=7'b0010010;
							4: s0=7'b0011001;
							3: s0=7'b0110000;
							2: s0=7'b0100100;
							1: s0=7'b1111001;
							0: s0=7'b1000000;
							default: s0=7'b1111111;
						endcase
					end
			end
		else if(swcase==2)
			begin
				case (sone1)
					9: s0=7'b0010000;
					8: s0=7'b0000000;
					7: s0=7'b1111000;
					6: s0=7'b0000010;
					5: s0=7'b0010010;
					4: s0=7'b0011001;
					3: s0=7'b0110000;
					2: s0=7'b0100100;
					1: s0=7'b1111001;
					0: s0=7'b1000000;
				default: s0=7'b1111111;
				endcase
			end
		else
			begin
				if(ctl_sw[0]) s0=7'b0001001;
				else s0=7'b1000111;
			end
	end
	*/
endmodule