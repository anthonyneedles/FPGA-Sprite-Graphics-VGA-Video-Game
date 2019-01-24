`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Western Washington University 
// Engineer: Anthony Needles
// 
// Create Date: 05/8/2017 4:13:15 PM
// Design Name: AnthonyNeedles_VGAEncoder
// Module Name: VGAEncoder
// Project Name: Project 5
// Description: Takes synchronized switch state to drive a certain color combination
// via VGA cable. Creates horizonal and vertical coordinates to determine which pixel 
// to "color" next. After each row the next row is "colored". After row is finished
// a signal HSYNC is deasserted. After all rows are "colored" the coordinates restart
// at 0,0. 
// 
//////////////////////////////////////////////////////////////////////////////////


module VGAEncoder(
    input CLK,
    input [11:0] CSEL,
    input ARST_L,
    output HSYNC,
    output VSYNC,
    output reg [3:0] RED,
    output reg [3:0] GREEN,
    output reg [3:0] BLUE,
    output reg [9:0] HCOORD,
    output reg [9:0] VCOORD
    );

wire aclr_i;
wire Hrollover_i, Vrollover_i;
    
assign aclr_i = ~ARST_L;

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

assign HSYNC = ((HCOORD < 756) && (HCOORD > 658)) ? 1'b0 : 1'b1;
assign VSYNC = ((VCOORD < 495) && (VCOORD > 492)) ? 1'b0 : 1'b1;

always @(posedge CLK or posedge aclr_i) begin
    if (aclr_i) begin
        RED = 4'h0;
        GREEN = 4'h0;    
        BLUE = 4'h0;
    end
    else if((HCOORD > 640) || (VCOORD > 480)) begin
        RED = 4'h0;
        GREEN = 4'h0;    
        BLUE = 4'h0;
    end
    else begin
        // The requested RGB coloring is pulled from the
        // concatenated CSEL signal, as specified by VGAController
        RED <= CSEL[11:8];
        GREEN <= CSEL[7:4];
        BLUE <= CSEL[3:0];
    end  
end
endmodule