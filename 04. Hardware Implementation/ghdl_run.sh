#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Step 1: Assign Testbench to the variable
#FILENAME="Reg_File_tb"
#FILENAME="ALUTB"
#FILENAME="PCTB"
#FILENAME="Pipeline_Reg_TB"
FILENAME="CPUTB"

# Step 2: Analyze all VHDL files
echo "Analyzing all VHDL files."
VHDL_FILES=("2sCOMPLEMENTER" "ADDER" "ALU" "AND" "CONTROL_UNIT" "CPU" "FORWARD" "MUX2_1" "MUX4_1" "OR" "PC" "REG_EX_MEM" "REG_FILE" "REG_ID_EX" "REG_IF_ID" "REG_MEM_WB" "SHIFT" "SLT" "SLTU" "XOR")

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
