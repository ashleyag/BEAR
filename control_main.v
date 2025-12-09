`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2023 09:43:49 PM
// Design Name: 
// Module Name: control_main
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


module control_main(
input sys_clk,
input st1,
input st2,
input st3,
input st3ext,
input reset,
input ready,
input serout,
output st1control,
output st2control,
output sw3,
output phreset,
output st3reset,
output streset,
output start,
output bear_clk,
output capcharge_reset,
output TxD,
//output reg [9:0] adc_data,
//output reg phreset_start,
//output reg [1:0] phreset_state
//output reg [1:0] st1start,
//output reg [1:0] st2start,
//output reg [1:0] st3start,
//output reg [1:0] st1state,
//output reg [1:0] st2state,
//output reg [1:0] st3state,
//output reg [1:0] sw3reset_state,
//output reg [1:0] sw3reset_start
//output reg adcstart_start,
//output reg [1:0] adcstart_state,
//output reg [1:0] bit_state,
//output reg [4:0] counter,
//output reg adc_done,
//output reg y1,
//output reg y0,
//output reg[7:0] uart_data,
//output reg[7:0] uart_data1,
//output reg[7:0] uart_data2,
//output reg [7:0]uart_data3,
//output reg [3:0]bear_data1,
//output reg [3:0]bear_data2,
//output reg [3:0]bear_data3, 
output reg [3:0] an,
output [6:0] seg
    );
reg  st1start;
 reg  st2start;
 reg  st3start;
 reg [1:0] st1state;
 reg [1:0] st2state;
 reg [1:0] st3state;
 reg  streset_start;
 reg [1:0] streset_state;
 reg  st3reset_start;
 reg [1:0] st3reset_state;
 reg  phreset_start;
 reg [1:0] phreset_state;
 reg  sw3reset_start;
 reg [1:0] sw3reset_state;

 wire control_st1;
 wire control_st2;
 wire control_st3;
 wire bear_streset;
 wire bear_st3reset;
 wire pdh_reset;
 wire sw3reset;
 reg[1:0]  s3_reg;
 wire st3control;
 wire adcstart_count;
 wire bearclk_count;
 wire adc_clk;
 wire adc_clk_bar;
 reg  adcstart_start;
 reg [1:0] adcstart_state;
 reg [1:0] bit_state;
 reg [4:0] counter;
 reg [9:0] adc_data;
 reg transmit;
 reg fpga_ST1, fpga_ST2, fpga_ST3;
 reg y0,y1;
 reg[7:0] uart_data1,uart_data2,uart_data3;
 reg[7:0] uart_data;
 reg[3:0] bear_data1,bear_data2,bear_data3;
 reg adc_done;
 reg uartdone;
 reg [3:0] uart_state;
 reg tx1done,tx2done,tx3done,tx4done;
 wire done;
 reg [3:0] hex;
 wire ready_flag;
 reg readyflag_start;


// ST1 control
 always @(posedge sys_clk)begin
 if(reset ==1)begin 
 st1state = 2'b00;
 end
 if(st1state ==2'b00 && st1==1 && reset ==0)begin 
 st1state =2'b01;
 end
 if(st1control ==1 && st1state==2'b01)begin 
 st1state =2'b10;
 end
 if (st1control ==0 && st1state ==2'b10)begin 
 st1state =2'b00;
 end
 end
 
 always@(posedge sys_clk)begin 
 if(st1state ==2'b00)begin
 st1start =1;
 end
 if(st1state ==2'b01) begin 
 st1start =0;
 end
 if(st1state ==2'b10) begin 
 st1start =0;
 end
 end
    
// ST2
 always @(posedge sys_clk)begin
 if(reset ==1)begin 
 st2state = 2'b00;
 end
 if(st2state ==2'b00 && st2==1 && reset ==0)begin 
 st2state =2'b01;
 end
 if(st2control ==1 && st2state==2'b01)begin 
 st2state =2'b10;
 end
 if (st2control ==0 && st2state ==2'b10)begin 
 st2state =2'b00;
 end
 end
 
 always@(posedge sys_clk)begin 
 if(st2state ==2'b00)begin
 st2start =1;
 end
 if(st2state ==2'b01) begin 
 st2start =0;
 end
 if(st2state ==2'b10) begin 
 st2start =0;
 end
 end
 
 //changed to trigger on ST3
 always @(posedge sys_clk)begin
 if(reset ==1)begin 
 st3state = 2'b00;
 end
 if(st3state ==2'b00 && st3==1 && st3control==0)begin 
 st3state =2'b01;
 end
 if(st3state==2'b01 && st3==1 && st3control == 1)begin 
 st3state =2'b10;
 end
 if (st3state ==2'b10 && st3control==0)begin 
 st3state =2'b11;
 end
 if (st3state ==2'b11 && sw3reset ==1) begin 
 //if (st3state == 2'b11) begin
 st3state =2'b00;
 end
 end
 
 always@(posedge sys_clk)begin 
 if(st3state ==2'b00)begin
 st3start =1;
 s3_reg=1;
 end
 if(st3state ==2'b01) begin 
 st3start =0;
 s3_reg =1;
 end
 if(st3state ==2'b10) begin 
 st3start =0;
 s3_reg =1;
 end
 if(st3state ==2'b11) begin 
 st3start =1;
 s3_reg =0;
 end
 end
 
//sw3reset triggered by ST3
always @(posedge sys_clk)begin 
if (reset == 1) begin 
sw3reset_state = 2'b00;
end
if(st3 ==1 && sw3reset_state ==2'b0) begin 
sw3reset_state = 2'b01;
end
if (sw3reset == 0 && sw3reset_state ==2'b01) begin 
sw3reset_state = 2'b10;
end
if (sw3reset == 1 && sw3reset_state ==2'b10) begin 
sw3reset_state = 2'b00;
end
end  

always  @(posedge sys_clk)begin 
if (sw3reset_state == 2'b00)begin 
sw3reset_start = 1;
end   
if (sw3reset_state == 2'b01)begin 
sw3reset_start = 0;
end 
if (sw3reset_state == 2'b10 ) begin 
sw3reset_start = 0;
end
end 

 //st3reset doesnt affect st3ext
always @(posedge sys_clk)begin 
if (reset == 1) begin 
st3reset_state = 2'b00;
end
if(st3 ==1 && st3reset_state ==2'b0) begin 
st3reset_state = 2'b01;
end
if (st3reset == 0 && st3reset_state ==2'b01) begin 
st3reset_state = 2'b10;
end
if (st3reset == 1 && st3reset_state ==2'b10) begin 
st3reset_state = 2'b00;
end
end  

always  @(posedge sys_clk)begin 
if (st3reset_state == 2'b00)begin 
st3reset_start = 1;
end   
if (st3reset_state == 2'b01)begin 
st3reset_start = 0;
end 
if (st3reset_state == 2'b10 ) begin 
st3reset_start = 0;
end
end

 //st12reset
always @(posedge sys_clk)begin 
if (reset == 1) begin 
streset_state = 2'b00;
end
if(st1 ==1 && streset_state ==2'b0) begin 
streset_state = 2'b01;
end
if (streset == 0 && streset_state ==2'b01) begin 
streset_state = 2'b10;
end
if (streset == 1 && streset_state ==2'b10) begin 
streset_state = 2'b00;
end
end  

always  @(posedge sys_clk)begin 
if (streset_state == 2'b00)begin 
streset_start = 1;
end   
if (streset_state == 2'b01)begin 
streset_start = 0;
end 
if (streset_state == 2'b10 ) begin 
streset_start = 0;
end
end

 //phreset st3 controlled
always @(posedge sys_clk)begin 
if (reset == 1) begin 
phreset_state = 2'b00;
end
if(st3 ==1 && phreset_state ==2'b0) begin 
phreset_state = 2'b01;
end
if (phreset == 1 && phreset_state ==2'b01) begin 
phreset_state = 2'b10;
end
if (phreset == 0 && phreset_state ==2'b10) begin 
phreset_state = 2'b00;
end
end  

always  @(posedge sys_clk)begin 
if (phreset_state == 2'b00)begin 
phreset_start = 1;
end   
if (phreset_state == 2'b01)begin 
phreset_start = 0;
end 
if (phreset_state == 2'b10 ) begin 
phreset_start = 0;
end
end
    
    
//START st3 triggered.
always @(posedge sys_clk)begin 
if (reset ==1) begin 
adcstart_state = 2'b00;
end
if (st3 == 1 && adcstart_state == 2'b00) begin     
adcstart_state = 2'b01;
end
if (start == 1 && adcstart_state == 2'b01) begin     
adcstart_state = 2'b10;
end
if (start == 1 && adcstart_state == 2'b10) begin     
adcstart_state = 2'b10;
end
if (start == 0 && adcstart_state == 2'b10) begin 
adcstart_state = 2'b11;
end
//if (ready ==1 && adcstart_state == 2'b11) begin 
if (uartdone == 1 && adcstart_state == 2'b11) begin 
adcstart_state = 2'b00;
end
end   

always @(posedge sys_clk)begin 
if (adcstart_state == 2'b00 || adcstart_state ==2'b11 )begin 
adcstart_start = 1;
end
if (adcstart_state == 2'b01 || adcstart_state == 2'b10)begin 
adcstart_start = 0;
end
end

//store ADC bits 
//fpga_ST1,ST2and ST3
 always @(posedge sys_clk)begin 
    if(st1 ==1 && reset ==0) begin 
    fpga_ST1 =1'b1; 
    end
    if(st2 ==1 && reset ==0)begin 
    fpga_ST2 =1'b1;
    end
    if(st3 ==1 && reset ==0)begin //st3ext opposite to ST3.
    fpga_ST3 =1'b1;
    end
    if(reset ==1 || uartdone ==1)begin
    fpga_ST1 = 1'b0;
    fpga_ST2 = 1'b0;
    fpga_ST3 = 1'b0;
    end
 end
 //y0,y1
 always @ (posedge sys_clk) begin 
    if(fpga_ST3)begin 
    y1=1'b0;
    y0=1'b1;
    end
    if(fpga_ST1)begin 
    y1=1'b1;
    y0=1'b0;
    end
    if(fpga_ST2)begin 
    y1=1'b1;
    y0=1'b1;
    end
    if(reset==1 ||uartdone ==1)begin 
    y1=1'b0;
    y0=1'b0;
    end
 end
 //use end of UART transmission to reset these. 

//ADC processing using Start 
always @(posedge sys_clk)begin 
if (reset == 1) begin 
bit_state = 2'b00;
end
if(start ==1 && bit_state ==2'b0) begin 
bit_state = 2'b01;
end
if (ready_flag == 1 && bit_state ==2'b01) begin 
bit_state = 2'b10;
end
if (bit_state ==2'b10 && uart_state ==2'b10) begin 
bit_state = 2'b11;
end
if (bit_state ==2'b11 && uartdone==1) begin 
bit_state = 2'b00;
end
end  
//ready_flag start
always  @(posedge sys_clk)begin 
if (bit_state == 2'b01)begin 
readyflag_start = 0;
end   
if (bit_state == 2'b00||bit_state ==2'b10 || bit_state ==2'b11)begin 
readyflag_start = 1;
end 
end

//bit loading
always @(posedge adc_clk)begin 
if (bit_state ==0 || bit_state ==1)begin 
    counter <= 0;
    adc_done <= 0;
    adc_data <= 0;
end 
if (bit_state ==2'b10)begin 
    if(counter <=4'b1010)begin 
    adc_data[counter]<= serout;
     $display("serout = %b, counter = %d", serout, counter);
    counter <= counter+1;
    end
    if(counter == 4'b1011)begin 
    adc_done <= 1;
    end 
end
if(bit_state ==2'b11)begin 
adc_done <=0;
end
end

//UART data processing 
always @(posedge adc_clk)begin
    if (bit_state==2'b10)begin
    bear_data1 = {y1,y0,adc_data[0],adc_data[1]};
    bear_data2 = {adc_data[2],adc_data[3],adc_data[4],adc_data[5]};
    bear_data3 = {adc_data[6],adc_data[7],adc_data[8],adc_data[9]};
    end
    if(reset==1 || uartdone ==1) begin 
    bear_data1 =4'b0;
    bear_data2 =4'b0;
    bear_data3 =4'b0;
    end
end

always @(posedge sys_clk)begin
    case(bear_data1)
    4'b0000 : uart_data1 = 8'b0011_0000;
    4'b0001 : uart_data1 = 8'b0011_0001; 
    4'b0010 : uart_data1 = 8'b0011_0010; 
    4'b0011 : uart_data1 = 8'b0011_0011; 
    4'b0100 : uart_data1 = 8'b0011_0100; 
    4'b0101 : uart_data1 = 8'b0011_0101; 
    4'b0110 : uart_data1 = 8'b0011_0110; 
    4'b0111 : uart_data1 = 8'b0011_0111; 
    4'b1000 : uart_data1 = 8'b0011_1000; 
    4'b1001 : uart_data1 = 8'b0011_1001; 
    4'b1010 : uart_data1 = 8'b0100_0001; 
    4'b1011 : uart_data1 = 8'b0100_0010; 
    4'b1100 : uart_data1 = 8'b0100_0011; 
    4'b1101 : uart_data1 = 8'b0100_0100; 
    4'b1110 : uart_data1 = 8'b0100_0101; 
    4'b1111 : uart_data1 = 8'b0100_0110; 
    default : uart_data1 = 8'b0010_0011;  
    endcase
end

always @(posedge sys_clk)begin
    case(bear_data2)
    4'b0000 : uart_data2 = 8'b0011_0000;
    4'b0001 : uart_data2 = 8'b0011_0001; 
    4'b0010 : uart_data2 = 8'b0011_0010; 
    4'b0011 : uart_data2 = 8'b0011_0011; 
    4'b0100 : uart_data2 = 8'b0011_0100; 
    4'b0101 : uart_data2 = 8'b0011_0101; 
    4'b0110 : uart_data2 = 8'b0011_0110; 
    4'b0111 : uart_data2 = 8'b0011_0111; 
    4'b1000 : uart_data2 = 8'b0011_1000; 
    4'b1001 : uart_data2 = 8'b0011_1001; 
    4'b1010 : uart_data2 = 8'b0100_0001; 
    4'b1011 : uart_data2 = 8'b0100_0010; 
    4'b1100 : uart_data2 = 8'b0100_0011; 
    4'b1101 : uart_data2 = 8'b0100_0100; 
    4'b1110 : uart_data2 = 8'b0100_0101; 
    4'b1111 : uart_data2 = 8'b0100_0110; 
    default : uart_data2 = 8'b0010_0011;  
    endcase
end
always @(posedge sys_clk)begin
    case(bear_data3)
    4'b0000 : uart_data3 = 8'b0011_0000;
    4'b0001 : uart_data3 = 8'b0011_0001; 
    4'b0010 : uart_data3 = 8'b0011_0010; 
    4'b0011 : uart_data3 = 8'b0011_0011; 
    4'b0100 : uart_data3 = 8'b0011_0100; 
    4'b0101 : uart_data3 = 8'b0011_0101; 
    4'b0110 : uart_data3 = 8'b0011_0110; 
    4'b0111 : uart_data3 = 8'b0011_0111; 
    4'b1000 : uart_data3 = 8'b0011_1000; 
    4'b1001 : uart_data3 = 8'b0011_1001; 
    4'b1010 : uart_data3 = 8'b0100_0001; 
    4'b1011 : uart_data3 = 8'b0100_0010; 
    4'b1100 : uart_data3 = 8'b0100_0011; 
    4'b1101 : uart_data3 = 8'b0100_0100; 
    4'b1110 : uart_data3 = 8'b0100_0101; 
    4'b1111 : uart_data3 = 8'b0100_0110; 
    default : uart_data3 = 8'b0010_0011;  
    endcase
end

//UART state machine
always @(posedge sys_clk) begin 
    if(reset) uart_state = 2'b00;
    if(adc_done ==1 && uart_state ==2'b00)begin 
    uart_state = 2'b01;
    end
    if(uart_state ==2'b01 && done ==0 && tx1done ==1)begin
    uart_state =2'b10;
    end
    if(uart_state == 2'b10 && done ==0 && tx2done ==1)begin 
    uart_state =2'b11;
    end
    if(uart_state ==2'b11 && done ==0 && tx3done == 1 )begin 
    uart_state =3'b100;
    end
    if(uart_state == 3'b100 && done ==0 && tx4done ==1)begin 
    uart_state =2'b00;
    end 
end
//UART state machine
always @(posedge sys_clk)begin 
    if (uart_state ==2'b00)begin 
    transmit=0;
    tx1done=0;
    tx2done=0;
    tx3done=0;
    tx4done=0;
    uartdone=0;
    end
    if (uart_state == 2'b01) begin 
       transmit = 1;
       if (done == 0)begin
       uart_data = uart_data1; 
       hex = bear_data1;
       an =4'b0111; 
       end
       else if (done ==1)begin 
       tx1done =1;
       end
    end 
    if (uart_state == 2'b10) begin 
       if (done ==0)begin 
       uart_data =uart_data2;
       hex = bear_data2;
       an =4'b1011; 
       end
       else if (done ==1) begin 
       tx2done =1;
       end
    end 
     if (uart_state == 2'b11) begin 
       if(done ==0)begin
       uart_data = uart_data3;
       hex = bear_data3;
       an =4'b1101; 
       end
       else if (done ==1) begin 
       tx3done =1;
       end
    end 
      if (uart_state == 3'b100) begin 
       if ( done ==0)begin 
       uart_data = 8'b0010_1100;
       hex = 4'b1111; //F for comma
       an =4'b1110; 
       end
       else if (done ==1)begin 
       tx4done = 1;
       uartdone =1;
       end
    end    
 end

assign st1control = control_st1;
assign st2control = control_st2;
 assign st3control =control_st3;
 //sw3 = open-close-open
 assign sw3 = s3_reg && ~reset ;
//sw3=st3 switch close-open-close
//assign sw3 = st3;
 assign phreset = pdh_reset || reset ;
 assign st3reset = ~bear_st3reset && ~reset;
// assign st3reset = ~reset;
 assign streset = ~bear_streset && ~reset;
 assign capcharge_reset =pdh_reset || reset;
 //assign streset = 0; 
// always reset.
 assign bear_clk = bearclk_count;
 assign adc_clk = bearclk_count;
 assign adc_clk_bar = ~bearclk_count;
 assign start = adcstart_count;
 pulsegen #(.N(0),.W(500))controlgen1(.clk(sys_clk),.reset(st1start),.pulseout(control_st1)); 
 pulsegen #(.N(0),.W(500))controlgen2(.clk(sys_clk),.reset(st2start),.pulseout(control_st2)); 
 pulsegen #(.N(0),.W(60))controlgen3(.clk(sys_clk),.reset(st3start),.pulseout(control_st3)); 
 pulsegen #(.N(995000),.W(20))sw3control(.clk(sys_clk),.reset(sw3reset_start),.pulseout(sw3reset)); 
 // changed from 9.8ms to 9.95ms to prevent cseries from leaking. 
 pulsegen #(.N(0),.W(980000))resetgen1(.clk(sys_clk),.reset(st3reset_start),.pulseout(bear_st3reset)); 
 //changed from 0 to 500 (5us) in order to prevent st3 from glitching CSAOut. changed to 20 (200ns) for mode23.
 pulsegen #(.N(0),.W(980000))resetgen2(.clk(sys_clk),.reset(streset_start),.pulseout(bear_streset));
 //from 980000 to 994000 streset after st3reset.
 pulsegen #(.N(3000),.W(994000))resetgen3(.clk(sys_clk),.reset(phreset_start),.pulseout(pdh_reset));
 //9.9ms -9.94ms.
 pulsegen #(.N(50),.W(50))bearclkgen(.clk(sys_clk),.reset(reset),.pulseout(bearclk_count));
 pulsegen #(.N(1),.W(1))adcstartgen(.clk(adc_clk_bar),.reset(adcstart_start),.pulseout(adcstart_count));
 //july 8th changed adc_clk to adc_clk_bar. and 2,2, to 1,1
   // 1us delay = 100, 100ns delay =10. 980000=9.8ms
 pulsegen #(.N(11),.W(1))readyflag_gen(.clk(adc_clk),.reset(readyflag_start),.pulseout(ready_flag));
 uart txmod( .sys_clk(sys_clk),.uart_reset(reset),.transmit(transmit),.data(uart_data),.TxD(TxD),.done(done));
 sev_seg display(.hex(hex),.seg(seg));
 
endmodule
