`timescale 1ns / 1ps

module memory(
    input clk,
    input memory_in_regWrite,
    input [2:0] memory_in_memtoReg,
    input memory_in_memWrite,
    input memory_in_memRead,
    
    input [31:0] memory_in_imm_plus_pc_or_rs1,
    
    
    input [31:0] memory_in_aluOut,
    
    input [31:0] memory_in_instr,
    
    input [31:0] memory_in_data2,
    
    input [4:0] memory_in_rd,
    
    input [31:0] memory_in_immediate,
    
    input [31:0] memory_in_pc_plus_four,
    
    output memory_out_regWrite,
    output [2:0] memory_out_memtoReg,
    
    output [31:0] memory_out_aluOut,
    
    //output [31:0] memory_out_instr,
    
    output [31:0] memory_out_dataMemOut,
    
    output [4:0] memory_out_rd,
    
    output [31:0] memory_out_imm_plus_pc_or_rs1,

    output [31:0] memory_out_immediate,
    
    output [31:0] memory_out_pc_plus_four,
    
    output [4:0] memory_out_rd_to_execute, // executedak, forwardinge gidecek
    output memory_out_regWrite_to_execute, // executedak, forwardinge gidecek
    output [31:0] memory_out_aluOut_to_execute, // executedak, forwardinge gidecek
    
    output [2:0] memory_out_memtoReg_to_execute, // executedak, forwardinge gidecek
    
    output [31:0] memory_out_immediate_to_execute, ////////
    output [31:0] memory_out_imm_plus_pc_or_rs1_to_execute,////////////
    output [31:0] memory_out_pc_plus_four_to_execute, /////////////
    
    output memory_out_memRead_to_execute,
    output [31:0] memory_out_dataMemOut_to_execute,
    
    output memory_out_memRead,
    
    output [31:0] memory_out_instr
    
    
    );
    
    
    wire [31:0] memory_data_mem_out;
    
    assign memory_out_aluOut_to_execute=memory_in_aluOut;
    assign memory_out_regWrite_to_execute=memory_in_regWrite;
    assign memory_out_rd_to_execute=memory_in_rd;
    
    assign memory_out_memtoReg_to_execute=memory_in_memtoReg;
    
    assign memory_out_immediate_to_execute=memory_in_immediate;
    assign memory_out_imm_plus_pc_or_rs1_to_execute=memory_in_imm_plus_pc_or_rs1;
    assign memory_out_pc_plus_four_to_execute=memory_in_pc_plus_four;
    
    assign memory_out_dataMemOut_to_execute=memory_data_mem_out; ////////////////
    assign memory_out_memRead_to_execute=memory_in_memRead;
    
    dmem datamemory(.address(memory_in_aluOut),
                    .data_in(memory_in_data2),
                    .func3(memory_in_instr[14:12]),
                    .clk(clk),
                    .wr_en(memory_in_memWrite),
                    .rd_en(memory_in_memRead),
                    .data_out(memory_data_mem_out)
                    );
                    
     MEM_WB_register mem_wb_reg(.clk(clk),
                                .MEM_memtoReg(memory_in_memtoReg), //wb
                                .MEM_regWrite(memory_in_regWrite), //wb
                                
                                .MEM_aluOut(memory_in_aluOut),
                                
                                .MEM_dmemOut(memory_data_mem_out),
                                
                                .MEM_rd(memory_in_rd),
                                
                                .MEM_imm(memory_in_immediate),
                                
                                .MEM_pc_plus_four(memory_in_pc_plus_four),
                                
                                .MEM_imm_plus_pc_or_rs1(memory_in_imm_plus_pc_or_rs1),
                                
                                .MEM_memRead(memory_in_memRead),
                                
                                .MEM_instr(memory_in_instr),
                                
                                .WB_memtoReg(memory_out_memtoReg), //wb
                                .WB_regWrite(memory_out_regWrite), //wb
                                
                                .WB_aluOut(memory_out_aluOut),
                                
                                .WB_dmemOut(memory_out_dataMemOut),
                                
                                .WB_rd(memory_out_rd),
                                
                                .WB_imm(memory_out_immediate),
                                
                                .WB_pc_plus_four(memory_out_pc_plus_four),
                                
                                .WB_imm_plus_pc_or_rs1(memory_out_imm_plus_pc_or_rs1),
                                
                                .WB_memRead(memory_out_memRead),
                                
                                .WB_instr(memory_out_instr)
    );               
                    
                    
    
    
    
endmodule
