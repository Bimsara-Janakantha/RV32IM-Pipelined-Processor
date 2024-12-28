-- This is the component file for 2 input AND gate

library ieee ;
use ieee.std_logic_1164.all ;


entity and2 is
  port (
    A : in std_logic;
    B : in std_logic;
    F : out std_logic
  ) ;
end and2; 


architecture temp of and2 is
begin
  F <= A and B;

end architecture;