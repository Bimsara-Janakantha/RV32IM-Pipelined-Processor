-- Create by BG
-- Created on Fri, 03 Jan 2025 at 08:54 AM
-- Last modified on Wed, 08 Jan 2025 at 10:37 PM
-- This is the Pipelined Register (ID/EX) module for RV32IM Piplined Processor

-------------------------------------------------------------------
--                        REGISTER ID/EX                         --
-------------------------------------------------------------------
-- The ID/EX register with 11 input streams and 9 output stream. --
-- Registers: CONTROLS, IMM, DATA1, DATA2, PC4, PC               --
-- Completed for R, I - Type Instructions                        --
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
    WriteEnable_I, MUX1_I, MUX2_I, MUX3_I, MUX4_I, Jump_I, Branch_I, MemRead_I, MemWrite_I : in std_logic;
    FUNC3_I  : in std_logic_vector (2 downto 0);
    ALUOP_I  : in std_logic_vector (3 downto 0);
    RD_I     : in std_logic_vector (4 downto 0);
    IMM_I, PC_I, PC4_I, DATA1_I, DATA2_I : in std_logic_vector (31 downto 0);

    -- Output Ports
    WriteEnable_O, MUX1_O, MUX2_O, MUX3_O, MUX4_O, Jump_O, Branch_O, MemRead_O, MemWrite_O : out std_logic;
    FUNC3_O  : out std_logic_vector (2 downto 0);
    ALUOP_O  : out std_logic_vector (3 downto 0);
    RD_O     : out std_logic_vector (4 downto 0);
    IMM_O, PC_O, PC4_O, DATA1_O, DATA2_O : out std_logic_vector (31 downto 0)
  );
end REG_ID_EX ; 

-- ID/EX Architecture
architecture ID_EX_Architecture of REG_ID_EX is
    begin
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- RESET REGISTER
                if (RESET = '1') then
                    RD_O          <= (others => '0');
                    FUNC3_O       <= (others => '0');
                    ALUOP_O       <= (others => '0');
                    WriteEnable_O <= '0';
                    MemRead_O     <= '0';
                    MemWrite_O    <= '0';
                    MUX1_O        <= '0';
                    MUX2_O        <= '0';
                    MUX3_O        <= '0';
                    MUX4_O        <= '0';
                    Branch_O      <= '0';
                    Jump_O        <= '0';
                    IMM_O         <= (others => '0');
                    PC_O          <= (others => '0');
                    PC4_O         <= (others => '0');
                    DATA1_O       <= (others => '0');
                    DATA2_O       <= (others => '0');
                
                -- Memory send to the outputs
                else
                    RD_O          <= RD_I;
                    FUNC3_O       <= FUNC3_I;
                    ALUOP_O       <= ALUOP_I;
                    WriteEnable_O <= WriteEnable_I;
                    MemRead_O     <= MemRead_I;
                    MemWrite_O    <= MemWrite_I;
                    MUX1_O        <= MUX1_I;
                    MUX2_O        <= MUX2_I;
                    MUX3_O        <= MUX3_I;
                    MUX4_O        <= MUX4_I;
                    Branch_O      <= Branch_I;
                    Jump_O        <= Jump_I;
                    IMM_O         <= IMM_I;
                    PC_O          <= PC_I;
                    PC4_O         <= PC4_I;
                    DATA1_O       <= DATA1_I;
                    DATA2_O       <= DATA2_I;

                end if;
                               
            end if;

        end process;

end architecture ;
