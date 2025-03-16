// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : scc_channel.v
// AUTHOR 	      : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-10-02 	Luigi C. Filho	Initial Version
// 1.1		2016-09-05	Luigi C. Filho	Comments translated to english
// 1.2		2025-16-03	Luigi C. Filho	Remove coments, change names
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, Konami SCC, Channel
// ----------------------------------------------------------------------------
// PURPOSE : MSX Channel for Konami SCC
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

module scc_channel (
	clk,
	rst_n,
	freq_reg,
	wave_addr
);

input clk;
input rst_n;
input [11:0]freq_reg;
output [4:0]wave_addr;

reg [4:0]wave_addr;
reg [15:0]cnt;
reg tone;
reg [4:0]cntw;

always @(posedge clk or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   cnt <= 12'd0;
   tone <= 1'b0;
  end
 else
  begin
   if (cnt == freq_reg) 
    begin
     cnt <= 12'd0;
     tone <= ~tone;
    end
   else
    begin
     cnt <= cnt + 12'd1;
    end
  end 
end

always @(posedge tone or negedge rst_n)
begin
  if (rst_n == 1'b0)
   begin
    cntw <= 5'd0;
   end
  else
   begin
    if (cntw == 5'd31)
     cntw <= 5'd0;
    else
     cntw <= cntw + 5'd1;
   end
end   

always @(cntw)
begin
	wave_addr = cntw;
end
   
endmodule 
