// +---------------------------------------------------------------------------
// Copyright (c) 2014 LC Desenvolvimentos, Inc. All rights reserved
// ----------------------------------------------------------------------------
// FILE NAME 	  : psg_envgen.v
// AUTHOR         : Luigi C. Filho
// ----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION 	DATE 		AUTHOR 			DESCRIPTION
// 1.0 		2014-23-01 	Luigi C. Filho	Initial Version
// 1.1		2025-16-03	Luigi C. Filho	Modified to add in Git, remove coments 
//										change names to a generic 
// ----------------------------------------------------------------------------
// KEYWORDS : MSX, PSG, GI AY-3-8910 Modified, Gerador de envoltória 
// ----------------------------------------------------------------------------
// PURPOSE : GI AY-3-8910 PSG gerador de envoltória for MSX 
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

module psg_envgen (
	clk256,
	rst_n,
	envfreqf_reg,
	envfreqr_reg,
	shapeenv,
	e_reg
);

input	clk256;
input	rst_n;
input	[7:0]envfreqf_reg;
input	[7:0]envfreqr_reg;
input   [3:0]shapeenv;
output  e_reg;

reg [3:0]e_reg;
reg env;
reg no;
reg al;

reg [15:0]envcnt;

always @(posedge clk256)
begin
 if (rst_n == 1'b0)
  begin
   envcnt <= 16'd0;
   env <= 1'b0;
  end
 else
  begin
   if (envcnt == {envfreqr_reg, envfreqf_reg}) 
    begin
     envcnt <= 12'd0;
     env <= ~env;
    end
   else
    begin
     envcnt <= envcnt + 16'd1;
    end
  end 
end

always @(posedge env or negedge rst_n)
begin
 if(rst_n == 1'b0) begin
 e_reg <= 4'b0000;
 no <= 1'b0;
 end
 else
  begin
   if (shapeenv[3:2] == 2'b00)
    begin
    if (no == 1'b0) begin
      e_reg <= 4'b1111; end
      if (e_reg == 4'b0001)
       begin
        e_reg <= 4'd0;
        no <= 1'b1;
       end
      else
       begin 
        if (no == 1'b0)
        e_reg <= e_reg - 4'b0001;
       end
    end
  else if (shapeenv[3:2] == 2'b01) 
    begin
     if (e_reg == 4'b1111)
       begin
        e_reg <= 4'd0;
        no <= 1'b1;
       end
      else
       begin
        if (no == 1'b0)
        e_reg <= e_reg + 4'b0001;
       end
    end
   else if (shapeenv == 4'b1000)
    begin
        e_reg <= e_reg - 4'b0001;
    end
  else if (shapeenv == 4'b1001)
      begin
	  if (no == 1'b0) begin
      e_reg <= 4'b1111; end
      if (e_reg == 4'b0001)
       begin
        e_reg <= 4'd0;
        no <= 1'b1;
       end
      else
       begin 
        if (no == 1'b0)
        e_reg <= e_reg - 4'b0001;
       end
    end
   else if (shapeenv == 4'b1010)
    begin
     e_reg <= 4'b1111;
     if (e_reg == 4'b0001)
      al <= 1'b1;
     else if (e_reg == 4'b1110) begin
       al <= 1'b0;
      end
     if (al == 1'b1) begin
       e_reg <= e_reg + 4'b0001;
      end
     else if (al == 1'b0) begin
       e_reg <= e_reg - 4'b0001;
      end
     end
   else if (shapeenv == 4'b1011)
    begin
    if (no == 1'b0) begin
      e_reg <= 4'b1111; end
      if (e_reg == 4'b0001)
       begin
        e_reg <= 4'hF;
        no <= 1'b1;
       end
      else
       begin 
        if (no == 1'b0)
        e_reg <= e_reg - 4'b0001;
       end
    end
   else if (shapeenv == 4'b1100)
    begin
		e_reg <= e_reg + 4'b0001;
    end
   else if (shapeenv == 4'b1101)
    begin
      if (e_reg == 4'hF)
       begin
		no <= 1'b1;
        e_reg <= 4'hF;
       end
      else
       begin 
        if (no == 1'b0)
        e_reg <= e_reg + 4'b0001;
       end
    end
   else if (shapeenv == 4'b1110)
    begin
     if (e_reg == 4'b0001)
      al <= 1'b0;
     else if (e_reg == 4'b1110) begin
      al <= 1'b1;
     end

     if (al == 1'b1) begin
      e_reg <= e_reg - 4'b0001;
      end
     else if (al == 1'b0) begin
      e_reg <= e_reg + 4'b0001;
      end
     end
   else if (shapeenv == 4'b1111)
    begin
      if (e_reg == 4'b1111)
       begin
        e_reg <= 4'h0;
        no <= 1'b1;
       end
      else
       begin 
        if (no == 1'b0)
        e_reg <= e_reg + 4'b0001;
       end
    end 
  end
end

endmodule 
