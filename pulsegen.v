`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:44:04 AM
// Design Name: 
// Module Name: pulsegen
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


module pulsegen
#(parameter N =0, parameter W = 0)
(
    input clk,
    input reset,
    output reg pulseout
    );
    reg [25:0] counter;
    
    always@( posedge clk) begin 
    if (reset) begin 
    counter =25'b0;
    pulseout =0;
    end
    else begin 
    counter = counter +1;
    if (counter > N)begin //Nns delay.
    pulseout =1;
    end
    if (counter > N+W) begin  //Wns pulse 
    pulseout =0;
    counter =1;
    end
    end
   end
endmodule
