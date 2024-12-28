library ieee;
use ieee.std_logic_1164.all;

entity cpuTb is
end cpuTb;

architecture test of cpuTb is
    component and2
    port(
        A : in std_logic;
        B : in std_logic;
        F : out std_logic
    );
    end component;

    signal in1, in2, result : std_logic;

begin
    and_gate : and2 port map(A => in1, B => in2, F => result);

    process    
    begin
        in1 <= 'X'; -- 'x' should CAPITAL
        in2 <= 'X'; -- 'x' should CAPITAL
        wait for 2 ns;

        in1 <= '0';
        in2 <= '0';
        wait for 2 ns;

        in1 <= '0';
        in2 <= '1';
        wait for 2 ns;

        in1 <= '1';
        in2 <= '0';
        wait for 2 ns;

        in1 <= '1';
        in2 <= '1';
        wait for 2 ns;

        assert false report "Executed Testbench";
        wait;
    end process;

end architecture;

