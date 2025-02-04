library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity IMEM is
    port(
         Clock       : in  std_logic;
         Reset       : in  std_logic;
         Address     : in  std_logic_vector(31 downto 0);
         Instruction : out std_logic_vector(31 downto 0)
    );
end IMEM;

architecture Behavioral of IMEM is
    -- Memory array: 256 words of 32 bits each.
    type mem_array is array (0 to 255) of std_logic_vector(31 downto 0);
    signal mem : mem_array := (others => (others => '0'));

    -- Function: Convert an 8-character hexadecimal string to an integer.
    function hex_to_integer(s: string) return integer is
        variable result : integer := 0;
    begin
        for i in s'range loop
            result := result * 16;
            case s(i) is
                when '0' => result := result + 0;
                when '1' => result := result + 1;
                when '2' => result := result + 2;
                when '3' => result := result + 3;
                when '4' => result := result + 4;
                when '5' => result := result + 5;
                when '6' => result := result + 6;
                when '7' => result := result + 7;
                when '8' => result := result + 8;
                when '9' => result := result + 9;
                when 'A' | 'a' => result := result + 10;
                when 'B' | 'b' => result := result + 11;
                when 'C' | 'c' => result := result + 12;
                when 'D' | 'd' => result := result + 13;
                when 'E' | 'e' => result := result + 14;
                when 'F' | 'f' => result := result + 15;
                when others => null;
            end case;
        end loop;
        return result;
    end hex_to_integer;
    
begin

    ------------------------------------------------------------------
    -- Initialization Process: Read the "instr_mem.mem" file and load 
    -- the memory array. This process executes during simulation 
    -- initialization.
    ------------------------------------------------------------------
    init_memory: process
        file infile : text open read_mode is "instr_mem.mem";
        variable L : line;
        variable index : integer := 0;
        variable hex_str : string(1 to 8);  -- 8 hex digits per 32-bit word
        variable int_val : integer;
    begin
        while not endfile(infile) loop
            readline(infile, L);
            -- Read an 8-character hex string from the line.
            read(L, hex_str);
            int_val := hex_to_integer(hex_str);
            report "Instruction: " & integer'image(int_val) severity note;
            mem(index) <= std_logic_vector(to_unsigned(int_val, 32));
            index := index + 1;
        end loop;
        wait;
    end process init_memory;

    ------------------------------------------------------------------
    -- Instruction Output Process
    --
    -- On every rising edge of the Clock, this process uses the PC to
    -- index into the memory array and outputs the corresponding
    -- instruction.
    --
    -- Here we assume word addressing: for example, if your memory 
    -- stores 256 words, you may use bits [31 downto 2] (or an 
    -- appropriate slice) of the PC as the index.
    ------------------------------------------------------------------
    process(Clock)
        variable addr : integer;
    begin
        if rising_edge(Clock) then
            -- Example: using bits [9 downto 2] for a 256-word memory.
            addr := to_integer(unsigned(Address(9 downto 2)));
            Instruction <= mem(addr);
        end if;
    end process;

end Behavioral;
