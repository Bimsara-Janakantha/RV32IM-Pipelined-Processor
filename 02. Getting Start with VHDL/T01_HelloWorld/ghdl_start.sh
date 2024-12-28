#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Step 1: Check for required arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <filename> <entity_name>"
  exit 1
fi

# Assign arguments to variables
FILENAME=$1
ENTITY_NAME=$2

# Step 2: Analyze the file
if [ ! -f "${FILENAME}.vhdl" ]; then
  echo "Error: File '${FILENAME}.vhdl' does not exist."
  exit 1
fi

echo "Analyzing VHDL file: ${FILENAME}.vhdl"
ghdl -a "${FILENAME}.vhdl"

# Step 3: Execute the program
echo "Building the entity: $ENTITY_NAME"
ghdl -e "$ENTITY_NAME"

# Step 4: Run the program
echo "Running the entity: $ENTITY_NAME"
ghdl -r "$ENTITY_NAME"

echo "\nResult:"