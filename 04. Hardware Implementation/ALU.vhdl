-- Create by BG
-- Created on Sun, 29 Dec 2024 at 01:00 AM
-- Last modified on Tue, 31 Dec 2024 at 11:30 PM
-- This is the module for 32 bit Arithmetic Logic Unit (ALU)


------------------------------------------------------
--          32-bit Arithmetic Logic unit            --
------------------------------------------------------
-- An ALU with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.     --
-- Containing Modules:                              --
-- 1. AND           2. OR           3. XOR          --
-- 4. ADDER         5. SLL          6. SRL          --
-- 7. SRA           8. SLT          9. SLTU         --
--10. SUB          11. FWD                          --
------------------------------------------------------


-----------------
-- ALUOP CODES --
-----------------
-- 0000 - ADD  --
-- 0001 - SUB  --
-- 0010 - SLL  --
-- 0011 - SLT  --
-- 0100 - SLTU --
-- 0101 - XOR  --
-- 0110 - SRL  --
-- 0111 - SRA  --
-- 1000 - OR   --
-- 1001 - AND  --
-----------------

-- NOTE: Time Unit = 10 ns

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU Entity 
entity ALU is
  port(
    DATA1     : in std_logic_vector (31 downto 0);
    DATA2     : in std_logic_vector (31 downto 0);
    ALUOP     : in std_logic_vector (3 downto 0);
    ALURESULT : out std_logic_vector (31 downto 0);
    ZERO      : out std_logic
  );
end ALU; 

-- Architecture of the ALU
architecture ALU_Architecture of ALU is

  -- Components of the ALU
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

  component SetLessThanUnsigned
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component Complementer2s is
    port(
        input_data  : in std_logic_vector (31 downto 0);
        output_data : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  component mux2_1 is
    port(
        input_1  : in std_logic_vector (31 downto 0);
        input_2  : in std_logic_vector (31 downto 0);
        selector : in std_logic;
        output_1 : out std_logic_vector (31 downto 0) -- No ; here
    );
  end component;


  -- Signals 
  signal andOutput, orOutput, xorOutput, adderOutput, shiftOutput, sltOutput, sltuOutput, compOutput, muxOutput : std_logic_vector (31 downto 0);
  signal shiftType : std_logic_vector (1 downto 0);
  signal muxSelect : std_logic;
  
begin
  ------------------- Port Mapping -------------------
  AND_operator : ander 
    port map(
      input_1  => DATA1, 
      input_2  => DATA2, 
      output_1 => andOutput
    );

  OR_operator : orer 
    port map(
      input_1  => DATA1, 
      input_2  => DATA2, 
      output_1 => orOutput
    );

  XOR_operator : xorer 
    port map(
      input_1  => DATA1, 
      input_2  => DATA2, 
      output_1 => xorOutput
    );

  Complementor : Complementer2s
    port map(
      input_data  => DATA2,
      output_data => compOutput
    );

  MUX : mux2_1
    port map(
      input_1  => DATA2,
      input_2  => compOutput,
      selector => muxSelect,
      output_1 => muxOutput
    );

  ADD_operator : adder
    port map(
      input_1  => DATA1, 
      input_2  => muxOutput, 
      output_1 => adderOutput
    );

  SHIFT_operator : shifter
    port map(
      input_1   => DATA1, 
      input_2   => DATA2, 
      shiftType => shiftType,
      output_1  => shiftOutput
    );

  SLT_operator : SetLessThan
    port map(
      input_1  => DATA1, 
      input_2  => DATA2, 
      output_1 => sltOutput
    );

  SLTU_operator : SetLessThanUnsigned
    port map(
      input_1  => DATA1, 
      input_2  => DATA2, 
      output_1 => sltuOutput
    );

  
  -- Process(es)
  process( ALUOP, andOutput, orOutput, xorOutput, adderOutput, shiftOutput, sltOutput, sltuOutput )
  begin
    case( ALUOP ) is
      
      when "0000" => -- ADD Instructions
        muxSelect <= '0';
        ALURESULT <= adderOutput after 20 ns;

      when "0001" => -- SUB Instructions
        muxSelect <= '1';
        ALURESULT <= adderOutput after 30 ns;
      
      when "0010" => -- SLL Instruction
        shiftType <= "00";       -- Direction = left , extender = 0 => 00
        ALURESULT <= shiftOutput after 20 ns;
      
      when "0011" => -- SLT Instructions
        ALURESULT <= sltOutput after 20 ns;

      when "0100" => -- SLTU Instructions
        ALURESULT <= sltuOutput after 20 ns;

      when "0101" => -- XOR Instructions
        ALURESULT <= xorOutput after 10 ns;
      
      when "0110" => -- SRL Instructions
        shiftType <= "10";       -- Direction = right , extender = 0 => 10
        ALURESULT <= shiftOutput after 20 ns;
      
      when "0111" => -- SRA Instructions
        shiftType <= "11";       -- Direction = right , extender = 1 => 11
        ALURESULT <= shiftOutput after 20 ns;

      when "1000" => -- OR Instructions
        ALURESULT <= orOutput after 10 ns;
      
      when "1001" => -- AND Instructions
        ALURESULT <= andOutput after 10 ns;

      -- Add more instructions here later

      when others =>
        -- Unexpected Behaviour
        ALURESULT <= (others => 'X');
        
    end case ;

    -- End simulation
    --wait;
  end process;

end architecture ;