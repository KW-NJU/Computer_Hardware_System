module CPU(clk, clk_50,encode, endeip, initialeip, finalres, finalflag, finallength, prognum);
	reg [31:0] mipreg [30:0];//31个32位寄存器
	integer i;
	initial
		begin
		mipreg[0] = 32'h00000000;
		start = 32'h10010000;
		finalflag <= 0;                                             //为0时返回值无效
		codestart = 1;
		forencode = 0;
		flag = 0;
		ramdata[0]=8'h48;
		ramdata[1]=8'h65;
		ramdata[2]=8'h6c;
		ramdata[3]=8'h6c;
		ramdata[4]=8'h6f;
		ramdata[5]=8'h2c;
		ramdata[6]=8'h20;
		ramdata[7]=8'h57;
		ramdata[8]=8'h6f;
		ramdata[9]=8'h72;
		ramdata[10]=8'h6c;
		ramdata[11]=8'h64;
		ramdata[12]=8'h21;
		ramdata[13]=8'h20;
		ramdata[14]=8'h0a;
		ramdata[15]=8'h00;
		ramdata[16]=8'h49;
		ramdata[17]=8'h6e;
		ramdata[18]=8'h76;
		ramdata[19]=8'h61;
		ramdata[20]=8'h6c;
		ramdata[21]=8'h69;
		ramdata[22]=8'h64;
		ramdata[23]=8'h20;
		ramdata[24]=8'h49;
		ramdata[25]=8'h6e;
		ramdata[26]=8'h70;
		ramdata[27]=8'h75;
		ramdata[28]=8'h74;
		ramdata[29]=8'h21;
		ramdata[30]=8'h0a;
		ramdata[31]=8'h00;
		ramdata[32]=8'h58;
		ramdata[33]=8'h58;
		ramdata[34]=8'h58;
		ramdata[35]=8'h58;
		ramdata[36]=8'h58;
		ramdata[37]=8'h58;
		ramdata[38]=8'h58;
		ramdata[39]=8'h58;
		ramdata[40]=8'h58;
		ramdata[41]=8'h58;
		ramdata[42]=8'h58;
		ramdata[43]=8'h58;
		ramdata[44]=8'h58;
		ramdata[45]=8'h58;
		ramdata[46]=8'h58;
		ramdata[47]=8'h58;
		ramdata[48]=8'h58;
		ramdata[49]=8'h58;
		ramdata[50]=8'h58;
		ramdata[51]=8'h58;
		ramdata[52]=8'h58;
		ramdata[53]=8'h58;
		ramdata[54]=8'h58;
		ramdata[55]=8'h58;
		ramdata[56]=8'h00;
		ramdata[57]=8'h00;
		ramdata[58]=8'h00;
		ramdata[59]=8'h00;
		ramdata[60]=8'h00;
		ramdata[61]=8'h00;
		ramdata[62]=8'h00;
		ramdata[63]=8'h00;
		end
	wire [31:0] singlecode;											//单条指令
	wire [5:0] opcode;												//操作码
	wire [4:0] rs;													//操作数rs寄存器
	wire [4:0] rt;													//类上
	wire [4:0] rd;													//类上
	wire [31:0] base;												//操作数基址
	wire [4:0] shamt;												//操作数函数
	wire [5:0] funct;
	wire [15:0] immediateLTYPE;
	wire [31:0] offset;			                    				//l-type立即数、偏移量
	wire [25:0] immediateJTYPE;									    //j-type立即数
	reg [3:0] aluopcode;
	reg [31:0] src, dest;											//alu的输入
    wire [31:0] res;													//alu的输出
    reg [31:0] eip;													//eip寄存器
	integer start;                                           //数据ram的地址
	input clk;
	input clk_50;
	input wire encode;
	reg forencode;
	input wire [31:0] prognum;								//输入程序编号
	reg codestart;											//程序是否开始的标志
	input wire [31:0] endeip;									    //执行代码结束位置
	input wire [31:0] initialeip;                                   //执行代码开始位置
	output wire [127:0] finalres;									//返回十六字节的数据
	output reg finalflag;                                          //返回值有效，即程序执行结束
	output wire [31:0] finallength;                                 //返回的有效长度
	reg [7:0] ramdata [63:0];										//.data
	reg flag;
	reg [4:0] rtt;
