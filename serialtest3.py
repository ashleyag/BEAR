#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 10:56:00 2025

@author: ashleygomez
"""

import serial
import csv
import time


def char_to_4bit_binary(char):
    # Look-Up Table (LUT) for characters mapped to 4-bit binary values
    lut = {
        'a': '1010',
        'b': '1011',
        'c': '1100',
        'd': '1101',
        'e': '1110',
        'f': '1111',
        '0': '0000',
        '1': '0001',
        '2': '0010',
        '3': '0011',
        '4': '0100',
        '5': '0101',
        '6': '0110',
        '7': '0111',
        '8': '1000',
        '9': '1001'
        # Add more mappings as needed
    }
    
    # Return the 4-bit binary representation from the LUT
    return lut.get(char.lower(), 'Unknown') 



# Set the serial port (replace with your actual port path)
serial_port = '/dev/tty.usbserial-210183B464A81'  # Adjust this based on your system
baud_rate = 230400  # Adjust the baud rate if needed
timeout = 0.01  # Time to wait for new data (in seconds)

# Open the serial port
ser = serial.Serial(serial_port, baud_rate, timeout=timeout)

data_list =[]
binary_data_list=[]

print("Starting data collection...")
    
try:
    while True:
            # Read one line of data from the serial port
            data = ser.read_until(b',').decode('utf-8').strip()
            if data:  # Only process if data is not empty
                
                cleaned_data = data.replace(',', '')
               
                binary_data = ''.join([char_to_4bit_binary(char) for char in cleaned_data])
                data_list.append(binary_data)
               
                print(f"{binary_data},{cleaned_data}")  # Optional: Print the data to console
                #print(f"{data}")
                
            time.sleep(0.01)  # Sleep to avoid overwhelming the serial connection
except KeyboardInterrupt:
        print("Data collection stopped by user.")
    
finally:
        # Close the serial port when done
        ser.close()
        print("Serial port closed.")


# Open CSV file to write data 
# set path 
csv_filename = '/Users/ashleygomez/Desktop/BEAR 2_tests/2025_09/Sept22/ic5_2test_adc/1000mev.csv'

# Open the file in write mode, create a CSV writer
with open(csv_filename, mode='w', newline='') as file:
    #writer = csv.writer(file)
    writer = csv.writer(file, delimiter=' ')
    
    # Optional: Write headers (if your data has specific columns)
    #writer.writerow(['Data1'])  # Adjust column headers based on your data
    for data in data_list:
        writer.writerow([data])
    