`timescale 1ns / 1ps

module execute(
    input clk,
    input [31:0] execute_in_pc,
    input [31:0] execute_in_data1,
    input [31:0] execute_in_data2,
    input [4:0] execute_in_rs1,
    input [4:0] execute_in_rs2,
    input [4:0] execute_in_rd,
    input [31:0] execute_in_immediate,
    input [31:0] execute_in_instr,
    
    input execute_in_branch,
    input execute_in_memRead,
    input [2:0] execute_in_memtoReg,
    input [1:0] execute_in_aluOp,
    input execute_in_memWrite,
    input execute_in_aluSrc,
    input execute_in_regWrite,
    input execute_in_jalr,
    input execute_in_jump,
    input execute_in_bne,
    input execute_in_blt,
    input execute_in_bge,
    input execute_in_bltu,
    input execute_in_bgeu,
    
    
    input [31:0] execute_in_mem_aluOut, // veri sorunu oldugu zaman memorydeki veri henüz reg file'a yazýlmadan direkt alýnýr 
    input [31:0] execute_in_wb_aluOut,  // veri sorunu oldugu zaman writebacki veri henüz reg file'a yazýlmadan direkt alýnýr     
    input [31:0] execute_in_mem_immediate, ////////
    input [31:0] execute_in_wb_immediate,///////////
    input [31:0] execute_in_mem_imm_plus_pc_or_rs1,//////////
    input [31:0] execute_in_wb_imm_plus_pc_or_rs1,////////
    input [31:0] execute_in_mem_pc_plus_four,///////
    input [31:0] execute_in_wb_pc_plus_four,//////////
    
    //forwarding unit icin
    input [4:0] execute_in_mem_rd,
    input [4:0] execute_in_wb_rd,
    input execute_in_mem_regWrite,
    input execute_in_wb_regWrite,
    input [2:0] execute_in_mem_memtoReg, // sonradan eklendi
    input [2:0] execute_in_wb_memtoReg, // sonradan eklendi
    
    input execute_in_mem_memRead, // sonradan eklendi
    input execute_in_wb_memRead,
    
    input [31:0] execute_in_pc_plus_four,
    
    input [31:0] execute_in_mem_dataMemOut, //////////////////////
    input [31:0] execute_in_wb_dataMemOut,
            
    output [31:0] execute_out_data2,             
    output [4:0] execute_out_rd,          
    output [31:0] execute_out_immediate,      
                                                 
    output execute_out_memRead,           
    output [2:0] execute_out_memtoReg,          
    output execute_out_memWrite,                      
    output execute_out_regWrite,   
           
    output [31:0] execute_imm_plus_pc_or_rs1_to_fetch,   //fetche gidecek         
    output [31:0] execute_out_imm_plus_pc_or_rs1,
    output [31:0] execute_out_aluOut,
    output [31:0] execute_out_instr, //memorye func3 olarak girecek
    output  execute_out_flush, // fetchteki pcnin onundeki mux'a ve ID/EX registerina gider (register'a girmez)
    
    output [31:0] execute_out_pc_plus_four,
    
    output execute_out_memRead_to_decode, //decode'daki hazard unit'e gidecek
    
    output [4:0] execute_out_rd_to_decode //decode'daki hazard unit'e gidecek
    );
    
    
    
    wire [31:0] execute_alu_in1;
    wire [31:0] execute_alu_in2;
    wire [3:0] execute_alu_select;
    
    wire [3:0] execute_muxA_select,execute_muxB_select;
    
    wire [31:0] execute_data2;
    wire [31:0] execute_aluOut;
    
    wire execute_zero_flag,execute_blt_flag,execute_bge_flag,execute_bltu_flag,execute_bgeu_flag; //alu bayraklari
    wire [31:0] execute_jalr_wire;
    wire [31:0] execute_imm_plus_pc_or_rs1;
    
    
    assign execute_out_rd_to_decode=execute_in_rd;

    assign execute_out_memRead_to_decode=execute_in_memRead;
    
    assign execute_alu_in1= (execute_muxA_select==4'b0000) ? execute_in_data1:
                            (execute_muxA_select==4'b0001) ? execute_in_mem_aluOut:
                            (execute_muxA_select==4'b0010) ? execute_in_wb_aluOut :
                            (execute_muxA_select==4'b0011) ? execute_in_mem_pc_plus_four :
                            (execute_muxA_select==4'b0100) ? execute_in_wb_pc_plus_four:
                            (execute_muxA_select==4'b0101) ? execute_in_mem_immediate:
                            (execute_muxA_select==4'b0110) ? execute_in_wb_immediate:
                            (execute_muxA_select==4'b0111) ? execute_in_mem_imm_plus_pc_or_rs1:
                            (execute_muxA_select==4'b1000) ? execute_in_wb_imm_plus_pc_or_rs1 :
                            
                            (execute_muxA_select==4'b1001) ? execute_in_mem_dataMemOut:
                            (execute_muxA_select==4'b1010) ? execute_in_wb_dataMemOut: 0;
                    
                    
    assign execute_data2=   (execute_muxB_select==4'b0000) ? execute_in_data2:                       
                            (execute_muxB_select==4'b0001) ? execute_in_mem_aluOut:
                            (execute_muxB_select==4'b0010) ? execute_in_wb_aluOut :
                            (execute_muxB_select==4'b0011) ? execute_in_mem_pc_plus_four :
                            (execute_muxB_select==4'b0100) ? execute_in_wb_pc_plus_four:
                            (execute_muxB_select==4'b0101) ? execute_in_mem_immediate:
                            (execute_muxB_select==4'b0110) ? execute_in_wb_immediate:
                            (execute_muxB_select==4'b0111) ? execute_in_mem_imm_plus_pc_or_rs1:
                            (execute_muxB_select==4'b1000) ? execute_in_wb_imm_plus_pc_or_rs1 :
                            (execute_muxB_select==4'b1001) ? execute_in_mem_dataMemOut: 
                            (execute_muxB_select==4'b1010) ? execute_in_wb_dataMemOut: 0;
                              
    assign execute_alu_in2= (execute_in_aluSrc) ?  execute_in_immediate : execute_data2;                         
                              
    
    
    forwarding_unit forwarding(.MEM_rd(execute_in_mem_rd),
                               .MEM_regWrite(execute_in_mem_regWrite),
                               .WB_rd(execute_in_wb_rd),
                               .WB_regWrite(execute_in_wb_regWrite),
                               .EX_rs1(execute_in_rs1),
                               .EX_rs2(execute_in_rs2),
                               .MEM_memtoReg(execute_in_mem_memtoReg),
                               .WB_memtoReg(execute_in_wb_memtoReg),
                               .MEM_memRead(execute_in_mem_memRead), //////////////
                               .WB_memRead(execute_in_wb_memRead),
                               .MuxA_select(execute_muxA_select),
                               .MuxB_select(execute_muxB_select)
                               );
    
    
    alu_control aluControl(.instr(execute_in_instr),
                           .aluOp(execute_in_aluOp),
                           .alu_select(execute_alu_select)
                           );
    
    
    
    
    alu eyalu( 
           .A(execute_alu_in1),
           .B(execute_alu_in2),
           .g_sel(execute_alu_select),
           .zero(execute_zero_flag),
           .blt(execute_blt_flag),
           .bge(execute_bge_flag),
           .bltu(execute_bltu_flag),
           .bgeu(execute_bgeu_flag),
           .f_out(execute_aluOut)
           );   
           
           
    assign execute_jalr_wire = execute_in_jalr ? execute_alu_in1: execute_in_pc; // jalr gelirse immediate pc ile deðil r1 ile toplanýcak

    assign execute_imm_plus_pc_or_rs1 = execute_in_immediate+ execute_jalr_wire; 


    //wire execute_flush;

    assign execute_out_flush=(execute_in_branch & execute_zero_flag)|(execute_in_bne & !execute_zero_flag)|(execute_in_blt & execute_blt_flag)|(execute_in_bge & execute_bge_flag)|(execute_in_bltu & execute_bltu_flag)|(execute_in_bgeu & execute_bgeu_flag)|execute_in_jump;       
    
    assign execute_imm_plus_pc_or_rs1_to_fetch=execute_imm_plus_pc_or_rs1; // fetche gidecek output
    
    
    EX_MEM_register ex_mem_reg(
    .clk(clk),
    .EX_memRead(execute_in_memRead), //mem
    .EX_memtoReg(execute_in_memtoReg), //wb
    .EX_regWrite(execute_in_regWrite), //wb
    .EX_memWrite(execute_in_memWrite),
    
    .EX_imm_plus_pc_or_rs1(execute_imm_plus_pc_or_rs1),
    
    .EX_aluOut(execute_aluOut),
    
    .EX_data2(execute_data2), //store icin dmem'e girecek
    
    .EX_rd(execute_in_rd),
    
    .EX_imm(execute_in_immediate),
    
    .EX_pc_plus_four(execute_in_pc_plus_four),
    
    .EX_instr(execute_in_instr),
    
    .MEM_memRead(execute_out_memRead), //mem
    .MEM_memtoReg(execute_out_memtoReg), //wb
    .MEM_regWrite(execute_out_regWrite), //wb
    .MEM_memWrite(execute_out_memWrite),
    
    .MEM_imm_plus_pc_or_rs1(execute_out_imm_plus_pc_or_rs1),
    
    .MEM_aluOut(execute_out_aluOut),

    .MEM_instr(execute_out_instr),
        
    .MEM_data2(execute_out_data2), //store icin dmem'e girecek
    
    .MEM_rd(execute_out_rd),
    
    .MEM_imm(execute_out_immediate),
    
    .MEM_pc_plus_four(execute_out_pc_plus_four)
    
    );
    
    
    
    
    
endmodule
