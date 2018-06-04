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
    wire   [31:0]  id_inst;          //对应于ID阶段的指令
    
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
    
    //id_ex.v
    wire [7:0]        ex_aluop;
    wire [2:0]        ex_alusel;
    wire [31:0]       ex_reg1;
    wire [31:0]       ex_reg2;
    wire [4:0]        ex_wd;
    wire              ex_wreg;
    
    //ex.v
    wire [4:0]       ex_wd_o;			//要写入的目的寄存器的值
    wire             ex_wreg_o;        //是否有要写入的目的寄存器
    wire [31:0]      ex_wdata_o;        //要写入目的寄存器的数据
    
    //ex_mem.v
    wire [4:0]       mem_wd;
    wire             mem_wreg;
    wire [31:0]      mem_wdata;
    
    //mem.v
    wire [4:0]       mem_wd_o;
    wire             mem_wreg_o;
    wire [31:0]      mem_wdata_o;
    
    //mem_wb.v
    wire [4:0]       wb_wd;
    wire             wb_wreg;
    wire [31:0]      wb_wdata;      
    
    //inst_rom.v
    wire    [31:0]  inst;            //读出的指令   
    
   
    pc_reg  pc_reg0(
        .clk(clk),                   //时钟信号
        .rst(rst),                   //复位信号
        .pc(pc),                     //要读取的指令地址
        .ce(ce)                      //指令存储器的使能信号
    );
    
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
        .we(wb_wreg),                     //写使能信号
        .waddr(wb_wd),               //写地址
        .wdata(wb_wdata),               //写数据
        
        //读端口1
        .re1(reg1_read_o),           //读使能信号
        .raddr1(reg1_addr_o),        //读地址
        .rdata1(rdata1),             //读数据
        
        //读端口2
        .re2(reg2_read_o),
        .raddr2(reg2_addr_o),
        .rdata2(rdata2)
        
    );
    
    id id0(
    
        .rst(rst),
        .pc_i(id_pc),            //译码阶段的指令地址
        .inst_i(id_inst),        //译码阶段的指令
    
        //从Regfile中读取的值
        .reg1_data_i(rdata1),    //读寄存器1的数据
        .reg2_data_i(rdata2),    //读寄存器2的数据
    
        //输出到Regfile中的值
        .reg1_read_o(reg1_read_o),    //读寄存器1的使能信号,连接的是Regfile中的rel信号（读端口1的使能信号）
        .reg2_read_o(reg2_read_o),  //读寄存器2的使能信号 
        .reg1_addr_o(reg1_addr_o),    //读寄存器1的地址，连接的是Regfile中的raddr1信号（读端口1的地址）
        .reg2_addr_o(reg2_addr_o),     //读寄存器2的地址
        
        //送到执行阶段的信息
        .aluop_o(aluop_o),        //指令运算的子类型
        .alusel_o(alusel_o),        //指令的运算类型
        .reg1_o(reg1_o),        //源操作数1
        .reg2_o(reg2_o),        //源操作数2
        .wd_o(wd_o),            //要写入的目的寄存器地址（首先要判断wreg_o）
        .wreg_o(wreg_o)        //判断译码阶段是否要写入目的寄存器
    );
    
    id_ex id_ex0(
    
        .clk(clk),
        .rst(rst),
    
        
        //从译码阶段传来的信息
        .id_aluop(aluop_o),        //运算的子类型
        .id_alusel(alusel_o),    //运算类型
        .id_reg1(reg1_o),        //译码阶段要进行运算的源操作数1
        .id_reg2(reg2_o),        //译码阶段要进行运算的源操作数2
        .id_wd(wd_o),        //译码阶段要写入的寄存器地址
        .id_wreg(wreg_o),        //是否要写入目的寄存器
        
        //传递到执行阶段的信息
        .ex_aluop(ex_aluop),
        .ex_alusel(ex_alusel),
        .ex_reg1(ex_reg1),
        .ex_reg2(ex_reg2),
        .ex_wd(ex_wd),
        .ex_wreg(ex_wreg)
        
    );
    
    ex ex0(
    
        .rst(rst),
        
        //译码阶段送到执行阶段的信息
        .aluop_i(ex_aluop),
        .alusel_i(ex_alusel),
        .reg1_i(ex_reg1),
        .reg2_i(ex_reg2),
        .wd_i(ex_wd),
        .wreg_i(ex_wreg),
    
        //执行的结果
        .wd_o(ex_wd_o),            //要写入的目的寄存器的值
        .wreg_o(ex_wreg_o),        //是否有要写入的目的寄存器
        .wdata_o(ex_wdata_o)        //要写入目的寄存器的数据
        
    );
    
    ex_mem ex_mem0(
    
        .clk(clk),
        .rst(rst),
        
        //EX阶段产生的计算结果    
        .ex_wd(ex_wd_o),        //要写入的目的寄存器的地址
        .ex_wreg(ex_wreg_o),        //是否有要写入的目的寄存器
        .ex_wdata(ex_wdata_o),     //要写入目的寄存器的data
        
        //
        .mem_wd(mem_wd),
        .mem_wreg(mem_wreg),
        .mem_wdata(mem_wdata)
        
    );
    
    mem mem0(
    
        .rst(rst),
        
        //来自执行阶段的结果    
        .wd_i(mem_wd),
        .wreg_i(mem_wreg),
        .wdata_i(mem_wdata),
        
        //访存阶段的结果
        .wd_o(mem_wd_o),
        .wreg_o(mem_wreg_o),
        .wdata_o(mem_wdata_o)
        
    );
    
    inst_rom inst_rom0(
        .ce(ce),                     //使能信号
        .addr(pc),                   //要读取的指令地址
        .inst(inst)                  //读出的指令
    );
    
    mem_wb mem_wb0(
    
        .clk(clk),
        .rst(rst),

        //来自于访存阶段的结果    
        .mem_wd(mem_wd_o),
        .mem_wreg(mem_wreg_o),
        .mem_wdata(mem_wdata_o),
    
        //送到回写阶段的结果
        .wb_wd(wb_wd),
        .wb_wreg(wb_wreg),
        .wb_wdata(wb_wdata)           
        
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
