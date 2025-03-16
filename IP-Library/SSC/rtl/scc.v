// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : scc.v
// AUTHOR 	      : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-13-02 	Luigi C. Filho	Initial Version
// 1.1		2016-09-05	Luigi C. Filho	Comments translated to english
// 1.2		2025-16-03	Luigi C. Filho	Remove coments, change names
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, Konami SCC, SCC 
// ----------------------------------------------------------------------------
// PURPOSE : MSX Konami SCC
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

module scc (
	clk,
	rst_n,
	addr,
	data_in,
	data_out,
	wr_n,
	rd_n,
	sdnout,
	cs_n,
	stlsel_n,
	ma
);

input clk;
input rst_n;
input [12:0]addr; 
input [7:0]data_in;
output [7:0]data_out;
input wr_n;
input rd_n;
output cs_n;
output [10:0]sdnout;
input stlsel_n;
output [5:0]ma; 

reg [5:0]ma;
reg [10:0]sdnout;
reg cs_n;
reg [7:0]data_out;
wire [4:0]addrmr;
wire [7:0]addrscc;
wire clk32;

reg [7:0] wavec1[0:31]; 
reg [7:0] wavec2[0:31]; 
reg [7:0] wavec3[0:31]; 
reg [7:0] wavec45[0:31];
reg [3:0] freqc1h; 
reg [7:0] freqc1l;      
reg [3:0] freqc2h;
reg [7:0] freqc2l;      
reg [3:0] freqc3h; 
reg [7:0] freqc3l; 	 	
reg [3:0] freqc4h; 
reg [7:0] freqc4l; 	 	
reg [3:0] freqc5h; 
reg [7:0] freqc5l; 	 	
reg [3:0] volc1; 	 	
reg [3:0] volc2; 	 	
reg [3:0] volc3; 	 	
reg [3:0] volc4; 	 	
reg [3:0] volc5;    	
reg [4:0] ofchs;	 	
reg [7:0] testreg;	 	
reg [5:0] mrr0;
reg [5:0] mrr1;
reg [5:0] mrr2;
reg [5:0] mrr3;
reg [11:0] ch1; 
reg [11:0] ch2;
reg [11:0] ch3; 
reg [11:0] ch4;
reg [11:0] ch5;

wire [4:0]wavech1;
wire [4:0]wavech2;
wire [4:0]wavech3;
wire [4:0]wavech4;
wire [4:0]wavech5;
wire [11:0]freqc1;
wire [11:0]freqc2;
wire [11:0]freqc3;
wire [11:0]freqc4;
wire [11:0]freqc5;

assign addrmr = addr[12:8];
assign addrscc = addr[7:0];
assign freqc1 = {freqc1h, freqc1l};
assign freqc2 = {freqc2h, freqc2l};
assign freqc3 = {freqc3h, freqc3l};
assign freqc4 = {freqc4h, freqc4l};
assign freqc5 = {freqc5h, freqc5l};

integer i;

