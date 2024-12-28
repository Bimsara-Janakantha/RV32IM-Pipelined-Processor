# T02_WaitFor

---

## Ownership Notice

- Created by BG
- Created on 2024-12-28
- Last modified on 2024-12-28

---

## About

- This is my 2nd program with VHDL
- This is used to study the behaviour of the wait keyword in VHDL. 
- This is running on the **VS Code** with **GHDL** and **GTKWave**.
- The syntax of the Wait For statement is:
  > wait for [time_value] [time_unit];

- The default time value is femtoseconds (fs), but we can specify another time base.
- The possible time values are:
   > femtoseconds (fs) <br>
   > picoseconds (ps) <br>
   > nanoseconds (ns) <br>
   > microseconds (us) <br>
   > milliseconds (ms) <br>
   > seconds (sec) <br>
   > minutes (min) <br>
   > hours (hr) <br>

---

## How to run the program

### Method 01

- **Step 1:** Go to the actual directory
  > cd <directory_name>

- **Step 2:** Analyze the file
  > ghdl -a <file_name>.vhdl<br> ex: _ghdl -a T02_WaitForTb.vhdl_

- **Step 3:** Execute the program
  > ghdl -e <entity_name><br> ex: _ghdl -e T02_WaitForTb_

- **Step 4:** Run the program
  > ghdl -r <entity_name><br> ex: _ghdl -r T02_WaitForTb_<br>


### Method 02: Using ghdl_run.sh File

**Note:** Use lynux base terminal _(ex: Git Bash, WSL)_. Also, keep the **ghdl_run.sh** file is in the same working directory.

- **Step 1:** Enable execution of ghdl_run.sh file
  > chmod +x ghdl_run.sh

- **Step 2:** Run the ghdl_run.sh file
  > ./ghdl_run.sh <file_name> <entity_name> <br> ex: _./ghdl_run.sh T02_WaitForTb T02_WaitForTb_

---

## Reference

credits for the actual creator
[![Watch the video](https://img.youtube.com/vi/EoiqKxaJs18/maxresdefault.jpg)](https://youtu.be/EoiqKxaJs18)

### [Watch the full video on YouTube](https://youtu.be/EoiqKxaJs18)
