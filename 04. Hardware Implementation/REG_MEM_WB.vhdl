-- Create by BG
-- Created on Sat, 04 Jan 2025 at 02:10 AM
-- Last modified on Sat, 04 Jan 2025 at 02:10 AM
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
    WriteEnable_I : in std_logic;
    RD_I          : in std_logic_vector (4 downto 0);
    ALURESULT_I   : in std_logic_vector (31 downto 0);

    -- Output Ports
    WriteEnable_O : out std_logic;
    RD_O          : out std_logic_vector (4 downto 0);
    ALURESULT_O   : out std_logic_vector (31 downto 0)
  );
end REG_MEM_WB ; 

-- MEM/WB Architecture
architecture MEM_WB_Architecture of REG_MEM_WB is
    -- Internal Registers
    Signal CONTROLS, ALURESULT : std_logic_vector (31 downto 0);
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- RESET REGISTER
                if (RESET = '1') then
                    -- RESET MEMORY
                    CONTROLS  <= (others => '0');
                    ALURESULT <= (others => '0');

                    -- RESET OUTPUTS
                    WriteEnable_O <= '0';
                    RD_O          <= (others => '0');
                    ALURESULT_O   <= (others => '0');
                
                else
                    -- Memory send to the outputs
                    WriteEnable_O <= CONTROLS(4);
                    RD_O          <= CONTROLS(31 downto 27);
                    ALURESULT_O   <= ALURESULT;

                    -- Memory update with new inputs
                    CONTROLS  <= std_logic_vector(RD_I & "0000000000000000000000" & WriteEnable_I & "0000");
                    ALURESULT <= ALURESULT_I;
                end if;
                               
            end if;

        end process;

end architecture ;
