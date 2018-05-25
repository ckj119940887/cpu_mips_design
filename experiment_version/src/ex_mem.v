// Module:  ex_mem
// File:    ex_mem.v
// Description: 将EX模块的输出连接到该模块，该模块作为EX阶段和Memory之间的桥梁
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex_mem(

	input wire					  clk,
	input wire					  rst,
	
	
	//EX阶段产生的计算结果	
	input wire[`RegAddrBus]       ex_wd,		//要写入的目的寄存器的地址
	input wire                    ex_wreg,		//是否有要写入的目的寄存器
	input wire[`RegBus]			  ex_wdata, 	//要写入目的寄存器的data
	
	//
	output reg[`RegAddrBus]       mem_wd,
	output reg                    mem_wreg,
	output reg[`RegBus]			  mem_wdata
	
	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  mem_wdata <= `ZeroWord;	
		end else begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;			
		end    //if
	end      //always
			

endmodule
