`timescale 1ns / 1ps


module pc(clk,pc,pc_next);

input clk;
input [31:0] pc;
output reg [31:0] pc_next=32'h00400000;

always @(posedge clk) begin

    pc_next<=pc;


end


endmodule
