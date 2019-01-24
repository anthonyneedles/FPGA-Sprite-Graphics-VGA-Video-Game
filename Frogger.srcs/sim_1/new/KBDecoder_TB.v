
// Verilog test fixture for Lab2
// Steve Sandelin, 3/21/17

`timescale 1ns/1ps
`define CKPER 16667

module KBDecoderTestBench;
reg CLK, ARST_L, SDATA;
wire KEYUP, rollover;
wire [3:0] HEX0, HEX1;
reg [21:0] in_seq;
wire [4:0] SREG;

KBDecoder DUT(.CLK(CLK), .ARST_L(ARST_L), .SDATA(SDATA), .KEYUP(KEYUP), .HEX0(HEX0), .HEX1(HEX1), .SREG(SREG), .rollover_i(rollover));

initial in_seq <= 22'b1100011100111111100001;     // test vector sequence for EN

initial CLK <= 1'b0;
always  #`CKPER CLK <= ~CLK;                 // test clock with period of 2*CKPER

initial
begin
  ARST_L <= 1'b0;    // reset active
  #25 ARST_L <= 1'b1; // and 25ns later, inactive...
end

always @(posedge CLK)
  if(ARST_L == 1'b0)
    SDATA <= #1 1'b0;
  else
    SDATA <= #1 in_seq[0];

always @(posedge CLK)
  if(ARST_L == 1'b0)
    in_seq <= #1 in_seq;
  else
    in_seq <= #1 {1'b0, in_seq[21:1]};

endmodule