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
-- 4. ADDER         5. SLL                          --
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
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component orer
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component xorer
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component adder
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component shifter
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;
  

  -- signals
  signal rs1, rs2, anderOutput, orOutput, xorOutput, adderOutput, shiftOutput : std_logic_vector (31 downto 0);

  
begin
  ------------------- Port Mapping -------------------
  AND_operator : ander 
    port map(
      DATA1 => rs1, 
      DATA2 => rs2, 
      RESULT => anderOutput
    );

  OR_operator : orer 
    port map(
      DATA1 => rs1, 
      DATA2 => rs2, 
      RESULT => orOutput
    );

  XOR_operator : xorer 
    port map(
      DATA1 => rs1, 
      DATA2 => rs2, 
      RESULT => xorOutput
    );

  ADD_operator : adder
    port map(
      DATA1 => rs1, 
      DATA2 => rs2, 
      RESULT => adderOutput
    );

  SHIFT_operator : shifter
    port map(
      DATA1 => rs1, 
      DATA2 => rs2, 
      RESULT => shiftOutput
    );
 
  -- Process(es)
  process 
  begin
    -- Test case 1 : All bits zero
    rs1 <= "00000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000001";
    wait for 10 ns;

    -- Test case 2: All bits one
    rs1 <= "00000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000010";
    wait for 10 ns;

    -- Test case 3: Alternating bits
    rs1 <= "00000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000011";
    wait for 10 ns;

    -- Test case 4: Mixed patterns
    rs1 <= "00000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000100";
    wait for 10 ns;

    -- Test case 5: Random patterns
    rs1 <= "00000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000101";
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end architecture ;