-- Create by BG
-- Created on Sun, 29 Dec 2024 at 11:00 PM
-- Last modified on Sun, 30 Dec 2024 at 10:00 PM
-- This is the module for 32 bit Shift register unit


----------------------------------------------------------
--                  32-bit SHIFT unit                   --
----------------------------------------------------------
-- An Shifter with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.         --
-- Currently work for the SLL, SRL, SRA instruction.    --
----------------------------------------------------------



-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity (for now it is empty)
entity shifter is
    port(
        DATA1     : in std_logic_vector (31 downto 0); -- Data to shift
        DATA2     : in std_logic_vector (31 downto 0); -- Shifting amount
        SHIFTTYPE : in std_logic_vector (1 downto 0);  -- Shifting type (sll-00, srl-10, sra-11)
        RESULT    : out std_logic_vector (31 downto 0) -- Final result
    );
end shifter; 

-- Architecture
architecture Shifter_Architecture of shifter is

  -- Components
  component mux4_1
    port(
      input_1  : in std_logic_vector (31 downto 0); -- 1st input stream of the mux
      input_2  : in std_logic_vector (31 downto 0); -- 2nd input stream of the mux
      input_3  : in std_logic_vector (31 downto 0); -- 3rd input stream of the mux
      input_4  : in std_logic_vector (31 downto 0); -- 4th input stream of the mux
      selector : in std_logic_vector (1 downto 0);  -- Selector switches (stream)
      output_1 : out std_logic_vector (31 downto 0) -- Output stream of the mux
    );
  end component;

  component adder
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)
    );
  end component;

  -- signals
  signal mux0Out, mux1Out, mux2Out, mux3Out, mux4Out, mux5Out : std_logic_vector (31 downto 0);        -- Output signals of Muxes
  signal mux0Sel, mux1Sel, mux2Sel, mux3Sel, mux4Sel, mux5Sel : std_logic_vector (1 downto 0);         -- Selector signals of Muxes
  signal shift_L1, shift_L2, shift_L4, shift_L8, shift_L16, shift_L32 : std_logic_vector(31 downto 0); -- Input signals for shift left
  signal shift_R1, shift_R2, shift_R4, shift_R8, shift_R16, shift_R32 : std_logic_vector(31 downto 0); -- Input signals for shift right
  
  -- Extender Signals
  signal Extender : std_logic_vector(31 downto 0);

  -- Signals for ADDER
  signal fixed, adderOut : std_logic_vector(31 downto 0);
  
begin
  -- Assigning extender values
  Extender <= (others => SHIFTTYPE(0));

  -- Fixed value for adder
  fixed <= "11111111111111111111111111100001"; -- -31 value in binary

  
  ------------------- Port Mapping For Each Component -------------------
  Mux0 : mux4_1
    port map(
      input_1  => DATA1,    -- Original data for shift left
      input_2  => shift_L1, -- Shift left by 1 bit
      input_3  => DATA1,    -- Original data for shift right
      input_4  => shift_R1, -- Shift right by 1 bit
      selector => mux0Sel,
      output_1 => mux0Out
    );

  Mux1 : mux4_1
    port map(
      input_1  => mux0Out,  -- Original data for shift left
      input_2  => shift_L2, -- Shift left by 2 bit
      input_3  => mux0Out,  -- Original data for shift right
      input_4  => shift_R2, -- Shift right by 2 bit
      selector => mux1Sel,
      output_1 => mux1Out
    );
    
  Mux2 : mux4_1
    port map(
      input_1  => mux1Out,  -- Original data for shift left
      input_2  => shift_L4, -- Shift left by 4 bit
      input_3  => mux1Out,  -- Original data for shift right
      input_4  => shift_R4, -- Shift right by 4 bit
      selector => mux2Sel,
      output_1 => mux2Out
    );
    
  Mux3 : mux4_1
    port map(
      input_1  => mux2Out,  -- Original data for shift left
      input_2  => shift_L8, -- Shift left by 8 bit
      input_3  => mux2Out,  -- Original data for shift right
      input_4  => shift_R8, -- Shift right by 8 bit
      selector => mux3Sel,
      output_1 => mux3Out
    );
  
  Mux4 : mux4_1
    port map(
      input_1  => mux3Out,   -- Original data for shift left
      input_2  => shift_L16, -- Shift left by 16 bit
      input_3  => mux3Out,   -- Original data for shift right
      input_4  => shift_R16, -- Shift right by 16 bit
      selector => mux4Sel,
      output_1 => mux4Out
    );
    
  -- Note here we change the input configuration only for Mux5
  -- Selector = "00" -> Left Direction Shift
  -- Selector = "01" -> Left Direction No Shift
  -- Selector = "10" -> Right Direction Shift
  -- Selector = "11" -> Right Direction No Shift
  Mux5 : mux4_1
    port map(
      input_1  => shift_L32, -- Shift left by 32 bit
      input_2  => mux4Out,   -- Original data for shift left
      input_3  => shift_R32, -- Shift right by 32 bit
      input_4  => mux4Out,   -- Original data for shift right
      selector => mux5Sel,
      output_1 => RESULT
    );
 

  ShiftAdder : adder
    port map(
      DATA1  => DATA2,    -- shift amount
      DATA2  => fixed,    -- (-31)
      RESULT => adderOut  -- shift_amount + (-31) => MSB > 0 ? totally_shift : partially_shift
    );

  -- Process
  process(DATA1, DATA2, mux0Out, mux1Out, mux2Out, mux3Out, mux4Out, adderOut, SHIFTTYPE)
  begin
    -- Shift Left Updates
    shift_L1  <= std_logic_vector(DATA1(30 downto 0) & Extender(0));
    shift_L2  <= std_logic_vector(mux0Out(29 downto 0) & Extender(1 downto 0));
    shift_L4  <= std_logic_vector(mux1Out(27 downto 0) & Extender(3 downto 0));
    shift_L8  <= std_logic_vector(mux2Out(23 downto 0) & Extender(7 downto 0));
    shift_L16 <= std_logic_vector(mux3Out(15 downto 0) & Extender(15 downto 0));
    shift_L32 <= Extender;

    -- Shift Right Updates
    shift_R1  <= std_logic_vector(Extender(0) & DATA1(31 downto 1));
    shift_R2  <= std_logic_vector(Extender(1 downto 0) & mux0Out(31 downto 2));
    shift_R4  <= std_logic_vector(Extender(3 downto 0) & mux1Out(31 downto 4));
    shift_R8  <= std_logic_vector(Extender(7 downto 0) & mux2Out(31 downto 8));
    shift_R16 <= std_logic_vector(Extender(15 downto 0) & mux3Out(31 downto 16));
    shift_R32 <= Extender;

    -- Defining selector signals
    mux0Sel <= SHIFTTYPE(1) & DATA2(0);
    mux1Sel <= SHIFTTYPE(1) & DATA2(1);
    mux2Sel <= SHIFTTYPE(1) & DATA2(2);
    mux3Sel <= SHIFTTYPE(1) & DATA2(3);
    mux4Sel <= SHIFTTYPE(1) & DATA2(4);    
    mux5Sel <= SHIFTTYPE(1) & adderOut(31); -- Checking the MSB of the adderOut
  end process;

end architecture ;