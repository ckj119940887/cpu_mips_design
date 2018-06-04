/*全局宏定义*/
`define RstEnable 1'b1					//复位信号有效
`define RstDisable 1'b0					//复位信号无效
`define ZeroWord 32'h00000000			//常数0(32-bit)
`define WriteEnable 1'b1				//写信号有效
`define WriteDisable 1'b0				//写信号无效
`define ReadEnable 1'b1					//读信号有效
`define ReadDisable 1'b0				//读信号无效
`define AluOpBus 7:0					//译码阶段的aluop_o位宽,aluop_o指的是指令要进行的运算的子类型
`define AluSelBus 2:0					//译码阶段的alusel_o位宽,alusel_o指的是指令要进行的运算的类型
`define InstValid 1'b0					//指令有效
`define InstInvalid 1'b1				//指令无效
`define Stop 1'b1						//
`define NoStop 1'b0						//
`define InDelaySlot 1'b1				//
`define NotInDelaySlot 1'b0				//
`define Branch 1'b1						//
`define NotBranch 1'b0					//
`define InterruptAssert 1'b1			//
`define InterruptNotAssert 1'b0			//
`define TrapAssert 1'b1					//
`define TrapNotAssert 1'b0				//
`define True_v 1'b1						//逻辑真
`define False_v 1'b0					//逻辑假
`define ChipEnable 1'b1					//芯片使能
`define ChipDisable 1'b0				//芯片禁止


//指令相关宏定义
`define EXE_ORI  6'b001101				//ORI指令码
`define EXE_NOP 6'b000000				//NOP指令码

//AluOp，对应的是运算子类型，进行具体的操作，如或操作，与操作
`define EXE_OR_OP    8'b00100101		//或操作
`define EXE_ORI_OP  8'b01011010			//
`define EXE_NOP_OP    8'b00000000		//

//AluSel,对应的是运算类型，即用来表示逻辑运算，算术运算...
`define EXE_RES_LOGIC 3'b001			//逻辑运算
`define EXE_RES_NOP 3'b000				//空操作

//指令存储器(ROM)相关的宏定义	
`define InstAddrBus 31:0				//ROM地址总线宽度
`define InstBus 31:0					//ROM数据总线宽度
`define InstMemNum 131071				//ROM的大小，128KB
`define InstMemNumLog2 17				//ROM实际使用的地址线宽度


//通用存储器Regfile的相关宏定义
`define RegAddrBus 4:0					//Regfile模块的地址线宽度
`define RegBus 31:0						//Regfile模块的数据线宽度
`define RegWidth 32						//通用寄存器宽度
`define DoubleRegWidth 64				//两倍通用寄存器宽度
`define DoubleRegBus 63:0				//两倍通用寄存器的数据线宽度
`define RegNum 32						//寄存器数量
`define RegNumLog2 5					//寄存器使用的地址位数
`define NOPRegAddr 5'b00000				//
