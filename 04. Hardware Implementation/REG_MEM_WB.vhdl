-- Create by BG
-- Created on Sat, 04 Jan 2025 at 02:10 AM
-- Last modified on Wed, 08 Jan 2025 at 01:40 AM
-- This is the Pipelined Register (MEM/WB) module for RV32IM Piplined Processor

-------------------------------------------------------------------
--                        REGISTER MEM/WB                        --
-------------------------------------------------------------------
-- The MEM/WB register with 5 input streams and 3 output stream. --
-- Registers: CONTROLS, ALURESULT                                --
-- Completed for R-Type Instructions                             --
-------------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

-- MEM/WB Entity
entity REG_MEM_WB is
  port (
    -- Signal Ports
    RESET, CLK  : in std_logic;

    -- Input Ports
    WriteEnable_I, MUX2_I : in std_logic;
    RD_I          : in std_logic_vector (4 downto 0);
    ALURESULT_I, MEMOUT_I : in std_logic_vector (31 downto 0);

    -- Output Ports
    WriteEnable_O, MUX2_O : out std_logic;
    RD_O          : out std_logic_vector (4 downto 0);
    ALURESULT_O, MEMOUT_O : out std_logic_vector (31 downto 0)
  );
end REG_MEM_WB ; 

-- MEM/WB Architecture
architecture MEM_WB_Architecture of REG_MEM_WB is
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- RESET REGISTER
                if (RESET = '1') then
                    WriteEnable_O <= '0';
                    MUX2_O        <= '0';
                    RD_O          <= (others => '0');
                    ALURESULT_O   <= (others => '0');
                    MEMOUT_O      <= (others => '0');
                
                -- Memory send to the outputs
                else
                    WriteEnable_O <= WriteEnable_I;
                    MUX2_O        <= MUX2_I;
                    RD_O          <= RD_I;
                    ALURESULT_O   <= ALURESULT_I;
                    MEMOUT_O      <= MEMOUT_I;

                end if;
                               
            end if;

        end process;

end architecture ;
