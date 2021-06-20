`timescale 1ns / 1ps



module top(
input	clk,
input	rst_n,
input	key1,
input	key2,
output	[5:0] led,
output	[6:0]	HEX0,
output	[6:0]	HEX1
    );

wire	[3:0]	money_shi	;
wire	[3:0]	money_ge	;	
wire	key1_en,key2_en;	
//按键消抖
key_module i1
(
.CLK_50M	(clk),
.RST_N		(rst_n),
.KEY		({key2,key1}),
.key_out	({key2_en,key1_en})
);  	
	
	
//控制部分	
control i2(
.clk		(clk		),		//50mhz
.rst_n		(rst_n		),
.key1		(key1_en		),	//按下表示五毛
.key2		(key2_en		),	//按下表示1块
.led		(led		),
.money_shi	(money_shi	), 
.money_ge	(money_ge	)
    );		
//数码管显示
SEG7_LUT	seg1(	HEX0,money_shi	);
SEG7_LUT	seg2(	HEX1,money_ge	);	
	
	
	
	
	
	
	
	
	
endmodule




























