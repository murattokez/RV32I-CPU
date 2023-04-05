`timescale 1ns / 1ps

module Imem(pc,instr);

input [19:0] pc; //normalde 31di ama pc yi 0x0040000 den basltamk icin bit düsürüldü
output [31:0] instr;


reg [31:0] memory [0:256];

assign instr = memory[pc];


initial begin



$readmemh("hex_memory_file.mem",memory);




end
    
    
    
    
endmodule
