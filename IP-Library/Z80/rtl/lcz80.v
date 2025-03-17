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
