`timescale 1ns / 1ps

module aluControl(instr,aluOp,alu_select);

input [31:0] instr;
input [1:0] aluOp;
output reg [3:0] alu_select;

parameter ADD = 4'b0000;
parameter SUB = 4'b0001;

parameter SLL = 4'b0010;
parameter SRL = 4'b0011;
parameter SRA = 4'b0100;

parameter XOR = 4'b0101;
parameter OR =  4'b0110;
parameter AND = 4'b0111;
parameter SLT = 4'b1000; 
parameter SLTU= 4'b1001;


wire [6:0] func7=instr[31:25];
wire [11:0] select_control={aluOp,instr[14:12],instr[6:0]}; //alu_op func 3 opcode[1:0]
    //func7 olmayan instructionlara xx koyulur
    always @* begin
        case(select_control)
            12'b00_010_0100011 :
                alu_select = ADD; //lw,sw desired instruction sw
            12'b00_001_0100011 :
                alu_select = ADD; //lw,sw  desired instruction    sh
            12'b00_000_0100011 :
                alu_select = ADD; //lw,sw  desired instruction    sb
                
            12'b00_000_0000011 :
                alu_select = ADD; //lw,sw desired instruction    lb
            12'b00_001_0000011 :
                alu_select = ADD; //lw,sw  desired instruction     lh
            12'b00_010_0000011 :
                alu_select = ADD; //lw,sw  desired instruction    lw
            12'b00_100_0000011 :
                alu_select = ADD; //lw,sw desired instruction lbu
            12'b00_101_0100011 :
                alu_select = ADD; //lw,sw  desired instruction    lhu
                        
            12'b01_000_1100011: 
                alu_select = SUB; // beq
            12'b01_001_1100011: 
                alu_select = SUB; // bne   
            12'b01_100_1100011: 
                alu_select = SUB; // blt     
            12'b01_101_1100011: 
                alu_select = SUB; // bge 
            12'b01_110_1100011: 
                alu_select = SUB; // bltu    
            12'b01_111_1100011: 
                alu_select = SUB; // bgeu    
               
                    
            12'b10_000_0110011: begin
                case(func7)
                    7'b0000000:
                        alu_select = ADD;
                    7'b0100000:
                        alu_select = SUB;
                
                endcase
            end
            12'b10_001_0110011:
                alu_select = SLL;
            12'b10_010_0110011:
                alu_select = SLT;
            12'b10_011_0110011:
                alu_select = SLTU; //sltu olarak guncellenecek
            12'b10_100_0110011:
                alu_select = XOR;
            12'b10_101_0110011: begin
                case(func7)
                    7'b0000000:
                        alu_select = SRL;
                    7'b0100000:
                        alu_select = SRA;
                endcase      
            end   
            12'b10_110_0110011:
                alu_select = OR;
            12'b10_111_0110011:
                alu_select = AND;    
                
            12'b10_000_0010011 : //addi
                alu_select = ADD;
            12'b10_010_0010011: //slti
                alu_select = SLT;
            12'b10_011_0010011: //sltiu eklenecek
                alu_select = SLTU;    
            12'b10_100_0010011: //xori
                alu_select = XOR;
            12'b10_110_0010011: //ori
                alu_select = OR;
            12'b10_111_0010011: //andi
                alu_select = AND; 
                
            12'b10_001_0010011: //slli
                alu_select = SLL;
                
            12'b10_101_0010011: begin //srli
                case(func7)
                    7'b0000000:
                        alu_select = SRL;
                    7'b0100000:
                        alu_select = SRA;
                
                endcase
            end    
                           
                
            
                   
                    
        endcase      
                
    
    
    
    
    
    
    
    
    end
    
    
    
    
    
    
    
endmodule
