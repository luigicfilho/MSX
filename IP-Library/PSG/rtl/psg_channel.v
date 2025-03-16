// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : psg_channel.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, remove coments 
//										change names to a generic 
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PSG, GI AY-3-8910 Modified, Channel
// ----------------------------------------------------------------------------
// PURPOSE : GI AY-3-8910 PSG Channel for MSX 
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


module psg_channel (
	clk16,
	rst_n,
	freqreg,
	volreg,
	e_reg,
	tone,
	vol
);

input	clk16;
input	rst_n;
input	[11:0]freqreg;
input	[4:0]volreg;
input	[3:0]e_reg;
output	tone;
output	[3:0]vol;

reg [11:0]cnt;
reg	tone;
reg	[3:0]vol;

always @(posedge clk16 or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   cnt <= 12'd0;
   tone <= 1'b0;
  end
 else
  begin
   if (cnt == freqreg) 
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

always @(volreg or e_reg)
begin
 if (volreg[4] == 1'b1)
   vol = e_reg;
 else
   vol = volreg[3:0];
end 

endmodule 
