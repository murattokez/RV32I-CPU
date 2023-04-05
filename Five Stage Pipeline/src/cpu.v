`timescale 1ns / 1ps



module cpu(
    input clk,
    output [31:0] register_file_out
    );
    
    
    
    //ID_IF decode'dan fetch'e gittigini belirtir veya ID_EX yine wire'ýn decode'dan executa gittigini belirtir.
    
    ////fetch
    
    //wire [31:0] IF_ID_imm_plus_pc_or_rs1;
    wire [31:0] IF_ID_pc;
    wire [31:0] IF_ID_instr;
    wire [31:0] IF_ID_pc_plus_four;
    
    ///////decode
    wire ID_EX_branch;        //kontrol sinyalleri  
    wire ID_EX_memRead;       
    wire [2:0] ID_EX_memtoReg;
    wire [1:0] ID_EX_aluOp;   
    wire ID_EX_memWrite;      
    wire ID_EX_aluSrc;        
    wire ID_EX_regWrite;      
    wire ID_EX_jalr;     
    wire ID_EX_jump;
    wire ID_EX_bne,ID_EX_blt,ID_EX_bge,ID_EX_bltu,ID_EX_bgeu; // control unit branch
    wire [31:0] ID_EX_pc;
    wire [31:0] ID_EX_data1;
    wire [31:0] ID_EX_data2;
    wire [4:0] ID_EX_rs1;
    wire [4:0] ID_EX_rs2;
    wire [4:0] ID_EX_rd;
    wire [31:0] ID_EX_imm;
    wire [31:0] ID_EX_instr;
    wire [31:0] ID_EX_pc_plus_four;
    wire ID_IF_pcWrite_en;
    wire ID_IF_stall;
    
    
    
    ///////execute
    wire EX_MEM_memRead;       
    wire [2:0] EX_MEM_memtoReg;   
    wire EX_MEM_memWrite;            
    wire EX_MEM_regWrite;      
    wire [31:0] EX_MEM_imm_plus_pc_or_rs1;
    wire [31:0] EX_MEM_aluOut;
    wire [31:0] EX_MEM_instr;
    wire [31:0] EX_MEM_data2;
    wire [4:0] EX_MEM_rd;
    wire [31:0] EX_MEM_imm;
    wire [31:0] EX_MEM_pc_plus_four;
    wire [31:0] EX_IF_imm_plus_pc_or_rs1;
    wire flush; //fetch'deki pcnin onundeki mux'a ve ID/Ex registerina gider
    wire EX_ID_memRead; // hazard detection'a girecek
    
    //assign EX_MEM_memRead=EX_ID_memRead;
    
    /////////////memory
    wire MEM_WB_regWrite;
    wire [2:0] MEM_WB_memtoReg;
    wire [31:0] MEM_WB_aluOut;
    wire [31:0] MEM_WB_dataMemOut;
    wire [4:0] MEM_WB_rd;
    wire [31:0] MEM_WB_imm_plus_pc_or_rs1;
    wire [31:0] MEM_WB_imm;
    wire [31:0] MEM_WB_pc_plus_four; 
    wire [4:0] MEM_EX_rd; //forwarding
    wire [31:0] MEM_EX_aluOut; //forwarding
    wire MEM_EX_regWrite;
    
    
    /////writeBack
    wire [31:0] WB_ID_write_data; //nihai sonuc
    wire [4:0] WB_EX_rd;
    wire [31:0] WB_EX_aluOut;
    wire WB_EX_regWrite;
    wire WB_ID_regWrite;
    
    //assign WB_EX_regWrite=WB_ID_regWrite;
    //sonradan eklenenler
    wire [4:0] WB_ID_rd;
    
    wire [2:0] MEM_EX_memtoReg;
    wire [2:0] WB_EX_memtoReg;
    
    wire [31:0] MEM_EX_pc_plus_four;
    wire [31:0] WB_EX_pc_plus_four;
    wire [31:0] MEM_EX_immediate;
    wire [31:0] WB_EX_immediate;
    wire [31:0] MEM_EX_imm_plus_pc_or_rs1;
    wire [31:0] WB_EX_imm_plus_pc_or_rs1;
   
    
    wire WB_EX_memRead;
    wire MEM_EX_memRead;
    wire [31:0] MEM_EX_dataMemOut;
    wire [31:0] WB_EX_dataMemOut;
    
    wire MEM_WB_memRead;
    
    wire [4:0] EX_ID_rd;
    
    wire [31:0] MEM_WB_instr;
    
    fetch fetchStage(.clk(clk),
           .flush(flush),
          .fetch_in_pcWrite(ID_IF_pcWrite_en),
          .fetch_in_IF_ID_write_en(ID_IF_stall),
          .fetch_in_branch_or_jump(flush), 
          .fetch_in_imm_plus_pc_or_rs1(EX_IF_imm_plus_pc_or_rs1),
          
          .fetch_out_pc(IF_ID_pc),
          .fetch_out_instr(IF_ID_instr),
          .fetch_out_pc_plus_four(IF_ID_pc_plus_four)
    );
    
    
    decode decodeStage(.clk(clk),
           .flush(flush),
           .decode_in_pc(IF_ID_pc),
           .decode_in_instr(IF_ID_instr),
           .decode_in_write_data(WB_ID_write_data),
           .decode_in_regWrite(WB_ID_regWrite), 
           .decode_in_memRead(EX_ID_memRead), //execute'dan gelecek
           .decode_in_pc_plus_four(IF_ID_pc_plus_four),
           
           .decode_in_rd(WB_ID_rd),
           .decode_in_ex_rd(EX_ID_rd),
           
           
           .decode_out_memWrite(ID_EX_memWrite),//wb
           .decode_out_memRead(ID_EX_memRead), //wb
           .decode_out_regWrite(ID_EX_regWrite), //mem
           .decode_out_memtoReg(ID_EX_memtoReg),//mem
           .decode_out_aluOp(ID_EX_aluOp),
           .decode_out_aluSrc(ID_EX_aluSrc), //ex
           .decode_out_branch(ID_EX_branch),//ex
           .decode_out_jalr(ID_EX_jalr),//ex
           .decode_out_jump(ID_EX_jump),//ex
           .decode_out_bne(ID_EX_bne),
           .decode_out_blt(ID_EX_blt),
           .decode_out_bge(ID_EX_bge),
           .decode_out_bltu(ID_EX_bltu),
           .decode_out_bgeu(ID_EX_bgeu),//ex
           .decode_out_pc(ID_EX_pc),
           .decode_out_data1(ID_EX_data1),
           .decode_out_data2(ID_EX_data2),
           .decode_out_rs1(ID_EX_rs1),
           .decode_out_rs2(ID_EX_rs2),
           .decode_out_rd(ID_EX_rd),
           .decode_out_immediate(ID_EX_imm),
           .decode_out_instr(ID_EX_instr),
           .decode_out_pcWrite(ID_IF_pcWrite_en),
           .decode_out_IF_ID_write_en(ID_IF_stall),
           
           .decode_out_pc_plus_four(ID_EX_pc_plus_four)
           
           

    );
    
    assign register_file_out=WB_ID_write_data;
    //assign EX_MEM_memRead=EX_ID_memRead;
    
    execute executeStage(.clk(clk),
            .execute_in_pc(ID_EX_pc),
            .execute_in_data1(ID_EX_data1),
            .execute_in_data2(ID_EX_data2),
            .execute_in_rs1(ID_EX_rs1),
            .execute_in_rs2(ID_EX_rs2),
            .execute_in_rd(ID_EX_rd),
            .execute_in_immediate(ID_EX_imm),
            .execute_in_instr(ID_EX_instr),
            
            .execute_in_branch(ID_EX_branch),
            .execute_in_memRead(ID_EX_memRead),
            .execute_in_memtoReg(ID_EX_memtoReg),
            .execute_in_aluOp(ID_EX_aluOp),
            .execute_in_memWrite(ID_EX_memWrite),
            .execute_in_aluSrc(ID_EX_aluSrc),
            .execute_in_regWrite(ID_EX_regWrite),
            .execute_in_jalr(ID_EX_jalr),
            .execute_in_jump(ID_EX_jump),
            .execute_in_bne(ID_EX_bne),
            .execute_in_blt(ID_EX_blt),
            .execute_in_bge(ID_EX_bge),
            .execute_in_bltu(ID_EX_bltu),
            .execute_in_bgeu(ID_EX_bgeu),
            
           
            .execute_in_mem_aluOut(MEM_EX_aluOut), // veri sorunu oldugu zaman memorydeki veri henüz reg file'a yazýlmadan direkt alýnýr 
            .execute_in_wb_aluOut(WB_EX_aluOut),  // veri sorunu oldugu zaman writebacki veri henüz reg file'a yazýlmadan direkt alýnýr 
            
            .execute_in_mem_pc_plus_four(MEM_EX_pc_plus_four),//////
            .execute_in_wb_pc_plus_four(WB_EX_pc_plus_four),/////////
            
            .execute_in_mem_immediate(MEM_EX_immediate),/////////
            .execute_in_wb_immediate(WB_EX_immediate),/////////
            
            .execute_in_mem_imm_plus_pc_or_rs1(MEM_EX_imm_plus_pc_or_rs1),/////////
            .execute_in_wb_imm_plus_pc_or_rs1(WB_EX_imm_plus_pc_or_rs1),/////////
            
            
            .execute_in_mem_rd(MEM_EX_rd),
            .execute_in_wb_rd(WB_EX_rd),
            .execute_in_mem_regWrite(MEM_EX_regWrite),
            .execute_in_wb_regWrite(WB_EX_regWrite),
            
            .execute_in_mem_memtoReg(MEM_EX_memtoReg),
            .execute_in_wb_memtoReg(WB_EX_memtoReg),
            
            
            .execute_in_pc_plus_four(ID_EX_pc_plus_four),
            
            .execute_in_mem_memRead(MEM_EX_memRead),
            .execute_in_wb_memRead(WB_EX_memRead),

            .execute_in_wb_dataMemOut(WB_EX_dataMemOut),
            .execute_in_mem_dataMemOut(MEM_EX_dataMemOut),
            
            .execute_out_data2(EX_MEM_data2),             
            .execute_out_rd(EX_MEM_rd),          
            .execute_out_immediate(EX_MEM_imm),      
                                               
            .execute_out_memRead(EX_MEM_memRead),           
            .execute_out_memtoReg(EX_MEM_memtoReg),          
            .execute_out_memWrite(EX_MEM_memWrite),                      
            .execute_out_regWrite(EX_MEM_regWrite),   
            
            .execute_imm_plus_pc_or_rs1_to_fetch(EX_IF_imm_plus_pc_or_rs1),   //fetche gidecek         
            .execute_out_imm_plus_pc_or_rs1(EX_MEM_imm_plus_pc_or_rs1),
            .execute_out_aluOut(EX_MEM_aluOut),
            .execute_out_instr(EX_MEM_instr), //memorye func3 olarak girecek
            .execute_out_flush(flush), // fetchteki pcnin onundeki mux'a ve ID/EX registerina gider (register'a girmez)
            
            .execute_out_pc_plus_four(EX_MEM_pc_plus_four),
            
            .execute_out_memRead_to_decode(EX_ID_memRead), //decode'daki hazard unit'e gidecek
            
            .execute_out_rd_to_decode(EX_ID_rd)
            
            
            
            
    );
    
    
    memory memoryStage(.clk(clk),
           .memory_in_regWrite(EX_MEM_regWrite),
           .memory_in_memtoReg(EX_MEM_memtoReg),
           .memory_in_memWrite(EX_MEM_memWrite),
           .memory_in_memRead(EX_MEM_memRead),
           
           .memory_in_imm_plus_pc_or_rs1(EX_MEM_imm_plus_pc_or_rs1),
           
           .memory_in_aluOut(EX_MEM_aluOut),
           
           .memory_in_instr(EX_MEM_instr),
           
           .memory_in_data2(EX_MEM_data2),
           
           .memory_in_rd(EX_MEM_rd),
           
           .memory_in_immediate(EX_MEM_imm),
           
           .memory_in_pc_plus_four(EX_MEM_pc_plus_four),
           
           .memory_out_regWrite(MEM_WB_regWrite),
           .memory_out_memtoReg(MEM_WB_memtoReg),
           
           .memory_out_aluOut(MEM_WB_aluOut),
           
           //.memory_out_instr(MEM_WB_instr),
           
           .memory_out_dataMemOut(MEM_WB_dataMemOut),
           
           .memory_out_rd(MEM_WB_rd),
           
           .memory_out_imm_plus_pc_or_rs1(MEM_WB_imm_plus_pc_or_rs1),
           
           .memory_out_immediate(MEM_WB_imm),
           
           .memory_out_pc_plus_four(MEM_WB_pc_plus_four),
           
           .memory_out_rd_to_execute(MEM_EX_rd), // executedak, forwardinge gidecek
           .memory_out_regWrite_to_execute(MEM_EX_regWrite), // executedak, forwardinge gidecek
           .memory_out_aluOut_to_execute(MEM_EX_aluOut), // executedak, forwardinge gidecek
           
           .memory_out_memtoReg_to_execute(MEM_EX_memtoReg),
           
           .memory_out_immediate_to_execute(MEM_EX_immediate),
           .memory_out_imm_plus_pc_or_rs1_to_execute(MEM_EX_imm_plus_pc_or_rs1),
           .memory_out_pc_plus_four_to_execute(MEM_EX_pc_plus_four),
           
           .memory_out_memRead_to_execute(MEM_EX_memRead),
           .memory_out_dataMemOut_to_execute(MEM_EX_dataMemOut),
           
           .memory_out_memRead(MEM_WB_memRead),
           
           .memory_out_instr(MEM_WB_instr)
    );
    
    
    writeBack writeBackStage(.clk(clk),
               .writeBack_in_regWrite(MEM_WB_regWrite),
               .writeBack_in_memtoReg(MEM_WB_memtoReg),
               .writeBack_in_aluOut(MEM_WB_aluOut),
               .writeBack_in_dataMemOut(MEM_WB_dataMemOut),
               .writeBack_in_rd(MEM_WB_rd),
               .writeBack_in_imm_plus_pc_or_rs1(MEM_WB_imm_plus_pc_or_rs1),
               .writeBack_in_immediate(MEM_WB_imm),
               .writeBack_in_pc_plus_four(MEM_WB_pc_plus_four),
               
               .writeBack_in_memRead(MEM_WB_memRead),
               
               .writeBack_in_instr(MEM_WB_instr),
               
               .writeBack_out_regWrite(WB_EX_regWrite), // forwarda girecek
               .writeBack_out_rd(WB_EX_rd), //forward'a girecek
               .writeBack_out_aluOut(WB_EX_aluOut),
               .writeBack_out_writeData(WB_ID_write_data), // nihai sonuc
                
                .writeBack_out_regWrite_to_decode(WB_ID_regWrite),
                
                .writeBack_out_rd_to_decode(WB_ID_rd),
                
                .writeBack_out_memtoReg_to_execute(WB_EX_memtoReg),
                
                .writeBack_out_immediate_to_execute(WB_EX_immediate),
                .writeBack_out_imm_plus_pc_or_rs1_to_execute(WB_EX_imm_plus_pc_or_rs1),
                .writeBack_out_pc_plus_four_to_execute(WB_EX_pc_plus_four),
                
                
                .writeBack_out_memRead_to_execute(WB_EX_memRead),
                
                .writeBack_out_dataMememOut_to_execute(WB_EX_dataMemOut)
    );
    
    
    always @(posedge clk) begin
        $display("%h (%0t)", MEM_WB_instr, $time);
    end
    
    
endmodule
