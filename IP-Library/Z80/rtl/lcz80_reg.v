// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : lcz80_reg.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-10-02 	Luigi C. Filho	Initial Version
// 1.1		2025-17-03	Luigi C. Filho	Remove coments, change names
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, MSX, Zilog Z80, Registers 
// ----------------------------------------------------------------------------
// PURPOSE : Zilog Z80 Processor Registers 
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

module lcz80_reg (
	DOBH, 
	DOAL, 
	DOCL, 
	DOBL, 
	DOCH, 
	DOAH, 
	AddrC, 
	AddrA, 
	AddrB, 
	DIH, 
	DIL, 
	clk, 
	CEN, 
	WEH, 
	WEL
);

input  [2:0] AddrC;
output [7:0] DOBH;
input  [2:0] AddrA;
input  [2:0] AddrB;
input  [7:0] DIH;
output [7:0] DOAL;
output [7:0] DOCL;
input  [7:0] DIL;
output [7:0] DOBL;
output [7:0] DOCH;
output [7:0] DOAH;
input  clk, CEN, WEH, WEL;

reg [7:0] RegsH [0:7];
reg [7:0] RegsL [0:7];

always @(posedge clk)
begin
	if (CEN)
	begin
		if (WEH) RegsH[AddrA] <= DIH;
		if (WEL) RegsL[AddrA] <= DIL;
	end
end
          
assign DOAH = RegsH[AddrA];
assign DOAL = RegsL[AddrA];
assign DOBH = RegsH[AddrB];
assign DOBL = RegsL[AddrB];
assign DOCH = RegsH[AddrC];
assign DOCL = RegsL[AddrC];

wire [15:0] IX = { RegsH[3], RegsL[3] };
wire [15:0] IY = { RegsH[7], RegsL[7] };
  
endmodule
