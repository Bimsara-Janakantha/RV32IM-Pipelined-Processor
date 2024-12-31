-- Create by BG
-- Created on Tue, 31 Dec 2024 at 07:00 PM
-- Last modified on Tue, 31 Dec 2024 at 08:00 PM
-- This is the module for 32 bit SLTU unit


------------------------------------------------------------------------
--                     32-bit 2-input SLTU Unit                       --
------------------------------------------------------------------------
-- An SLTU Unit with 2 input streams and 1 output stream.             --
-- Each input and output stream is 32 bit wide.                       --
-- If input_1 is less than input_2, the output will be 1, otherwise 0 --
------------------------------------------------------------------------


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Entity (module)
entity SetLessThanUnsigned is
    port(
        input_1 : in std_logic_vector (31 downto 0);
        input_2 : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
end SetLessThanUnsigned;

-- Architecture of the entity (module) - This implies how it would be working
architecture SLTU_Architecture of SetLessThanUnsigned is
begin 
    output_1 <= x"00000001" 
                    when unsigned(input_1) < unsigned(input_2)
                    else x"00000000";
end architecture;