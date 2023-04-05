`timescale 1ns / 1ps

module MEM_WB_register(
    input clk,
    input [2:0] MEM_memtoReg, //wb
    input MEM_regWrite, //wb
    input MEM_memRead,
        
    input [31:0] MEM_aluOut,
    
    input [31:0] MEM_dmemOut,
    
    input [4:0] MEM_rd,
    
    input [31:0] MEM_imm,
    
    input [31:0] MEM_pc_plus_four,
    
    input [31:0] MEM_imm_plus_pc_or_rs1,
    
    input [31:0] MEM_instr,
    
    output reg [2:0] WB_memtoReg=0, //wb
    output reg WB_regWrite=0, //wb
    
    output reg [31:0] WB_aluOut=0,
    
    output reg [31:0] WB_dmemOut=0,
    
    output reg [4:0] WB_rd=0,
    
    output reg [31:0] WB_imm=0,
    
    output reg [31:0] WB_pc_plus_four=0,
    
    output reg [31:0] WB_imm_plus_pc_or_rs1=0,
    
    output reg WB_memRead=0,
    
    output reg [31:0] WB_instr=0

    );
    
    
    always @(posedge clk) begin
        WB_memtoReg<=MEM_memtoReg;
        WB_regWrite<=MEM_regWrite;
    
        WB_aluOut<=MEM_aluOut;
        WB_dmemOut<=MEM_dmemOut;
        WB_rd<=MEM_rd;
        WB_imm<=MEM_imm;
    
        WB_pc_plus_four<=MEM_pc_plus_four;
        
        WB_imm_plus_pc_or_rs1<=MEM_imm_plus_pc_or_rs1;
        
        WB_memRead<=MEM_memRead;
        
        WB_instr<=MEM_instr;
    end
    
    
    
    
    
    
    
    
endmodule
