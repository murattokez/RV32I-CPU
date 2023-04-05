`timescale 1ns / 1ps

module tb_cpu();

    reg clk;
    wire [31:0] register_file_out;
    
    
    
    cpu dut0(.clk(clk),.register_file_out(register_file_out));
    
    
    always #5 clk=~clk;
    
    
    initial begin
    //$stop;
    clk=0;
    
    
    end








endmodule
