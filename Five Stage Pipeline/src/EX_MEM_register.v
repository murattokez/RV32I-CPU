`timescale 1ns / 1ps

module EX_MEM_register(
    input clk,
    input EX_memRead, //mem
    input [2:0] EX_memtoReg, //wb
    input EX_regWrite, //wb
    input EX_memWrite, //mem
    
    input [31:0] EX_imm_plus_pc_or_rs1,
    
    input [31:0] EX_aluOut,
    
    input [31:0] EX_instr,
    
    input [31:0] EX_data2, //store icin dmem'e girecek
    
    input [4:0] EX_rd,
    
    input [31:0] EX_imm,
    
    input [31:0] EX_pc_plus_four,
    
    output reg MEM_memRead=0, //mem
    output reg [2:0] MEM_memtoReg=0, //wb
    output reg MEM_regWrite=0, //wb
    output reg MEM_memWrite=0, //mem
    
    output reg [31:0] MEM_imm_plus_pc_or_rs1=0,
    
    output reg [31:0] MEM_aluOut=0,
    
    output reg [31:0] MEM_instr=0,
    
    output reg [31:0] MEM_data2=0, //store icin dmem'e girecek
    
    output reg [4:0] MEM_rd=0,
    
    output reg [31:0] MEM_imm=0,
    
    output reg [31:0] MEM_pc_plus_four=0
    );
    
    always @(posedge clk) begin
        MEM_memRead<=EX_memRead;
        MEM_memtoReg<=EX_memtoReg;
        MEM_regWrite<=EX_regWrite;
        MEM_memWrite<=EX_memWrite;
        
        MEM_imm_plus_pc_or_rs1<=EX_imm_plus_pc_or_rs1;
        
        MEM_aluOut<=EX_aluOut;
        
        MEM_instr<=EX_instr;
        
        MEM_data2<=EX_data2;
    
        MEM_rd<=EX_rd;
        
        MEM_imm<=EX_imm;
        
        MEM_pc_plus_four<=EX_pc_plus_four;
    end
    
   
endmodule
