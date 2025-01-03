-- This TB working for R-Type only

-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench entity
entity Pipeline_Reg_TB is
end Pipeline_Reg_TB;

-- Architecture of the testbench
architecture behavior of Pipeline_Reg_TB is
    -- Component Declaration for the Unit Under Test (UUT)
    component REG_IF_ID
        port(
            INSTRUCTION_I, PC_I, PC4_I : in std_logic_vector (31 downto 0);
            RESET, CLK                 : in std_logic;
            INSTRUCTION_O, PC_O, PC4_O : out std_logic_vector (31 downto 0)
        );
    end component;

    component REG_ID_EX is
        port (
          -- Signal Ports
          RESET, CLK  : in std_logic;
      
          -- Input Ports
          WriteEnable_I : in std_logic;
          FUNC3_I       : in std_logic_vector (2 downto 0);
          ALUOP_I       : in std_logic_vector (3 downto 0);
          RD_I          : in std_logic_vector (4 downto 0);
          IMM_I, PC_I, PC4_I, DATA1_I, DATA2_I : in std_logic_vector (31 downto 0);
      
          -- Output Ports
          WriteEnable_O : out std_logic;
          FUNC3_O       : out std_logic_vector (2 downto 0);
          ALUOP_O       : out std_logic_vector (3 downto 0);
          RD_O          : out std_logic_vector (4 downto 0);
          IMM_O, PC_O, PC4_O, DATA1_O, DATA2_O : out std_logic_vector (31 downto 0)
        );
    end component;

    -- Internal Signals
    signal INSTRUCTION_I, PC_I, PC4_I : std_logic_vector (31 downto 0);
    SIGNAL RESET, CLK                 : std_logic;
    SIGNAL INSTRUCTION_O, PC_O, PC4_O : std_logic_vector (31 downto 0);

    SIGNAL WriteEnable_I, WriteEnable_O : std_logic;
    SIGNAL FUNC3_I, FUNC3_O : std_logic_vector (2 downto 0);
    SIGNAL ALUOP_I, ALUOP_O : std_logic_vector (3 downto 0);
    SIGNAL RD_I, RD_O       : std_logic_vector (4 downto 0);
    SIGNAL IMM_I, DATA1_I, DATA2_I, IMM_O, DATA1_O, DATA2_O : std_logic_vector (31 downto 0);

    -- Clock period
    constant clk_period : time := 40 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    test_IFID: REG_IF_ID
        port map(
            INSTRUCTION_I => INSTRUCTION_I,
            PC_I          => PC_I,
            PC4_I         => PC4_I,

            INSTRUCTION_O => INSTRUCTION_O,
            PC_O          => PC_O,
            PC4_O         => PC4_O,

            CLK           => CLK,
            RESET         => Reset
        );

    test_IDEX: REG_ID_EX
        port map(
            WriteEnable_I => WriteEnable_I,
            FUNC3_I => FUNC3_I,
            ALUOP_I => ALUOP_I,
            RD_I    => RD_I,
            IMM_I   => IMM_I,
            PC_I    => PC_I,
            PC4_I   => PC4_I,
            DATA1_I => DATA1_I,
            DATA2_I => DATA2_I,

            WriteEnable_O => WriteEnable_O,
            FUNC3_O => FUNC3_O,
            ALUOP_O => ALUOP_O,
            RD_O    => RD_O,
            IMM_O   => IMM_O,
            PC_O    => PC_O,
            PC4_O   => PC4_O,
            DATA1_O => DATA1_O,
            DATA2_O => DATA2_O,

            CLK     => CLK,
            RESET   => Reset            
        );

    -- Clock Process
    Clock_Process : process
    begin
        for index in 1 to 10 loop
            -- Sequential statements
            CLK <= '0';
            wait for clk_period / 2;
            CLK <= '1';
            wait for clk_period / 2;

            report "Cycle: " & integer'image(index) severity note;
        end loop;
        wait;
    end process;

    -- Stimulus Process
    process
    begin
        -- Test Case 1: Reset operation
        Reset <= '1';
        wait for clk_period;
        Reset <= '0';

        -- Test Case 2
        INSTRUCTION_I <= std_logic_vector(to_unsigned(5, 32));
        PC_I          <= std_logic_vector(to_unsigned(0, 32));
        PC4_I         <= std_logic_vector(to_unsigned(4, 32));
        RD_I          <= std_logic_vector(to_unsigned(15, 5));
        FUNC3_I       <= std_logic_vector(to_unsigned(3, 3));
        IMM_I         <= std_logic_vector(to_unsigned(12, 32));
        DATA1_I       <= std_logic_vector(to_unsigned(5, 32));
        DATA2_I       <= std_logic_vector(to_unsigned(6, 32));
        wait for clk_period;

        -- Test Case 3
        INSTRUCTION_I <= std_logic_vector(to_unsigned(10, 32));
        PC_I          <= std_logic_vector(to_unsigned(4, 32));
        PC4_I         <= std_logic_vector(to_unsigned(8, 32));
        RD_I          <= std_logic_vector(to_unsigned(2, 5));
        FUNC3_I       <= std_logic_vector(to_unsigned(4, 3));
        IMM_I         <= std_logic_vector(to_unsigned(5, 32));
        DATA1_I       <= std_logic_vector(to_unsigned(10, 32));
        DATA2_I       <= std_logic_vector(to_unsigned(12, 32));
        wait for clk_period;

        -- Test Case 4
        INSTRUCTION_I <= std_logic_vector(to_unsigned(3, 32));
        PC_I          <= std_logic_vector(to_unsigned(8, 32));
        PC4_I         <= std_logic_vector(to_unsigned(12, 32));
        RD_I          <= std_logic_vector(to_unsigned(1, 5));
        FUNC3_I       <= std_logic_vector(to_unsigned(7, 3));
        IMM_I         <= std_logic_vector(to_unsigned(11, 32));
        DATA1_I       <= std_logic_vector(to_unsigned(15, 32));
        DATA2_I       <= std_logic_vector(to_unsigned(10, 32));
        wait for clk_period;         
        wait;
    end process;
end behavior;
