-- Create by BG
-- Created on Thu, 02 Jan 2025 at 06:37 PM
-- Last modified on Wed, 07 Jan 2025 at 00:37 AM
-- This is the control unit module for RV32IM Pipelined Processor

---------------------------------------------------------------
--                    Control Unit Module                    --
---------------------------------------------------------------
-- A Control Unit with 3 input streams and n output streams. --
-- Containing Control Signals:                               --
-- 1. WriteEnable - 1 bit wide                               --
-- 2. MemRead     - 1 bit wide                               --
-- 3. MemWrite    - 1 bit wide                               --
-- 4. ALUOP       - 4 bit wide                               --
-- 5. Jump        - 1 bit wide                               --
-- 6. Branch      - 1 bit wide                               --
-- 7. MUX1_EN     - 1 bit wide  - MUX for IMM DECORDER       --
-- 8. MUX2_EN     - 1 bit wide  - MUX for WriteData of Reg   --
-- 9. MUX3_EN     - 1 bit wide                               --
--10. MUX4_EN     - 1 bit wide                               --
--11. MUX5_EN     - 1 bit wide                               --
---------------------------------------------------------------

library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity CONTROL_UNIT is
  port (
    -- Input Ports   
    FUNC7, OPCODE : in std_logic_vector (6 downto 0);
    FUNC3         : in std_logic_vector (2 downto 0);

    -- Output Ports
    WriteEnable, MemRead, MemWrite, Jump, Branch, MUX1_EN, MUX2_EN, MUX3_EN, MUX4_EN, MUX5_EN : out std_logic;
    ALUOP : out std_logic_vector (3 downto 0)      
  ) ;
end CONTROL_UNIT ; 

architecture Control_Unit_Architecture of CONTROL_UNIT is
begin
    process (FUNC7, FUNC3, OPCODE)
    begin
        -- SET ALL CONTROL SIGNALS TO 0
        WriteEnable <= '0'; 
        MemRead     <= '0'; 
        MemWrite    <= '0'; 
        Jump        <= '0'; 
        Branch      <= '0'; 
        MUX1_EN     <= '0'; 
        MUX2_EN     <= '0'; 
        MUX3_EN     <= '0';
        MUX4_EN     <= '0'; 
        MUX5_EN     <= '0';
        ALUOP       <= "0000";

        -- R-Type Instructions
        if (OPCODE = "0110011") then
            case( FUNC3 ) is
                when "000" =>   -- ADD / SUB / MUL (Later) Instruction
                    if (FUNC7 = "0000000") then
                        ALUOP <= "0000";    -- ADD
                    elsif (FUNC7 = "0100000") then 
                        ALUOP <= "0001";    -- SUB
                    end if ;

                when "001" =>   -- SLL Instruction
                    ALUOP <= "0010";

                when "010" =>   -- SLT Instruction
                    ALUOP <= "0011";
                
                when "011" =>   -- SLTU Instruction
                    ALUOP <= "0100";
                
                when "100" =>   -- XOR Instruction
                    ALUOP <= "0101";

                when "101" =>   -- SRL/SRA Instruction
                    if (FUNC7 = "0000000") then
                        ALUOP <= "0110";  -- SRL 
                    elsif (FUNC7 = "0100000") then
                        ALUOP <= "0111";  -- SRA
                    end if;
                   
                when "110" =>   -- OR Instruction
                    ALUOP <= "1000";

                when "111" =>   -- AND Instruction
                    ALUOP <= "1001";

                when others =>  -- Unexpected Behaviour
                    ALUOP <= (others => 'X');
            end case ;

            WriteEnable <= '1';

        -- I-Type Load Instructions
        elsif (OPCODE = "0000011") then
            WriteEnable <= '1';
            MUX1_EN     <= '1'; -- IMM DECORDER
            MUX2_EN     <= '1'; 
            MemRead     <= '1';

        -- I-Type Arithmetic Instructions
        elsif (OPCODE = "0010011") then
            case( FUNC3 ) is            
                when "000" =>   -- ADDI Instruction
                    ALUOP <= "0000";

                when "001" =>   -- SLLI Instruction
                    ALUOP <= "0010";

                when "010" =>   -- SLTI Instruction
                    ALUOP <= "0011";

                when "011" =>   -- SLTIU Instruction
                    ALUOP <= "0100";

                when "100" =>   -- XORI Instruction
                    ALUOP <= "0101";

                when "101" =>   -- SRLI/SRAI Instruction
                    if (FUNC7 = "0000000") then
                        ALUOP <= "0110";  -- SRL 
                    elsif (FUNC7 = "0100000") then
                        ALUOP <= "0111";  -- SRA
                    end if;
                
                when "110" =>   -- ORI Instruction
                    ALUOP <= "1000";

                when "111" =>   -- ANDI Instruction
                    ALUOP <= "1001";

                when others =>  -- Unexpected Behaviour
                    ALUOP <= (others => 'X');
                            
            end case ;

            WriteEnable <= '1';
            MUX1_EN     <= '1';

        -- I-Type JALR Instruction
        elsif (OPCODE = "1100111") then
           MUX1_EN     <= '1';
           MUX3_EN     <= '1';
           MUX4_EN     <= '1';
           WriteEnable <= '1';

        -- S-Type Instructions
        elsif (OPCODE = "0100011") then
            MUX1_EN  <= '1';
            MemWrite <= '1';
        
        -- Add more later
        else
            
        end if;
    end process;

end architecture ;