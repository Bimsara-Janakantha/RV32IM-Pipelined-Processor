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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity (for now it is empty)
entity ALUTB is
    port(
        -- Add ports here
    );
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
    
    -- Process body
    
    -- End Simulation
    wait;
  end process;

end architecture;