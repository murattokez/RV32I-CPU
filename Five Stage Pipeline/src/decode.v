`timescale 1ns / 1ps


module decode(
    input clk,
    input flush,
    input [31:0] decode_in_pc,
    input [31:0] decode_in_instr,
    input [31:0] decode_in_write_data,
    input decode_in_regWrite, //wb'dan gelecek
    input decode_in_memRead, //execute'dan gelecek
    input [4:0] decode_in_rd, //writebackten gelecek
    input [31:0] decode_in_pc_plus_four,
    
    input [4:0] decode_in_ex_rd, //hazard uit icin executeden gelecek
    
    output decode_out_memWrite,//wb
    output decode_out_memRead, //wb
    output decode_out_regWrite, //mem
    output [2:0] decode_out_memtoReg,//mem
    output [1:0] decode_out_aluOp,
    output decode_out_aluSrc, //ex
    output decode_out_branch,//ex
    output decode_out_jalr,//ex
    output decode_out_jump,//ex
    output decode_out_bne,decode_out_blt,decode_out_bge,decode_out_bltu,decode_out_bgeu,//ex
    output [31:0] decode_out_pc,
    output [31:0] decode_out_data1,
    output [31:0] decode_out_data2,
    output [4:0] decode_out_rs1,
    output [4:0] decode_out_rs2,
    output [4:0] decode_out_rd,
    output [31:0] decode_out_immediate,
    output [31:0] decode_out_instr,
    output  decode_out_pcWrite,
    output  decode_out_IF_ID_write_en,
    
    output [31:0] decode_out_pc_plus_four

    );
    
    wire branch;        //kontrol sinyalleri  
    wire memRead;       
    wire [2:0] memtoReg;
    wire [1:0] aluOp;   
    wire memWrite;      
    wire aluSrc;        
    wire regWrite;      
    wire jalr;     
    wire jump; 
    wire bne,blt,bge,bltu,bgeu; // control unit branch
    
    
    wire [31:0] r1_data;
    wire [31:0] r2_data; // reg file'dan cikacak ID/EX register'a girecek    
    
    wire [31:0] extend_imm_value;// immden cikip ID/EX'e girecek
    
    
    wire controlValues_select; // kontrol sinyallerinin onundeki mux (stall oldugunda kontorl sinyaleri 0 lanýr)
     wire [16:0] control_signals = {branch,memRead,memtoReg,aluOp,memWrite,aluSrc,regWrite,jalr,jump,bne,blt,bge,bltu,bgeu};
    //kontrol sinyalleri yukaridaki wire'a sirali olarak encodelanmistir
    wire [16:0] encoded_control_signals;
    
    assign encoded_control_signals = controlValues_select ? 0 : control_signals;
    
    
    
    hazard_detection hazardUnit(.IF_ID_rs1(decode_in_instr[19:15]),
                                .IF_ID_rs2(decode_in_instr[24:20]),
                                .ID_EX_rd(decode_in_ex_rd),
                                .ID_EX_memRead(decode_in_memRead),
                                .pcWrite_en(decode_out_pcWrite),
                                .IF_ID_write_en(decode_out_IF_ID_write_en),
                                .ID_EX_controlValues_select(controlValues_select)
                                 );
    
    
    
        
    control_unit cu(.instr(decode_in_instr[6:0]),
                .func3(decode_in_instr[14:12]),
                .branch(branch),
                .memRead(memRead),
                .memtoReg(memtoReg),
                .aluOp(aluOp),
                .memWrite(memWrite),
                .aluSrc(aluSrc),
                .regWrite(regWrite),
                .jalr(jalr),
                .jump(jump),
                .bne(bne),
                .blt(blt),
                .bge(bge),
                .bltu(bltu),
                .bgeu(bgeu)
                );
                
    registerfile regfile(.rs1(decode_in_instr[19:15]),
                         .rs2(decode_in_instr[24:20]),
                         .rd(decode_in_rd),
                         .wr_data(decode_in_write_data),
                         .wr_en(decode_in_regWrite),
                         .clk(clk),
                         .r1_data(r1_data),
                         .r2_data(r2_data)
                         //.out()
                         );
                
     imm immediate(.Instruction(decode_in_instr[31:0]),
                   .Imm(extend_imm_value)
                    );           
                
                
                
                
                
                
                
    
    
        ID_EX_register ID_EX_reg(
                       .clk(clk),
                       .flush(flush),
                       .ID_branch(encoded_control_signals[16]), // control signals
                       .ID_memRead(encoded_control_signals[15]),
                       .ID_memtoReg(encoded_control_signals[14:12]),
                       .ID_aluOp(encoded_control_signals[11:10]),
                       .ID_memWrite(encoded_control_signals[9]),
                       .ID_aluSrc(encoded_control_signals[8]),
                       .ID_regWrite(encoded_control_signals[7]),
                       .ID_jalr(encoded_control_signals[6]),
                       .ID_jump(encoded_control_signals[5]),
                       .ID_bne(encoded_control_signals[4]),
                       .ID_blt(encoded_control_signals[3]),
                       .ID_bge(encoded_control_signals[2]),
                       .ID_bltu(encoded_control_signals[1]),
                       .ID_bgeu(encoded_control_signals[0]),
    
    
                       .ID_PC(decode_in_pc), //pc
                       
                       .ID_data1(r1_data), //datalar
                       .ID_data2(r2_data),
                       
                       .ID_rs1(decode_in_instr[19:15]), 
                       .ID_rs2(decode_in_instr[24:20]),
                       .ID_rd(decode_in_instr[11:7]),
                       
                       .ID_imm(extend_imm_value),
                       
                       .ID_pc_plus_four(decode_in_pc_plus_four),
                       
                       .ID_instr(decode_in_instr),
    
                       .EX_branch(decode_out_branch), 
                       .EX_memRead(decode_out_memRead),
                       .EX_memtoReg(decode_out_memtoReg),
                       .EX_aluOp(decode_out_aluOp),
                       .EX_memWrite(decode_out_memWrite),
                       .EX_aluSrc(decode_out_aluSrc),
                       .EX_regWrite(decode_out_regWrite),
                       .EX_jalr(decode_out_jalr),
                       .EX_jump(decode_out_jump),
                       .EX_bne(decode_out_bne),
                       .EX_blt(decode_out_blt),
                       .EX_bge(decode_out_bge),
                       .EX_bltu(decode_out_bltu),
                       .EX_bgeu(decode_out_bgeu),
  
                       .EX_PC(decode_out_pc), //pc
  
                       .EX_data1(decode_out_data1), //datalar
                       .EX_data2(decode_out_data2),
  
                       .EX_rs1(decode_out_rs1), //source ve destinationlar
                       .EX_rs2(decode_out_rs2),
                       .EX_rd(decode_out_rd),
  
                       .EX_imm(decode_out_immediate),

                       .EX_pc_plus_four(decode_out_pc_plus_four),
                       .EX_instr(decode_out_instr)
    );
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
