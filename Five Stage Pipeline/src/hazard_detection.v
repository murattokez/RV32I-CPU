`timescale 1ns / 1ps

module hazard_detection(IF_ID_rs1,IF_ID_rs2,ID_EX_rd,ID_EX_memRead,pcWrite_en,IF_ID_write_en,ID_EX_controlValues_select);



input [4:0] IF_ID_rs1;
input [4:0] IF_ID_rs2;
input [4:0] ID_EX_rd;
input ID_EX_memRead;
output reg pcWrite_en;
output reg IF_ID_write_en;
output reg ID_EX_controlValues_select; 
    
    
always @* begin
    if(ID_EX_memRead&&(( IF_ID_rs1==ID_EX_rd)|| (IF_ID_rs2==ID_EX_rd) )) begin // ld buydugu geldiginde ve ex'teki rd ile decoddaki rs1 veya rs2 esit oldugunda
        pcWrite_en=0;
        IF_ID_write_en=0;
        ID_EX_controlValues_select=1; // contorl sinyallerini gecirme        
    end
        
    else begin
        pcWrite_en=1;                
        IF_ID_write_en=1;            
        ID_EX_controlValues_select=0; // contorl sinyallerini gecir 
    
        
    end


end    
    
    
    
    
endmodule
