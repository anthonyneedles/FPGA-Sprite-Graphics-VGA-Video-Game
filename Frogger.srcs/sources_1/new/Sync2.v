`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Western Washington University 
// Engineer: Anthony Needles
// 
// Create Date: 05/1/2017 4:13:15 PM
// Design Name: AnthonyNeedles_Sync2
// Module Name: Sync2
// Project Name: Project 4
// Description: Takes in an asyncronous signal and makes it synchronous
// 
//////////////////////////////////////////////////////////////////////////////////

module Sync2(
    input CLK,
    input ASYNC,
    input ACLR_L,
    output SYNC
    );
    
reg [1:0] SREG;
wire aclr_i;

assign aclr_i = ~ACLR_L; 
assign SYNC = SREG[1];

// This design creates two DFFs, with one feeding into another, 
// creating a sync. signal from an async. one
always @(posedge CLK or posedge aclr_i) begin        
        if(aclr_i) begin
            SREG <= 2'b00;
        end
        else begin
            SREG[0] <= ASYNC;
            SREG[1] <= SREG[0];
        end
end
   
endmodule
