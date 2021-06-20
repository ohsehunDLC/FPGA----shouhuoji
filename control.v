`timescale 1ns / 1ps



module control(
input	clk,		//50mhz
input	rst_n,
input	key1,	//按下表示5角
input	key2,	//按下表示10角
output	reg[5:0] led,
output	[3:0] money_shi, money_ge
    );
reg	[7:0]	money;	
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
	money <= 0;
else if(key1)
	money <= money + 5;	//金额加5角
else if(key2)
	money <= money + 10;//金额加10角
end	


assign money_shi = money/10;		//求十位
assign	money_ge = money%10;		//求个位
reg	key1_r,key2_r;	
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
	begin
	key1_r <=0;
	key2_r <=0;
	end
else
	begin
	key1_r <=key1;
	key2_r <=key2;
	end
end	

//1s计时
parameter time_1s = 50_000_000;
reg	[27:0]	cnt_1s;
wire	time_1s_flag;//1s标志
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
	cnt_1s <= 0;
else if(cnt_1s == time_1s-1)
	cnt_1s <=0;
else
	cnt_1s <= cnt_1s + 1'b1;
end
assign time_1s_flag = (cnt_1s == time_1s-1);
//流水灯
reg	[1:0]	state;
reg	[2:0]	cnt;
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
	begin
	led <=0;
	state <=0;
	cnt <=0;
	end
else 
	case(state)
		2'd0:
			begin
			if(key1_r | key2_r)
				begin
				if(money >= 25)
					begin
					state <= 2'd1;
					led <= 6'b000001;
					end
				end
			
			end
		2'd1://只从左往右循环
			begin
			if(time_1s_flag)
				begin
				led <= led <<1;
				if(cnt == 5)
					begin
					cnt <= 0;
					if(money >25)
						begin
						state <=2;
						led <= 6'b100000;
						end
					else
						state <=3;
					end
				else
					cnt <= cnt + 1'b1;
				end
				
			end
		2'd2://再从右往左循环
			begin
			if(time_1s_flag)
				begin
				led <= led >>1;
				if(cnt == 5)
					begin
					cnt <= 0;
					state <=3;
					end
				else
					cnt <= cnt + 1'b1;
				end
			end
		2'd3://停止
			begin
			led <= 6'b000000;
			state <= state;
			end
	endcase
end

	
endmodule













































