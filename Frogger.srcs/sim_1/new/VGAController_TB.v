
// Verilog test fixture for Lab2
// Steve Sandelin, 3/21/17

`timescale 1ns/1ps
`define CKPER 20

module VGAController_TB;
reg CLK, ARST_L;
wire rollover_i, aclr_i;
wire Hrollover_i, Vrollover_i;
wire [17:0] SREG;
wire [11:0] CSEL;
reg [9:0] HCOORD, VCOORD;
wire [9:0] XPos, YPos;
wire [5:0] XSpeed, YSpeed;

VGAController DUT(.CLK(CLK), .ARST_L(ARST_L), .SREG(SREG), .rollover_i(rollover_i), .HCOORD(HCOORD), .VCOORD(VCOORD), .CSEL(CSEL), .XPos(XPos), .YPos(YPos), .XSpeed(XSpeed), .YSpeed(YSpeed));
assign aclr_i = ~ARST_L;

initial CLK <= 1'b0;
always  #`CKPER CLK <= ~CLK;                 // test clock with period of 2*CKPER

initial
begin
  ARST_L <= 1'b0;    // reset active
  #25 ARST_L <= 1'b1; // and 25ns later, inactive...
end

//Rollovers are asserted when the maximum value is reached for either horizontal
//or vertical (800 and 525).
assign Hrollover_i = (HCOORD[9] & HCOORD[8] & HCOORD[5]) ? 1'b1 : 1'b0;  
assign Vrollover_i = (VCOORD[9] & VCOORD[3] & VCOORD[2] & VCOORD[0]) ? 1'b1 : 1'b0;  

//HCOORD counts every clock cycle or resets to 0
always @(posedge CLK or posedge aclr_i) begin
    if(aclr_i) begin
        HCOORD <= 10'b0000000000; 
    end              
    else if(Hrollover_i)
        HCOORD <= 10'b0000000000;
    else
        HCOORD <= HCOORD + 1;
end

//HCOORD counts every time Hrollover_i is asserted, or resets to 0
//Effectively counting the rows
always @(posedge CLK or posedge aclr_i) begin
    if(aclr_i) begin
        VCOORD <= 10'b0000000000; 
    end              
    else if(Vrollover_i)
        VCOORD <= 10'b0000000000;
    else if(Hrollover_i)
        VCOORD <= VCOORD + 1;
end

endmodule