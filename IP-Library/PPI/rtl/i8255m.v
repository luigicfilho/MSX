// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : i8255m.v
// AUTHOR 	  	  : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, remove coments 
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PPI, Intel 8255 Modified
// ----------------------------------------------------------------------------
// PURPOSE : Intel 8255 PPI Modified for MSX 
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

module i8255m (
	clk,
	reset, 
	cs_n, 
	rd_n, 
	wr_n, 
	addr, 
	data_in,
	data_out, 
	porta, 
	portb, 
	portch, 
	portcl
   );

	input clk;
	input [7:0] data_in; 
	output [7:0] data_out; 
	input reset;
	input cs_n;
	input rd_n; 
	input wr_n; 
	input [1:0] addr; 
	output [7:0] porta;  
	input  [7:0] portb; 
	output [3:0] portch;
	output [3:0] portcl; 

reg [7:0] data_out;
reg [7:0] porta;
reg [3:0] portch;
reg [3:0] portcl;

always @(posedge clk or posedge reset)
begin
  if (reset == 1'b1)
   begin
    data_out <= 8'h00;
    porta <= 8'h00;
    {portch, portcl} <= 8'h00;
   end
  else
   begin
    if (cs_n == 1'b0)
     begin
      if (rd_n == 1'b0 && wr_n == 1'b1)
       begin
        case(addr)
         2'b00 : data_out = porta;
         2'b01 : data_out = portb;
         2'b10 : data_out = {portch, portcl};
         2'b11 : data_out = modereg;
        endcase
       end
      else if ( rd_n == 1'b1 && wr_n == 1'b0)
       begin
        case(addr)
         2'b00 : porta = data_in;
         2'b10 : {portch, portcl} = data_in;
         2'b11 : modereg = data_in;
        endcase
       end
     end
   end
end

endmodule
