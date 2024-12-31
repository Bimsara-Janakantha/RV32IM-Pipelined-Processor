-- Create by BG
-- Created on Tue, 31 Dec 2024 at 05:00 PM
-- Last modified on Tue, 31 Dec 2024 at 06:00 PM
-- This is the module for 32 bit SLT unit


------------------------------------------------------------------------
--                      32-bit 2-input SLT Unit                       --
------------------------------------------------------------------------
-- An SLT Unit with 2 input streams and 1 output stream.              --
-- Each input and output stream is 32 bit wide.                       --
-- If input_1 is less than input_2, the output will be 1, otherwise 0 --
------------------------------------------------------------------------


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Entity (module)
entity SetLessThan is
    port(
        input_1 : in std_logic_vector (31 downto 0);
        input_2 : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
end SetLessThan;

-- Architecture of the entity (module) - This implies how it would be working
architecture SLT_Architecture of SetLessThan is
begin 
    output_1 <= x"00000001" 
                    when signed(input_1) < signed(input_2)
                    else x"00000000";
end architecture;