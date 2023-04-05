`timescale 1ns / 1ps

module Imem(pc,instr);

input [19:0] pc; //normalde 31di ama pc yi 0x0040000 den basltamk icin bit düsürüldü
output [31:0] instr;


reg [31:0] memory [0:256];

assign instr = memory[pc];

integer i;

/*initial begin
    for(i=0;i<31;i=i+1) 
        memory[i]=0;


end*/


initial begin

/*memory[0]=32'h00100313; //addi x6=x0+1 =1 calisti
memory[1]=32'b000000010010_00011_000_01000_1100111; // jalr x8 x3 18 calisti
//memory[2]=32'b0100000_00010_00001_100_00001_1100011; // blt calisti
memory[5]=32'b00000000000000000111_11000_0110111; // lui calisti
memory[6]=32'b00000000000000011111_11000_0010111;
memory[7]=32'b0000001_00100_00011_010_10010_0100011; //sw
memory[8]=32'b000000110010_00100_010_00011_0000011; //lw x3 x12 18
memory[9]=32'b0000011_00011_00011_001_10010_0100011; //sh
memory[10]=32'b000001110010_00011_001_00011_0000011; //lh*/


$readmemh("hex_memory_file.mem",memory);




end
    
    
    
    
endmodule
