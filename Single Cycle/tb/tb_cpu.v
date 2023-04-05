`timescale 1ns / 1ps



module tb_cpu();




reg clk;
wire [31:0] reg_file_out;

cpu cpu(clk,reg_file_out);

always #10 clk=~clk;

initial begin

clk=0;

end



endmodule
