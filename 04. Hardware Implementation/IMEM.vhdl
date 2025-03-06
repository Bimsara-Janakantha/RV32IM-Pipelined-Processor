-- Create by BG
-- Created on Tue, 04 Feb 2025 at 12:54 PM
-- Last modified on Tue, 04 Feb 2025 at 02:37 PM
-- This is the Instruction Memory module for RV32IM Piplined Processor

------------------------------------------------------
--                Instruction Memory                --
------------------------------------------------------
-- A IMEM with 1 input streams and 1 output stream. --
------------------------------------------------------

-- Note: 1 time unit = 1ns/100ps = 10ns
-- Timing (Delays) : 40ns for reading operation

-- Libraries (IEEE)
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    

-- Libraries (STD)
library std;
use std.textio.all;

-- IMEM Entity
entity IMEM is
    port(
        ADDRESS     : in  std_logic_vector(31 downto 0);
        INSTRUCTION : out std_logic_vector(31 downto 0)
    );
end IMEM;

-- IMEM Architecture
architecture IMEM_Architecture of IMEM is
    -- Memory array: 1024 words of 8 bits each.
    type mem_array is array (0 to 1023) of std_logic_vector(7 downto 0);
    signal instr_mem : mem_array := (others => (others => '0'));

    -- Function to convert a string of '0's and '1's to std_logic_vector
    function string_to_slv(s: string) return std_logic_vector is
        variable result: std_logic_vector(7 downto 0); -- MSB to LSB order
    begin
        for i in 1 to 8 loop
            --report "Bit: " & s(i) severity error;
        case s(i) is
            when '0' => result(8 - i) := '0'; -- Map '0' to bit '0'
            when '1' => result(8 - i) := '1'; -- Map '1' to bit '1'
            when others =>
            report "Invalid character in string: '" & s(i) & "'" severity error;
            result(8 - i) := 'X'; -- Handle invalid characters
        end case;
        end loop;
        return result;
    end function;

    -- Function to convert std_logic_vector back to string (for reporting)
    function slv_to_string(vector: std_logic_vector) return string is
        variable result: string(1 to 8);
    begin
        for i in 0 to 7 loop
        case vector(i) is
            when '0' => result(i+1) := '0';
            when '1' => result(i+1) := '1';
            when others => result(i+1) := 'X';
        end case;
        end loop;
        return result;
    end function;

begin

    ------------------------------------------------------------------
    -- Initialization Process: Read the "instr_mem.mem" file and load 
    -- the memory array. This process executes during simulation 
    -- initialization.
    ------------------------------------------------------------------
    init_memory: process
        file mem_file     : text open read_mode is "instr_mem.mem";
        variable mem_line : line;
        variable mem_str  : string(1 to 8);
        variable idx      : integer := 0;
    begin
        while not endfile(mem_file) loop
            readline(mem_file, mem_line);

            -- Read a binary chunk from the ROM
            read(mem_line, mem_str);
            report "Instruction: " & mem_str severity note;

            -- Save it into the IMEM
            instr_mem(idx) <= string_to_slv(mem_str) after 1 ps;

            idx := idx + 1;
        end loop;
        wait;
    end process init_memory;
   
    ------------------------------------------------------------------
    -- Instruction Output Process
    --
    -- When the PC changes IMEM get that PC, index into the memory 
    -- array and outputs the corresponding instruction.
    ------------------------------------------------------------------
    read_memory : process(ADDRESS)
        variable idx : integer := 0;
    begin
        idx := to_integer(unsigned(ADDRESS));
        report "INDEX: " & integer'image(idx) severity note;
        
        INSTRUCTION <= instr_mem(idx+3) & instr_mem(idx+2) & instr_mem(idx+1) & instr_mem(idx) after 40 ns;

    end process read_memory;

end IMEM_Architecture;

