`timescale 1ns / 1ps


module control_unit(instr,func3,branch,memRead,memtoReg,aluOp,memWrite,aluSrc,regWrite,jalr,jump,bne,blt,bge,bltu,bgeu);


input [6:0] instr; //instr opcode
input [2:0] func3; // opcode'larý ayný olanlarý ayýrmak icin
output reg branch;
output reg memRead;
output reg [2:0] memtoReg;
output reg [1:0] aluOp;
output reg memWrite;
output reg aluSrc;
output reg regWrite;
output reg jalr;
output reg jump;
output reg bne,blt,bge,bltu,bgeu;

parameter R_format=7'b0110011, //add,sub,sll,slt,sltu,xor,srl,sra,or,and
          I_format=7'b0010011, //addi,slti,sltiu,xori,ori,andi,slli,srli,srai,
          LW=7'b0000011, // lb,lh,lbu,lhu,
          SW=7'b0100011, //sb,sh,
          BEQ=7'b1100011, //beq,bne,blt,bge,bltu,bgeu
          LUI=7'b0110111,
          AUIPC=7'b0010111,
          JAL=7'b1101111,
          JALR=7'b1100111;
          

          
  
    
always @* begin
    case(instr)
        R_format: begin
            aluSrc=0;
            memtoReg=3'b100;
            regWrite=1;
            memRead=0; //data memorye gerek oyk
            memWrite=0;
            branch=0;
            aluOp=2'b10;
            jalr=0;
            jump=0;
            bne=0; 
            blt=0; 
            bge=0; 
            bltu=0;
            bgeu=0;
            
        end
        
         I_format: begin
            aluSrc=1; //immediate
            memtoReg=3'b100;
            regWrite=1;
            memRead=0; //data memorye gerek oyk
            memWrite=0;
            branch=0;
            aluOp=2'b10;
            jalr=0;
            jump=0;
            bne=0;             
            blt=0;             
            bge=0;             
            bltu=0;            
            bgeu=0;            
            
        end
        
        LW: begin
            aluSrc=1;
            memtoReg=3'b000;
            regWrite=1;// REGÝSTERA YAZILACKA
            memRead=1; //MEMORYDEN OKUNACAK
            memWrite=0;
            branch=0;
            aluOp=2'b00;
            jalr=0;
            jump=0;
            bne=0;             
            blt=0;             
            bge=0;             
            bltu=0;            
            bgeu=0;            
            
        end

        SW: begin
            aluSrc=1;
            memtoReg=3'b000;
            regWrite=0;
            memRead=0;
            memWrite=1; // REGÝSTERDAN OKUNACAK MEMORYE YAZILACK
            branch=0;
            aluOp=2'b00;
            jalr=0;
            jump=0;
            bne=0; 
            blt=0; 
            bge=0; 
            bltu=0;
            bgeu=0;            
              
        end
        
        BEQ: begin
               
                case(func3)
                    3'b000: begin //beq
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=1; //beq
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=0; 
                         blt=0; 
                         bge=0; 
                         bltu=0;
                         bgeu=0;
                    end
                    
                    3'b001: begin //bne
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=0;
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=1;  
                         blt=0;  
                         bge=0;  
                         bltu=0; 
                         bgeu=0; 
                    end
                    3'b100: begin //blt
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=0;
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=0;  
                         blt=1;  
                         bge=0;  
                         bltu=0; 
                         bgeu=0; 
                    end
                    3'b101: begin //bge
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=0;
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=0;  
                         blt=0;  
                         bge=1;  
                         bltu=0; 
                         bgeu=0; 
                    end
                    3'b110: begin //bltu
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=0;
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=0;  
                         blt=0;  
                         bge=0;  
                         bltu=1; 
                         bgeu=0; 
                    end
                    3'b111: begin //bgeu
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=0;
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=0;  
                         blt=0;  
                         bge=0;  
                         bltu=0; 
                         bgeu=1; 
                    end
                    default: begin
                         aluSrc=0;
                         memtoReg=3'bxxx;
                         regWrite=0;
                         memRead=0;
                         memWrite=0;
                         branch=1; //beq
                         aluOp=2'b01;
                         jalr=0;
                         jump=0;
                         bne=0; 
                         blt=0; 
                         bge=0; 
                         bltu=0;
                         bgeu=0;
                    end
                endcase
            
        end
        
         LUI: begin
            aluSrc=1;
            memtoReg=3'b010;
            regWrite=1; //register file a yazýlacak yani 1
            memRead=0;
            memWrite=0;
            branch=0;
            aluOp=2'bxx;
            jalr=0;
            jump=0;
            bne=0;  
            blt=0;  
            bge=0;  
            bltu=0; 
            bgeu=0; 
            
        end
        
        AUIPC: begin
            aluSrc=1;
            memtoReg=3'b001;
            regWrite=1; //register file a yazýlacak yani 1
            memRead=0;
            memWrite=0;
            branch=0;
            aluOp=2'bxx;
            jalr=0;
            jump=0;
            bne=0;  
            blt=0;  
            bge=0;  
            bltu=0; 
            bgeu=0; 
            
        end
        
         JAL: begin
            aluSrc=1;
            memtoReg=3'b011;
            regWrite=1; //register file a yazýlacak yani 1
            memRead=0;
            memWrite=0;
            branch=0;
            aluOp=2'bxx;
            jalr=0;
            jump=1;
            bne=0;  
            blt=0;  
            bge=0;  
            bltu=0; 
            bgeu=0; 
            
        end
        
         JALR: begin
            aluSrc=1;
            memtoReg=3'b011;
            regWrite=1; //register file a yazýlacak yani 1
            memRead=0;
            memWrite=0;
            branch=0;
            aluOp=2'bxx;
            jalr=1;
            jump=1;
            bne=0;  
            blt=0;  
            bge=0;  
            bltu=0; 
            bgeu=0; 
            
        end

        default: begin
            aluSrc=0;
            memtoReg=3'b100;
            regWrite=1;
            memRead=0; //data memorye gerek oyk
            memWrite=0;
            branch=0;
            aluOp=2'b10;
            jalr=0;
            jump=0;
            bne=0; 
            blt=0; 
            bge=0; 
            bltu=0;
            bgeu=0;
            
        end

    endcase



end     
    
    
    
endmodule


//aludaki cýkarma islemi 0 cýkarsa ve branch aktif ise beq buyrugu calisir ve buyruktaki immediate degeri pc'ye gider ve +4 deðil +immediate kadar artatr.
