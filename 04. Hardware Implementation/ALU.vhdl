-- Create by BG
-- Created on Sun, 29 Dec 2024 at 01:00 AM
-- Last modified on Sun, 29 Dec 2024 at 12:30 PM
-- This is the module for 32 bit Arithmetic Logic Unit (ALU)


------------------------------------------------------
--          32-bit Arithmetic Logic unit            --
------------------------------------------------------
-- An ALU with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.     --
-- Containing Modules:                              --
-- 1. AND           2. OR           3. XOR          --
-- 4. ADDER                                         --
------------------------------------------------------



-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all ;

-- Entity (for now it is empty)
entity ALU is
end ALU; 

-- Architecture
architecture ALU_Architecture of ALU is

  -- Components
  component ander
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component orer
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component xorer
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component adder
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;
  

  -- signals
  signal rs1, rs2, anderOutput, orOutput, xorOutput, adderOutput : std_logic_vector (31 downto 0);

  
begin
  ------------------- Port Mapping -------------------
  AND_operator : ander 
    port map(
      input_1 => rs1, 
      input_2 => rs2, 
      output_1 => anderOutput
    );

  OR_operator : orer 
    port map(
      input_1 => rs1, 
      input_2 => rs2, 
      output_1 => orOutput
    );

  XOR_operator : xorer 
    port map(
      input_1 => rs1, 
      input_2 => rs2, 
      output_1 => xorOutput
    );

  ADD_operator : adder
    port map(
      input_1 => rs1, 
      input_2 => rs2, 
      output_1 => adderOutput
    );
 
  -- Process(es)
  process 
  begin
    -- Test case 1 : All bits zero
    rs1 <= (others => '0');
    rs2 <= (others => '0');
    wait for 10 ns;

    -- Test case 2: All bits one
    rs1 <= (others => '1');
    rs2 <= (others => '1');
    wait for 10 ns;

    -- Test case 3: Alternating bits
    rs1 <= "10101010101010101010101010101010";
    rs2 <= "01010101010101010101010101010101";
    wait for 10 ns;

    -- Test case 4: Mixed patterns
    rs1 <= "11110000111100001111000011110000";
    rs2 <= "00001111000011110000111100001111";
    wait for 10 ns;

    -- Test case 5: Random patterns
    rs1 <= "11001100110011001100110011001100";
    rs2 <= "10101010101010101010101010101010";
    wait for 10 ns;

    -- Test cases for adder testing
    
    -- Test Case 1: Add two small numbers
    rs1 <= x"00000005";
    rs2 <= x"00000003";
    wait for 10 ns;

    -- Test Case 2: Add two large numbers (overflow case)
    rs1 <= x"FFFFFFFF";
    rs2 <= x"00000001";
    wait for 10 ns;

    -- Test Case 3: Add zero and a number
    rs1 <= x"00000000";
    rs2 <= x"12345678";
    wait for 10 ns;

    -- Test Case 4: Add two random numbers
    rs1 <= x"ABCDEF01";
    rs2 <= x"12345678";
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end architecture ;