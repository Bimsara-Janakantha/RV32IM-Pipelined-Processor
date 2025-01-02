-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench entity
entity PCTB is
end PCTB;

-- Architecture of the testbench
architecture behavior of PCTB is
    -- Component Declaration for the Unit Under Test (UUT)
    component ProgramCounter is
        port (
          CLK, RESET : in std_logic;
          PC : out std_logic_vector (31 downto 0)
        ) ;
      end component;

    -- Internal Signals
    signal Clock : std_logic := '0';
    signal Reset : std_logic := '0';
    signal PC    : std_logic_vector(31 downto 0);

    -- Clock period
    constant clk_period : time := 40 ns;

begin
    testPC : ProgramCounter 
        port map(
            CLK => Clock,
            RESET => Reset,
            PC => PC
        );

    -- Clock Process
    Clock_Process : process
    begin
        Clock <= '0';
        wait for clk_period / 2;
        Clock <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus Process
    process
    begin
        -- Test Case 1: Reset operation
        Reset <= '1';
        wait for clk_period;
        Reset <= '0';

        wait for clk_period * 10;

        Reset <= '1';
        wait for clk_period;
        Reset <= '0';
       
        wait for clk_period * 10;
        
        assert false report "Simulation finished" severity failure;
    end process;
end behavior;
