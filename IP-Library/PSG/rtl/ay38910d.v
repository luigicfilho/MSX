// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : ay38910d.v
// AUTHOR 	      : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, remove coments 
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PSG, GI AY-3-8910 Digital part
// ----------------------------------------------------------------------------
// PURPOSE : GI AY-3-8910 PSG Digital part for MSX 
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

module ay38910d (
	clk,
	rst_n,
	ioa_in,
	ioa_out,
	iob_in,
	iob_out,
	data_in,
	data_out,
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
input	[7:0] ioa_in;
output	[7:0] ioa_out;
input	[7:0] iob_in;
output	[7:0] iob_out;
input	[7:0] data_in;
output	[7:0] data_out;
input	[1:0] bc12;
input	bdir;
input	a8;
input	a9_n;
output	[4:0] channela;
output	[4:0] channelb;
output	[4:0] channelc;

reg	[7:0] ioa_out;
reg	[7:0] iob_out;
reg	[7:0] data_out;
reg [7:0] freqah;  
reg [3:0] freqal;  
reg [7:0] freqbh;  
reg [3:0] freqbl;  
reg [7:0] freqch;  
reg [3:0] freqcl;  
reg [4:0] noise;   
reg [7:0] iomixer; 
reg [4:0] levelca; 
reg [4:0] levelcb; 
reg [4:0] levelcc; 
reg [7:0] envfreqf;
reg [7:0] envfreqr;
reg [3:0] shapeenv;
reg [7:0] porta;   
reg [7:0] portb;

reg [3:0] addr;

wire [11:0]freqa;
wire [11:0]freqb;
wire [11:0]freqc;
wire [3:0]e_regs;
wire atone;
wire btone;
wire ctone;
wire snoise;
wire clk16d;
wire [3:0]avol;
wire [3:0]bvol;
wire [3:0]cvol;
wire amix;
wire bmix;
wire cmix;

assign freqa = {freqal, freqah};
assign freqb = {freqbl, freqbh};
assign freqc = {freqcl, freqch};
assign channela = {avol, amix};
assign channelb = {bvol, bmix};
assign channelc = {cvol, cmix};

always @(posedge clk or negedge rst_n)
begin : REGs
 if (rst_n == 1'b0)
  begin
    addr <= 4'h0;
    freqah   <= 8'h00;
    freqal   <= 4'h0;
    freqbh   <= 8'h00;
    freqbl   <= 4'h0;
    freqch   <= 8'h00;
    freqcl   <= 4'h0;
    noise    <= 5'd0;
    iomixer  <= 8'h00;
    levelca  <= 5'd0;
    levelcb  <= 5'd0;
    levelcc  <= 5'd0;
    envfreqf <= 8'h00;
    envfreqr <= 8'h00;
    shapeenv <= 4'h0;
    porta    <= 8'h00;
    portb    <= 8'h00;
  end
 else
  begin 
	if ( {bdir, bc12} == 3'b001 || {bdir, bc12} == 3'b100 || {bdir, bc12} == 3'b111 ) begin
	  if (a9_n == 1'b0 && a8 == 1'b1 && data_in[7:4] == 4'd0)
	    addr <= data_in[3:0];
	    end
	else if ( {bdir, bc12} == 3'b110 ) 
	  begin
	    case(addr)
          4'd0  : freqah   <= data_in;
          4'd1  : freqal   <= data_in[3:0];
          4'd2  : freqbh   <= data_in;
          4'd3  : freqbl   <= data_in[3:0];
          4'd4  : freqch   <= data_in;
          4'd5  : freqcl   <= data_in[3:0];
          4'd6  : noise    <= data_in[4:0];
          4'd7  : iomixer  <= data_in;
          4'd8  : levelca  <= data_in[4:0];
          4'd9  : levelcb  <= data_in[4:0];
          4'd10 : levelcc  <= data_in[4:0];
          4'd11 : envfreqf <= data_in;
          4'd12 : envfreqr <= data_in;
          4'd13 : shapeenv <= data_in[3:0];
          4'd14 : porta    <= data_in;
          4'd15 : portb    <= data_in;
        endcase
      end
   else if ( {bdir, bc12} == 3'b011 ) 
     begin
	    case(addr)
	      4'd0  : data_out      <= freqah;
          4'd1  : data_out[3:0] <= freqal;
          4'd2  : data_out      <= freqbh;
          4'd3  : data_out[3:0] <= freqbl;
          4'd4  : data_out      <= freqch;
          4'd5  : data_out[3:0] <= freqcl;
          4'd6  : data_out[4:0] <= noise;
          4'd7  : data_out      <= iomixer;
          4'd8  : data_out[4:0] <= levelca;
          4'd9  : data_out[4:0] <= levelcb;
          4'd10 : data_out[4:0] <= levelcc;
          4'd11 : data_out      <= envfreqf;
          4'd12 : data_out      <= envfreqr;
          4'd13 : data_out[3:0] <= shapeenv;
          4'd14 : data_out      <= porta;
          4'd15 : data_out      <= portb;
        endcase
     end
     
     case(iomixer[7:6])
      2'b00 : begin porta <= ioa_in; portb <= iob_in; end
      2'b01 : begin ioa_out <= porta; portb <= iob_in; end
      2'b10 : begin porta <= ioa_in; iob_out <= portb; end
      2'b11 : begin ioa_out <= porta; iob_out <= portb; end
     endcase
  end
end

psg_clkdiv CLKDIV (
	.clk(clk),
	.rst_n(rst_n),
	.clk16(clk16d)
);

psg_channel CHA(
	.clk16(clk16d),
	.rst_n(rst_n),
	.freqreg(freqa),
	.volreg(levelca),
	.e_reg(e_regs),
	.tone(atone),
	.vol(avol)
);

psg_channel CHB(
	.clk16(clk16d),
	.rst_n(rst_n),
	.freqreg(freqb),
	.volreg(levelcb),
	.e_reg(e_regs),
	.tone(btone),
	.vol(bvol)
);

psg_channel CHC(
	.clk16(clk16d),
	.rst_n(rst_n),
	.freqreg(freqc),
	.volreg(levelcc),
	.e_reg(e_regs),
	.tone(ctone),
	.vol(cvol)
);

psg_noise NOISE (
	.clk16(clk16d),
	.rst_n(rst_n),
	.noise_reg(noise),
	.noisef(snoise)
);

psg_mixer MIX (
	.tonea(atone),
	.toneb(btone),
	.tonec(ctone),
	.noisei(snoise),
	.mixe_reg(iomixer[5:0]),
	.mixeda(amix),
	.mixedb(bmix),
	.mixedc(cmix)
);

psg_envgen ENVGEN (
	.clk256(clk16d),
	.rst_n(rst_n),
	.envfreqf_reg(envfreqf),
	.envfreqr_reg(envfreqr),
	.shapeenv(shapeenv),
	.e_reg(e_regs)
);
endmodule 

