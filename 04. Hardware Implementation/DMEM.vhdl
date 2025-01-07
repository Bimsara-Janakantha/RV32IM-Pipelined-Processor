-- Create by BG
-- Created on Thu, 02 Jan 2025 at 09:37 PM
-- Last modified on Tue, 07 Jan 2025 at 09:37 PM
-- This is the data memory unit for RMV-32IM Pipelined processor

-------------------------------------------------------------
--       RV-32IM Pipelined Processor Data Memory Unit      --
-------------------------------------------------------------
-- A Data Memory with 7 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.            --
-- This is a 1KB Data Memory (1024 x 8 bits)               --
-------------------------------------------------------------

-----------------------------
--     DMEM OPERATIONS     --
-----------------------------
--    LOAD    |    STORE   --
--------------+--------------
--  000 - LB  |  000 - SB  --
--  001 - LH  |  001 - SH  --
--  010 - LW  |  111 - SW  --
--  100 - LBU |            --
--  101 - LHU |            --
-----------------------------


-- Note: 1 time unit = 1ns/100ps = 10ns

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity 
entity DMEM is
  port(
    MemAddress   : in std_logic_vector (31 downto 0);
    MemDataInput : in std_logic_vector (31 downto 0);
    FUNC3        : in std_logic_vector (2 downto 0);
    CLK, RESET   : in std_logic;
    MemRead      : in std_logic;
    MemWrite     : in std_logic;
    MemOut       : out std_logic_vector (31 downto 0)
  );
end DMEM; 

-- Architecture of the DMEM
architecture DMEM_Architecture of DMEM is
  -- Deffinition of the Data memory - 1024 Bytes memory
  type DataMemory is Array (0 to 1023) of std_logic_vector(7 downto 0);

begin
  
  process (CLK, MemAddress, MemRead, FUNC3)
    variable MEMORY : DataMemory := (others => (others => '0'));
    variable EXTENDER : std_logic_vector(31 downto 0) := (others => '0');
  begin

    -- Asynchronous Operations - Read Data
    if (MemRead = '1') then

      case( FUNC3 ) is
      
        when "000" => -- LB
          EXTENDER := (others => MEMORY(to_integer(Unsigned(MemAddress)))(7));
          MemOut <= EXTENDER(31 downto 8) & MEMORY(to_integer(Unsigned(MemAddress)));

        when "001" => -- LH
          EXTENDER := (others => MEMORY(to_integer(Unsigned(MemAddress) + 1))(7));
          MemOut <= EXTENDER(31 downto 16) & MEMORY(to_integer(Unsigned(MemAddress) + 1)) & MEMORY(to_integer(Unsigned(MemAddress)));
      
        when "010" => -- LW
          MemOut <= MEMORY(to_integer(Unsigned(MemAddress) + 3)) & MEMORY(to_integer(Unsigned(MemAddress) + 2)) & MEMORY(to_integer(Unsigned(MemAddress) + 1)) & MEMORY(to_integer(Unsigned(MemAddress)));

        when "100" => -- LBU
          EXTENDER := (others => '0');
          MemOut <= EXTENDER(31 downto 8) & MEMORY(to_integer(Unsigned(MemAddress)));

        when "101" => -- LHU
          MemOut <= EXTENDER(31 downto 16) & MEMORY(to_integer(Unsigned(MemAddress))) & MEMORY(to_integer(Unsigned(MemAddress) + 1));
      
        when others =>
          MemOut <= (others => 'X');
      end case ;

    end if;

    -- Synchronous Operations - (Reset, Write)
    if rising_edge(CLK) then

      -- Reset Data
      if (RESET = '1') then
        MEMORY := (others => (others =>  '0'));

      -- Write Data
      elsif (MemWrite = '1') then

        case( FUNC3 ) is
        
          when "000" => -- SB
            MEMORY(to_integer(Unsigned(MemAddress)))     := MemDataInput(7 downto 0);

          when "001" => -- SH
            MEMORY(to_integer(Unsigned(MemAddress)))     := MemDataInput(7 downto 0);
            MEMORY(to_integer(Unsigned(MemAddress) + 1)) := MemDataInput(15 downto 8);

          when others => -- SW
            MEMORY(to_integer(Unsigned(MemAddress)))     := MemDataInput(7 downto 0);
            MEMORY(to_integer(Unsigned(MemAddress) + 1)) := MemDataInput(15 downto 8);
            MEMORY(to_integer(Unsigned(MemAddress) + 2)) := MemDataInput(23 downto 16);
            MEMORY(to_integer(Unsigned(MemAddress) + 3)) := MemDataInput(31 downto 24);
        
        end case ;

      end if;

    end if;

  end process;

end architecture;