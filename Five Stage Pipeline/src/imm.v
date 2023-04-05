`timescale 1ns / 1ps

module imm(Instruction,Imm);

input [31:0] Instruction;
//input [2:0] op;
output reg [31:0] Imm;

parameter op_arithmetic_I=7'b0010011, //I
          op_store=7'b0100011, //S
          op_cond_branch=7'b1100011, //SB
          op_uncond_jump=7'b1101111, //UJ
          op_load_upper_imm_lui=7'b0110111, //U
          op_load_upper_imm_auipc=7'b0010111;
          

wire [6:0] op;

assign op = Instruction[6:0];


always @* begin
    case(op)
        op_arithmetic_I: Imm = {{21{Instruction[31]}},Instruction[30:25],Instruction[24:21],Instruction[20]}; //koffman sy 274, riscv spec sy 17
        op_store: Imm={{21{Instruction[31]}},Instruction[30:25],Instruction[11:8],Instruction[7]};
        op_cond_branch: Imm={{20{Instruction[31]}},Instruction[7],Instruction[30:25],Instruction[11:8],1'b0}; // duzeltildil
        op_uncond_jump: Imm={{12{Instruction[31]}},Instruction[19:12],Instruction[20],Instruction[30:25],Instruction[24:21],1'b0};
        op_load_upper_imm_lui: Imm={Instruction[31],Instruction[30:20],Instruction[19:12],12'b0};
        op_load_upper_imm_auipc: Imm={Instruction[31],Instruction[30:20],Instruction[19:12],12'b0};
        default: Imm = {{21{Instruction[31]}},Instruction[30:25],Instruction[24:21],Instruction[20]};
    endcase


end





endmodule


//sonuc register'ý register file'a giderken ya data memoryden gider ya da aludan direkt gider. data mmeoryden gittiði zamanlar lw,stor egibi buyruklar geldðindedir.