//=======================================================
//  Structural coding
//=======================================================
	assign opcode[5:0] = singlecode[31:26];					//以下为解码分配
	assign base[31:0] = mipreg[singlecode[25:21]];
	assign rs[4:0] = singlecode[25:21];
	assign rt[4:0] = singlecode[20:16];
	assign rd[4:0] = singlecode[15:11];
	assign shamt[4:0] = singlecode[10:6];
	assign funct[5:0] = singlecode[5:0];
	assign immediateLTYPE = singlecode[15:0];
	assign offset = {{16{singlecode[15]}},singlecode[15:0]};
	assign immediateJTYPE = singlecode[25:0];
	assign finallength = mipreg[2][31:0];                  //返回的有效长度为2号寄存器的值
	assign finalres[7:0] = ramdata[mipreg[3]];            //将十六个字节的数据返回
	assign finalres[15:8] = ramdata[mipreg[3] + 1];
	assign finalres[23:16] = ramdata[mipreg[3] + 2];
	assign finalres[31:24] = ramdata[mipreg[3] + 3];
	assign finalres[39:32] = ramdata[mipreg[3] + 4];
	assign finalres[47:40] = ramdata[mipreg[3] + 5];
	assign finalres[55:48] = ramdata[mipreg[3] + 6];
	assign finalres[63:56] = ramdata[mipreg[3] + 7];
	assign finalres[71:64] = ramdata[mipreg[3] + 8];
	assign finalres[79:72] = ramdata[mipreg[3] + 9];
	assign finalres[87:80] = ramdata[mipreg[3] + 10];
	assign finalres[95:88] = ramdata[mipreg[3] + 11];
	assign finalres[103:96] = ramdata[mipreg[3] + 12];
	assign finalres[111:104] = ramdata[mipreg[3] + 13];
	assign finalres[119:112] = ramdata[mipreg[3] + 14];
	assign finalres[127:120] = ramdata[mipreg[3] + 15];
	integer count_clk;
	always @(negedge clk)
	begin
	   forencode <= encode;
	   if(forencode == 0 && encode == 1)
		begin
			finalflag <= 0;
			eip = initialeip;
			codestart = 1;
			mipreg[4] = prognum;
		end
	   if(count_clk== 25000)
		begin
			count_clk <=0;
	   if(flag == 1)
		begin
	   mipreg[rtt][31:0] = res[31:0];
		flag <= 0;
		end
	   //forencode <= encode;
		else if(eip == endeip && codestart == 1)                                         //截止时执行nop
		begin
			//singlecode <= 32'hffffffff;
			finalflag <= 1;                                       //返回值有效时的标志，时序
			codestart = 0;
		end
		else if(codestart == 1 && finalflag == 0)
		begin
		if(opcode == 0)											  //opcode为0的一系列指令
		begin
			if(immediateJTYPE == 0) 				  //nop
			begin	
				flag <= 0;
				eip <= eip + 4;
			end
			else if(funct[5] == 1 || funct[2] == 1)
			begin
				src = mipreg[rt];										  //对两个操作数进行赋值
				dest = mipreg[rs];									  //将结果赋给目标寄存器
				rtt = rd;//mipreg[rd] <= res;
            flag <= 1;				
				if(funct == 6'h20 || funct == 6'h21)		     //add和addu
					begin
					aluopcode = 4'b0000;								  //对alu进行操作码赋值
					end
				else if(funct == 6'h22 || funct == 6'h23)		  //sub和subu
					aluopcode = 4'b0001;
				else if(funct == 6'h24)								  //and
					aluopcode = 4'b0010;
				else if(funct == 6'h25)								  //or
					aluopcode = 4'b0011;	
				else if(funct == 6'h26)								  //xor
					aluopcode = 4'b0110;
				else if(funct == 6'h27)								  //nor
					aluopcode = 4'b0101;
				else if(funct == 6'h2a || funct == 6'h2b)      //slt和sltu
					aluopcode = 4'b1011;
				else if(funct == 4)									  //sllv
					aluopcode = 4'b1000;
				else if(funct == 6)									  //srlv
					aluopcode = 4'b1001;
				else if(funct == 7)									  //srav
					aluopcode = 4'b1010;
				eip <= eip + 4;
			end
			else if(funct[3] == 1)									  //jr
			begin
				eip <= (mipreg[rs] - 28'h0400000);
				flag <= 0;
			end
			else															
			begin
				src = mipreg[rt];
				dest = {{16{1'b0}},shamt};
				rtt = rd;//mipreg[rd] <= res;
				flag <= 1;
				if(funct == 0)											 //sll
					aluopcode = 4'b1000;
				else if(funct == 2)									 //srl
					aluopcode = 4'b1001;
				else if(funct == 3)
					aluopcode = 4'b1010;								 //sra
				eip <= eip + 4;
			end
		end
		else if(opcode == 2)
		begin
			eip <= {4'b0000,((immediateJTYPE << 2) - 28'h0400000)};
			flag <= 0;
			//无条件跳转,权限
		end
		else if(opcode == 4)											//beq
		begin
		   flag <= 0;
			if(mipreg[rs] == mipreg[rt])
				eip <= eip + 4 + ({{16{immediateLTYPE[15]}},immediateLTYPE[15:0]} << 2);
			else
				eip <= eip + 4;
		end 
		else if(opcode == 5)											//bne
		begin
		   flag <= 0;
			if(mipreg[rs] != mipreg[rt])
				eip <= eip + 4 + ({{16{immediateLTYPE[15]}},immediateLTYPE[15:0]} << 2);
			else 
				eip <= eip + 4;
		end
		else if(opcode == 6)											//blez
		begin
		   flag <= 0;
			if(mipreg[rs][31] == 1 || mipreg[rs] == 32'b00000000)
				eip <= eip + 4 + ({{16{immediateLTYPE[15]}},immediateLTYPE[15:0]} << 2);
			else
				eip <= eip + 4;
			//rs < 0进行跳转
		end
		else if(opcode == 7)										   //bgtz
		begin
		   flag <= 0;
			if(mipreg[rs][31] == 0 && mipreg[rs] != 0)
				eip <= eip + 4 + ({{16{immediateLTYPE[15]}},immediateLTYPE} << 2);
			else
				eip <= eip + 4;
		end
		else if(opcode == 6'b001000 || opcode == 9 )      //addi,addiu
		begin
		   flag <= 1;
			src = mipreg[rs];
			dest = {16'h0000,immediateLTYPE[15:0]};
			rtt = rt;
			aluopcode = 4'b0000;
			//mipreg[rtt] <= res;                          //改为立即赋值
			eip <= eip + 4;
		end
		else if(opcode == 10 || opcode == 11)	           //slti,sltui				
		begin
		   flag <= 1;
			src = mipreg[rs];
			dest = {16'h0000,immediateLTYPE[15:0]};
			rtt = rt;//mipreg[rt] <= res;
			aluopcode = 4'b1011;
			eip <= eip + 4;
		end
		else if(opcode == 12)									  //andi
		begin
		   flag <= 1;
			src = mipreg[rs];
			dest = {16'h0000,immediateLTYPE[15:0]};
			aluopcode = 4'b0010;
			rtt = rt;//mipreg[rt] <= res;
			eip <= eip + 4;
		end
		else if(opcode == 13)									  //ori
		begin
		   flag <= 1;
			src = mipreg[rs];
			dest = {16'h0000,immediateLTYPE[15:0]};
			aluopcode = 4'b0011;
			rtt = rt;//mipreg[rt] <= res;
			eip <= eip + 4;
		end
		else if(opcode == 14)									 //xori
		begin
		   flag <= 1;
			src = mipreg[rs];
			dest = {16'h0000,immediateLTYPE[15:0]};
			rtt = rt;//mipreg[rt] <= res;
			aluopcode = 4'b0110;
			eip <= eip + 4;
		end 
		else if(opcode == 15)							       //lui
		begin
		   flag <= 0;
			mipreg[rt][31:16] = immediateLTYPE[15:0];
			mipreg[rt][15:0] = 16'h0000;
			eip <= eip + 4;
		end
		else if(opcode == 6'h20)                         //lb
		begin
			flag <= 0;
			mipreg[rt] <= {{24{ramdata[base + offset - start][7]}},ramdata[base + offset - start][7:0]};
			eip <= eip + 4;
		end 
		else if(opcode == 6'h23)                         //lw
		begin
			flag <= 0;
			mipreg[rt] <= {ramdata[base + offset + 3 - start][7:0], ramdata[base + offset + 2 - start][7:0], ramdata[base + offset + 1 - start][7 : 0], ramdata[base + offset - start][7:0]};
			eip <= eip + 4;
			//将base + offset -> rt,ramdata undefined!,有疑问
		end
		else if(opcode == 6'b101000)                         //sb
		begin
		   flag <= 0;
			ramdata[base + offset - start] <= mipreg[rt][7:0];
			eip <= eip + 4;
		end
		else if(opcode == 6'h2b)                             //sw
		begin
		   flag <= 0;
			ramdata[base + offset - start] <= mipreg[rt][7:0];
			ramdata[base + offset + 1 - start] <= mipreg[rt][15:8];
			ramdata[base + offset + 2 - start] <= mipreg[rt][23:16];
			ramdata[base + offset + 3 - start] <= mipreg[rt][31:24];
			eip <= eip + 4;
			//将rt -> base + offset
		end
		end
		end
		else count_clk <= count_clk+1;
	end

	ALU cpuALU(src,dest,aluopcode,res);
	my_software eip0(.address(eip),.clock(clk_50),.q(singlecode[7:0]));
	my_software eip1(.address(eip + 1),.clock(clk_50),.q(singlecode[15:8]));
	my_software eip2(.address(eip + 2),.clock(clk_50),.q(singlecode[23:16]));
	my_software eip3(.address(eip + 3),.clock(clk_50),.q(singlecode[31:24]));
	/*
	寄存器编号		寄存器名	用途
	0				zero		永远返回0
	1				$at		汇编保留寄存器（不可做其它用途）
	2-3			$v0-$v1	(value)存储表达式或函数返回值
	4-7			$a0-$a3	(argument)存储子程序前4个参数，在子程序调用过程中释放
	8-15			$t0-$t7	(temp)临时变量，同上调用时不保存
	16-23			$s0-$s7	(saved)使用其中一个的子例程必须在退出之前保存原始并还原它。跨过程调用保留
	24-25			$t8-$t9	(temp)临时变量，同$t0-$t7
	26-27			$k0-$k1	中断函数返回值，不可做其他用途
	28				$gp		(globol pointer)指向64k(2^16)大小的静态数据块的中间地址
	29				$sp		(stack pointer)栈指针，指向栈顶
	30				$s8/$fp	(saved/frame pointer简写)帧指针
	31				$ra		返回地址，不可做其他用途
	*/
endmodule