always @(posedge clk or negedge rst_n)
begin : REGs
 if (rst_n == 1'b0)
  begin
    for (i = 0; i == 31; i=i+1) begin
    wavec1[i] <= 8'h00;
    wavec2[i] <= 8'h00;
    wavec3[i] <= 8'h00;
    wavec45[i] <= 8'h00;
    end
    freqc1l  	<= 8'h00;
    freqc1h  	<= 4'h0; 
    freqc2l  	<= 8'h00;
    freqc2h  	<= 4'h0; 
    freqc3l  	<= 8'h00;
    freqc3h  	<= 4'h0; 
    freqc4l  	<= 8'h00;
    freqc4h  	<= 4'h0; 
    freqc5l  	<= 8'h00;
    freqc5h  	<= 4'h0;  
	volc1  		<= 4'h0;  
	volc2  		<= 4'h0;  
	volc3  		<= 4'h0;  
	volc4  		<= 4'h0;  
	volc5  		<= 4'h0;  
	ofchs  		<= 5'd0;  
	testreg  	<= 8'd0;  
  end
 else
  begin 
	if (mrr3 == 6'h3F && wr_n == 1'b0 || rd_n == 1'b1 && stlsel_n == 1'b0) 
	  begin
	    case(addrscc[6:4])
          3'h0,3'h1  : wavec1[addrscc[4:0]]   	<= data_in;
          3'h2,3'h3  : wavec2[addrscc[4:0]]   	<= data_in;
          3'h4,3'h5  : wavec3[addrscc[4:0]]   	<= data_in;
          3'h6,3'h7  : wavec45[addrscc[4:0]]   <= data_in;
        endcase
        
        if ({addrscc[7],addrscc[4]} == 2'b11 || {addrscc[7],addrscc[4]} == 2'b10)
        begin
          case(addrscc[3:0])
          4'h0  : freqc1h   <= data_in[3:0];
          4'h2  : freqc2h   <= data_in[3:0]; 
          4'h4  : freqc3h   <= data_in[3:0];
          4'h6  : freqc4h   <= data_in[3:0];
          4'h8  : freqc5h   <= data_in[3:0]; 
          4'h1  : freqc1l   <= data_in; 
          4'h3  : freqc2l   <= data_in; 
          4'h5  : freqc3l   <= data_in; 
          4'h7  : freqc4l   <= data_in; 
          4'h9  : freqc5l   <= data_in; 
          4'hA  : volc1     <= data_in[3:0];
          4'hB  : volc2 	   <= data_in[3:0]; 
          4'hC  : volc3 	   <= data_in[3:0]; 
          4'hD  : volc4 	   <= data_in[3:0]; 
          4'hE  : volc5     <= data_in[3:0];
          4'hF  : ofchs     <= data_in[4:0];
          endcase
          end
          
          if (addrscc[7:4] == 4'hE || addrscc[7:4] == 4'hF)
           testreg   <= data_in;
      end
   else if (mrr3 == 6'h3F && wr_n == 1'b1 || rd_n == 1'b0 && stlsel_n == 1'b0) 
     begin
	    case(addrscc[6:4])
          3'h0,3'h1  : data_out <= wavec1[addrscc[4:0]];
          3'h2,3'h3  : data_out <= wavec2[addrscc[4:0]];
          3'h4,3'h5  : data_out <= wavec3[addrscc[4:0]];
          3'h6,3'h7  : data_out <= wavec45[addrscc[4:0]];
         endcase
     end
  end
end

always @(posedge clk or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   mrr0 <= 6'd0;
   mrr1 <= 6'd0;
   mrr2 <= 6'd0;
   mrr3 <= 6'd0;
  end
 else
  begin
   if (stlsel_n == 1'b0) begin
   if (addrmr == 5'h0A)
    mrr0 <= data_in[5:0];
   else if (addrmr == 5'h0E)
    mrr1 <= data_in[5:0];
   else if (addrmr == 5'h12)
    mrr2 <= data_in[5:0];
   else if (addrmr == 5'h16)
    mrr3 <= data_in[5:0];
   end
  end
end

always @(posedge clk or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   cs_n <= 1'b1;
   ma   <= 6'd0;
  end
 else
  begin
   case(addrmr[4:2])
    3'b010 : begin cs_n <= 1'b0; ma <= mrr0; end
    3'b011 : begin cs_n <= 1'b0; ma <= mrr1; end
    3'b100 : begin cs_n <= 1'b0; ma <= mrr2; end
    3'b101 : begin cs_n <= 1'b0; ma <= mrr3; end
    default : begin cs_n <= 1'b1; ma <= 6'd0; end
   endcase
  end
end

always @(posedge clk or negedge rst_n)
begin
 if (rst_n == 1'b0)
  begin
   ch1 <= 12'd0;
   ch2 <= 12'd0; 
   ch3 <= 12'd0;
   ch4 <= 12'd0;
   ch5 <= 12'd0;
  end
 else
  begin
   if (ofchs[4] == 1'b0)
    ch5 <= 12'd0;
   else
    ch5 <= wavec45[wavech5] * volc5;
 
   if (ofchs[3] == 1'b0)
    ch4 <= 12'd0;
   else
    ch4 <= wavec45[wavech4] * volc4;

   if (ofchs[2] == 1'b0) 
    ch3 <= 12'd0; 
   else
    ch3 <= wavec3[wavech3] * volc3;

   if (ofchs[1] == 1'b0)
    ch2 <= 12'd0;
   else
    ch2 <= wavec2[wavech2] * volc2;

   if (ofchs[0] == 1'b0)
    ch1 <= 12'd0; 
   else
    ch1 <= wavec1[wavech1] * volc1;
  end
end

always @(ch1, ch2, ch3, ch4, ch5)
begin
  sdnout = ch1[11:1] + ch2[11:1] + ch3[11:1] + ch4[11:1] + ch5[11:1];
end

scc_clkdiv CLKDIV (
	.clk(clk),
	.rst_n(rst_n),
	.clk32(clk32)
);

scc_channel CH1(
	.clk(clk32),
	.rst_n(rst_n),
	.freq_reg(freqc1),
	.wave_addr(wavech1)
);

scc_channel CH2(
	.clk(clk32),
	.rst_n(rst_n),
	.freq_reg(freqc2),
	.wave_addr(wavech2)
);

scc_channel CH3(
	.clk(clk32),
	.rst_n(rst_n),
	.freq_reg(freqc3),
	.wave_addr(wavech3)
);

scc_channel CH4(
	.clk(clk32),
	.rst_n(rst_n),
	.freq_reg(freqc4),
	.wave_addr(wavech4)
);

scc_channel CH5(
	.clk(clk32),
	.rst_n(rst_n),
	.freq_reg(freqc5),
	.wave_addr(wavech5)
);

endmodule
