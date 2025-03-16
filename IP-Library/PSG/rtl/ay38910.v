// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : ay38910.v
// AUTHOR 	      : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, remove coments 
// 										changes to use "d" variant, and top 
//										level name
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PSG, GI AY-3-8910 Modified with PWM DAC
// ----------------------------------------------------------------------------
// PURPOSE : GI AY-3-8910 PSG Modified for MSX with PWM DAC 
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


module ay38910 (
	clk,
	rst_n,
	ioa,
	iob,
	data,
	bc12,
	bdir,
	a8,
	a9_n,
	channela,
	channelb,
	channelc
);

input	clk;
input	rst_n;
inout	[7:0]ioa;
inout	[7:0]iob;
inout	[7:0]data;
input	[1:0]bc12;
input	bdir;
input	a8;
input	a9_n;
output	channela;
output	channelb;
output	channelc;

wire [7:0]dataout;

wire [7:0]ioaout;
wire [7:0]iobout;

wire [4:0]canal1;
wire [4:0]canal2;
wire [4:0]canal3;

wire [3:0]signal1;
wire [3:0]signal2;
wire [3:0]signal3;

reg [3:0]signald1;
reg [3:0]signald2;
reg [3:0]signald3;

wire [1:0]ioctl;

assign data = bdir ? 7'hZZ : dataout;
assign ioa = bdir ? 7'hZZ : ioaout;
assign iob = bdir ? 7'hZZ : iobout;

assign signal1 = canal1[4:1] * canal1[0];
assign signal2 = canal2[4:1] * canal2[0];
assign signal3 = canal3[4:1] * canal3[0];

always @(signal1)
begin
 case(signal1)
  4'd0  : signald1 = 4'b0000;
  4'd1  : signald1 = 4'b0000;
  4'd2  : signald1 = 4'b0000;
  4'd3  : signald1 = 4'b0000;
  4'd4  : signald1 = 4'b0000;
  4'd5  : signald1 = 4'b0001;
  4'd6  : signald1 = 4'b0001;
  4'd7  : signald1 = 4'b0001;
  4'd8  : signald1 = 4'b0001;
  4'd9  : signald1 = 4'b0010;
  4'd10 : signald1 = 4'b0011;
  4'd11 : signald1 = 4'b0100;
  4'd12 : signald1 = 4'b0110;
  4'd13 : signald1 = 4'b1000;
  4'd14 : signald1 = 4'b1011;
  4'd15 : signald1 = 4'b1111;
 endcase
end

always @(signal2)
begin
 case(signal2)
  4'd0  : signald2 = 4'b0000;
  4'd1  : signald2 = 4'b0000;
  4'd2  : signald2 = 4'b0000;
  4'd3  : signald2 = 4'b0000;
  4'd4  : signald2 = 4'b0000;
  4'd5  : signald2 = 4'b0001;
  4'd6  : signald2 = 4'b0001;
  4'd7  : signald2 = 4'b0001;
  4'd8  : signald2 = 4'b0001;
  4'd9  : signald2 = 4'b0010;
  4'd10 : signald2 = 4'b0011;
  4'd11 : signald2 = 4'b0100;
  4'd12 : signald2 = 4'b0110;
  4'd13 : signald2 = 4'b1000;
  4'd14 : signald2 = 4'b1011;
  4'd15 : signald2 = 4'b1111;
 endcase
end

always @(signal3)
begin
 case(signal3)
  4'd0  : signald3 = 4'b0000;
  4'd1  : signald3 = 4'b0000;
  4'd2  : signald3 = 4'b0000;
  4'd3  : signald3 = 4'b0000;
  4'd4  : signald3 = 4'b0000;
  4'd5  : signald3 = 4'b0001;
  4'd6  : signald3 = 4'b0001;
  4'd7  : signald3 = 4'b0001;
  4'd8  : signald3 = 4'b0001;
  4'd9  : signald3 = 4'b0010;
  4'd10 : signald3 = 4'b0011;
  4'd11 : signald3 = 4'b0100;
  4'd12 : signald3 = 4'b0110;
  4'd13 : signald3 = 4'b1000;
  4'd14 : signald3 = 4'b1011;
  4'd15 : signald3 = 4'b1111;
 endcase
end

ay38910d PSG (
	.clk(clk),
	.rst_n(rst_n),
	.ioa_in(ioa),
	.ioa_out(ioaout),
	.iob_in(iob),
	.iob_out(iobout),
	.data_in(data),
	.data_out(dataout),
	.bc12(bc12),
	.bdir(bdir),
	.a8(a8),
	.a9_n(a9_n),
	.channela(canal1),
	.channelb(canal2),
	.channelc(canal3)
);

pcm_pwm PWMGEN1 (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(signald1),
	.pwm_o(channela)
);

pcm_pwm PWMGEN2 (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(signald2),
	.pwm_o(channelb)
);
 
pcm_pwm PWMGEN3 (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(signald3),
	.pwm_o(channelc)
);

endmodule 
