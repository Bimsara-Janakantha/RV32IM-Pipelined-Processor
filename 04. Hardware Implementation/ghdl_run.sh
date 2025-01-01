#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Step 1: Assign Testbench to the variable
#FILENAME="Reg_File_tb"
FILENAME="ALUTB"

# Step 2: Analyze all VHDL files
echo "Analyzing all VHDL files."
VHDL_FILES=("AND" "OR" "XOR" "ADDER" "MUX2_1" "MUX4_1" "SHIFT" "SLT" "SLTU" "ALU" "FORWARD" "2sCOMPLEMENTER" "REG_FILE")

for file in "${VHDL_FILES[@]}"; do
    ghdl -a "${file}.vhdl"
    echo "Successfully Analyzed ${file}.vhdl"
done

# Step 3: Analyze the TestBench file
echo "Analyzing VHDL file: ${FILENAME}.vhdl"
ghdl -a "${FILENAME}.vhdl"

# Step 4: Build the entity
echo "Building the entity: ${FILENAME}"
ghdl -e "${FILENAME}"

# Step 5: Run the entity and generate the VCD file
echo "Running the entity: ${FILENAME}"
echo -e "\nResult:"
ghdl -r "${FILENAME}" --vcd=cpu_wavedata.vcd

# Step 6: Open the VCD file in GTKWave
echo "Opening the GTKWave: cpu_wavedata.vcd"
gtkwave cpu_wavedata.vcd
