-- Create by BG
-- Created on Sun, 29 Dec 2024 at 10:00 PM
-- Last modified on Sun, 30 Dec 2024 at 02:30 PM
-- This is the module for 32 bit Shift register unit


----------------------------------------------------------
--                  32-bit SHIFT unit                   --
----------------------------------------------------------
-- An Shifter with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.         --
-- Currently work for the SLL instruction only.         --
----------------------------------------------------------



-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all ;

-- Entity (for now it is empty)
entity shifter is
    port(
        DATA1   : in std_logic_vector (31 downto 0);
        DATA2   : in std_logic_vector (31 downto 0);
        RESULT  : out std_logic_vector (31 downto 0)
    );
end shifter; 

-- Architecture
architecture Shifter_Architecture of shifter is

  -- Components
  component mux2_1
    port(
        input_1   : in std_logic_vector (31 downto 0);
        input_2   : in std_logic_vector (31 downto 0);
        selector  : in std_logic;
        output_1  : out std_logic_vector (31 downto 0)    -- No ; here
    );
  end component;

  -- Add OR gate component here to handle shifts more than 32

  -- signals
  signal mux0Out, mux1Out, mux2Out, mux3Out, mux4Out, mux5Out : std_logic_vector (31 downto 0);
  signal shift1, shift2, shift4, shift8, shift16, shift32 : std_logic_vector(31 downto 0);
  signal LSBExtender : std_logic_vector(31 downto 0);

  
begin
  LSBExtender <= (others => '0');

  ------------------- Port Mapping For Each Component -------------------
  Mux0 : mux2_1
    port map(
      input_1  => DATA1, 
      input_2  => shift1, -- shift by 1 bit
      selector => DATA2(0),
      output_1 => mux0Out
    );

  Mux1 : mux2_1
    port map(
      input_1  => mux0Out, 
      input_2  => shift2, -- shift by 2 bits
      selector => DATA2(1),
      output_1 => mux1Out
    );

  Mux2 : mux2_1
    port map(
      input_1  => mux1Out, 
      input_2  => shift4, -- shift by 4 bits
      selector => DATA2(2),
      output_1 => mux2Out
    );
  
  Mux3 : mux2_1
    port map(
      input_1  => mux2Out, 
      input_2  => shift8, -- shift by 8 bits
      selector => DATA2(3),
      output_1 => mux3Out
    );

  Mux4 : mux2_1
    port map(
      input_1  => mux3Out, 
      input_2  => shift16, -- shift by 16 bits
      selector => DATA2(4),
      output_1 => mux4Out
    );

  Mux5 : mux2_1
    port map(
      input_1  => mux4Out, 
      input_2  => shift32, 
      selector => DATA2(5),
      output_1 => RESULT
    );

  -- One Mapping is remaining for the OR gate

  -- Process
  process(DATA1, DATA2, mux0Out, mux1Out, mux2Out, mux3Out, mux4Out, mux5Out)
  begin
    shift1  <= std_logic_vector(DATA1(30 downto 0) & LSBExtender(0));
    shift2  <= std_logic_vector(mux0Out(29 downto 0) & LSBExtender(1 downto 0));
    shift4  <= std_logic_vector(mux1Out(27 downto 0) & LSBExtender(3 downto 0));
    shift8  <= std_logic_vector(mux2Out(23 downto 0) & LSBExtender(7 downto 0));
    shift16 <= std_logic_vector(mux3Out(15 downto 0) & LSBExtender(15 downto 0));
    shift32 <= LSBExtender;
  end process;


end architecture ;