#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 16:31:17 2025

@author: ashleygomez
"""

import pandas as pd
import os
import matplotlib.pyplot as plt
import numpy as np

# Function to read binary numbers from CSV and split each into first 2 bits and last 10 bits,
# then convert the last 10 bits to decimal, and add a message based on LUT for the first 2 bits
def split_and_convert_with_LUT(directory, lut):
    # List all CSV files in the directory
    files = [f for f in os.listdir(directory) if f.endswith('.csv')]
    
    for file in files:
        # Construct the full path to the file
        file_path = os.path.join(directory, file)
        
        try:
            # Read the CSV file with chunksize if it's too large
            chunksize = 10000  # Set a reasonable chunk size (you can adjust this)
            chunk_iter = pd.read_csv(file_path, chunksize=chunksize, header=None)  # Ensure header=None to treat all rows as data

            # Initialize to ensure the first row's data is included
            first_chunk = True

            for chunk in chunk_iter:
                # Process each chunk of the CSV file
                process_chunk(chunk, file, lut, directory, first_chunk)
                
                # Set first_chunk to False after processing the first chunk
                first_chunk = False
        
        except Exception as e:
            print(f"Error reading {file}: {e}")
            continue

# Function to process a chunk
def process_chunk(chunk, file, lut, directory, first_chunk):
    # Create lists to store the split parts, decimal conversion, and LUT messages
    split_first_2 = []
    adc_out = []
    decimal_last_10 = []
    lut_messages = []
    eout_av = []
    eout_aq = []
    con_voltage = []


    # for binary_str in chunk.iloc[:, 0]:  # Assuming binary data is in the first column
    #     binary_str = str(binary_str).strip()

    #     # Pad the binary string with leading zeroes to make sure it is 12 bits
    #     binary_str = binary_str.zfill(12)
    
    ## added on july 16 
    for binary_str in chunk.iloc[:, 0]:
        binary_str = str(binary_str).strip()

        if binary_str.endswith('.0'):
            binary_str = binary_str[:-2]

        binary_str = binary_str.zfill(12)

        if not binary_str.isdigit() or len(binary_str) != 12:
            print(f"Skipping invalid binary string: '{binary_str}' in file '{file}'")
            continue


        # Initialize variables to avoid reference errors
        first_2 = None
        last_10 = None
        decimal_value = None
        lut_message = None
        result_av = None
        result_aq = None
        voltage = None

        # Check that the length of the binary string is 12
        if len(binary_str) == 12:
            # Split the binary number into first 2 bits and last 10 bits
            first_2 = binary_str[:2]
            last_10 = binary_str[2:]

            # Convert the last 10 bits to decimal
            decimal_value = int(last_10, 2) # Convert binary to decimal

            # Get the message from the LUT based on the first 2 bits
            lut_message = lut.get(first_2, "Unknown combination")  # Default message if not found
             
            #apply formula to get voltage 
            voltage = deci_to_volt (decimal_value)
            
            # Apply the formulas to the decimal value
            result_av = Eout_av_formula(voltage, lut_message)
            result_aq = Eout_aq_formula(voltage, lut_message)
        
            
        else:
            print(f"Warning: Binary number '{binary_str}' in file '{file}' is not 12 bits.")
        
        # Store the split parts, decimal value, and LUT message
        split_first_2.append(first_2)
        adc_out.append(last_10)
        decimal_last_10.append(decimal_value)
        lut_messages.append(lut_message)
        eout_av.append(result_av)
        eout_aq.append(result_aq)
        con_voltage.append(voltage)
      
    # Create a DataFrame with only the necessary columns: 'First 2 Bits', 'Decimal (Last 10 Bits)', and 'LUT Message'
    result_data = pd.DataFrame({
        'Mode': lut_messages,
        'ADCOut_binary': adc_out,
        'ADCOut_Decimal': decimal_last_10,
        'Voltage': con_voltage,
        'Output Av (MeV)': eout_av,
        'Output Aq (MeV)': eout_aq,
    })
    #to remove 0s.
   # result_data = result_data[result_data['ADCOut_Decimal'] != 0]
    def should_keep(row):
       return not (row['ADCOut_Decimal'] == 0 and row['Mode'] == 'Mode1')

    result_data = result_data[result_data.apply(should_keep, axis=1)]  

    
    # Save the resulting DataFrame to a new CSV file
   # output_filename = os.path.join(directory, f"processed_{os.path.splitext(file)[0]}.csv")
   
    
   # Create output directory if it doesn't exist
    output_dir = os.path.join(os.path.dirname(directory), os.path.basename(directory) + '_processed')
    os.makedirs(output_dir, exist_ok=True)

    # Construct output file path without "processed_" prefix
    output_filename = os.path.join(output_dir, os.path.basename(file))


    # Write header only for the first chunk (i.e., if the file doesn't exist or is being created)
    result_data.to_csv(output_filename, mode='a', header=first_chunk, index=False)
    
    print(f"Processed and saved {file} as {output_filename}")
    #mean = np.mean(decimal_last_10)
    #median = np.median(decimal_last_10)
    std_dev = np.std(decimal_last_10)
    mode, frequency = find_mode_from_histogram(decimal_last_10)

    print(f"The most occurring data point (mode) is: {mode} with frequency: {frequency} and stdev:{std_dev}")

    # #  Plotting the histogram
    # output_image = os.path.join(directory, f"{os.path.splitext(file)[0]}_adcout.png")
    # plt.hist(eout_av,color='red', bins=20, edgecolor='black')  # You can adjust the number of bins
    # plt.title("ADC Out")
    # plt.xlabel("Eout")
    # plt.ylabel("Frequency")
    
    #   # Annotate key statistics on the plot
    # plt.text(mean, max(np.histogram(eout_av, bins=20)[0]), f'Mean: {mean:.2f}', horizontalalignment ='center', verticalalignment='top', color='green', fontsize=12)
    #   #plt.text(median, max(np.histogram(eout_av, bins=20)[0]) * 0.9, f'Median: {median:.2f}', horizontalalignment='center', color='green', fontsize=12)
    #   #plt.text(mode, max(np.histogram(eout_av, bins=20)[0]) * 0.8, f'Mode: {mode:.2f}', horizontalalignment='center', color='blue', fontsize=12)

    #   # Add standard deviation annotation
    # plt.text(mean + std_dev, max(np.histogram(eout_av, bins=20)[0]) * 0.7, f'St. Dev: {std_dev:.2f}', horizontalalignment='center', color='purple', fontsize=12)
    # plt.savefig(output_image)
    # plt.close()  # Close the figure to avoid overlap in future plots

    # Set the directory containing your CSV files
    
directory ='/Users/ashleygomez/Desktop/ic5_test/2n_5n'# Replace with the actual path




# Define the Look-Up Table (LUT)
lut = {
    '00': 'Mode1',  # Example message for '00'
    '01': 'Mode1',  # Example message for '01'
    '10': 'Mode2',  # Example message for '10'
    '11': 'Mode3'   # Example message for '11'
}

def deci_to_volt(decimal_value):
    if decimal_value >= 986:
        result = decimal_value * 585.9375 * (10**-6)
    elif decimal_value < 986:
        result = (decimal_value * 585.9375*(10**-6)) + 0.022
    return result


# Define the formula function (example formula: result = decimal_value * 2 + 5)
def Eout_av_formula(voltage, lut_message):
    if lut_message == 'NA':
        result = 0
    elif lut_message == 'Mode1':
        result = round( ((voltage * 3.62 * 6.24 * (10**18) * 150 * (10**-12)) / (55 * (10**6))), 2)
    elif lut_message == 'Mode2':
        result = round( ((voltage * 3.62 * 6.24 * (10**18) * 2150 * (10**-12)) / (55 * (10**6))), 2)
    elif lut_message == 'Mode3':
        result = round( ((voltage * 3.62 * 6.24 * (10**18) * 7150 * (10**-12)) / (55 * (10**6))), 2)
    return result

def Eout_aq_formula(voltage, lut_message):
    if lut_message == 'NA':
        result = 0
    elif lut_message == 'Mode1':
        result = round( ((voltage * 3.62 * 6.24 * (10**18) * 100) / (2 * (10**12) * (10**6) * 13.209)), 2)
    elif lut_message == 'Mode2':
        result = round( ((voltage * 3.62 * 6.24 * (10**18) * 100) / (2 * (10**12) * (10**6) * 1.0507)), 2)
    elif lut_message == 'Mode3':
        result = round( ((voltage * 3.62 * 6.24 * (10**18) * 100) / (2 * (10**12) * (10**6) * 0.3183 )), 2)
    return result

def find_mode_from_histogram(data, bins=20):
    # Compute the histogram
    hist, bin_edges = np.histogram(data, bins=bins)

    # Find the bin with the maximum frequency
    max_freq_bin_index = np.argmax(hist)

    # Find the center of the bin with the maximum frequency
    mode = (bin_edges[max_freq_bin_index] + bin_edges[max_freq_bin_index + 1]) / 2

    return mode, hist[max_freq_bin_index]

# Call the function to process multiple CSV files with LUT comparison
split_and_convert_with_LUT(directory, lut)
