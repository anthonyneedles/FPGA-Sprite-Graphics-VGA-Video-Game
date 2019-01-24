`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Western Washington University
// Engineer: Anthony Needles
// 
// Create Date: 05/16/2017 12:16:12 PM
// Design Name: AnthonyNeedles_EksBox 
// Module Name: EksBox
// Project Name: Project 6 
// Description: This module handles the interconnects of the project, as per the lab handout
// 
//////////////////////////////////////////////////////////////////////////////////


module EksBox(
    input CLK,
    input ARST_L,
    input SCLK,
    input SDATA,
    output HSYNC,
    output VSYNC,
    output [3:0] RED,
    output [3:0] GREEN,
    output [3:0] BLUE,
    output kbstrobe_i
    );
    
wire clk25mhz_i, synctop_i, syncbot_i, keyup_i;
wire [3:0] hex1_i, hex0_i;   
wire [9:0] hcoord_i, vcoord_i;
wire [11:0] csel_i; 
    
Sync2           U1 (.CLK(CLK), .ASYNC(SCLK), .ACLR_L(ARST_L), .SYNC(synctop_i));
Sync2           U2 (.CLK(CLK), .ASYNC(SDATA), .ACLR_L(ARST_L), .SYNC(syncbot_i));
Clk25Mhz        U3 (.CLKIN(CLK), .ACLR_L(ARST_L), .CLKOUT(clk25mhz_i));
KBDecoder       U4 (.CLK(synctop_i), .SDATA(syncbot_i), .ARST_L(ARST_L), .HEX1(hex1_i), .HEX0(hex0_i), .KEYUP(keyup_i));
SwitchDB        U5 (.CLK(clk25mhz_i), .SW(keyup_i), .ACLR_L(ARST_L), .SWDB(kbstrobe_i));
VGAController   U6 (.CLK(clk25mhz_i), .KBCODE({hex1_i, hex0_i}), .HCOORD(hcoord_i), .VCOORD(vcoord_i), .KBSTROBE(kbstrobe_i), .ARST_L(ARST_L), .CSEL(csel_i));
VGAEncoder      U7 (.CLK(clk25mhz_i), .CSEL(csel_i), .ARST_L(ARST_L), .HSYNC(HSYNC), .VSYNC(VSYNC), .RED(RED), .GREEN(GREEN), .BLUE(BLUE), .HCOORD(hcoord_i), .VCOORD(vcoord_i));
    
endmodule
