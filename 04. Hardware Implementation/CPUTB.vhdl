library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

entity CPUTB is
end CPUTB ; 

architecture testbench of CPUTB is
  component CPU is
    port(
      INSTRUCTION : in std_logic_vector (31 downto 0);
      CLK, RESET  : in std_logic;
      PC          : out std_logic_vector (31 downto 0)
    );
  end component;

  component IMEM is
    port(
      ADDRESS     : in std_logic_vector (31 downto 0);
      INSTRUCTION : out std_logic_vector (31 downto 0)
    );
  end component;

  Signal CLK : std_logic;
  Signal RESET : std_logic;
  Signal PC, INSTRUCTION : std_logic_vector (31 downto 0);

  -- Clock period
  constant clk_period : time := 80 ns;
begin
  RV_CPU : CPU
  port map (
    INSTRUCTION => INSTRUCTION,
    CLK         => CLK,
    RESET       => RESET,
    PC          => PC
  );

  RV_IMEM : IMEM
  port map (
    ADDRESS     => PC,
    INSTRUCTION => INSTRUCTION
  );

  -- Clock Process
  Clocking : process
    variable clk_cycles : integer := 20;
  begin
      for index in 1 to clk_cycles loop
          -- Sequential statements
          CLK <= '0';
          wait for clk_period / 2;
          CLK <= '1';
          wait for clk_period / 2;

          report "Cycle: " & integer'image(index) severity note;
      end loop;
      wait;
  end process;

  -- Reset Porcess
  Reseting : process
  begin
    RESET <= '1';
    wait for clk_period;
    RESET <= '0';
    wait;
  end process;

end architecture ;