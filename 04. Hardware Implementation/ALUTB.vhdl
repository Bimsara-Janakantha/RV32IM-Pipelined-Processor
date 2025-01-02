-- Create by BG
-- Created on Tue, 31 Dec 2024 at 11:37 PM
-- Last modified on Tue, 31 Dec 2024 at 11:37 PM
-- This is the testbech module for 32 bit Arithmetic Logic Unit (ALU)

------------------------------------------------------
--     32-bit Arithmetic Logic unit Test Bench      --
------------------------------------------------------
-- An ALU with 3 input streams and 2 output streams.--
-- Containing Modules:                              --
-- 1. ADDER         2. SLL                          --
------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all ;

-- Entity (for now it is empty)
entity ALUTB is
end ALUTB; 

-- Architecture
architecture ALUTB_Architecture of ALUTB is
    component ALU is
        port(
          DATA1     : in std_logic_vector (31 downto 0);
          DATA2     : in std_logic_vector (31 downto 0);
          ALUOP     : in std_logic_vector (3 downto 0);
          ALURESULT : out std_logic_vector (31 downto 0);
          ZERO      : out std_logic
        );
    end component;
    
    -- signals
    signal DATA1, DATA2, ALURESULT : std_logic_vector(31 downto 0) := (others => '0');
    signal ALUOP : std_logic_vector(3 downto 0);
    signal ZERO : std_logic;
    
begin
    ------------------- Port Mapping -------------------
    ALU_Component : ALU 
      port map(
          DATA1     => DATA1,
          DATA2     => DATA2,
          ALUOP     => ALUOP,
          ALURESULT => ALURESULT,
          ZERO      => ZERO
      );

  -- Process(es)
  process 
  begin
    -- Test Case 1: AND Operation
    ALUOP <= "1000";
    DATA1 <= "00000000000000000000000000000000";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "10101010101010101010101010101010";
    DATA2 <= "01010101010101010101010101010101";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "11111111111111111111111111111111";
    wait for 40 ns;

    -- Test Case 2: OR Operation
    ALUOP <= "0111";
    DATA1 <= "00000000000000000000000000000000";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "10101010101010101010101010101010";
    DATA2 <= "01010101010101010101010101010101";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "11111111111111111111111111111111";
    wait for 40 ns;

    -- Test Case 3: XOR Operation
    ALUOP <= "0100";
    DATA1 <= "00000000000000000000000000000000";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "10101010101010101010101010101010";
    DATA2 <= "01010101010101010101010101010101";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "11111111111111111111111111111111";
    wait for 40 ns;

    -- Test Case 4: ADD Operation
    ALUOP <= "0000";
    DATA1 <= "00000000000000000000000000000000";
    DATA2 <= "00000000000000000000000000000000";
    wait for 40 ns;

    DATA1 <= "00000000000000000000000000000001";
    DATA2 <= "00000000000000000000000000000001";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111";
    DATA2 <= "00000000000000000000000000000001";
    wait for 40 ns;

    -- Test Case 5: SLT Operation
    ALUOP <= "0010";
    DATA1 <= "00000000000000000000000000000001";
    DATA2 <= "00000000000000000000000000000010";
    wait for 40 ns;

    DATA1 <= "00000000000000000000000000000010";
    DATA2 <= "00000000000000000000000000000001";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111"; -- -1 in signed
    DATA2 <= "00000000000000000000000000000000"; -- 0 in signed
    wait for 40 ns;

    DATA1 <= "10000000000000000000000000000000"; -- -2147483648
    DATA2 <= "01111111111111111111111111111111"; -- 2147483647
    wait for 40 ns;

    -- Test Case 6: SLTU Operation
    ALUOP <= "0011";
    DATA1 <= "00000000000000000000000000000001";
    DATA2 <= "00000000000000000000000000000010";
    wait for 40 ns;

    DATA1 <= "00000000000000000000000000000010";
    DATA2 <= "00000000000000000000000000000001";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111"; -- -1 in signed
    DATA2 <= "00000000000000000000000000000000"; -- 0 in signed
    wait for 40 ns;

    DATA1 <= "10000000000000000000000000000000"; -- -2147483648
    DATA2 <= "01111111111111111111111111111111"; -- 2147483647
    wait for 40 ns;

    -- Test Case 7: SLL Operation
    ALUOP <= "0001";
    DATA1 <= "00000000000000000000000000000001";
    DATA2 <= "00000000000000000000000000000010";
    wait for 40 ns;

    DATA1 <= "00000000000000000000000000000010";
    DATA2 <= "00000000000000000000000000000100";
    wait for 40 ns;

    DATA1 <= "11111111111111111111111111111111"; 
    DATA2 <= "00000000000000000000000000000001"; 
    wait for 40 ns;

    DATA1 <= "10000000000000000000000000000000"; 
    DATA2 <= "01111111111111111111111111111111"; 
    wait for 40 ns;

    -- End Simulation
    wait;
  end process;

end architecture;