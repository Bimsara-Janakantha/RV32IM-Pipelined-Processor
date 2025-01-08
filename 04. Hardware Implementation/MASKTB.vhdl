library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench entity
entity MASKTB is
end MASKTB;

-- Testbench architecture
architecture Testbench of MASKTB is
    -- Component declaration for the DUT (Device Under Test)
    component MASK is
        port (
            input_data  : in std_logic_vector(31 downto 0);
            output_data : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals to connect to the DUT
    signal input_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal output_data : std_logic_vector(31 downto 0);

begin
    -- Instantiate the DUT
    uut: MASK
        port map (
            input_data  => input_data,
            output_data => output_data
        );

    -- Test process
    stim_proc: process
    begin
        -- Test case 1: All zeros
        input_data <= (others => '0');
        wait for 10 ns;
        
        -- Test case 2: All ones
        input_data <= (others => '1');
        wait for 10 ns;

        -- Test case 3: A specific pattern
        input_data <= "10101010101010101010101010101010";
        wait for 10 ns;

        -- Test case 4: Another specific pattern
        input_data <= "11110000111100001111000011110000";
        wait for 10 ns;

        -- End simulation
        wait;
    end process;
end Testbench;
