// Module:  if_id
// File:    if_id.v
// Description: 该模块的作用是将IF阶段的指令和地址传送给ID阶段，相当于连接了IF和ID两个阶段
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module if_id(

	input wire					  clk,			//时钟信号
	input wire					  rst,			//复位信号
	

	input wire[`InstAddrBus]	  if_pc,		//来自于IF阶段的地址
	input wire[`InstBus]          if_inst,		//来自于IF阶段的指令
	output reg[`InstAddrBus]      id_pc,		//对应于ID阶段的地址
	output reg[`InstBus]          id_inst  		//对应于ID阶段的指令
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) beginn 			//复位时pc和inst都置0
			id_pc <= `ZeroWord;id_pci  			
			id_inst <= `ZeroWord;
	  end else begin							//将IF阶段的指令和地址传给ID阶段
		  id_pc <= if_pc;
		  id_inst <= if_inst;
		end
	end

endmodule
