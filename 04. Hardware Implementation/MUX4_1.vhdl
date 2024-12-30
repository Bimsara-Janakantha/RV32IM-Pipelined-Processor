-- Create by BG
-- Created on Sun, 30 Dec 2024 at 02:00 PM
-- Last modified on Sun, 30 Dec 2024 at 02:30 PM
-- This is the module for 32 bit 4:1 Multiplexer unit


--------------------------------------------------------------------
--                    32-bit 4:1 MULTIPLEXER                      --
--------------------------------------------------------------------
-- A MUXLTIPLEXER with 4 input streams and 1 output stream.       --
-- Each input and output stream is 32 bit wide.                   --
-- There is a 2-bit selector to switch between the input streams. --
--------------------------------------------------------------------


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;

-- Entity (module)
entity mux4_1 is
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        input_3   : in std_logic_vector (31 downto 0);
        input_4   : in std_logic_vector (31 downto 0);
        selector  : in std_logic_vector (1 downto 0);
        output_1  : out std_logic_vector (31 downto 0) -- No ; here
    );
end mux4_1;

-- Architecture of the entity (module) - This implies how it would be working
architecture MUX_Architecture of mux4_1 is
begin 
    
    -- Process starts (sequential block)
    process(input_1, input_2, input_3, input_4, selector)
    begin
        case( selector ) is
            -- Case 1: If selector == "00" then output is input_1
            when "00" =>
                output_1 <= input_1;
                
            -- Case 2: If selector == "01" then output is input_2
            when "01" =>
                output_1 <= input_2;

            -- Case 3: If selector == "10" then output is input_3
            when "10" =>
                output_1 <= input_3;

            -- Case 4: If selector == "11" then output is input_4
            when "11" =>
                output_1 <= input_4;
        
            -- Default Case: Set output to HIGH IMPEDENCE
            when others =>
                output_1 <= (others => 'Z');
        
        end case ;
        
    end process;

end architecture;