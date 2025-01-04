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

  Signal CLK : std_logic ;
  Signal RESET : std_logic ;
  Signal PC, INSTRUCTION : std_logic_vector (31 downto 0);

  -- Clock period
  constant clk_period : time := 40 ns;
begin
  CPU_TEST : CPU
  port map (
    INSTRUCTION => INSTRUCTION,
    CLK         => CLK,
    RESET       => RESET,
    PC          => PC
  );

  -- Clock Process
  Clocking : process
    variable clk_cycles : integer := 10;
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

  -- Stimulus Process
  process(PC)
  begin

    case (PC) is  
      when x"00000000" =>
        INSTRUCTION <= x"00000001";
        report "Instruction No: 1";

      when x"00000004" =>
        INSTRUCTION <= x"00000002";
        report "Instruction No: 2";

      when x"00000008" =>
        INSTRUCTION <= x"00000003";
        report "Instruction No: 3";

      when x"0000000C" =>
        INSTRUCTION <= x"00000004";
        report "Instruction No: 4";

      when x"00000010" =>
        INSTRUCTION <= x"00000005";
        report "Instruction No: 5";

      when x"00000014" =>
        INSTRUCTION <= x"00000006";
        report "Instruction No: 6";
      
      when x"00000018" =>
        INSTRUCTION <= x"00000007";
        report "Instruction No: 7";

      when x"0000001C" =>
        INSTRUCTION <= x"00000008";
        report "Instruction No: 8";

      when x"00000020" =>
        INSTRUCTION <= x"00000009";
        report "Instruction No: 9";

      when x"00000024" =>
        INSTRUCTION <= x"0000000A";
        report "Instruction No: 10";
    
      when others =>
        report "Invalid PC";
        INSTRUCTION <= (others => 'X');
    end case ;
  end process;

end architecture ;