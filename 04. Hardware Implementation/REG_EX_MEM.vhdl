-- Create by BG
-- Created on Fri, 03 Jan 2025 at 08:54 PM
-- Last modified on Wed, 08 Jan 2025 at 08:37 AM
-- This is the Pipelined Register (EX/MEM) module for RV32IM Piplined Processor

-------------------------------------------------------------------
--                        REGISTER EX/MEM                        --
-------------------------------------------------------------------
-- The EX/MEM register with 6 input streams and 4 output stream. --
-- Registers: CONTROLS, ALURESULT                                --
-- Completed for R,I,S-Type Instructions                         --
-------------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

-- EX/MEM Entity
entity REG_EX_MEM is
  port (
    -- Signal Ports
    RESET, CLK  : in std_logic;

    -- Input Ports
    WriteEnable_I, MUX2_I, MemRead_I, MemWrite_I : in std_logic;
    RD_I        : in std_logic_vector (4 downto 0);
    FUNC3_I      : in std_logic_vector (2 downto 0);
    ALURESULT_I, MemDataInput_I  : in std_logic_vector (31 downto 0);

    -- Output Ports
    WriteEnable_O, MUX2_O, MemRead_O, MemWrite_O : out std_logic;
    RD_O         : out std_logic_vector (4 downto 0);
    FUNC3_O      : out std_logic_vector (2 downto 0);
    ALURESULT_O, MemDataInput_O  : out std_logic_vector (31 downto 0)
  );
end REG_EX_MEM ; 

-- EX/MEM Architecture
architecture EX_MEM_Architecture of REG_EX_MEM is
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- RESET REGISTER
                if (RESET = '1') then
                    WriteEnable_O  <= '0';
                    MUX2_O         <= '0'; 
                    MemRead_O      <= '0';
                    MemWrite_O     <= '0';
                    RD_O           <= (others => '0');
                    MemDataInput_O <= (others => '0');
                    FUNC3_O        <= (others => '0');
                    ALURESULT_O    <= (others => '0');
                
                -- Memory send to the outputs
                else
                    WriteEnable_O  <= WriteEnable_I;
                    MUX2_O         <= MUX2_I; 
                    MemRead_O      <= MemRead_I;
                    MemWrite_O     <= MemWrite_I;
                    RD_O           <= RD_I;
                    MemDataInput_O <= MemDataInput_I;
                    FUNC3_O        <= FUNC3_I;
                    ALURESULT_O    <= ALURESULT_I;

                end if;
                               
            end if;

        end process;

end architecture ;
