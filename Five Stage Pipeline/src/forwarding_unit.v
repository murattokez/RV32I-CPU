`timescale 1ns / 1ps

module forwarding_unit(MEM_rd,MEM_regWrite,WB_rd,WB_regWrite,EX_rs1,EX_rs2,MEM_memtoReg,WB_memtoReg,MEM_memRead,WB_memRead,MuxA_select,MuxB_select);

input [4:0] MEM_rd;
input MEM_regWrite;
input [4:0] WB_rd;
input  WB_regWrite;
input [4:0] EX_rs1,EX_rs2;
input [2:0] MEM_memtoReg;
input [2:0] WB_memtoReg;
input MEM_memRead;
input WB_memRead;
output reg [3:0] MuxA_select,MuxB_select;


always @* begin
    if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs1)&&(MEM_memtoReg==3'b100)) MuxA_select=4'b0001; //aludan gecen instructiolar-wb
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs1)&&(WB_rd==EX_rs1)&&(WB_memtoReg==3'b100)) MuxA_select=4'b0010; //-mem
        else if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs1)&&(MEM_memtoReg==3'b011)) MuxA_select=4'b0011; //wbden gelen jal (pc plus four)
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs1)&&(WB_rd==EX_rs1)&&(WB_memtoReg==3'b011)) MuxA_select=4'b0100; //memden gelen jal
        else if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs1)&&(MEM_memtoReg==3'b010)) MuxA_select=4'b0101; //lui (imm)
     else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs1)&&(WB_rd==EX_rs1)&&(WB_memtoReg==3'b010)) MuxA_select=4'b0110; //memden gelen lui
    else if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs1)&&(MEM_memtoReg==3'b001)) MuxA_select=4'b0111; //auipc (imm plus pc or rs1)
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs1)&&(WB_rd==EX_rs1)&&(WB_memtoReg==3'b001)) MuxA_select=4'b1000; //memden gelen lui
    
    else if(WB_memRead && (WB_rd!=0) && (WB_rd==EX_rs1) ) MuxA_select=4'b1010; //stallarken ayný zamanda load instructionu icin memoryden cikan memout load instrdan sonra gelen instr'da kullanýlmak uzere forward edilir 
    
       // else if(MEM_memRead && (MEM_rd!=0) && (MEM_rd==EX_rs1) ) MuxA_select=4'b1010; //stallarken ayný zamanda load instructionu icin memoryden cikan memout load instrdan sonra gelen instr'da kullanýlmak uzere forward edilir 
           //else if(WB_regWrite && (WB_rd!=0) &&(MEM_rd!=EX_rs1)&& (WB_rd==EX_rs1)&&(WB_memtoReg==3'b000) ) MuxA_select=4'b1001; //stallarken ayný zamanda load instructionu icin memoryden cikan memout load instrdan sonra gelen instr'da kullanýlmak uzere forward edilir 

    
   // else if()
else 
        MuxA_select=0;

    
    
    
    if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs2)&&(MEM_memtoReg==3'b100)) MuxB_select=4'b0001;
    
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs2)&&(WB_rd==EX_rs2)&&(WB_memtoReg==3'b100)) MuxB_select=4'b0010;
    
    /*else if(!MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs1)&&(MEM_memtoReg==3'b100)) MuxA_select=4'b0001; //aludan gecen instructiolar-wb
    else if(!MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs2)&&(MEM_memtoReg==3'b100)) MuxB_select=4'b0001;
    else if(!WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs1)&&(WB_rd==EX_rs1)&&(WB_memtoReg==3'b100)) MuxB_select=4'b0010; //-mem
    else if(!WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs2)&&(WB_rd==EX_rs2)&&(WB_memtoReg==3'b100)) MuxB_select=4'b0010;*/
    
    else if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs2)&&(MEM_memtoReg==3'b011)) MuxB_select=4'b0011;
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs2)&&(WB_rd==EX_rs2)&&(WB_memtoReg==3'b011)) MuxB_select=4'b0100;
    
    else if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs2)&&(MEM_memtoReg==3'b010)) MuxB_select=4'b0101;
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs2)&&(WB_rd==EX_rs2)&&(WB_memtoReg==3'b010)) MuxB_select=4'b0110;
    
    else if(MEM_regWrite &&(MEM_rd!=0)&&(MEM_rd==EX_rs2)&&(MEM_memtoReg==3'b001)) MuxB_select=4'b0111;
    else if(WB_regWrite &&(WB_rd!=0)&&(MEM_rd!=EX_rs2)&&(WB_rd==EX_rs2)&&(WB_memtoReg==3'b001)) MuxB_select=4'b1001;
    
      //  else if(WB_memRead && (WB_rd!=0)&&(MEM_rd!=EX_rs2) && (WB_rd==EX_rs2) ) MuxB_select=4'b1001; //stallarken ayný zamanda load instructionu icin memoryden cikan memout load instrdan sonra gelen instr'da kullanýlmak uzere forward edilir 
       //     else if(MEM_memRead && (MEM_rd!=0) && (MEM_rd==EX_rs2) ) MuxB_select=4'b1010; //stallarken ayný zamanda load instructionu icin memoryden cikan memout load instrdan sonra gelen instr'da kullanýlmak uzere forward edilir 
   // else if(WB_regWrite && (WB_rd!=0) &&(MEM_rd!=EX_rs2)&& (WB_rd==EX_rs2)&&(WB_memtoReg==3'b000) ) MuxB_select=4'b1001; //stallarken ayný zamanda load instructionu icin memoryden cikan memout load instrdan sonra gelen instr'da kullanýlmak uzere forward edilir 
 else if(WB_memRead && (WB_rd!=0) && (WB_rd==EX_rs2) ) MuxB_select=4'b1010; 

    
    //stall icin mod
    
    else begin
    MuxB_select=0;
    
    end







end




















endmodule
