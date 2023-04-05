`timescale 1ns / 1ps

module cpu(
    input clk,
    output [31:0] reg_file_out


);



wire [31:0] pc_in;
wire [31:0] pc_out;

wire [31:0] pcPlusFour;

wire [31:0] instr;




wire branch;        //kontrol sinyalleri  
wire memRead;       
wire [2:0] memtoReg;
wire [1:0] aluOp;   
wire memWrite;      
wire aluSrc;        
wire regWrite;      
wire jalr;     
wire jump;
wire beq; // branch & zero     

wire [31:0] r1_data,r2_data; // reg filedan cikan
wire [31:0] write_data; // register filea write backte yazýlan osnuc

wire [31:0] extend_imm_value;

wire [31:0] alu_in1,alu_in2;

wire [3:0] alu_select; // alunun selecti

wire zero_flag,blt_flag,bge_flag,bltu_flag,bgeu_flag; //alu bayraklari
wire bne,blt,bge,bltu,bgeu; // control unit branch

wire [31:0] alu_out;

wire [31:0] data_memory_out;

wire [31:0] jalr_wire;

wire [31:0] imm_plus_pc_or_rs1;

pc pc0(.clk(clk),
       .pc(pc_in),
       .pc_next(pc_out)
        );

assign pcPlusFour=pc_out+4;

Imem imem(.pc(pc_out[21:2]), // program counterý 0x0040000 den baslatmak icin inetrusvtion memorye sadece bu bitler arasý gonderildiki instruction memoryde 1 2 3 diye gitsin
     .instr(instr)
     );


registerfile regfile(.rs1(instr[19:15]),
             .rs2(instr[24:20]),
             .rd(instr[11:7]),
             .wr_data(write_data),
             .wr_en(regWrite),
             .clk(clk),
             .r1_data(r1_data),
             .r2_data(r2_data),
             .out(reg_file_out)
             );
             
 imm immediate(.Instruction(instr[31:0]),
    .Imm(extend_imm_value)
     );
     
assign alu_in1 = r1_data;     
assign alu_in2 = (aluSrc) ? extend_imm_value : r2_data;

aluControl alucntrl(.instr(instr[31:0]),
           .aluOp(aluOp),
           .alu_select(alu_select)
           );

alu eyalu( .A(alu_in1),
           .B(alu_in2),
           .g_sel(alu_select),
           .zero(zero_flag),
           .blt(blt_flag),
           .bge(bge_flag),
           .bltu(bltu_flag),
           .bgeu(bgeu_flag),
           .f_out(alu_out)
           );              
           
 
dmem datamem(.address(alu_out),
             .data_in(r2_data),
             .func3(instr[14:12]),
             .clk(clk),
             .wr_en(memWrite),
             .rd_en(memRead),
             .data_out(data_memory_out)
             );
             
             
assign write_data= (memtoReg==0) ? data_memory_out :
                   (memtoReg==1) ? imm_plus_pc_or_rs1:
                   (memtoReg==2) ? extend_imm_value:
                   (memtoReg==3) ? pcPlusFour:
                   (memtoReg==4) ? alu_out : 0 ; 


control_unit cu(.instr(instr[6:0]),
                .func3(instr[14:12]),
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

assign jalr_wire = jalr ? r1_data: pc_out; // jalr gelirse immediate pc ile deðil r1 ile toplanýcak

assign imm_plus_pc_or_rs1 = extend_imm_value+ jalr_wire; 

//assign beq=(branch & zero);

wire branchOrjump;

assign branchOrjump=(branch & zero_flag)|(bne & !zero_flag)|(blt & blt_flag)|(bge & bge_flag)|(bltu & bltu_flag)|(bgeu & bgeu_flag)|jump;

assign pc_in= branchOrjump ? imm_plus_pc_or_rs1 : pcPlusFour;





endmodule
