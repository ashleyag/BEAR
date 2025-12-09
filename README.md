# BEAR 2
Verilog modules and Python scripts used with the BEAR IC.  
  
Verilog modules were designed for the Basys 3 FPGA board:   
constraints.xdc - Constraints file  
control_main.v - Main module  
control_main_tb.v - Test bench for main module  
pulsegen.v - Pulse generator module  
uart.v - UART transmitter module  
sev_seg.v - Seven segment display module  
  
Python scripts included are :   
  serialtest3.py - to read the serial data from the FPGA.  
  serialout_processor_chunks.py - to process the serial data from the CSV files and generate new csv files with mode number, ADCOut decimal, ADCOut Voltage and output energy.  
  
Data used in figures for the paper: "An Extended Amplitude Range Readout Circuit for Charged Particle Detection - BEAR 2"  
  ic5_mode1mode23.csv: Data used in figure 7 of this paper.  
  postlayout.csv: Data used in figure 3 of this paper.   
