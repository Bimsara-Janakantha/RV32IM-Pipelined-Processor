# T01_HelloWorld

---

## Ownership Notice

- Created by BG
- Created on 2024-12-28
- Last modified on 2024-12-28

---

## About

- This is the my 1st program with VHDL.
- This is use to print simple "Hello World!" text in the command line.
- This is running on the **VS Code** with **GHDL** and **GTKWave**.

---

## How to run the program

- **Step 1:** Go to the actual directory

  > cd <directory_name>

- **Step 2:** Analyze the file

  > ghdl -a <file*name>.vhdl<br> \_ex: ghdl -a T01_HelloWorld.vhdl*

- **Step 3:** Execute the program

  > ghdl -e <entity*name><br> \_ex: ghdl -e T01_HelloWorldTb*

- **Step 4:** Run the program

  > ghdl -r <entity*name><br> ex: \_ghdl -r T01_HelloWorldTb*

### Alternative Way: Using ghdl_run.sh File

**Note:** Use lynux base terminal _(ex: Git Bash, WSL)_. Also keep the ghdl_run.sh file in the working directory

- **Step 1:** Enable execution of ghdl_run.sh file

  > chmod +x ghdl_runner.sh

- **Step 2:** Run the ghdl_run.sh file
  > ./ghdl*run.sh <file_name> <entity_name> <br> \_ex: ./ghdl_start.sh T01_HelloWorld T01_HelloWorldTb*

---

## Reference

credits for the actual creator
[![Watch the video](https://img.youtube.com/vi/h4ZXge1BE80/maxresdefault.jpg)](https://youtu.be/h4ZXge1BE80)

### [Watch the full video on YouTube](https://youtu.be/h4ZXge1BE80)
