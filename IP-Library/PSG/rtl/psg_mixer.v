// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : psg_mixer.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, just doc change
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PSG, GI AY-3-8910 Modified, Mixer 
// ----------------------------------------------------------------------------
// PURPOSE : GI AY-3-8910 PSG Mixer for MSX 
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

module psg_mixer (
	tonea,
	toneb,
	tonec,
	noisei,
	mixe_reg,
	mixeda,
	mixedb,
	mixedc
);

input	tonea;
input	toneb;
input	tonec;
input	noisei;
input   [5:0]mixe_reg;
output	mixeda;
output	mixedb;
output	mixedc;

reg	mixeda;
reg	mixedb;
reg	mixedc;

// Mix Channel A
always @(mixe_reg[3], mixe_reg[0], tonea, noisei)
begin
 case({mixe_reg[3], mixe_reg[0]})
  2'b00 : mixeda = tonea + noisei;
  2'b01 : mixeda = noisei;
  2'b10 : mixeda = tonea;
  2'b11 : mixeda = 1'b0; 
 endcase
end

// Mix Channel B
always @(mixe_reg[4], mixe_reg[1], toneb, noisei)
begin
 case({mixe_reg[4], mixe_reg[1]})
  2'b00 : mixedb = toneb + noisei;
  2'b01 : mixedb = noisei;
  2'b10 : mixedb = toneb;
  2'b11 : mixedb = 1'b0; 
 endcase
end

// Mix Channel C
always @(mixe_reg[5], mixe_reg[2], tonec, noisei)
begin
 case({mixe_reg[5], mixe_reg[2]})
  2'b00 : mixedc = tonec + noisei;
  2'b01 : mixedc = noisei;
  2'b10 : mixedc = tonec;
  2'b11 : mixedc = 1'b0; 
 endcase
end

endmodule 
