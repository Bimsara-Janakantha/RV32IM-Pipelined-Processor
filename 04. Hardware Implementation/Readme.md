# Hardware Implementation 

---

## Ownership Notice

- Created by BG
- Created on 2024-12-29
- Last modified on 2025-01-29

---

## About

- This is the directory for RV32IM Hardware Implementation. 
- This is running on the **VS Code** with **GHDL** and **GTKWave**.

---

## How to run the program

### General Instructions
- **Step 1:** Make the `program.s` file with appropriate assembly instructions. _(use # mark for comments)_
- **Step 2:** Compile the `Assembler.c` file
  ```powershell
  gcc Assembler.c -o Assembler
  ```
- **Step 3:** Run the `Assemble.exer` file
  ```powershell
  ./Assembler
  ``` 
- **Step 4:** Use the generated `instr_mem.mem` file for the instruction cache.

### Method 01

- **Step 1:** Go to the actual directory
  ```powershell
  cd <directory_name>
  ```

- **Step 2:** Analyze the files
  ```powershell
  ghdl -a <file_name>.vhdl
  ```
  > ex:<br> _ghdl -a and2.vhdl<br> ghdl -a cpuTb.vhdl_

- **Step 3:** Execute the testbench program
  ```powershell
  ghdl -e <entity_name>
  ```
  > ex: _ghdl -e cpuTb_

- **Step 4:** Run the testbench program
  ```powershell
  ghdl -r <entity_name> --vcd=<vcd_file_name>.vcd
  ```
  > ex: _ghdl -r cpuTb --vcd=cpu_wavedata.vcd_<br>

- **Step 5:** Open the gtkwave
  ```powershell
  gtkwave <vcd_file_name>
  ```
  > ex: _gtkwave cpu_wavedata.vcd_<br>


### Method 02: Using ghdl_run.sh File

**Note:** Use lynux base terminal _(ex: Git Bash, WSL)_. Also, keep the `ghdl_run.sh` file is in the same working directory.

- **Step 1:** Add **all newly created** `.vhdl` files to the `ghdl_run.sh` file.
  
- **Step 2:** Run the `ghdl_run.sh` file
  ```powershell
  ./ghdl_run.sh
  ```

---
