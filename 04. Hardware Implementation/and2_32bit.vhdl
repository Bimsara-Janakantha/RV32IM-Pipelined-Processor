-- Create by BG
-- Created on Sun, 29 Dec 2024
-- Last modified on Sun, 29 Dec 2024 at 01:00 AM
-- This is the module for 32 bit AND unit


-----------------------------------------------------------
-- and2_32bit => 32-bit 2-input AND Gate                 --
-- An AND Gate with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.          --
-----------------------------------------------------------


-- Note:
-- As a good practice use same name for the file and the entitity


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;

-- Entity
entity and2_32bit is
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0);
    );
end and2_32bit;

-- Architecture 
architecture alu of and2_32bit is
begin 
    RESULT <= DATA1 and DATA2;
end architecture;