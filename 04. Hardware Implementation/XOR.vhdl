-- Create by BG
-- Created on Sun, 29 Dec 2024 at 12:00 PM
-- Last modified on Sun, 29 Dec 2024 at 12:30 PM
-- This is the module for 32 bit XOR unit


-----------------------------------------------------------
--              32-bit 2-input XOR Gate                  --
-----------------------------------------------------------
-- An XOR Gate with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.          --
-----------------------------------------------------------


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;

-- Entity (module)
entity xorer is
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
end xorer;

-- Architecture of the entity (module) - This implies how it would be working
architecture XOR_Architecture of xorer is
begin 
    RESULT <= DATA1 xor DATA2;
end architecture;