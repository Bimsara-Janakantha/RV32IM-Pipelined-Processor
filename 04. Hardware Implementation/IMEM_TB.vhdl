library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

entity IMEM_TB is
end IMEM_TB ; 

architecture testbench of IMEM_TB is
    component IMEM is
        port(
          ADDRESS     : in std_logic_vector (31 downto 0);
          INSTRUCTION : out std_logic_vector (31 downto 0)
        );
    end component;

    component ProgramCounter is
        port (
          CLK, RESET : in std_logic;
          PC, PC4 : out std_logic_vector (31 downto 0)
        ) ;
    end component;

    Signal CLK, RESET : std_logic ;
    Signal INST, PC, PC4 : std_logic_vector(31 downto 0);

    -- Clock period
    constant clk_period : time := 80 ns;

    begin

    RV_PC : ProgramCounter
        port map(
          CLK   => CLK,
          RESET => RESET,
          PC    => PC,
          PC4   => PC4
    );

    IMEM_TEST : IMEM
        port map (
            ADDRESS     => PC,
            INSTRUCTION => INST
    );

    -- Reset Porcess
    Reseting : process
    begin
        RESET <= '1';
        wait for clk_period;
        RESET <= '0';
        wait;
    end process;

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
    
    end testbench;