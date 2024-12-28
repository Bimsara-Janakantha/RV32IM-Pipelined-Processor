# Hardware Implementation 

---

## Ownership Notice

- Created by BG
- Created on 2024-12-29
- Last modified on 2024-12-29

---

## About

- This is the directory for RV32IM Hardware Implementation. 
- This is running on the **VS Code** with **GHDL** and **GTKWave**.

---

## How to run the program

### Method 01

- **Step 1:** Go to the actual directory
  > cd <directory_name>

- **Step 2:** Analyze the files
  > ghdl -a <file_name>.vhdl<br> ex:<br> _ghdl -a and2.vhdl<br> ghdl -a cpuTb.vhdl_

- **Step 3:** Execute the testbench program
  > ghdl -e <entity_name><br> ex: _ghdl -e cpuTb_

- **Step 4:** Run the testbench program
  > ghdl -r <entity_name> --vcd=<vcd_file_name>.vcd<br> ex: _ghdl -r cpuTb --vcd=cpu_wavedata.vcd_<br>

- **Step 5:** Open the gtkwave
  > gtkwave <vcd_file_name><br> ex: _gtkwave cpu_wavedata.vcd_<br>


### Method 02: Using ghdl_run.sh File

**Note:** Use lynux base terminal _(ex: Git Bash, WSL)_. Also, keep the **ghdl_run.sh** file is in the same working directory.

- **Step 1:** Analyze all single component files
  > ghdl -a <file_name> <br> ex: _ghdl -a and2.vhdl_
  
- **Step 2:** Enable execution of ghdl_run.sh file
  > chmod +x ghdl_run.sh

- **Step 3:** Run the ghdl_run.sh file
  > ./ghdl_run.sh <file_name> <br> ex: _./ghdl_run.sh cpuTb_

---
