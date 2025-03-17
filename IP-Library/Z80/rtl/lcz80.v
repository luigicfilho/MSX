// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : lcz80.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-10-02 	Luigi C. Filho	Initial Version
// 1.1		2025-17-03	Luigi C. Filho	Remove coments, change names
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, MSX, Zilog Z80 Processor
// ----------------------------------------------------------------------------
// PURPOSE : Zilog Z80 Processor 
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

module lcz80 (
	m1_n, 
	mreq_n, 
	iorq_n, 
	rd_n, 
	wr_n, 
	rfsh_n, 
	halt_n, 
	busak_n, 
	A, 
	dout, 
	reset_n, 
	clk, 
	wait_n, 
	int_n, 
	nmi_n, 
	busrq_n, 
	di
);

parameter T2Write = 1; // 0 => wr_n active in T3, /=0 => wr_n active in T2
parameter IOWait  = 1; // 0 => Single cycle I/O, 1 => Std I/O cycle

input         reset_n; 
input         clk; 
input         wait_n; 
input         int_n; 
input         nmi_n; 
input         busrq_n; 
output        m1_n; 
output        mreq_n; 
output        iorq_n; 
output        rd_n; 
output        wr_n; 
output        rfsh_n; 
output        halt_n; 
output        busak_n; 
output [15:0] A;
input  [7:0]  di;
output [7:0]  dout;

reg           mreq_n; 
reg           iorq_n; 
reg           rd_n; 
reg           wr_n; 
wire          cen;
wire          intcycle_n;
wire          no_read;
wire          write;
wire          iorq;
reg  [7:0]    di_reg;
wire [6:0]    mcycle;
wire [6:0]    tstate;

assign    cen = 1;

lcz80_core  i_core (
	.cen (cen),
	.m1_n (m1_n),
	.iorq (iorq),
	.no_read (no_read),
	.write (write),
	.rfsh_n (rfsh_n),
	.halt_n (halt_n),
	.wait_n (wait_n),
	.int_n (int_n),
	.nmi_n (nmi_n),
	.reset_n (reset_n),
	.busrq_n (busrq_n),
	.busak_n (busak_n),
	.clk (clk),
	.IntE (),
	.stop (),
	.A (A),
	.dinst (di),
	.di (di_reg),
	.dout (dout),
	.mc (mcycle),
	.ts (tstate),
	.intcycle_n (intcycle_n)
);  

always @(posedge clk or negedge reset_n)
begin
	if (!reset_n)
		begin
			rd_n   <= 1'b1;
			wr_n   <= 1'b1;
			iorq_n <= 1'b1;
			mreq_n <= 1'b1;
			di_reg <= 0;
		end
	else
		begin
			rd_n <= 1'b1;
			wr_n <= 1'b1;
			iorq_n <= 1'b1;
			mreq_n <= 1'b1;
			if (mcycle[0])
				begin
					if (tstate[1] || (tstate[2] && wait_n == 1'b0))
						begin
							rd_n <= ~ intcycle_n;
							mreq_n <= ~ intcycle_n;
							iorq_n <= intcycle_n;
						end
					if (tstate[3])
						mreq_n <= 1'b0;
				end         
			else
				begin
					if ((tstate[1] || (tstate[2] && wait_n == 1'b0)) && no_read == 1'b0 && write == 1'b0)
						begin
							rd_n <= 1'b0;
							iorq_n <= ~ iorq;
							mreq_n <= iorq;
						end
					if (T2Write == 0)
						begin                          
							if (tstate[2] && write == 1'b1)
								begin
									wr_n <= 1'b0;
									iorq_n <= ~ iorq;
									mreq_n <= iorq;
								end
						end
					else
						begin
							if ((tstate[1] || (tstate[2] && wait_n == 1'b0)) && write == 1'b1)
								begin
									wr_n <= 1'b0;
									iorq_n <= ~ iorq;
									mreq_n <= iorq;
								end
						end
				end
			if (tstate[2] && wait_n == 1'b1)
				di_reg <= di;
		end
end

endmodule
