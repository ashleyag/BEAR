`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 11:41:45 AM
// Design Name: 
// Module Name: sev_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sev_seg(
input [3:0] hex,
output reg [6:0] seg
    );
    
       always @*
    begin
        case(hex)
            4'h0: seg[6:0] = 7'b1000000;    // digit 0 hex40 
            4'h1: seg[6:0] = 7'b1111001;    // digit 1 hex79
            4'h2: seg[6:0] = 7'b0100100;    // digit 2 hex24
            4'h3: seg[6:0] = 7'b0110000;    // digit 3 hex30
            4'h4: seg[6:0] = 7'b0011001;    // digit 4 hex19
            4'h5: seg[6:0] = 7'b0010010;    // digit 5 hex12
            4'h6: seg[6:0] = 7'b0000010;    // digit 6 hex02
            4'h7: seg[6:0] = 7'b1111000;    // digit 7 hex78
            4'h8: seg[6:0] = 7'b0000000;    // digit 8 hex00
            4'h9: seg[6:0] = 7'b0010000;    // digit 9 hex10
            4'ha: seg[6:0] = 7'b0001000;    // digit A hex08
            4'hb: seg[6:0] = 7'b0000011;    // digit B hex03
            4'hc: seg[6:0] = 7'b1000110;    // digit C hex46
            4'hd: seg[6:0] = 7'b0100001;    // digit D hex21
            4'he: seg[6:0] = 7'b0000110;    // digit E hex06
            4'hf: seg[6:0] = 7'b0001110;    // digit F hex0E
            default: seg[6:0] = 7'b0000010; //digit G hex02
        endcase
    end 
    
endmodule



