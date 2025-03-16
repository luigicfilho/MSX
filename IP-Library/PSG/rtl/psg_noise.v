// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : psg_noise.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, changes in 
//										Pseudo-noise generation, 100% same in 
//										the AY-3-8910 IC, only available in IP
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PSG, GI AY-3-8910 Modified, Noise 
// ----------------------------------------------------------------------------
// PURPOSE : GI AY-3-8910 PSG noise for MSX 
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

module psg_noise (
	clk16,
	rst_n,
	noise_reg,
	noisef
);

input clk16;
input rst_n;
input [4:0]noise_reg;
output noisef;

reg [4:0]noisecnt;
reg noi;

reg [16:0]shifreg;

assign noisef = shifreg[0];

always @(posedge clk16 or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   noisecnt <= 5'd0;
   noi <= 1'b0;
  end
 else
  begin
   if (noisecnt == noise_reg) 
    begin
     noisecnt <= 5'd0;
     noi <= ~noi;
    end
   else
    begin
     noisecnt <= noisecnt + 5'd1;
    end
  end 
end

always @(posedge noi or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   shifreg <= 17'b0;
  end
 else
  begin
   shifreg <= shifreg >> 1;
   shifreg[16] <= shifreg[0] ^ shifreg[4];
  end
end

endmodule
