`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Western Washington University 
// Engineer: Anthony Needles
// 
// Create Date: 05/01/2017 4:13:14 PM
// Design Name: AnthonyNeedles_KBDecoder
// Module Name: KBDecoder
// Project Name: Project 
// Description: Implements a shift register to hold 22 bits of data,
// outputs two hex values based of certain bits of the shift register, 
// shifts in SDATA from KB and send out strobe upon reading an "F0"
//
//////////////////////////////////////////////////////////////////////////////////

module KBDecoder(
    input CLK,
    input SDATA,
    input ARST_L,
    output [3:0] HEX0,
    output [3:0] HEX1,
    output reg KEYUP
    );
    
wire arst_i, rollover_i;
//reg [4:0] SREG;
reg [21:0] Shift;

assign arst_i = ~ARST_L;
// These two hex values are constantly sampled 
// from their respective places in the shift register
assign HEX0[3:0] = Shift[15:12];
assign HEX1[3:0] = Shift[19:16];
//assign rollover_i = (SREG[4] & SREG[2] & SREG[0]) ? 1'b1 : 1'b0;

//always @(negedge CLK or posedge arst_i) begin
//    if(arst_i)
//        SREG <= 5'b00000;
//    else if (rollover_i)
//        SREG <= 5'b00000;
//    else
//        SREG <= SREG + 1;
//end

// Right shifting shift register
always @(negedge CLK or posedge arst_i) begin;
    if(arst_i)begin
        Shift <= 22'b0000000000000000000000;
    end
    else begin
        Shift <= {SDATA, Shift[21:1]}; 
    end
end

//If a value of F0 is found in [8:1] then a pulse is sent indicating a keyup
always @(posedge CLK) begin
    if(Shift[8:1] == 8'hF0) begin
        KEYUP <= 1'b1;
    end
    else begin
        KEYUP <= 1'b0;
    end    
end    

endmodule
