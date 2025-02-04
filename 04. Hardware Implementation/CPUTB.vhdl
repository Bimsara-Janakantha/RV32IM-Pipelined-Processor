library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

entity CPUTB is
end CPUTB ; 

architecture testbench of CPUTB is
  component CPU is
    port(
      -- General Ports
      CLK, RESET  : in std_logic;

      -- Ports for IMEM
      INSTRUCTION : in std_logic_vector (31 downto 0);
      PC          : out std_logic_vector (31 downto 0);

      -- Ports for DMEM
      DMEMREAD, DMEMWRITE : out std_logic;
      FUNC3               : out std_logic_vector (2 downto 0);
      ALURESULT, DMEMIN   : out std_logic_vector (31 downto 0);
      DMEMOUT             : in std_logic_vector (31 downto 0)
    );
  end component;

  component IMEM is
    port(
      ADDRESS     : in std_logic_vector (31 downto 0);
      INSTRUCTION : out std_logic_vector (31 downto 0)
    );
  end component;

  component DMEM is
    port(
      MemAddress   : in std_logic_vector (31 downto 0);
      MemDataInput : in std_logic_vector (31 downto 0);
      FUNC3        : in std_logic_vector (2 downto 0);
      CLK, RESET   : in std_logic;
      MemRead      : in std_logic;
      MemWrite     : in std_logic;
      MemOut       : out std_logic_vector (31 downto 0)
    );
  end component;

  Signal FUNC3                                       : std_logic_vector (2 downto 0);
  Signal CLK, RESET, MEMREAD, MEMWRITE               : std_logic;
  Signal PC, INSTRUCTION, ALURESULT, MEMDATA, MEMOUT : std_logic_vector (31 downto 0);


  -- Clock period
  constant clk_period : time := 80 ns;
begin
  RV_CPU : CPU
  port map (
    INSTRUCTION => INSTRUCTION,
    CLK         => CLK,
    RESET       => RESET,
    PC          => PC,
    DMEMREAD    => MEMREAD,
    DMEMWRITE   => MEMWRITE,
    FUNC3       => FUNC3,
    ALURESULT   => ALURESULT,
    DMEMIN      => MEMDATA,
    DMEMOUT     => MEMOUT
  );

  RV_IMEM : IMEM
  port map (
    ADDRESS     => PC,
    INSTRUCTION => INSTRUCTION
  );

  RV_DMEM : DMEM
  port map(
    CLK          => CLK, 
    RESET        => RESET,
    MemAddress   => ALURESULT,
    MemDataInput => MEMDATA,
    FUNC3        => FUNC3,
    MemRead      => MEMREAD,
    MemWrite     => MEMWRITE,
    MemOut       => MEMOUT
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