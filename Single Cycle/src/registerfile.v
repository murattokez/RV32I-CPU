`timescale 1ns / 1ps


module registerfile(rs1,rs2,rd,wr_data,wr_en,clk,r1_data,r2_data,out);

input [4:0] rs1,rs2,rd;
input [31:0] wr_data; //data memoryden gelen sonuc
input wr_en,clk;
output [31:0] r1_data,r2_data;
output  [31:0] out;

assign out=wr_data; // cpu'dan cikis almak icin


reg [31:0] regs [31:0]; //32 tane 32 bitlik register

integer i;

initial begin
for(i=0;i<32;i=i+1) begin

regs[i]=0;
end
/*regs[0]=0;
regs[1]=0;
regs[2]=32'h7fffeffc;
regs[3]=32'h10008000;*/

end

always @(posedge clk) begin

if(wr_en) begin
    regs[rd]<=wr_data; // yazma write back
end


regs[0]<=0; //x0 hep 0
end

assign r1_data=regs[rs1]; //okuma 
assign r2_data=regs[rs2];



endmodule
