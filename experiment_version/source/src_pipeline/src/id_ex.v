// Module:  id_ex
// File:    id_ex.v
// Description: ID与EX之间的桥梁
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module id_ex(

	input wire				      clk,
	input wire					  rst,

	
	//从译码阶段传来的信息
	input wire[`AluOpBus]         id_aluop,		//运算的子类型
	input wire[`AluSelBus]        id_alusel,	//运算类型
	input wire[`RegBus]           id_reg1,		//译码阶段要进行运算的源操作数1
	input wire[`RegBus]           id_reg2,		//译码阶段要进行运算的源操作数2
	input wire[`RegAddrBus]       id_wd,		//译码阶段要写入的寄存器地址
	input wire                    id_wreg,		//是否要写入目的寄存器
	
	//传递到执行阶段的信息
	output reg[`AluOpBus]         ex_aluop,
	output reg[`AluSelBus]        ex_alusel,
	output reg[`RegBus]           ex_reg1,
	output reg[`RegBus]           ex_reg2,
	output reg[`RegAddrBus]       ex_wd,
	output reg                    ex_wreg
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
		end else begin		
			ex_aluop <= id_aluop;
			ex_alusel <= id_alusel;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;		
		end
	end
	
endmodule
