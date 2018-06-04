// Module:  regfile
// File:    regfile.v
// Description: ID阶段要操作的所有寄存器，这里的所有的地址对应的都是寄存器的地址
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module regfile(

	input wire					clk,
	input wire					rst,
	
	//写端口
	input wire					we,			//写使能信号
	input wire[`RegAddrBus]		waddr,		//写地址
	input wire[`RegBus]			wdata,		//写数据
	
	//读端口1
	input wire					re1,		//读使能信号
	input wire[`RegAddrBus]		raddr1,		//读地址
	output reg[`RegBus]         rdata1,		//读数据
	
	//读端口2
	input wire					re2,
	input wire[`RegAddrBus]		raddr2,
	output reg[`RegBus]         rdata2
	
);
	//这里定义了32个通用寄存器
	reg[`RegBus]  regs[0:`RegNum-1];

	//当写信号有效且写操作目的寄存器不为$0时($0的值只能为0，不能写入)，将数据写到指定位置
	//写操作是时序逻辑电路，发生在时钟信号的上升沿
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
	
	//针对第一个读端口的读操作，读操作是组合逻辑电路，一旦地址发生变化，会立即给出新地址对应寄存器的值
	//如果要读取的寄存器是在下一个时钟上升沿要写入的寄存器，那么就将要写入的数据直接作为结果输出
	always @ (*) begin
	  if(rst == `RstEnable) begin
		rdata1 <= `ZeroWord;
	  end else if(raddr1 == `RegNumLog2'h0) begin	
  		rdata1 <= `ZeroWord;			//如果读地址寄存器为0，读出的数据肯定为0
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
		rdata1 <= wdata;				//如果读地址和写地址相同，直接将写入的数据赋值给要读的数据
	  end else if(re1 == `ReadEnable) begin
	    rdata1 <= regs[raddr1];			//正常的读操作
	  end else begin
	    rdata1 <= `ZeroWord;
	  end
	end

	//针对第而二个读端口的读操作，与第一个读端口的操作完全相同
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

endmodule
