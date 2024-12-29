-- Create by BG
-- Created on Sun, 29 Dec 2024 at 11:00 AM
-- Last modified on Sun, 29 Dec 2024 at 11:37 AM
-- This is the module for 32 bit OR unit


----------------------------------------------------------
--               32-bit 2-input OR Gate                 --
----------------------------------------------------------
-- An OR Gate with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.         --
----------------------------------------------------------


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;

-- Entity (module)
entity orer is
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
end orer;

-- Architecture of the entity (module) - This implies how it would be working
architecture OR_Architecture of orer is
begin 
    output_1 <= input_1 or input_2;
end architecture;