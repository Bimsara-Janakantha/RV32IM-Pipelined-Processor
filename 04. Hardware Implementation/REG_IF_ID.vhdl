-- Create by BG
-- Created on Fri, 03 Jan 2025 at 07:54 AM
-- Last modified on Fri, 03 Jan 2025 at 08:37 AM
-- This is the Pipelined Register (IF/ID) module for RV32IM Piplined Processor

------------------------------------------------------------------
--                        REGISTER IF/ID                        --
------------------------------------------------------------------
-- The IF/ID register with 3 input streams and 3 output stream. --
-- Registers: INSTRUCTION, PC4, PC                              --
-- Completed For R-Type, I-Type                                 --
------------------------------------------------------------------

-- Libraries (IEEE)
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- IF/ID Entity
entity REG_IF_ID is
  port (
    INSTRUCTION_I, PC_I, PC4_I : in std_logic_vector (31 downto 0);
    RESET, CLK                 : in std_logic;
    INSTRUCTION_O, PC_O, PC4_O : out std_logic_vector (31 downto 0)
  ) ;
end REG_IF_ID ; 

-- IF/ID Architecture
architecture IF_ID_Architecture of REG_IF_ID is
    --Signal INSTRUCTION, PC, PC4 : std_logic_vector(31 downto 0);
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- RESET REGISTER
                if (RESET = '1') then
                    -- Delete this later
                    -- RESET MEMORY
                    --INSTRUCTION   <= (others => '0');
                    --PC            <= (others => '0');
                    --PC4           <= (others => '0');

                    -- RESET OUTPUTS
                    INSTRUCTION_O <= (others => '0');
                    PC_O          <= (others => '0');
                    PC4_O         <= (others => '0');
                
                else
                    -- Memory send to the outputs
                    INSTRUCTION_O <= INSTRUCTION_I;
                    PC_O          <= PC_I;
                    PC4_O         <= PC4_I;

                    -- We will delete this section later
                    -- Memory update with new inputs
                    --INSTRUCTION <= INSTRUCTION_I;
                    --PC          <= PC_I;
                    --PC4         <= PC4_I;
                end if;
                               
            end if;

        end process;

end architecture ;
