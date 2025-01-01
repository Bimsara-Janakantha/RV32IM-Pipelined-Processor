-- Create by BG
-- Created on Wed, 01 Jan 2025 at 09:21 AM
-- Last modified on Wed, 01 Jan 2025 at 12:21 AM
-- This is the module for 32 bit Register file

----------------------------------------------------------------
--                    32-bit Register File                    --
----------------------------------------------------------------
-- A Register File with 5 input streams and 2 output streams. --
-- Input output streams                                       --
-- ReadRegister_1 : input : 32-bits wide                      --
-- ReadRegister_2 : input : 32-bits wide                      --
-- WriteRegister  : input : 32-bits wide                      --
-- WriteData      : input : 32-bits wide                      --
-- WriteEnable    : input : 1-bit wide                        --
-- ReadData_1     : input : 32-bits wide                      --
-- ReadData_2     : input : 32-bits wide                      --
----------------------------------------------------------------

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity
entity Reg_File is
    port(
        -- Data Inputs and Output Streams
        ReadRegister_1 : in std_logic_vector (31 downto 0);
        ReadRegister_2 : in std_logic_vector (31 downto 0);
        WriteRegister  : in std_logic_vector (31 downto 0);
        WriteData      : in std_logic_vector (31 downto 0);
        ReadData_1     : out std_logic_vector (31 downto 0);
        ReadData_2     : out std_logic_vector (31 downto 0);
        
        -- Control Signals
        Clock, Reset, WriteEnable : in std_logic
    );
end Reg_File; 

-- Architecture
architecture Reg_File_Architecture of Reg_File is    
    -- Make an array to hold 32 registers (Declare custom type)
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0); 

    -- Initialize registers to zero
    -- register registers : reg_array := (others => (others => '0'));      
    
begin
    -- Read Operation - Asynchronous
    process(ReadRegister_1, ReadRegister_2)
    begin
        -- Read data from specified registers
        -- Add delay here
        ReadData_1 <= registers(to_integer(unsigned(ReadRegister_1)));
        ReadData_2 <= registers(to_integer(unsigned(ReadRegister_2)));
    end process;

    -- Write Operation - Synchronous
    process(Clock)
        variable registers : reg_array := (others => (others => '0'));
    begin
        if rising_edge(Clock) then
            -- Reset all registers
            if (Reset = '1') then
                -- Add delay here
                registers <= (others => (others => '0'));

            -- Write data to the register
            elsif (WriteEnable = '1') then 
                -- Add a delay here
                registers(to_integer(Unsigned(WriteRegister))) <= WriteData;
            end if;
        end if;
    end process;
    
end architecture;