-- Create by BG
-- Created on Sun, 29 Dec 2024
-- Last modified on Sun, 29 Dec 2024 at 01:00 AM
-- This is the module for 32 bit Arithmetic Logic Unit (ALU)


-----------------------------------------------------------
-- alu_32bit => 32-bit Arithmetic Logic unit             --
-- An ALU with 2 input streams and 1 output stream.      --
-- Each input and output stream is 32 bit wide.          --
-----------------------------------------------------------


-- Note:
-- As a good practice use same name for the file and the entitity


-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all ;

-- Entity (for now it is empty)
entity alu_32bit is
end alu_32bit; 

-- Architecture
architecture alu of alu_32bit is

  -- Components
  component and2_32bit 
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  -- signals
  signal REGOUT1, REGOUT2, ALURESULT : std_logic_vector (31 downto 0);

  
begin
  and_gate : and2_32bit port map(DATA1 => REGOUT1, DATA2 => REGOUT2, RESULT => ALURESULT);

  -- Process(es)
  process 
  begin
    -- Test case 1 : All bits zero
    REGOUT1 <= (others => '0');
    REGOUT2 <= (others => '0');
    wait for 10 ns;

    -- Test case 2: All bits one
    REGOUT1 <= (others => '1');
    REGOUT2 <= (others => '1');
    wait for 10 ns;

    -- Test case 3: Alternating bits
    REGOUT1 <= "10101010101010101010101010101010";
    REGOUT2 <= "01010101010101010101010101010101";
    wait for 10 ns;

    -- Test case 4: Mixed patterns
    REGOUT1 <= "11110000111100001111000011110000";
    REGOUT2 <= "00001111000011110000111100001111";
    wait for 10 ns;

    -- Test case 5: Random patterns
    REGOUT1 <= "11001100110011001100110011001100";
    REGOUT2 <= "10101010101010101010101010101010";
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end architecture ;