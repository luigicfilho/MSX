// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : lcz80_alu.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-10-02 	Luigi C. Filho	Initial Version
// 1.1		2025-17-03	Luigi C. Filho	Remove coments, change names
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, MSX, Zilog Z80, Alu 
// ----------------------------------------------------------------------------
// PURPOSE : Zilog Z80 Processor Alu 
// ----------------------------------------------------------------------------
//  Redistribution and use of this RTL or any derivative works, are NOT
//  permitted.
//
//  A distribuição e uso deste RTL ou qualquer trabalho derivatido NÃO é
//  permitido.
//
//  THIS RTL IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
//  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
//  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
//  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ----------------------------------------------------------------------------

module lcz80_alu (
  Q, 
  F_Out, 
  Arith16, 
  Z16, 
  ALU_Op, 
  IR, 
  ISet, 
  BusA, 
  BusB, 
  F_In
);

input 		  Arith16;
input 		  Z16;
input  [3:0]  ALU_Op;
input  [5:0]  IR;
input  [1:0]  ISet;
input  [7:0]  BusA;
input  [7:0]  BusB;
input  [7:0]  F_In;
output [7:0]  Q;
output [7:0]  F_Out;

reg [7:0]     Q;
reg [7:0]     F_Out;

function [4:0] AddSub4;
input [3:0] A;
input [3:0] B;
input Sub;
input Carry_In;
begin
  AddSub4 = { 1'b0, A } + { 1'b0, (Sub)?~B:B } + {4'h0,Carry_In};
end
endfunction
  
function [3:0] AddSub3;
input [2:0] A;
input [2:0] B;
input Sub;
input Carry_In;
begin
  AddSub3 = { 1'b0, A } + { 1'b0, (Sub)?~B:B } + {3'h0,Carry_In};
end
endfunction

function [1:0] AddSub1;
input A;
input B;
input Sub;
input Carry_In;
begin
  AddSub1 = { 1'b0, A } + { 1'b0, (Sub)?~B:B } + {1'h0,Carry_In};
end
endfunction

reg UseCarry;
reg Carry7_v;
reg OverFlow_v;
reg HalfCarry_v;
reg Carry_v;
reg [7:0] Q_v;
reg [7:0] BitMask;
  
always @(ALU_Op or BusA or BusB or F_In or IR)
begin
	case (IR[5:3])
		3'b000 : BitMask = 8'b00000001;
		3'b001 : BitMask = 8'b00000010;
		3'b010 : BitMask = 8'b00000100; 
		3'b011 : BitMask = 8'b00001000; 
		3'b100 : BitMask = 8'b00010000; 
		3'b101 : BitMask = 8'b00100000; 
		3'b110 : BitMask = 8'b01000000; 
		default: BitMask = 8'b10000000; 
	endcase

	UseCarry = ~ ALU_Op[2] && ALU_Op[0];
	{ HalfCarry_v, Q_v[3:0] } = AddSub4(BusA[3:0], BusB[3:0], ALU_Op[1], ALU_Op[1] ^ (UseCarry && F_In[0]) );
	{ Carry7_v, Q_v[6:4]  } = AddSub3(BusA[6:4], BusB[6:4], ALU_Op[1], HalfCarry_v);
	{ Carry_v, Q_v[7] } = AddSub1(BusA[7], BusB[7], ALU_Op[1], Carry7_v);
	OverFlow_v = Carry_v ^ Carry7_v;
end

reg [7:0] Q_t;
reg [8:0] DAA_Q;
  
always @ (ALU_Op or Arith16 or BitMask or BusA or BusB
	or Carry_v or F_In or HalfCarry_v or IR or ISet
	or OverFlow_v or Q_v or Z16)
begin
  Q_t = 8'hxx;
  DAA_Q = {9{1'bx}}; 
  F_Out = F_In;
  
	case (ALU_Op)
		4'b0000, 4'b0001,  4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111 :
		begin
			F_Out[1] = 1'b0;
			F_Out[0] = 1'b0;
			
			case (ALU_Op[2:0])
				3'b000, 3'b001 : // ADD, ADC
				begin
					Q_t = Q_v;
					F_Out[0] = Carry_v;
					F_Out[4] = HalfCarry_v;
					F_Out[2] = OverFlow_v;
				end
				3'b010, 3'b011, 3'b111 : // SUB, SBC, CP
				begin
					Q_t = Q_v;
					F_Out[1] = 1'b1;
					F_Out[0] = ~ Carry_v;
					F_Out[4] = ~ HalfCarry_v;
					F_Out[2] = OverFlow_v;
				end
				3'b100 : // AND
				begin
					Q_t[7:0] = BusA & BusB;
					F_Out[4] = 1'b1;
				end
				3'b101 : // XOR
				begin
					Q_t[7:0] = BusA ^ BusB;
					F_Out[4] = 1'b0;
				end
				default : // OR 3'b110
				begin
					Q_t[7:0] = BusA | BusB;
					F_Out[4] = 1'b0;
				end  
			endcase 
		
		if (ALU_Op[2:0] == 3'b111 ) 
			begin // CP
				F_Out[3] = BusB[3];
				F_Out[5] = BusB[5];
			end 
		else 
			begin
				F_Out[3] = Q_t[3];
				F_Out[5] = Q_t[5];
			end

		if (Q_t[7:0] == 8'b00000000 ) 
			begin
				F_Out[6] = 1'b1;
				if (Z16 == 1'b1 ) 
					begin
						F_Out[6] = F_In[6];	// 16 bit ADC,SBC
					end
			end 
		else 
			begin
				F_Out[6] = 1'b0;
			end 
				
		F_Out[7] = Q_t[7];
		case (ALU_Op[2:0])
			3'b000, 3'b001, 3'b010, 3'b011, 3'b111 : ;// ADD, ADC, SUB, SBC, CP ;
			default :
				F_Out[2] = ~(^Q_t);                    
		endcase
		
		if (Arith16 == 1'b1 ) 
			begin
				F_Out[7] = F_In[7];
				F_Out[6] = F_In[6];
				F_Out[2] = F_In[2];
			end
		end // case: 4'b0000, 4'b0001,  4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111
		4'b1100 :
		begin
			// DAA
			F_Out[4] = F_In[4];
			F_Out[0] = F_In[0];
			DAA_Q[7:0] = BusA;
			DAA_Q[8] = 1'b0;
			if (F_In[1] == 1'b0 ) 
				begin
				// After addition
				// Alow > 9 || H == 1
				if (DAA_Q[3:0] > 9 || F_In[4] == 1'b1 ) 
					begin
						if ((DAA_Q[3:0] > 9) ) 
							begin
								F_Out[4] = 1'b1;
							end 
						else 
							begin
								F_Out[4] = 1'b0;
							end
					DAA_Q = DAA_Q + 6;
					end
			
				// new Ahigh > 9 || C == 1
				if (DAA_Q[8:4] > 9 || F_In[0] == 1'b1 ) 
					begin
						DAA_Q = DAA_Q + 96; // 0x60
					end
				end 
			else 
				begin
					// After subtraction
					if (DAA_Q[3:0] > 9 || F_In[4] == 1'b1 ) 
						begin
							if (DAA_Q[3:0] > 5 ) 
								begin
									F_Out[4] = 1'b0;
								end
							DAA_Q[7:0] = DAA_Q[7:0] - 6;
						end
					if (BusA > 153 || F_In[0] == 1'b1 ) 
						begin
							DAA_Q = DAA_Q - 352; // 0x160
						end
				end
				
			F_Out[3] = DAA_Q[3];
			F_Out[5] = DAA_Q[5];
			F_Out[0] = F_In[0] || DAA_Q[8];
			Q_t = DAA_Q[7:0];
		
			if (DAA_Q[7:0] == 8'b00000000 ) 
				begin
					F_Out[6] = 1'b1;
				end 
			else 
				begin
					F_Out[6] = 1'b0;
				end
		
			F_Out[7] = DAA_Q[7];
			F_Out[2] = ~ (^DAA_Q);
		end
		4'b1101, 4'b1110 :
		begin
			// RLD, RRD
			Q_t[7:4] = BusA[7:4];
			if (ALU_Op[0] == 1'b1 ) 
				begin
					Q_t[3:0] = BusB[7:4];
				end 
			else 
				begin
					Q_t[3:0] = BusB[3:0];
				end
			F_Out[4] = 1'b0;
			F_Out[1] = 1'b0;
			F_Out[3] = Q_t[3];
			F_Out[5] = Q_t[5];
			if (Q_t[7:0] == 8'b00000000 ) 
				begin
					F_Out[6] = 1'b1;
				end 
			else 
				begin
					F_Out[6] = 1'b0;
				end
			F_Out[7] = Q_t[7];
			F_Out[2] = ~(^Q_t);
		end
		4'b1001 :
		begin
			// BIT
			Q_t[7:0] = BusB & BitMask;
			F_Out[7] = Q_t[7];
			if (Q_t[7:0] == 8'b00000000 ) 
				begin
					F_Out[6] = 1'b1;
					F_Out[2] = 1'b1;
				end 
			else 
				begin
					F_Out[6] = 1'b0;
					F_Out[2] = 1'b0;
				end
			F_Out[4] = 1'b1;
			F_Out[1] = 1'b0;
			F_Out[3] = 1'b0;
			F_Out[5] = 1'b0;
			if (IR[2:0] != 3'b110 ) 
				begin
					F_Out[3] = BusB[3];
					F_Out[5] = BusB[5];
				end
		end	
		4'b1010 :
			// SET
			Q_t[7:0] = BusB | BitMask;
		4'b1011 :
			// RES
			Q_t[7:0] = BusB & ~ BitMask;	
		4'b1000 :
		begin
			// ROT
			case (IR[5:3])
				3'b000 : // RLC
				begin
					Q_t[7:1] = BusA[6:0];
					Q_t[0] = BusA[7];
					F_Out[0] = BusA[7];
				end
				3'b010 : // RL
				begin
					Q_t[7:1] = BusA[6:0];
					Q_t[0] = F_In[0];
					F_Out[0] = BusA[7];
				end  
				3'b001 : // RRC
				begin
					Q_t[6:0] = BusA[7:1];
					Q_t[7] = BusA[0];
					F_Out[0] = BusA[0];
				end 
				3'b011 : // RR
				begin                        
					Q_t[6:0] = BusA[7:1];
					Q_t[7] = F_In[0];
					F_Out[0] = BusA[0];
				end
				3'b100 : // SLA
				begin
					Q_t[7:1] = BusA[6:0];
					Q_t[0] = 1'b0;
					F_Out[0] = BusA[7];
				end  
				3'b110 : // SLL (Undocumented) / SWAP
				begin
					Q_t[7:1] = BusA[6:0];
					Q_t[0] = 1'b1;
					F_Out[0] = BusA[7];
				end // case: 3'b110  
				3'b101 : // SRA
				begin
					Q_t[6:0] = BusA[7:1];
					Q_t[7] = BusA[7];
					F_Out[0] = BusA[0];
				end
				default : // SRL
				begin
					Q_t[6:0] = BusA[7:1];
					Q_t[7] = 1'b0;
					F_Out[0] = BusA[0];
				end
			endcase // case(IR[5:3])
				
			F_Out[4] = 1'b0;
			F_Out[1] = 1'b0;
			F_Out[3] = Q_t[3];
			F_Out[5] = Q_t[5];
			F_Out[7] = Q_t[7];
			if (Q_t[7:0] == 8'b00000000 ) 
				begin
					F_Out[6] = 1'b1;
				end 
			else 
				begin
					F_Out[6] = 1'b0;
				end
			F_Out[2] = ~(^Q_t);

			if (ISet == 2'b00 ) 
				begin
					F_Out[2] = F_In[2];
					F_Out[7] = F_In[7];
					F_Out[6] = F_In[6];
				end
		end   
		default : ;  
	endcase  
	Q = Q_t;
end
  
endmodule
