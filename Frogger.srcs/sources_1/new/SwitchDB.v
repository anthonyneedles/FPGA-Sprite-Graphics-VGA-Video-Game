`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Western Washington University 
// Engineer: Anthony Needles
// 
// Create Date: 04/26/2017 2:30:15 PM
// Design Name: AnthonyNeedles_SwitchDB
// Module Name: SwitchDB
// Project Name: Project 3
// Description: Takes in button press as signal and releases a single pulse
// for each button pressed, debounced.
//
// 
//////////////////////////////////////////////////////////////////////////////////

module SwitchDB(CLK, SW, ACLR_L, SWDB);

input CLK, SW, ACLR_L;
output reg SWDB;

wire aclr_i;
reg [1:0] Q_CURR;
parameter [1:0] SW_OFF = 2'b00; //Symbolic state definitions; Simple binary counting order
parameter [1:0] SW_EDGE = 2'b01;
parameter [1:0] SW_VERF = 2'b10;
parameter [1:0] SW_HOLD = 2'b11;
assign aclr_i = ~ACLR_L;

//State Memory
always @(posedge CLK or posedge aclr_i) begin
    SWDB <= 1'b0;   //SWDB is defaulted to 0

    if(aclr_i) begin
        Q_CURR <= SW_OFF;
    end
    else begin
        case(Q_CURR)    //Set of cases that relate directly to State Diagram in Lab 3 Handout 
            SW_OFF: if(SW) begin
                        Q_CURR <= SW_EDGE;
                    end
                    else begin
                        Q_CURR <= SW_OFF;
                    end
                    
            SW_EDGE: if(SW) begin
                        Q_CURR <= SW_VERF;
                        SWDB <= 1'b1;   //Debounced signal only high when current state is SW_VERF
                     end
                     else begin
                        Q_CURR <= SW_OFF;
                     end
                     
             SW_VERF: Q_CURR <= SW_HOLD;
                      
             SW_HOLD: if(SW) begin
                          Q_CURR <= SW_HOLD;
                      end
                      else begin
                          Q_CURR <= SW_OFF;
                      end
        endcase              
    end
end
endmodule
