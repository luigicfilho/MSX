// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : s3527.v
// AUTHOR 	      : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, just the stub 
// 										remove all logic, create just a module 
//										stub
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, Engine, MSX ENGINE, S3527, stub
// ----------------------------------------------------------------------------
// PURPOSE : MSX ENGINE TOP clone of S3527
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

module s3527 (
	adr,
	data_in,
	data_out,
	cpu_ctrl_i,
	wait_n,
	romcs_n,
	mpx,
	ras_n,
	cas_n,
	we_n,
	cs_n,
	slt_n,
	slt0_n,
	rsel_n,
	vdpcr,
	vdpcw,
	pdb,
	pstb_n,
	busy,
	x_n,
	y_n,
	y10_n,
	sk_n,
	fwd,
	back,
	right,
	left,
	trga_i,
	trgb_i,
	trga_o,
	trgb_o,
	stb,
	cmi,
	cmo,
	rem,
	kana_n,
	caps_n,
	jis,
	rsti,
	rsto,
	ppisnd,
	ssgsnd,
	ph_i,
	ph_o
);

input	[15:0]adr;
input	[7:0]data_in;
output	[7:0]data_out;
output	wait_n;
input	[5:0]cpu_ctrl_i;
output romcs_n;
output	mpx;
output	ras_n;
output	[1:0]cas_n;
output	we_n;
output [2:0]cs_n;
output	[2:0]slt_n;
output	[1:0]slt0_n;
input	rsel_n;
output	vdpcr_n;
output	vdpcw_n;
output	[7:0]pdb;
output	pstb_n;
input	busy;
input	[7:0]x_n;
output	[9:0]y_n;
input	y10_n;
output	sk_n;
input	[1:0]fwd;
input	[1:0]back;
input	[1:0]right;
input	[1:0]left;
input	[1:0]trga_i;
input	[1:0]trgb_i;
output	[1:0]trga_o;
output	[1:0]trgb_o;
output	[1:0]stb;
input	cmi;
output	cmo;
output	rem;
output	kana_n;
output	caps_n;
input	jis;
input	rsti;
output	rsto;
output	ppisnd;
output	ssgsnd;
input	ph_i;
output	ph_o;

// THIS IS INTENTIONALLY JUST A STUB
// FOR THE COMPLETE IP CONTACT ME

s3527ad ADDRDEC (
	.mreq(),
	.refrsh(),
	.ioreq(),
	.m1(),
	.wr(),
	.rd(),
	.addr(),
	.chip_select()
);

i8255m PPI (
	.clk(),
	.reset(), 
	.cs_n(), 
	.rd_n(), 
	.wr_n(), 
	.addr(), 
	.data_in(),
	.data_out(), 
	.porta(), 
	.portb(), 
	.portch(), 
	.portcl()
   );

ay38910 PSG (
	.clk(),
	.rst_n(),
	.ioa(),
	.iob(),
	.data(),
	.bc12(),
	.bdir(),
	.a8(),
	.a9_n(),
	.channela(),
	.channelb(),
	.channelc()
);
endmodule 

