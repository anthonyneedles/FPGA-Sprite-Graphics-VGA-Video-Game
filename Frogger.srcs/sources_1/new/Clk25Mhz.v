`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Western Washington University 
// Engineer: Anthony Needles
// 
// Create Date: 05/8/2017 4:13:15 PM
// Design Name: AnthonyNeedles_Clk25Mhz
// Module Name: Clk25Mhz
// Project Name: Project 5
// Description: Divides system clock by 4 in order to get 25Mhz clock
// 
//////////////////////////////////////////////////////////////////////////////////

module Clk25Mhz(
    input CLKIN,
    input ACLR_L,
    output reg CLKOUT
    );
    
reg SREG;    
wire aclr_i;
assign aclr_i = ~ACLR_L;

//One bit counter
always @(posedge CLKIN or posedge aclr_i) begin
    if(aclr_i) begin
        SREG <= 1'b0;
    end
    else begin
        SREG <= ~SREG;
    end
end

//Output clock generation, divide by 4
always @(posedge CLKIN or posedge aclr_i) begin
    if(aclr_i) begin
        CLKOUT <= 1'b0;
    end
    else if(SREG) begin
        CLKOUT <= ~CLKOUT;
    end
end

endmodule
