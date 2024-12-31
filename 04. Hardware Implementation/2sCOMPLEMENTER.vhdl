-- Create by BG
-- Created on Tue, 31 Dec 2024 at 08:00 PM
-- Last modified on Tue, 31 Dec 2024 at 09:00 PM
-- This is the module for 32 bit 2's Complement unit


-------------------------------------------------------------------
--                  32-bit 2's complementor                      --
-------------------------------------------------------------------
-- An 2's complementor with 1 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.                  --
-------------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity (module)
entity Complementer2s is
    port(
        input_data  : in std_logic_vector (31 downto 0);
        output_data : out std_logic_vector (31 downto 0)    -- No ; here
    );
end Complementer2s;

-- Architecture of the entity (module) - This implies how it would be working
architecture Comp_Architecture of Complementer2s is
begin
    output_data <= std_logic_vector(signed(not input_data) + 1);
end architecture;