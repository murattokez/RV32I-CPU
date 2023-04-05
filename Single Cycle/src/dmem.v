`timescale 1ns / 1ps


module dmem(address,data_in,func3,clk,wr_en,rd_en,data_out);

input [31:0] address;
input [31:0] data_in;
input [2:0] func3; // func3
input clk,wr_en,rd_en;
output  [31:0] data_out;


reg [31:0] memory [2056:0];

reg [31:0] data_out_before_extend;

//assign data_out=(rd_en==1) ? memory[address]:0 ;


always @(posedge clk) begin
if(wr_en) begin
    case(func3)
        3'b010:
            memory[address]<=data_in; //sw
        
        3'b001:
            memory[address]<=data_in[15:0]; //sh
            
        3'b000:
            memory[address]<=data_in[7:0]; // sb address=rs1+imm
        
        
        
    
    endcase
end

end

always @* begin

if(rd_en) begin
    case(func3)
        3'b010:
            data_out_before_extend=memory[address]; //lw
            
        3'b001: begin
            //data_out_before_extend=memory[address][15:0]; //lh //bir sonraki adrese gectiði icin ayný adreste okuma yapmak icin +2 ile toplanýr
            data_out_before_extend=memory[address][15:0];
            end
            
        3'b000:
            data_out_before_extend=memory[address][7:0]; // lb address=rs1+imm
        
        
        
    
    endcase
end



end


sign_extend_datamem extend(data_out_before_extend,func3,data_out);






endmodule
