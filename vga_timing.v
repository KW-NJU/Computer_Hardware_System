`timescale 1 ns / 1 ns


module vga_640x480(pclk, reset, hsync, vsync, valid, h_cnt, v_cnt, ascii_h, ascii_v, char_h, char_v);
   input        pclk;
   input        reset;
   output       hsync;
   output       vsync;
   output       valid;
   output [9:0] h_cnt;
   output [9:0] v_cnt;
	output [5:0]ascii_h; // 当前在显存中的行,h_cnt / 16, 0~30
	output [7:0]ascii_v; // 当前在显存中的列, v_cnt / 9, 0~70
	output [3:0]char_h; // 当前在字模中的行, h_cnt % 16
	output [3:0]char_v; // 当前在字模中的列, v_cnt % 9
	
	assign ascii_v = h_cnt / 9;
	assign char_v = h_cnt % 9;
   
   parameter    h_frontporch = 96;
   parameter    h_active = 144;
   parameter    h_backporch = 784;
   parameter    h_total = 800;
   
   parameter    v_frontporch = 2;
   parameter    v_active = 35;
   parameter    v_backporch = 515;
   parameter    v_total = 525;
   
   reg [9:0]    x_cnt;
   reg [9:0]    y_cnt;
   
   wire         h_valid;
   wire         v_valid;
   
   
   always @(posedge reset or posedge pclk) begin
      if (reset == 1'b1)
         x_cnt <= 1;
      else 
      begin
         if (x_cnt == h_total)
            x_cnt <= 1;
         else begin
            x_cnt <= x_cnt + 1;
				/*if(h_valid) begin
					if(char_v == 8) begin
						char_v = 0;
						if(ascii_v == 69) begin
							ascii_v = 0;
						end
						else
							ascii_v = ascii_v + 1;
					end
					else
						char_v = char_v + 1;
				end*/
			end
      end
	end
   
   always @(posedge pclk)
      if (reset == 1'b1)
         y_cnt <= 1;
      else 
      begin
         if (y_cnt == v_total & x_cnt == h_total)
            y_cnt <= 1;
         else if (x_cnt == h_total)
            y_cnt <= y_cnt + 1;
      end
   
   assign hsync = ((x_cnt > h_frontporch)) ? 1'b1 : 
                  1'b0;
   assign vsync = ((y_cnt > v_frontporch)) ? 1'b1 : 
                  1'b0;
   
   assign h_valid = ((x_cnt > h_active) & (x_cnt <= h_backporch)) ? 1'b1 : 
                    1'b0;
   assign v_valid = ((y_cnt > v_active) & (y_cnt <= v_backporch)) ? 1'b1 : 
                    1'b0;
   
   assign valid = ((h_valid == 1'b1) & (v_valid == 1'b1)) ? 1'b1 : 
                  1'b0;
   
   assign h_cnt = ((h_valid == 1'b1)) ? x_cnt - 144 : 
                  {10{1'b0}};
   assign v_cnt = ((v_valid == 1'b1)) ? y_cnt - 35 : 
                  {10{1'b0}};
						
	assign ascii_h = v_cnt >> 4;
	assign char_h = v_cnt[3:0];
   
endmodule