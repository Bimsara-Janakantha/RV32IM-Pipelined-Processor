-- Create by BG
-- Created on Fri, 03 Jan 2025 at 08:54 AM
-- Last modified on Fri, 03 Jan 2025 at 09:37 AM
-- This is the Pipelined Register (ID/EX) module for RV32IM Piplined Processor

-------------------------------------------------------------------
--                        REGISTER ID/EX                         --
-------------------------------------------------------------------
-- The ID/EX register with 11 input streams and 9 output stream. --
-- Registers: CONTROLS, IMM, DATA1, DATA2, PC4, PC               --
-- Completed for R-Type Instructions                             --
-------------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

-- ID/EX Entity
entity REG_ID_EX is
  port (
    -- Signal Ports
    RESET, CLK  : in std_logic;

    -- Input Ports
    WriteEnable_I : in std_logic;
    FUNC3_I       : in std_logic_vector (2 downto 0);
    ALUOP_I       : in std_logic_vector (3 downto 0);
    RD_I          : in std_logic_vector (4 downto 0);
    IMM_I, PC_I, PC4_I, DATA1_I, DATA2_I : in std_logic_vector (31 downto 0);

    -- Output Ports
    WriteEnable_O : out std_logic;
    FUNC3_O       : out std_logic_vector (2 downto 0);
    ALUOP_O       : out std_logic_vector (3 downto 0);
    RD_O          : out std_logic_vector (4 downto 0);
    IMM_O, PC_O, PC4_O, DATA1_O, DATA2_O : out std_logic_vector (31 downto 0)
  );
end REG_ID_EX ; 

-- ID/EX Architecture
architecture ID_EX_Architecture of REG_ID_EX is
    -- Internal Registers
    Signal IMM, PC, PC4, DATA1, DATA2, CONTROLS : std_logic_vector (31 downto 0);
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- RESET REGISTER
                if (RESET = '1') then
                    -- RESET MEMORY
                    CONTROLS <= (others => '0');
                    IMM      <= (others => '0');
                    PC       <= (others => '0');
                    PC4      <= (others => '0');
                    DATA1    <= (others => '0');
                    DATA2    <= (others => '0');

                    -- RESET OUTPUTS
                    RD_O          <= (others => '0');
                    FUNC3_O       <= (others => '0');
                    ALUOP_O       <= (others => '0');
                    WriteEnable_O <= '0';
                    IMM_O         <= (others => '0');
                    PC_O          <= (others => '0');
                    PC4_O         <= (others => '0');
                    DATA1_O       <= (others => '0');
                    DATA2_O       <= (others => '0');
                
                else
                    -- Memory send to the outputs
                    RD_O          <= CONTROLS(31 downto 27);
                    FUNC3_O       <= CONTROLS(26 downto 24);
                    ALUOP_O       <= CONTROLS(3 downto 0);
                    WriteEnable_O <= CONTROLS(4);
                    IMM_O         <= IMM;
                    PC_O          <= PC;
                    PC4_O         <= PC4;
                    DATA1_O       <= DATA1;
                    DATA2_O       <= DATA2;

                    -- Memory update with new inputs
                    CONTROLS <= std_logic_vector(RD_I & FUNC3_I & "0000000000000000000" & WriteEnable_I & ALUOP_I);
                    IMM      <= IMM_I;
                    PC       <= PC_I;
                    PC4      <= PC4_I;
                    DATA1    <= DATA1_I;
                    DATA2    <= DATA2_I;
                end if;
                               
            end if;

        end process;

end architecture ;
