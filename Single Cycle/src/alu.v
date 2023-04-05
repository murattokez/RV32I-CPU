`timescale 1ns / 1ps

module alu(A,B,g_sel,zero,blt,bge,bltu,bgeu,c,f_out);

input [31:0] A,B;
input [3:0] g_sel;
output zero,blt,bge,bltu,bgeu; // branch bayraklari !zero=bne
output reg c;
output reg [31:0] f_out=0;

parameter ADD = 4'b0000;
parameter SUB = 4'b0001;

parameter SLL = 4'b0010;
parameter SRL = 4'b0011;
parameter SRA = 4'b0100;

parameter XOR = 4'b0101;
parameter OR =  4'b0110;
parameter AND = 4'b0111;
parameter SLT = 4'b1000; 
parameter SLTU= 4'b1001;


wire [31:0] slt_out,sltu_out;
reg carry;
assign slt_out = $signed(A)<$signed(B) ? 1:0;
assign sltu_out = $unsigned(A)<$unsigned(B) ? 1:0;

always @* begin
    case(g_sel)
        ADD: {c,f_out} = $signed(A)+$signed(B);
        SUB: f_out= $signed(A)-$signed(B);
        SLL: f_out= A<<B;
        SRL: f_out= A>>B;
        SRA: f_out= A>>>B;
        XOR: f_out= A^B;
        OR: f_out=A|B;
        AND: f_out= A&B;
        SLT: f_out=slt_out;
        SLTU: f_out=sltu_out;
        
    endcase

end


assign zero = (A==B) ? 1:0; 
assign blt = ($signed(A)<$signed(B))? 1:0;
assign bge= ($signed(A)>=$signed(B))? 1:0;
assign bltu=($unsigned(A)<$unsigned(B))? 1:0;
assign bgeu=($unsigned(A)>=$unsigned(B))? 1:0;





endmodule
