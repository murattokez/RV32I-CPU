`timescale 1ns / 1ps


module pc(clk,pcWrite,pc,pc_next);

input clk,pcWrite;
input [31:0] pc;
output reg [31:0] pc_next=32'h00400000;

always @(posedge clk) begin
    if(pcWrite)
        pc_next<=pc;
    

end


endmodule
