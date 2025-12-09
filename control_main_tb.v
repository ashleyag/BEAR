`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 12:00:52 PM
// Design Name: 
// Module Name: control_main_tb
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


module control_main_tb;
reg sys_clk;
reg st1,st2;
reg st3,st3ext;
reg reset;
reg ready;
reg serout;

wire st1control,st2control;
//wire st3control;
wire sw3;
wire phreset, st3reset, streset, start, bear_clk;
wire capcharge_reset;
//wire[1:0]st1start;
//wire [1:0]st2start;
//wire [1:0]st3start;
//wire [1:0]st1state;
//wire  [1:0] st2state;
//wire [1:0]st3state;
//wire [1:0] reset_start;
//wire [1:0] reset_state;
//wire [1:0] sw3reset_state;
//wire  [1:0] sw3reset_start;
//wire phreset_start;
//wire [1:0] phreset_state;
//wire [9:0] adc_data;
//wire [1:0] bit_state;
//wire adcstart_start;
//wire [1:0] adcstart_state;
//wire [4:0] counter;
//wire adc_done;
//wire y1;
//wire y0;
//wire [7:0] uart_data;
//wire [7:0] uart_data1;
//wire [7:0] uart_data2;
//wire [7:0]uart_data3;
//wire [3:0]bear_data1;
//wire [3:0]bear_data2;
//wire [3:0]bear_data3;
wire TxD;
wire [6:0] seg;
wire [3:0] an;

control_main UUT (.sys_clk(sys_clk),
                  .st1(st1),
                  .st2(st2),
                  .st3(st3),
                  .st3ext(st3ext),
                  .reset(reset),
                  .ready(ready),
                  .serout(serout),
                  .st1control(st1control),
                  .st2control(st2control),
//                  .st3control(st3control),
                  .sw3(sw3),
                  .phreset(phreset),
                  .st3reset(st3reset),
                  .streset(streset),
                  .start(start),
                  .bear_clk(bear_clk),
                  .capcharge_reset(capcharge_reset),
                  .TxD(TxD),
//                  .adc_data(adc_data),
//                  .adcstart_start(adcstart_start),
//                  .adcstart_state(adcstart_state),
//                  .bit_state(bit_state),
//                  .counter(counter),
//                  .adc_done(adc_done),
//                  .reset_start(reset_start),
//                  .reset_state(reset_state)
//                  .st1start(st1start),
//                  .st2start(st2start),
//                  .st3start(st3start),
//                  .st1state(st1state),
//                  .st2state(st2state),
//                  .st3state(st3state),
//                  .sw3reset_state(sw3reset_state),
//                  .sw3reset_start(sw3reset_start)
//                   .phreset_start(phreset_start),
//                   .phreset_state(phreset_state)
//                    .y1(y1),
//                    .y0(y0),
//                    .uart_data(uart_data),
//                    .uart_data1(uart_data1),
//                    .uart_data2(uart_data2),
//                    .uart_data3(uart_data3),
//                    .bear_data1(bear_data1),
//                    .bear_data2(bear_data2),
//                    .bear_data3(bear_data3),
                    .an(an),
                    .seg(seg)
                  );
 
 always #5 sys_clk =~sys_clk;
 
 initial begin 
 sys_clk=1;
 reset =0;
 ready = 0;
 serout=0;
 st1=0;
 st2=0;
 st3=0;
 st3ext=1;
 #100;
 reset =1;
 #10;
 reset =0;
 #603;
 st3=0;
 #2;
 st1 =1;
 st3 = 1;
 #10;
 st1 =0;
 st3 =0;
 #1;
 st2=1;
 #10;
 st2=0;
 #200;
 st1=1;
 st2=1;
 st3=1;
 #20;
 st1=0;
 st2=0;
 #7000;
 st3=0;
 #29654;
 ready = 1;
 #1000;
 //add
 serout =1;
 #1000;
 //add
 ready =0;
 serout =1;
 #1000;
 serout = 0;
 //ready=0;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #1000;
 serout = 1;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #640000;
 ready = 1;
 #1000;
 ready =0;
 serout =1;
 #1000;
 serout = 1;
 //ready =0;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #1000;
 serout = 1;
 #1000;
 serout = 1;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #1000;
 serout = 1;
 #1000;
 serout = 0;
 #1000000;
// reset =1;
// #10;
// reset =0;
// #103;
// st3=1;
// #2;
// st1 =1;
// #10;
// st1 =0;
// st3 =0;
// #1;
// st2=1;
// #10;
// st2=0;
// #200;
// st1=1;
// st2=1;
// st3=1;
// #20;
// st1=0;
// st2=0;
// st3=0;
 end


endmodule
