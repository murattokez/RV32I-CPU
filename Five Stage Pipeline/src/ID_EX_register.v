`timescale 1ns / 1ps

module ID_EX_register(
    input clk,
    input flush,
    input ID_branch, // control signals
    input ID_memRead,
    input [2:0] ID_memtoReg,
    input [1:0] ID_aluOp,
    input ID_memWrite,
    input ID_aluSrc,
    input ID_regWrite,
    input ID_jalr,
    input ID_jump,
    input ID_bne,ID_blt,ID_bge,ID_bltu,ID_bgeu,
    input [31:0] ID_instr,
    
    
    
    input [31:0] ID_PC, //pc
    
    input [31:0] ID_data1, //datalar
    input [31:0] ID_data2,
    
    input [4:0] ID_rs1, //source ve destinationlar
    input [4:0] ID_rs2,
    input [4:0] ID_rd,
    
    input [31:0] ID_imm, //immediate
    
    input [31:0] ID_pc_plus_four,
    
    output reg EX_branch=0, // control signals
    output reg EX_memRead=0,
    output reg [2:0] EX_memtoReg=0,
    output reg [1:0] EX_aluOp=0,
    output reg EX_memWrite=0,
    output reg EX_aluSrc=0,
    output reg EX_regWrite=0,
    output reg EX_jalr=0,
    output reg EX_jump=0,
    output reg EX_bne=0,EX_blt=0,EX_bge=0,EX_bltu=0,EX_bgeu=0,
    
    output reg [31:0] EX_PC=32'h00400000, //pc
    
    output reg [31:0] EX_data1=0, //datalar
    output reg [31:0] EX_data2=0,
    
    output reg [4:0] EX_rs1=0, //source ve destinationlar
    output reg [4:0] EX_rs2=0,
    output reg [4:0] EX_rd=0,
    
    output reg [31:0] EX_imm=0,
    
    output reg [31:0] EX_instr=0,
    
    output reg [31:0] EX_pc_plus_four=0



    );
    
    
    always @(posedge clk) begin
        if(flush) begin
            
        EX_branch<=0;         
        EX_memRead<=0;       
        EX_memtoReg<=0;     
        EX_aluOp<=0;           
        EX_memWrite<=0;     
        EX_aluSrc<=0;         
        EX_regWrite<=0;   
        
        EX_jalr<=0; 
        EX_jump<=0; 
        EX_bne<=0;   
        EX_blt<=0;   
        EX_bge<=0;   
        EX_bltu<=0; 
        EX_bgeu<=0;   
                                              
        EX_PC<=32'h00400000;                 
        EX_data1<=0;           
        EX_data2<=0;           
        EX_rs1<=0;               
        EX_rs2<=0;               
        EX_rd<=0;                 
        EX_imm<=0;               
             
         EX_instr<=0;
                                      
        EX_pc_plus_four<=0;    
   
        end
    
    
        else begin
        EX_branch<=ID_branch;
        EX_memRead<=ID_memRead;
        EX_memtoReg<=ID_memtoReg;
        EX_aluOp<=ID_aluOp;
        EX_memWrite<=ID_memWrite;
        EX_aluSrc<=ID_aluSrc;
        EX_regWrite<=ID_regWrite;
        
        EX_jalr<=ID_jalr;
        EX_jump<=ID_jump;
        EX_bne<=ID_bne;
        EX_blt<=ID_blt;
        EX_bge<=ID_bge;
        EX_bltu<=ID_bltu;
        EX_bgeu<=ID_bgeu;
        
        
        
        EX_PC<=ID_PC;
        EX_data1<=ID_data1;
        EX_data2<=ID_data2;
        EX_rs1<=ID_rs1;
        EX_rs2<=ID_rs2;
        EX_rd<=ID_rd;
        EX_imm<=ID_imm;
        
        EX_instr<=ID_instr;
        
        EX_pc_plus_four<=ID_pc_plus_four;
        end
    end
    
endmodule
