`timescale 1ns / 1ps


module fetch(
    input clk,flush,
    input fetch_in_pcWrite,
    input fetch_in_IF_ID_write_en,
    input fetch_in_branch_or_jump, // pcnin branch,jump yapacagýný veya dirket +4 u alacagini secer flush
    input [31:0] fetch_in_imm_plus_pc_or_rs1,
    output [31:0] fetch_out_pc,
    output [31:0] fetch_out_instr,
    output [31:0] fetch_out_pc_plus_four
    
    );
    
    //aga burasý cok karisti
    wire [31:0] pc_in;
    
    wire [31:0] fetch_pc;
    
    wire [31:0] fetch_instr;
    
    wire [31:0] fetch_pc_plus_four;
    
    assign fetch_pc_plus_four = fetch_pc+4;
    
    
    
    assign pc_in = (fetch_in_branch_or_jump) ? fetch_in_imm_plus_pc_or_rs1 : fetch_pc_plus_four;
    
    
    
    pc pc0(.clk(clk),
           .pcWrite(fetch_in_pcWrite),
           .pc(pc_in),
           .pc_next(fetch_pc)
            );
    
    
    Imem instrmem(.pc(fetch_pc[21:2]), // program counterý 0x0040000 den baslatmak icin inetrusvtion memorye sadece bu bitler arasý gonderildiki instruction memoryde 1 2 3 diye gitsin
                  .instr(fetch_instr)
                  );
    
    
    
    
    IF_ID_register IF_ID_reg(
                    .flush(flush),
                   .enable(fetch_in_IF_ID_write_en),
                   .clk(clk),
                   .fetch_pc(fetch_pc),        
                   .fetch_instr(fetch_instr),
                   .fetch_pc_plus_four(fetch_pc_plus_four),     
                   .decode_pc(fetch_out_pc),  
                   .decode_instr(fetch_out_instr),
                   .decode_pc_plus_four(fetch_out_pc_plus_four)
                    );
    
    
    
    
    
    
endmodule
