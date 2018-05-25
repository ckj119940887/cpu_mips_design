// Module:  ex
// File:    ex.v
// Description: 执行阶段，根据译码阶段的结果进行指定的运算
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex(

	input wire					  rst,
	
	//译码阶段送到执行阶段的信息
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,

	//执行的结果
	output reg[`RegAddrBus]       wd_o,			//要写入的目的寄存器的值
	output reg                    wreg_o,		//是否有要写入的目的寄存器
	output reg[`RegBus]			  wdata_o		//要写入目的寄存器的数据
	
);

	reg[`RegBus] logicout;						//用来保存逻辑运算结果的寄存器

	//第一阶段，根据运算的子类型进行相应的操作
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:	begin
					logicout <= reg1_i | reg2_i;
				end
				default: begin
					logicout <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	//根据运算类型将运算结果作为最终结果
	always @ (*) begin
		wd_o <= wd_i;	 	 	
	 	wreg_o <= wreg_i;
	 	case ( alusel_i ) 
	 		`EXE_RES_LOGIC: begin
	 			wdata_o <= logicout;
	 		end
	 		default: begin
	 			wdata_o <= `ZeroWord;
	 		end
	 	endcase
 	end	

endmodule
