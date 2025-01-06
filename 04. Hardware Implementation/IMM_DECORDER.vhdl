-- Create by BG
-- Created on Mon, 06 Jan 2025 at 08:00 PM
-- Last modified on Mon, 06 Jan 2025 at 08:37 PM
-- This is the module for 32 bit immidiate instruction decorder


---------------------------------------------------------------------------------
--                  32-bit Immidiate Instruction Decorder                      --
---------------------------------------------------------------------------------
-- An Immidiate Instruction Decorder with 1 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.                                --
---------------------------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;


-- IMM_DECORDER Entity
entity IMM_DECORDER is
  port (
    INSTRUCTION : in std_logic_vector(31 downto 0);
    IMM_OUTPUT  : out std_logic_vector(31 downto 0);
  ) ;
end IMM_DECORDER ; 


-- IMM_DECORDER Architecture
architecture IMM_DECORDER_Architecture of IMM_DECORDER is

begin

    process(INSTRUCTION)
        variable EXTENSION : std_logic_vector(31 downto 0);
    begin
        -- I Type Instruction - Category 1
        if (INSTRUCTION(6 downto 0) = "0000011") then
            EXTENSION := (others => INSTRUCTION(31));
            IMM_OUTPUT <= EXTENSION(31 downto 11) & INSTRUCTION(30 downto 20);

        -- I Type Instruction - Category 2
        elsif (INSTRUCTION(6 downto 0) = "0010011") then 
            EXTENSION := (others => INSTRUCTION(31));
            IMM_OUTPUT <= EXTENSION(31 downto 11) & INSTRUCTION(30 downto 20);

        -- I Type Instruction - Category 3
        elsif (INSTRUCTION(6 downto 0) = "1100111") then 
            EXTENSION := (others => INSTRUCTION(31));
            IMM_OUTPUT <= EXTENSION(31 downto 11) & INSTRUCTION(30 downto 20);

        -- S Type Instruction
        elsif (INSTRUCTION(6 downto 0) = "0100011") then 
            EXTENSION := (others => INSTRUCTION(31));
            IMM_OUTPUT <= EXTENSION(31 downto 12) & INSTRUCTION(31 downto 25) & INSTRUCTION(11 downto 7);

        -- B Type Instruction
        elsif (INSTRUCTION(6 downto 0) = "1100111") then 
            EXTENSION := (others => INSTRUCTION(31));
            IMM_OUTPUT <= EXTENSION(31 downto 12) & INSTRUCTION(31 downto 25) & INSTRUCTION(11 downto 7);
        

        end if ;







    end process;

end architecture ;