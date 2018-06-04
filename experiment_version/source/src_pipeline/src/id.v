// Module:  id
// File:    id.v
// Description: 指令的译码阶段
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module id(

	input wire					  rst,
	input wire[`InstAddrBus]	  pc_i,			//译码阶段的指令地址
	input wire[`InstBus]          inst_i,		//译码阶段的指令

	//从Regfile中读取的值
	input wire[`RegBus]           reg1_data_i,	//读寄存器1的数据
	input wire[`RegBus]           reg2_data_i,	//读寄存器2的数据

	//输出到Regfile中的值
	output reg                    reg1_read_o,	//读寄存器1的使能信号,连接的是Regfile中的rel信号（读端口1的使能信号）
	output reg                    reg2_read_o,  //读寄存器2的使能信号 
	output reg[`RegAddrBus]       reg1_addr_o,	//读寄存器1的地址，连接的是Regfile中的raddr1信号（读端口1的地址）
	output reg[`RegAddrBus]       reg2_addr_o, 	//读寄存器2的地址
	
	//送到执行阶段的信息
	output reg[`AluOpBus]         aluop_o,		//指令运算的子类型
	output reg[`AluSelBus]        alusel_o,		//指令的运算类型
	output reg[`RegBus]           reg1_o,		//源操作数1
	output reg[`RegBus]           reg2_o,		//源操作数2
	output reg[`RegAddrBus]       wd_o,			//要写入的目的寄存器地址（首先要判断wreg_o）
	output reg                    wreg_o		//判断译码阶段是否要写入目的寄存器
);

	//取得指令的指令码和功能码
  	wire[5:0] op = inst_i[31:26];
  	wire[4:0] op2 = inst_i[10:6];
  	wire[5:0] op3 = inst_i[5:0];
  	wire[4:0] op4 = inst_i[20:16];
  	reg[`RegBus]	imm;						//指令中用到的立即数
  	reg instvalid;								//指令是否有效
  
 	//第一阶段：对指令进行译码
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;			
	  	end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];		//默认的从Regfile读端口1读取的寄存器，并不是所有的指令类型都需要从Regfile中读取寄存器的值
			reg2_addr_o <= inst_i[20:16];		//默认的从Regfile读端口2读取的寄存器
			imm <= `ZeroWord;			
		  case (op)
		  	`EXE_ORI: begin                     //判断是否是ORI指令
		  		wreg_o <= `WriteEnable;			//ORI指令要将结果写到目的寄存器，所以wreg_o位WriteEnable
				aluop_o <= `EXE_OR_OP;			//运算子类型是进行或运算
		  		alusel_o <= `EXE_RES_LOGIC; 	//运算类型是逻辑运算
				reg1_read_o <= 1'b1;			//只用到了读端口1的寄存器
				reg2_read_o <= 1'b0;	  		//ORI指令的另一个操作数是立即数，所以设置该位为0，表示不使用读端口2，暗含的是使用立即数
				imm <= {16'h0, inst_i[15:0]};	//指令需要用到的立即数，同时对立即数进行了零扩展
				wd_o <= inst_i[20:16];			//目的寄存器地址
				instvalid <= `InstValid;		//指令有效
		  	end 							 
		    default: begin
		    end
		  endcase		  //case op			
		end       //if
	end         //always
	
	//第二阶段：确定源操作数1
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
	  	end else if(reg1_read_o == 1'b1) begin
	  		reg1_o <= reg1_data_i;				//Regfile读端口1的数值
	  	end else if(reg1_read_o == 1'b0) begin
	  		reg1_o <= imm;						//将立即数作为源操作数1
	  	end else begin
	    	reg1_o <= `ZeroWord;
	  	end
	end
	
	//第二阶段：确定源操作数1，与确定源操作数1的操作一样
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
	  	end else if(reg2_read_o == 1'b1) begin
	  		reg2_o <= reg2_data_i;
	  	end else if(reg2_read_o == 1'b0) begin
	  		reg2_o <= imm;
	  	end else begin
	    	reg2_o <= `ZeroWord;
	  	end
	end

endmodule
