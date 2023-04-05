`timescale 1ns / 1ps

module writeBack(
    input clk,
    input writeBack_in_regWrite,
    input [2:0] writeBack_in_memtoReg,
    input [31:0] writeBack_in_aluOut,
    input [31:0] writeBack_in_dataMemOut,
    input [4:0] writeBack_in_rd,
    input [31:0] writeBack_in_imm_plus_pc_or_rs1,
    input [31:0] writeBack_in_immediate,
    input [31:0] writeBack_in_pc_plus_four,
    
    input [31:0] writeBack_in_instr,
    
    input writeBack_in_memRead,
    
    output writeBack_out_regWrite, // forwarda girecek
    output [4:0] writeBack_out_rd, //forward'a girecek
    output [4:0] writeBack_out_rd_to_decode, // reg file'a girecek
    
    output [31:0] writeBack_out_aluOut, //mux a ve b için (forwarding)
    
    output [31:0] writeBack_out_writeData, // nihai sonuc
    
    output writeBack_out_regWrite_to_decode, //register file'a girecek
    
    
    output [2:0] writeBack_out_memtoReg_to_execute,
    
    output [31:0] writeBack_out_immediate_to_execute, ////////
    output [31:0] writeBack_out_imm_plus_pc_or_rs1_to_execute,////////////
    output [31:0] writeBack_out_pc_plus_four_to_execute, /////////////
    
    output writeBack_out_memRead_to_execute, //forward icin stall
    output [31:0] writeBack_out_dataMememOut_to_execute
    );
    
    
    assign writeBack_out_writeData = (writeBack_in_memtoReg==3'b000) ? writeBack_in_dataMemOut:
                                     (writeBack_in_memtoReg==3'b001) ? writeBack_in_imm_plus_pc_or_rs1:
                                     (writeBack_in_memtoReg==3'b010) ? writeBack_in_immediate:
                                     (writeBack_in_memtoReg==3'b011) ? writeBack_in_pc_plus_four:
                                     (writeBack_in_memtoReg==3'b100) ? writeBack_in_aluOut : 0; 
    
    
    
    assign writeBack_out_rd=writeBack_in_rd;
    assign writeBack_out_regWrite=writeBack_in_regWrite;
    assign writeBack_out_aluOut=writeBack_in_aluOut;
    
    assign writeBack_out_regWrite_to_decode=writeBack_in_regWrite;
    
    assign writeBack_out_rd_to_decode=writeBack_in_rd;
    
    
    assign writeBack_out_memtoReg_to_execute=writeBack_in_memtoReg;
    
    assign writeBack_out_immediate_to_execute=writeBack_in_immediate;
    assign writeBack_out_imm_plus_pc_or_rs1_to_execute=writeBack_in_imm_plus_pc_or_rs1;
    assign writeBack_out_pc_plus_four_to_execute=writeBack_in_pc_plus_four;
    
    assign writeBack_out_memRead_to_execute=writeBack_in_memRead;
    
    assign writeBack_out_dataMememOut_to_execute=writeBack_out_writeData;
   
   
endmodule
