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

- **Step 1:** Go to the actual directory<br>

  > cd <directory_name>

- **Step 2:** analyse the file

  > ghdl -a <filename>.vhdl
  > _ex: ghdl -a T01_HelloWorld.vhdl_

- **Step 3:** execute the program

  > ghdl -e <entity*name>
  > \_ex: ghdl -e T01_HelloWorldTb*

- **Step 4:** run the program
  > ghdl -r <entity*name>
  > \_ex: ghdl -r T01_HelloWorldTb*
