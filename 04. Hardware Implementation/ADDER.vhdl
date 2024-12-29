-- Create by BG
-- Created on Sun, 29 Dec 2024 at 01:00 PM
-- Last modified on Sun, 29 Dec 2024 at 04:37 PM
-- This is the module for 32-bit ADDER unit


----------------------------------------------------------------
--              32-bit 2-input unsigned ADDER                 --
----------------------------------------------------------------
-- A unsigned ADDER with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bits wide.              --
-- Use 2's complement input streams.                          --
-- This is a simple adder that only adds two input streams.   --
----------------------------------------------------------------


-- Libraries (IEEE)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity (module)
entity adder is
    port(
        input_1   : in  std_logic_vector(31 downto 0);  -- First 32-bit signed input
        input_2   : in  std_logic_vector(31 downto 0);  -- Second 32-bit signed input
        output_1  : out std_logic_vector(31 downto 0)   -- 32-bit signed output
    );
end adder;

-- Architecture of the entity (module) - Defines its behavior
architecture ADDER_Architecture of adder is
begin
    output_1 <= std_logic_vector(unsigned(input_1) + unsigned(input_2));
end ADDER_Architecture;
