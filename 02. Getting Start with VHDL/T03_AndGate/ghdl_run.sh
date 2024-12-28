#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Step 1: Check for required arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Assign arguments to variables
FILENAME=$1

# Step 2: Analyze the file
if [ ! -f "${FILENAME}.vhdl" ]; then
  echo "Error: File '${FILENAME}.vhdl' does not exist."
  exit 1
fi

# Step 3: Analyze the VHDL file
echo "Analyzing VHDL file: ${FILENAME}.vhdl"
ghdl -a "${FILENAME}.vhdl"

# Step 4: Execute the program
echo "Building the entity: ${FILENAME}"
ghdl -e "$FILENAME"

# Step 5: Run the program and generate the VCD file
echo "Running the entity: ${FILENAME}"
echo -e "\nResult:"
ghdl -r "${FILENAME}" --vcd=cpu_wavedata.vcd

# Step 6: Open the GTKWave
echo "Openning the GTKWave: cpu_wavedata.vcd"
gtkwave cpu_wavedata.vcd