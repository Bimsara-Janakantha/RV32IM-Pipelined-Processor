-- Create by BG
-- Created on Sun, 29 Dec 2024 at 10:00 PM
-- Last modified on Sun, 29 Dec 2024 at 11:00 PM
-- This is the module for 32 bit 2:1 Multiplexer unit


--------------------------------------------------------------
--                 32-bit 2:1 MULTIPLEXER                   --
--------------------------------------------------------------
-- A MUXLTIPLEXER with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.             --
-- There is a selector to switch between the input streams. --
--------------------------------------------------------------


-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;

-- Entity (module)
entity mux2_1 is
    port(
        input_1  : in std_logic_vector (31 downto 0);
        input_2  : in std_logic_vector (31 downto 0);
        selector : in std_logic;
        output_1 : out std_logic_vector (31 downto 0) -- No ; here
    );
end mux2_1;

-- Architecture of the entity (module) - This implies how it would be working
architecture MUX_Architecture of mux2_1 is
begin 
    
    -- Process starts (sequential block)
    process(input_1, input_2, selector)
    begin
        case( selector ) is
            -- Case 1: If selector == '0' then output is input_1
            when '0' =>
                output_1 <= input_1;
                
            -- Case 2: If selector == '1' then output is input_2
            when '1' =>
                output_1 <= input_2;
        
            -- Default Case: Set output to HIGH IMPEDENCE
            when others =>
                output_1 <= (others => 'Z');
        
        end case ;
        
    end process;

end architecture;