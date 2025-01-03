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
    PC, PC4 : out std_logic_vector (31 downto 0)
  ) ;
end ProgramCounter ; 

-- PC Architecture
architecture PC_Architecture of ProgramCounter is
begin
    -- Program Counter Function
    process (CLK, RESET)
        variable nextPC : unsigned(31 downto 0) := (others => '0'); -- Internal variable
    begin
        if rising_edge(CLK) then
            if (RESET = '1') then
                -- Reset Logic
                nextPC := to_unsigned(4, 32);    -- Reset nextPC to 4
                PC  <= (others => '0');          -- Reset output PC
                PC4 <= std_logic_vector(nextPC); -- Reset output PC4
                report "RESET PC!" severity note;
            else
                -- Normal Operation
                PC     <= std_logic_vector(nextPC);
                nextPC := nextPC + 4;
                PC4    <= std_logic_vector(nextPC);
                report "PC Updated to: " & integer'image(to_integer(nextPC)) severity note;
            end if;
        end if;
    end process;


end architecture ;