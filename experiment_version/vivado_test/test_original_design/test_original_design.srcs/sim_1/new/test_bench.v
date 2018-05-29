`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2018 08:13:48 AM
// Design Name: 
// Module Name: test_bench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_bench(

    );
    
    //通用的时钟信号和reset信号
    reg            clk;			     //时钟信号
    reg            rst;              //复位信号
        
    //pc_reg.v    
    wire   [31:0]  pc;               //要读取的指令地址,其宽度等于ROM地址总线的宽度
    wire           ce;               //指令存储器的使能信号
    
    //if_id.v
    wire   [31:0]  id_pc;            //对应于ID阶段的地址
    wire   [31:0]  id_isnt;          //对应于ID阶段的指令
    
    //id.v
    ////输出到Regfile中的值
    wire             reg1_read_o;	 //读寄存器1的使能信号,连接的是Regfile中的rel信号（读端口1的使能信号）
    wire             reg2_read_o;     //读寄存器2的使能信号 
    wire     [4:0]   reg1_addr_o;     //读寄存器1的地址，连接的是Regfile中的raddr1信号（读端口1的地址）
    wire     [4:0]   reg2_addr_o;     //读寄存器2的地址
   
    //送到执行阶段的信息
    wire     [7:0]   aluop_o;         //指令运算的子类型
    wire     [2:0]   alusel_o;        //指令的运算类型
    wire     [31:0]  reg1_o;          //源操作数1
    wire     [31:0]  reg2_o;          //源操作数2
    wire     [4:0]   wd_o;            //要写入的目的寄存器地址（首先要判断wreg_o）
    wire             wreg_o;          //判断译码阶段是否要写入目的寄存器
   
    //regfile.v
    wire     [31:0]  rdata1;		     //读数据  
    wire     [31:0]  rdata2;		     //读数据  
    
    //inst_rom.v
    wire    [31:0]  inst;            //读出的指令   
    
    //temp_WB
    //写端口
    wire             we;            //写使能信号
    wire     [4:0]   waddr;        //写地址
    wire     [31:0]  wdata;        //写数据
    
    pc_reg  pc_reg0(
        .clk(clk),                   //时钟信号
        .rst(rst),                   //复位信号
        .pc(pc),                     //要读取的指令地址
        .ce(ce)                      //指令存储器的使能信号
    );
    /*
    if_id if_id0(
        .clk(clk),                   //时钟信号
        .rst(rst),                   //复位信号
        .if_pc(pc),                  //来自于IF阶段的地址
        .if_inst(inst),              //来自于IF阶段的指令
        .id_pc(id_pc),               //对应于ID阶段的地址
        .id_inst(id_inst)            //对应于ID阶段的指令
    );
    
    regfile regfile0(
        .clk(clk),
        .rst(rst),
        
        //写端口
        .we(we),                     //写使能信号
        .waddr(waddr),               //写地址
        .wdata(wdata),               //写数据
        
        //读端口1
        .re1(reg1_read_o),           //读使能信号
        .raddr1(reg1_addr_o),        //读地址
        .rdata1(rdata1),             //读数据
        
        //读端口2
        .re2(reg2_read_o),
        .raddr2(reg2_addr_o),
        .rdata2(rdata2)
        
    );
    
    inst_rom inst_rom0(
        .clk(clk),
        .ce(ce),                     //使能信号
        .addr(pc),                   //要读取的指令地址
        .inst(inst)                  //读出的指令
    );
    */
    
    inst_rom inst_rom0(
            .ce(ce),                     //使能信号
            .addr(pc),                   //要读取的指令地址
            .inst(inst)                  //读出的指令
        );
    
    initial begin
        $readmemh ( "/home/ckj/git_dir/MIPS_design/experiment_version/vivado_test/test_original_design/src/inst_rom.data", inst_rom0.inst_mem );
    end
    
    initial begin
        rst = 1;
        clk = 1;
        #5 rst = 0;
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    
endmodule
