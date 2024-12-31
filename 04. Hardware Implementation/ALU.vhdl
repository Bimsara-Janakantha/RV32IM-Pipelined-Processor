-- Create by BG
-- Created on Sun, 29 Dec 2024 at 01:00 AM
-- Last modified on Sun, 30 Dec 2024 at 10:00 PM
-- This is the module for 32 bit Arithmetic Logic Unit (ALU)


------------------------------------------------------
--          32-bit Arithmetic Logic unit            --
------------------------------------------------------
-- An ALU with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.     --
-- Containing Modules:                              --
-- 1. AND           2. OR           3. XOR          --
-- 4. ADDER         5. SLL          6. SRL          --
-- 7. SRA           8. SLT                          --
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
        input_1  : in std_logic_vector (31 downto 0);
        input_2  : in std_logic_vector (31 downto 0);
        output_1 : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component orer
    port(
        input_1  : in std_logic_vector (31 downto 0);
        input_2  : in std_logic_vector (31 downto 0);
        output_1 : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component xorer
    port(
        input_1  : in std_logic_vector (31 downto 0);
        input_2  : in std_logic_vector (31 downto 0);
        output_1 : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component adder
    port(
        input_1  : in std_logic_vector (31 downto 0);
        input_2  : in std_logic_vector (31 downto 0);
        output_1 : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component shifter
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        shiftType : in std_logic_vector (1 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component SetLessThan
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;
  

  -- signals
  signal rs1, rs2 : std_logic_vector(31 downto 0) := (others => '0');
  signal anderOutput, orOutput, xorOutput, adderOutput, shiftOutput, sltOutput : std_logic_vector (31 downto 0);

  
begin
  ------------------- Port Mapping -------------------
  AND_operator : ander 
    port map(
      input_1  => rs1, 
      input_2  => rs2, 
      output_1 => anderOutput
    );

  OR_operator : orer 
    port map(
      input_1  => rs1, 
      input_2  => rs2, 
      output_1 => orOutput
    );

  XOR_operator : xorer 
    port map(
      input_1  => rs1, 
      input_2  => rs2, 
      output_1 => xorOutput
    );

  ADD_operator : adder
    port map(
      input_1  => rs1, 
      input_2  => rs2, 
      output_1 => adderOutput
    );

  SHIFT_operator : shifter
    port map(
      input_1   => rs1, 
      input_2   => rs2, 
      shiftType => "00",
      output_1  => shiftOutput
    );

  SLT_operator : SetLessThan
    port map(
      input_1  => rs1, 
      input_2  => rs2, 
      output_1 => sltOutput
    );
 
  -- Process(es)
  process 
  begin
    -- Test case 1 : All bits zero
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000001";
    wait for 10 ns;

    -- Test case 2: All bits one
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000010";
    wait for 10 ns;

    -- Test case 3: Alternating bits
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000011";
    wait for 10 ns;

    -- Test case 4: Mixed patterns
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000000100";
    wait for 10 ns;

    -- Test case 5: Random patterns
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000011110";
    wait for 10 ns;
    
    -- Test case 5: Random patterns
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000011111";
    wait for 10 ns;

    -- Test case 6: Random patterns
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00000000000000000000000000100000";
    wait for 10 ns;

    -- Test case 7: Random patterns
    rs1 <= "10000000000001000000000000000001";
    rs2 <= "00010000000000000000000000000101";
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end architecture ;