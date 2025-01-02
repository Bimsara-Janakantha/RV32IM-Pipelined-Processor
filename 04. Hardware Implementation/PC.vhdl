-- Create by BG
-- Created on Thu, 02 Jan 2025 at 07:54 PM
-- Last modified on Thu, 02 Jan 2025 at 08:37 PM
-- This is the Program Counter module for RV32IM Piplined Processor

----------------------------------------------------
--                 Program Counter                --
----------------------------------------------------
-- A PC with 2 input streams and 1 output stream. --
----------------------------------------------------


-- Libraries (IEEE)
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

-- PC Entity
entity ProgramCounter is
  port (
    CLK, RESET : in std_logic;
    PC : out std_logic_vector (31 downto 0)
  ) ;
end ProgramCounter ; 

-- PC Architecture
architecture PC_Architecture of ProgramCounter is
    Signal nextPC : unsigned(31 downto 0) := (others => '0');
begin
    -- Program Counter Function
    process (CLK, RESET, nextPC)
    begin
        if rising_edge(CLK) then
            if (RESET = '1') then
                -- Add wait here
                nextPC <= to_unsigned(4, nextPC'length);
                PC <= (others => '0');
                report "RESET PC!";

            else 
                nextPC <= nextPC + 4;
                PC <= std_logic_vector(nextPC);
                report "PC Updated to: " & integer'image(to_integer(nextPC));
            
            end if;

        end if;
            
    end process;

end architecture ;