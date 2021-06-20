module key_module
(
	//输入端口
	CLK_50M,RST_N,KEY,
	// 输出端口
	key_out
);  

//---------------------------------------------------------------------------
//--	外部端口声明
//---------------------------------------------------------------------------
input						CLK_50M;				// 时钟
input						RST_N;				//低电平复位
input		 	[1:0]		KEY;					//板上的KEY
output		 	[1:0]		key_out;				//消抖完成

//---------------------------------------------------------------------------
//--	内部端口声明
//---------------------------------------------------------------------------
reg		[19:0]	time_cnt;			//定时计数器
reg		[19:0]	time_cnt_n;			//计数器下一个状态
reg		 [1:0] 			key_reg;				//记录信号，所以用寄存器
reg		 [1:0] 			key_reg_n;			//寄存器下一个状态

//设置定时器的时间为20ms，公式：(20*10^6)ns / (1/50)ns
parameter SET_TIME_20MS = 27'd1_000_000;	
//parameter SET_TIME_20MS = 27'd1_0;	

//---------------------------------------------------------------------------
//--	逻辑功能实现
//---------------------------------------------------------------------------
// 给寄存器赋值
always @ (posedge CLK_50M, negedge RST_N)
begin
	if(!RST_N)								//判断复位
		time_cnt <= 20'h0;				//初始化
	else
		time_cnt <= time_cnt_n;			//赋值
end

//定时计数器
always @ (*)
begin
	if(time_cnt == SET_TIME_20MS)		//判断时间
		time_cnt_n = 20'h0;				//清零条件
	else
		time_cnt_n = time_cnt + 1'b1;//未到20ms，继续累加
end

// 寄存器
always @ (posedge CLK_50M, negedge RST_N)
begin
	if(!RST_N)								//判断复位
		key_reg <= 2'b11;					//初始化
	else
		key_reg <= key_reg_n;			//给寄存器赋值
end

//每20ms接受一次按键
always @ (*)
begin
	if(time_cnt == SET_TIME_20MS)		//判断时间
		key_reg_n <= KEY;					//达到20ms，刷新一次值
	else
		key_reg_n <= key_reg;			//没到就STBY

assign key_out = key_reg & (~key_reg_n);//判断是否按下

endmodule
