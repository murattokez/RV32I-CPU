`timescale 1ns / 1ps

module sign_extend_datamem(
    input [31:0] data_mem_out,
    input [2:0] func3,
    output reg [31:0] extended_data_mem_out

    );
    
    
    always @* begin
    case(func3)
        3'b001: extended_data_mem_out = {{16{data_mem_out[31]}},data_mem_out[30:16]}; //lh
        3'b000: extended_data_mem_out = {{24{data_mem_out[7]}},data_mem_out[6:0]}; //lb
        3'b010: extended_data_mem_out =data_mem_out; //lw
        3'b100: extended_data_mem_out = {{23{1'b0}},data_mem_out[7:0]}; //lbu
        3'b101: extended_data_mem_out = {{15{1'b0}},data_mem_out[15:0]};  //lhu
        
        default: extended_data_mem_out =data_mem_out;
    endcase


end


    
    
    
    
    
    
    
endmodule
