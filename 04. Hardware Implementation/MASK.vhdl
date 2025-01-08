-- Create by BG
-- Created on Wed, 08 Jan 2025 at 06:00 AM
-- Last modified on Wed, 08 Jan 2025 at 06:37 AM
-- This is the module for 32 bit AND unit


--------------------------------------------------------------
--                   32-bit Masking Unit                    --
--------------------------------------------------------------
-- A Masking Unit with 1 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.             --
--------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

-- Entity (module)
entity MASK is
  port (
    input_data  : in std_logic_vector (31 downto 0);
    output_data : out std_logic_vector(31 downto 0)
  ) ;
end MASK ; 

-- Architecture of the entity (module) - This implies how it would be working
architecture MASK_Architecture of MASK is
    Signal masking : std_logic_vector(31 downto 0);

begin
    masking     <= std_logic_vector(not to_unsigned(3, 32));
    output_data <= input_data and masking;
end architecture ;