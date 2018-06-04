// Module:  openmips_min_sopc
// File:    openmips_min_sopc.v
// Description: 用于测试的最小SOPC
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module openmips_min_sopc(

	input wire						clk,
	input wire						rst
	
);

  	//将CPU与指令ROM相连
  	wire[`InstAddrBus] inst_addr;
  	wire[`InstBus] inst;
  	wire rom_ce;
 
	//例化处理器openmips
	openmips openmips0(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce)
	
	);
	
	//例化指令ROM
	inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)	
	);


endmodule
