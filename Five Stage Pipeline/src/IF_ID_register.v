`timescale 1ns / 1ps



module IF_ID_register(
    input enable,clk,flush,
    input [31:0] fetch_pc,
    input [31:0] fetch_instr,
    input [31:0] fetch_pc_plus_four,
    output reg [31:0] decode_pc=32'h00400000,
    output reg [31:0] decode_instr=0,
    output reg [31:0] decode_pc_plus_four=0


);

always @(posedge clk) begin
if(!flush) begin
    if(enable) begin
        decode_pc<=fetch_pc;
        decode_instr<=fetch_instr;
        decode_pc_plus_four<=fetch_pc_plus_four;

    end
    /*else begin
        decode_pc<=32'h00400000;
        decode_instr<=0;
        decode_pc_plus_four<=0;
    
    end*/

end
else begin
        decode_pc<=32'h00400000;
        decode_instr<=0;
        decode_pc_plus_four<=0;


end

end








endmodule
