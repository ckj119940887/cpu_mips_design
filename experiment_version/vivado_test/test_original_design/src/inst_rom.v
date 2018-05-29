// Module:  inst_rom
// File:    inst_rom.v
// Description: 指令ROM
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module inst_rom(

	input wire                    ce,		//使能信号
	input wire[`InstAddrBus]	  addr,		//要读取的指令地址
	output reg[`InstBus]		  inst		//读出的指令
	
);
	
	//定义128KB的ROM
	reg[`InstBus]  inst_mem[`InstMemNum-1:0];

	//initial $readmemh ( "inst_rom.data", inst_mem );
	/*initial begin
	   inst_mem[0] = 32'h00000001;
	   inst_mem[1] = 32'h00000002;
	   inst_mem[2] = 32'h00000003;
	   inst_mem[3] = 32'h00000004;
	end*/
    
	//由于MIPS是按字节寻址，每个地址是32-bit的字
	//即0x0对应的是inst_mem[0],0x4对应的是inst_mem[1]，以此类推
	//所以在计算地址的时候要除以4，在实际运算中，要右移2位，所以[1:0]省略掉
	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
	  end else begin
	        $display("%h",addr);
		  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end

endmodule
